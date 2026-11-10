<?php
/**
 * migrate_app_images.php
 * 本番データベース (app_list) の images / icon / thumbnail に含まれる
 * Base64 画像データを実画像ファイル (/public/uploads/images/apps/...) に保存し、
 * 公開URLに一括置換・更新するマイグレーションスクリプト
 *
 * 使い方 (CLI):
 *   php scripts/migrate_app_images.php                # 実際に実行してDBとファイルを更新
 *   php scripts/migrate_app_images.php --dry-run      # DB・ファイルを変更せず事前チェック
 *   php scripts/migrate_app_images.php --export-sql   # UPDATEクエリをSQLファイルに出力
 */

// CLI 引数の解析
$isDryRun = in_array('--dry-run', $argv ?? []);
$isExportSql = in_array('--export-sql', $argv ?? []);
$isHelp = in_array('--help', $argv ?? []) || in_array('-h', $argv ?? []);

if ($isHelp) {
    echo <<<HELP
ENOKI Appcenter - アプリ画像 Base64 一括移行スクリプト
---------------------------------------------------------
使用方法:
  php scripts/migrate_app_images.php [オプション]

オプション:
  --dry-run     データベースおよびファイルへの変更を行わず、移行対象をシミュレーションします
  --export-sql  生成されたUPDATEクエリを SQLファイル (migration_app_images_applied.sql) に保存します
  --help, -h    このヘルプメッセージを表示します

HELP;
    exit(0);
}

ini_set('memory_limit', '512M');
ini_set('max_execution_time', '300');

$rootDir = dirname(__DIR__);
if (empty($_SERVER['DOCUMENT_ROOT'])) {
    $_SERVER['DOCUMENT_ROOT'] = $rootDir;
}
if (!defined('DIR_ROOT')) {
    define('DIR_ROOT', $rootDir);
}

$envPath = $rootDir . '/env.php';
if (!file_exists($envPath)) {
    $envPath = $rootDir . '/env.example.php';
}
require_once $envPath;
require_once $rootDir . '/php/settings.php';
require_once $rootDir . '/php/myAutoLoad.php';
require_once $rootDir . '/php/functions/database.php';
require_once $rootDir . '/php/functions/urlHelper.php';
require_once $rootDir . '/php/functions/imageStorage.php';

$isCli = (php_sapi_name() === 'cli');

function logMsg(string $msg, string $type = 'info'): void
{
    global $isCli;
    $colors = [
        'info' => "\033[36m",
        'success' => "\033[32m",
        'warning' => "\033[33m",
        'error' => "\033[31m",
        'reset' => "\033[0m",
    ];
    $time = date('Y-m-d H:i:s');
    if ($isCli) {
        $color = $colors[$type] ?? $colors['info'];
        $reset = $colors['reset'];
        echo "[{$time}] {$color}{$msg}{$reset}\n";
    } else {
        echo htmlspecialchars("[{$time}] {$msg}") . "<br>\n";
    }
}

logMsg("=========================================================");
logMsg("アプリ画像 Base64 -> 実ファイル＆URL 一括マイグレーション");
logMsg("=========================================================");
if ($isDryRun) {
    logMsg("【DRY-RUN モード】データベースおよびファイルへの変更は行われません", 'warning');
}

// 1. データベース接続
try {
    $pdo = SQLConnect();
    if (!$pdo) {
        throw new \RuntimeException("MySQLに接続できませんでした。env.phpの設定を確認してください。");
    }
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    logMsg("MySQL データベースに正常に接続しました。", 'success');
} catch (\Throwable $e) {
    logMsg("DB接続エラー: " . $e->getMessage(), 'error');
    exit(1);
}

// 2. アップロード先ディレクトリの準備
$targetDirs = getUploadTargetDirectories('apps');
if (empty($targetDirs)) {
    logMsg("アップロード先ディレクトリの作成または取得に失敗しました。", 'error');
    exit(1);
}
$primaryDir = $targetDirs[0];
logMsg("画像ファイル保存先: " . $primaryDir);

// 3. app_list からデータ取得
try {
    $stmt = $pdo->query("SELECT `appId`, `name`, `icon`, `thumbnail`, `images`, `updatedAt` FROM `app_list` ORDER BY `createdAt` ASC");
    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
    logMsg("取得したアプリレコード数: " . count($records) . " 件");
} catch (\Throwable $e) {
    logMsg("app_list 取得エラー: " . $e->getMessage(), 'error');
    exit(1);
}

