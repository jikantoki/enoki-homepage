<?php
/**
 * migrateAppImagesApi.php
 * 管理者専用: 本番データベース (app_list) の images / icon / thumbnail に含まれる
 * Base64 画像データを実画像ファイル (/public/uploads/images/apps/...) に保存し、
 * 公開URLに一括置換・更新する Web / API エンドポイント
 *
 * GET / POST /php/migrateAppImagesApi.php
 *   クエリパラメータ / POST パラメータ:
 *     - dryRun: 1 または true でシミュレーション実行 (DB/ファイル更新なし)
 *     - exportSql: 1 または true で migration_app_images_applied.sql を書き出し
 */

ini_set('memory_limit', '512M');
ini_set('max_execution_time', '300');

require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/authAccountforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';
require_once DIR_ROOT . '/php/functions/urlHelper.php';
require_once DIR_ROOT . '/php/functions/imageStorage.php';

header('Content-Type: application/json; charset=UTF-8');

// 管理者権限チェック
if (!isUserAdmin($secretId)) {
    echo json_encode([
        'status' => 'forbidden',
        'reason' => '管理者アカウントのみ実行できます。',
        'errCode' => 403,
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$input = file_get_contents('php://input');
$body = json_decode($input, true) ?: $_POST;

$dryRunParam = isset($_GET['dryRun']) ? $_GET['dryRun'] : ($body['dryRun'] ?? false);
$isDryRun = ($dryRunParam === true || $dryRunParam === '1' || $dryRunParam === 'true');

$exportSqlParam = isset($_GET['exportSql']) ? $_GET['exportSql'] : ($body['exportSql'] ?? false);
$isExportSql = ($exportSqlParam === true || $exportSqlParam === '1' || $exportSqlParam === 'true');

try {
    $pdo = SQLConnect();
    if (!$pdo) {
        throw new \RuntimeException("MySQLに接続できませんでした。");
    }
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $targetDirs = getUploadTargetDirectories('apps');
    if (empty($targetDirs)) {
        throw new \RuntimeException("アップロード先ディレクトリを取得できませんでした。");
    }

    $stmt = $pdo->query("SELECT `appId`, `name`, `icon`, `thumbnail`, `images`, `updatedAt` FROM `app_list` ORDER BY `createdAt` ASC");
    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $totalAppsChecked = count($records);
    $totalAppsUpdated = 0;
    $totalImagesConverted = 0;
    $totalIconsConverted = 0;
    $totalThumbsConverted = 0;
    $bytesSaved = 0;
    $appDetails = [];
    $sqlUpdates = [];
    $now = time();

    // ヘルパー: Base64 を画像ファイルに変換
    $convertBase64 = function(string $dataUri, string $safeAppId, string $prefix, int $index) use ($isDryRun, $targetDirs) {
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

        if (!$isDryRun) {
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
                return null;
            }
        }

        return [
            'filename' => $filename,
            'url' => $publicUrl,
            'originalLength' => $originalLength,
            'binaryLength' => $binaryLength,
        ];
    };

    foreach ($records as $row) {
        $appId = $row['appId'];
        $name = $row['name'];
        $safeAppId = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $appId) ?: 'app';

        $hasChanges = false;
        $appImagesConverted = 0;
        $appBytesSaved = 0;

        // images
        $rawImages = $row['images'];
        $imagesList = is_string($rawImages) ? (json_decode($rawImages, true) ?: []) : (array)$rawImages;
        if (!is_array($imagesList) && !empty($rawImages) && is_string($rawImages)) {
            $imagesList = [$rawImages];
        }

        $newImagesList = [];
        $imgIdx = 1;
        foreach ($imagesList as $imgItem) {
            if (!is_string($imgItem) || empty($imgItem)) {
                continue;
            }
            $res = $convertBase64($imgItem, $safeAppId, 'screen', $imgIdx);
            if ($res !== null) {
                $newImagesList[] = $res['url'];
                $hasChanges = true;
                $appImagesConverted++;
                $totalImagesConverted++;
                $appBytesSaved += ($res['originalLength'] - strlen($res['url']));
            } else {
                $newImagesList[] = toApiPublicAssetUrl($imgItem);
            }
            $imgIdx++;
        }

        // icon
        $newIcon = $row['icon'];
        if (!empty($row['icon']) && str_starts_with(trim($row['icon']), 'data:image/')) {
            $iconRes = $convertBase64($row['icon'], $safeAppId, 'icon', 1);
            if ($iconRes !== null) {
                $newIcon = $iconRes['url'];
                $hasChanges = true;
                $totalIconsConverted++;
                $appBytesSaved += ($iconRes['originalLength'] - strlen($iconRes['url']));
            }
        }

        // thumbnail
        $newThumbnail = $row['thumbnail'];
        if (!empty($row['thumbnail']) && str_starts_with(trim($row['thumbnail']), 'data:image/')) {
            $thumbRes = $convertBase64($row['thumbnail'], $safeAppId, 'thumb', 1);
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

            $appDetails[] = [
                'appId' => $appId,
                'name' => $name,
                'imagesConverted' => $appImagesConverted,
                'bytesSaved' => $appBytesSaved,
                'newImages' => $newImagesList,
            ];

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

            if (!$isDryRun) {
                $updateStmt = $pdo->prepare("UPDATE `app_list` SET `images` = :images, `icon` = :icon, `thumbnail` = :thumbnail, `updatedAt` = :updatedAt WHERE `appId` = :appId");
                $updateStmt->execute([
                    ':images' => $newImagesJson,
                    ':icon' => $newIcon,
                    ':thumbnail' => $newThumbnail,
                    ':updatedAt' => $now,
                    ':appId' => $appId,
                ]);
            }
        }
    }

    if ($isExportSql || (!empty($sqlUpdates) && !$isDryRun)) {
        $sqlOutPath = DIR_ROOT . '/migration_app_images_applied.sql';
        $sqlContent = "-- ========================================================\n";
        $sqlContent .= "-- アプリ画像 Base64 -> 公開URL 移行 SQL\n";
        $sqlContent .= "-- 生成日時: " . date('Y-m-d H:i:s') . "\n";
        $sqlContent .= "-- 更新件数: " . count($sqlUpdates) . " 件\n";
        $sqlContent .= "-- ========================================================\n\n";
        $sqlContent .= "START TRANSACTION;\n\n";
        $sqlContent .= implode("\n\n", $sqlUpdates) . "\n\n";
        $sqlContent .= "COMMIT;\n";
        @file_put_contents($sqlOutPath, $sqlContent);
    }

    echo json_encode([
        'status' => 'ok',
        'dryRun' => $isDryRun,
        'message' => $isDryRun ? 'マイグレーションの事前チェック（Dry-Run）が完了しました。' : 'マイグレーションが正常に完了しました。',
        'summary' => [
            'totalAppsChecked' => $totalAppsChecked,
            'totalAppsUpdated' => $totalAppsUpdated,
            'totalImagesConverted' => $totalImagesConverted,
            'totalIconsConverted' => $totalIconsConverted,
            'totalThumbsConverted' => $totalThumbsConverted,
            'bytesSaved' => $bytesSaved,
            'kbSaved' => round($bytesSaved / 1024, 1),
            'mbSaved' => round($bytesSaved / (1024 * 1024), 2),
        ],
        'details' => $appDetails,
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

} catch (\Throwable $th) {
    echo json_encode([
        'status' => 'error',
        'reason' => 'マイグレーション実行時エラー: ' . $th->getMessage(),
    ], JSON_UNESCAPED_UNICODE);
}
