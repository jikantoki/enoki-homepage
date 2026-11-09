<?php
/**
 * imageStorage.php
 * 画像の Base64 / Data URI データを実ファイル (/uploads/images/...) として保存し、
 * Webからアクセス可能な URL に変換・管理するヘルパー関数群
 */

/**
 * アップロード先の物理ディレクトリ一覧を取得（複数箇所に同期・フォールバック対応）
 *
 * @param string $subDir サブディレクトリ名 (例: 'apps', 'music', '')
 * @return array<string> 作成・確認済みの保存先ディレクトリパス一覧
 */
function getUploadTargetDirectories(string $subDir = ''): array
{
    $sub = trim($subDir, '/');
    $subPath = $sub !== '' ? '/' . $sub : '';

    $candidates = [];

    // 1. DOCUMENT_ROOT/public/uploads/images が最優先
    if (!empty($_SERVER['DOCUMENT_ROOT'])) {
        $candidates[] = rtrim($_SERVER['DOCUMENT_ROOT'], '/\\') . '/public/uploads/images' . $subPath;
    }

    // 2. DIR_ROOT/public/uploads/images
    if (defined('DIR_ROOT') && DIR_ROOT) {
        $candidates[] = rtrim(DIR_ROOT, '/\\') . '/public/uploads/images' . $subPath;
    }

    // 3. リポジトリルート/public/uploads/images (php/functions からの相対)
    $candidates[] = dirname(__DIR__, 2) . '/public/uploads/images' . $subPath;

    // 4. DOCUMENT_ROOT/uploads/images (ドキュメントルートが public 自体の場合)
    if (!empty($_SERVER['DOCUMENT_ROOT'])) {
        $candidates[] = rtrim($_SERVER['DOCUMENT_ROOT'], '/\\') . '/uploads/images' . $subPath;
    }

    // 5. DIR_ROOT/uploads/images
    if (defined('DIR_ROOT') && DIR_ROOT) {
        $candidates[] = rtrim(DIR_ROOT, '/\\') . '/uploads/images' . $subPath;
    }

    $validDirs = [];
    $seen = [];
    foreach ($candidates as $dir) {
        $realOrNorm = str_replace('\\', '/', $dir);
        if (isset($seen[$realOrNorm])) {
            continue;
        }
        $seen[$realOrNorm] = true;

        if (is_dir($dir) || @mkdir($dir, 0755, true)) {
            if (is_writable($dir)) {
                $validDirs[] = $dir;
                // 最優先の有効なディレクトリが見つかればそれをメインとして使用
                break;
            }
        }
    }

    return $validDirs;
}

/**
 * Base64 または SVG Data URI を画像ファイルとして保存し、相対URL (/uploads/images/...) を返す
 * すでに URL（/uploads/... や http...）の場合はそのまま返す
 *
 * @param string|null $dataUri Base64文字列、Data URI、または既存URL
 * @param string $subDir サブディレクトリ名 (例: 'apps')
 * @param string|null $preferredName 希望するファイル名（拡張子なし、例: 'appId_icon'）
 * @return string Webアクセス可能な画像URL (例: '/uploads/images/apps/appId_icon.svg')
 */
function saveImageUriToFile(?string $dataUri, string $subDir = 'apps', ?string $preferredName = null): string
{
    if (empty($dataUri) || !is_string($dataUri)) {
        return "/uploads/images/{$subDir}/default_app_thumb.svg";
    }

    $trimmed = trim($dataUri);

    // 既にURL形式の場合はそのまま返す
    if (
        str_starts_with($trimmed, '/uploads/') ||
        str_starts_with($trimmed, 'http://') ||
        str_starts_with($trimmed, 'https://') ||
        str_starts_with($trimmed, '/img/') ||
        str_starts_with($trimmed, '/icons/')
    ) {
        return $trimmed;
    }

    // Data URI でない場合はそのまま返す
    if (!str_starts_with($trimmed, 'data:image/')) {
        return $trimmed;
    }

    $targetDirs = getUploadTargetDirectories($subDir);
    if (empty($targetDirs)) {
        error_log("saveImageUriToFile: 有効なアップロードディレクトリが見つかりません。");
        return $trimmed;
    }

    $fileData = null;
    $ext = 'png';

    // 1. SVG Data URI
    if (str_starts_with($trimmed, 'data:image/svg+xml')) {
        $ext = 'svg';
        if (str_contains($trimmed, ';base64,')) {
            $parts = explode(';base64,', $trimmed, 2);
            $fileData = base64_decode($parts[1]);
        } else {
            // URLエンコードされたSVGデータ
            $raw = preg_replace('#^data:image/svg\+xml;?(?:utf8|charset=utf-8)?,#i', '', $trimmed);
            $fileData = rawurldecode($raw);
            if ($fileData === false || $fileData === '') {
                $fileData = urldecode($raw);
            }
        }
    }
    // 2. ラスター画像 (PNG, JPEG, WebP, GIF)
    elseif (preg_match('#^data:image/(png|jpe?g|webp|gif);base64,(.+)$#is', $trimmed, $matches)) {
        $rawExt = strtolower($matches[1]);
        $ext = ($rawExt === 'jpeg') ? 'jpg' : $rawExt;
        $fileData = base64_decode($matches[2]);
    } else {
        // 未知のData URI形式
        return $trimmed;
    }

    if ($fileData === false || $fileData === null || strlen($fileData) === 0) {
        error_log("saveImageUriToFile: 画像データのデコードに失敗しました。");
        return $trimmed;
    }

    // ファイル名の決定
    $sub = trim($subDir, '/');
    if (!empty($preferredName)) {
        $safeName = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $preferredName);
        $filename = "{$safeName}.{$ext}";
    } else {
        $timestamp = time();
        $random = bin2hex(random_bytes(4));
        $filename = "img_{$timestamp}_{$random}.{$ext}";
    }

    // 検出されたすべての有効ディレクトリに書き込み（同期）
    $written = false;
    foreach ($targetDirs as $dir) {
        $dest = rtrim($dir, '/\\') . '/' . $filename;
        if (@file_put_contents($dest, $fileData) !== false) {
            $written = true;
        }
    }

    if (!$written) {
        error_log("saveImageUriToFile: ファイル書き込みに失敗しました ({$filename})");
        return $trimmed;
    }

    $urlSub = $sub !== '' ? "/{$sub}" : '';
    return "/uploads/images{$urlSub}/{$filename}";
}

/**
 * 複数画像（スクリーンショット一覧）の配列またはJSONを受け取り、各画像を実ファイル化してURL配列を返す
 *
 * @param array|string|null $images JSON文字列または配列
 * @param string $appId アプリID
 * @return array<string> 画像URLの配列
 */
function processAppImagesList($images, string $appId): array
{
    if (empty($images)) {
        return [];
    }

    $list = is_string($images) ? (json_decode($images, true) ?: []) : (array)$images;
    if (!is_array($list)) {
        return [];
    }

    $result = [];
    $idx = 1;
    $safeId = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $appId) ?: 'app';

    foreach ($list as $img) {
        if (!empty($img) && is_string($img)) {
            $result[] = saveImageUriToFile($img, 'apps', "{$safeId}_screen_{$idx}");
            $idx++;
        }
    }

    return $result;
}