$totalAppsChecked = count($records);
$totalAppsUpdated = 0;
$totalImagesConverted = 0;
$totalIconsConverted = 0;
$totalThumbsConverted = 0;
$bytesSaved = 0;
$sqlUpdates = [];
$now = time();

// Base64判定およびファイル保存関数
function convertBase64ToImageFile(string $dataUri, string $safeAppId, string $prefix, int $index, bool $dryRun, array $targetDirs): ?array
{
    $trimmed = trim($dataUri);
    if (!str_starts_with($trimmed, 'data:image/')) {
        return null;
    }

    $ext = 'png';
    $fileData = null;

    if (str_starts_with($trimmed, 'data:image/svg+xml')) {
        $ext = 'svg';
        if (str_contains($trimmed, ';base64,')) {
            $parts = explode(';base64,', $trimmed, 2);
            $fileData = base64_decode($parts[1]);
        } else {
            $raw = preg_replace('#^data:image/svg\+xml;?(?:utf8|charset=utf-8)?,#i', '', $trimmed);
            $fileData = rawurldecode($raw);
            if ($fileData === false || $fileData === '') {
                $fileData = urldecode($raw);
            }
        }
    } elseif (preg_match('#^data:image/(png|jpe?g|webp|gif);base64,(.+)$#is', $trimmed, $matches)) {
        $rawExt = strtolower($matches[1]);
        $ext = ($rawExt === 'jpeg') ? 'jpg' : $rawExt;
        $fileData = base64_decode($matches[2]);
    } else {
        return null;
    }

    if ($fileData === false || $fileData === null || strlen($fileData) === 0) {
        return null;
    }

    $originalLength = strlen($trimmed);
    $binaryLength = strlen($fileData);
    $timestamp = time();
    $random = bin2hex(random_bytes(4));
    $filename = "{$prefix}_{$safeAppId}_{$index}_{$timestamp}_{$random}.{$ext}";

    $publicUrl = toApiPublicAssetUrl("/public/uploads/images/apps/{$filename}");

    if (!$dryRun) {
        $saved = false;
        foreach ($targetDirs as $dir) {
            if (!is_dir($dir)) {
                @mkdir($dir, 0755, true);
            }
            $dest = rtrim($dir, '/\\') . '/' . $filename;
            if (@file_put_contents($dest, $fileData) !== false) {
                $saved = true;
            }
        }
        if (!$saved) {
            logMsg("ファイル保存失敗: {$filename}", 'error');
            return null;
        }
    }

    return [
        'filename' => $filename,
        'url' => $publicUrl,
        'originalLength' => $originalLength,
        'binaryLength' => $binaryLength,
    ];
}

// 4. 各アプリレコードの走査と変換
foreach ($records as $row) {
    $appId = $row['appId'];
    $name = $row['name'];
    $safeAppId = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $appId) ?: 'app';

    $hasChanges = false;
    $appImagesConverted = 0;
    $appBytesSaved = 0;

    // --- A. images (スクリーンショット配列) のチェック ---
    $rawImages = $row['images'];
    $imagesList = is_string($rawImages) ? (json_decode($rawImages, true) ?: []) : (array)$rawImages;
    if (!is_array($imagesList) && !empty($rawImages) && is_string($rawImages)) {
        // 単一文字列として入っている場合
        $imagesList = [$rawImages];
    }

    $newImagesList = [];
    $imgIdx = 1;
    foreach ($imagesList as $imgItem) {
        if (!is_string($imgItem) || empty($imgItem)) {
            continue;
        }

        $res = convertBase64ToImageFile($imgItem, $safeAppId, 'screen', $imgIdx, $isDryRun, $targetDirs);
        if ($res !== null) {
            $newImagesList[] = $res['url'];
            $hasChanges = true;
            $appImagesConverted++;
            $totalImagesConverted++;
            $appBytesSaved += ($res['originalLength'] - strlen($res['url']));
        } else {
            // すでにURLの場合は正規化
            $newImagesList[] = toApiPublicAssetUrl($imgItem);
        }
        $imgIdx++;
    }

    // --- B. icon のチェック ---
    $newIcon = $row['icon'];
    if (!empty($row['icon']) && str_starts_with(trim($row['icon']), 'data:image/')) {
        $iconRes = convertBase64ToImageFile($row['icon'], $safeAppId, 'icon', 1, $isDryRun, $targetDirs);
        if ($iconRes !== null) {
            $newIcon = $iconRes['url'];
            $hasChanges = true;
            $totalIconsConverted++;
            $appBytesSaved += ($iconRes['originalLength'] - strlen($iconRes['url']));
        }
    }

    // --- C. thumbnail のチェック ---
    $newThumbnail = $row['thumbnail'];
    if (!empty($row['thumbnail']) && str_starts_with(trim($row['thumbnail']), 'data:image/')) {
        $thumbRes = convertBase64ToImageFile($row['thumbnail'], $safeAppId, 'thumb', 1, $isDryRun, $targetDirs);
        if ($thumbRes !== null) {
            $newThumbnail = $thumbRes['url'];
            $hasChanges = true;
            $totalThumbsConverted++;
            $appBytesSaved += ($thumbRes['originalLength'] - strlen($thumbRes['url']));
        }
    }

    if ($hasChanges) {
        $totalAppsUpdated++;
        $bytesSaved += $appBytesSaved;
        $newImagesJson = json_encode($newImagesList, JSON_UNESCAPED_UNICODE);

        logMsg(sprintf(
            "アプリ [%s] %s: スクリーンショット %d 枚変換 (削減: %.1f KB)",
            $appId,
            $name,
            $appImagesConverted,
            $appBytesSaved / 1024
        ), 'info');

        // SQL クエリ文字列作成 (エクスポート用)
        $escapeSql = function ($val) {
            if ($val === null) return 'NULL';
            return "'" . addslashes((string)$val) . "'";
        };
        $sqlUpdates[] = sprintf(
            "UPDATE `app_list` SET `images` = %s, `icon` = %s, `thumbnail` = %s, `updatedAt` = %d WHERE `appId` = %s;",
            $escapeSql($newImagesJson),
            $escapeSql($newIcon),
            $escapeSql($newThumbnail),
            $now,
            $escapeSql($appId)
        );

        // 実際のDB更新実行
        if (!$isDryRun) {
            try {
                $updateStmt = $pdo->prepare("UPDATE `app_list` SET `images` = :images, `icon` = :icon, `thumbnail` = :thumbnail, `updatedAt` = :updatedAt WHERE `appId` = :appId");
                $updateStmt->execute([
                    ':images' => $newImagesJson,
                    ':icon' => $newIcon,
                    ':thumbnail' => $newThumbnail,
                    ':updatedAt' => $now,
                    ':appId' => $appId,
                ]);
            } catch (\Throwable $e) {
                logMsg("レコード更新エラー (appId: {$appId}): " . $e->getMessage(), 'error');
            }
        }
    }
}

// 5. 実行結果サマリー
logMsg("---------------------------------------------------------");
logMsg("マイグレーション処理が完了しました！", 'success');
logMsg("検査したアプリ数: {$totalAppsChecked} 件");
logMsg("更新対象アプリ数: {$totalAppsUpdated} 件");
logMsg("変換したスクリーンショット画像: {$totalImagesConverted} 枚");
if ($totalIconsConverted > 0) {
    logMsg("変換したアイコン画像: {$totalIconsConverted} 枚");
}
if ($totalThumbsConverted > 0) {
    logMsg("変換したサムネイル画像: {$totalThumbsConverted} 枚");
}
logMsg(sprintf("データベース削減データ量: %.2f MB (%.1f KB)", $bytesSaved / (1024 * 1024), $bytesSaved / 1024), 'success');

// 6. SQL ファイル出力
if ($isExportSql || !empty($sqlUpdates)) {
    $sqlOutPath = $rootDir . '/migration_app_images_applied.sql';
    $sqlContent = "-- ========================================================\n";
    $sqlContent .= "-- アプリ画像 Base64 -> 公開URL 移行 SQL\n";
    $sqlContent .= "-- 生成日時: " . date('Y-m-d H:i:s') . "\n";
    $sqlContent .= "-- 更新件数: " . count($sqlUpdates) . " 件\n";
    $sqlContent .= "-- ========================================================\n\n";
    $sqlContent .= "START TRANSACTION;\n\n";
    $sqlContent .= implode("\n\n", $sqlUpdates) . "\n\n";
    $sqlContent .= "COMMIT;\n";

    if (@file_put_contents($sqlOutPath, $sqlContent) !== false) {
        logMsg("マイグレーションSQLを出力しました: " . $sqlOutPath, 'success');
    }
}

if ($isDryRun) {
    logMsg("※ DRY-RUN モードで実行されたため、実際のDBとファイルは変更されていません。", 'warning');
    logMsg("実際に反映するには、--dry-run なしで再実行してください:\n  php scripts/migrate_app_images.php");
}
