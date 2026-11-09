<?php
/**
 * imageStorage.php
 * 画像のアップロード保存、Base64デコード保存、および
 * アプリ名からアイコン・サムネイルSVGを自動生成して保存するヘルパー関数群
 */

/**
 * アップロード先の物理ディレクトリ一覧を取得
 *
 * @param string $subDir サブディレクトリ名 (例: 'images', '')
 * @return array<string> 保存先ディレクトリパス一覧
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
                break;
            }
        }
    }

    return $validDirs;
}

/**
 * アプリ名からカラーパレットを決定する
 */
function getAppPalette(string $name): array
{
    $palettes = [
        ['c1' => '#4F46E5', 'c2' => '#06B6D4', 'accent' => '#38BDF8'], // Indigo -> Cyan
        ['c1' => '#7C3AED', 'c2' => '#DB2777', 'accent' => '#F472B6'], // Purple -> Pink
        ['c1' => '#059669', 'c2' => '#10B981', 'accent' => '#34D399'], // Emerald
        ['c1' => '#D97706', 'c2' => '#EA580C', 'accent' => '#FBBF24'], // Amber -> Orange
        ['c1' => '#2563EB', 'c2' => '#4F46E5', 'accent' => '#60A5FA'], // Blue -> Indigo
        ['c1' => '#DC2626', 'c2' => '#E11D48', 'accent' => '#FB7185'], // Red -> Rose
        ['c1' => '#0D9488', 'c2' => '#0284C7', 'accent' => '#2DD4BF'], // Teal -> Sky
    ];
    $hash = 0;
    $len = mb_strlen($name, 'UTF-8');
    for ($i = 0; $i < $len; $i++) {
        $char = mb_substr($name, $i, 1, 'UTF-8');
        $hash = (($hash << 5) - $hash) + mb_ord($char, 'UTF-8');
        $hash = $hash & 0xFFFFFFFF;
    }
    $idx = abs($hash) % count($palettes);
    return $palettes[$idx];
}

/**
 * アプリ名からアイコンSVGコードを生成 (256x256)
 */
function generateAppIconSvgPHP(string $name): string
{
    $safeName = trim($name) !== '' ? trim($name) : 'App';
    $char = mb_substr($safeName, 0, 1, 'UTF-8');
    $p = getAppPalette($safeName);
    $escapedChar = htmlspecialchars($char, ENT_QUOTES | ENT_XML1, 'UTF-8');

    return <<<SVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="icon_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="{$p['c1']}"/>
      <stop offset="100%" stop-color="{$p['c2']}"/>
    </linearGradient>
    <filter id="icon_shadow" x="-10%" y="-10%" width="130%" height="130%">
      <feDropShadow dx="0" dy="6" stdDeviation="8" flood-color="#000000" flood-opacity="0.3"/>
    </filter>
  </defs>
  <rect width="256" height="256" rx="56" fill="url(#icon_bg)"/>
  <circle cx="128" cy="128" r="90" fill="none" stroke="{$p['accent']}" stroke-width="3" opacity="0.25"/>
  <text x="128" y="162" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="96" fill="#ffffff" filter="url(#icon_shadow)">{$escapedChar}</text>
</svg>
SVG;
}

/**
 * アプリ名からサムネイルSVGコードを生成 (640x360, 16:9)
 */
function generateAppThumbnailSvgPHP(string $name, string $category = 'アプリ'): string
{
    $safeName = trim($name) !== '' ? trim($name) : 'App';
    $safeCat = trim($category) !== '' ? trim($category) : 'アプリ';
    $p = getAppPalette($safeName);
    $escapedName = htmlspecialchars($safeName, ENT_QUOTES | ENT_XML1, 'UTF-8');
    $escapedCat = htmlspecialchars($safeCat, ENT_QUOTES | ENT_XML1, 'UTF-8');

    return <<<SVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 360" width="640" height="360">
  <defs>
    <linearGradient id="thumb_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="{$p['c1']}"/>
      <stop offset="100%" stop-color="{$p['c2']}"/>
    </linearGradient>
    <linearGradient id="thumb_overlay" x1="0%" y1="100%" x2="0%" y2="0%">
      <stop offset="0%" stop-color="#000000" stop-opacity="0.85"/>
      <stop offset="55%" stop-color="#000000" stop-opacity="0.3"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect width="640" height="360" rx="16" fill="url(#thumb_bg)"/>
  <circle cx="540" cy="90" r="130" fill="#ffffff" opacity="0.08"/>
  <circle cx="100" cy="70" r="110" fill="#ffffff" opacity="0.05"/>
  <circle cx="580" cy="270" r="160" fill="#000000" opacity="0.15"/>
  <rect width="640" height="360" rx="16" fill="url(#thumb_overlay)"/>
  <rect x="36" y="32" width="100" height="24" rx="12" fill="{$p['accent']}" opacity="0.9"/>
  <text x="86" y="48" font-family="system-ui, sans-serif" font-weight="700" font-size="11" fill="#000000" text-anchor="middle">{$escapedCat}</text>
  <text x="36" y="270" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="28" fill="#ffffff">{$escapedName}</text>
  <text x="36" y="305" font-family="system-ui, -apple-system, sans-serif" font-weight="500" font-size="15" fill="#e0e0e0">公式ハイライト • ENOKI APPS</text>
</svg>
SVG;
}

/**
 * 文字列SVGをファイルとして保存し、URLを返す
 */
function saveSvgContentToFile(string $svgContent, string $filenamePrefix): ?string
{
    $targetDirs = getUploadTargetDirectories();
    if (empty($targetDirs)) {
        return null;
    }

    $timestamp = time();
    $random = bin2hex(random_bytes(4));
    $filename = "{$filenamePrefix}_{$timestamp}_{$random}.svg";

    foreach ($targetDirs as $dir) {
        $dest = rtrim($dir, '/\\') . '/' . $filename;
        if (@file_put_contents($dest, $svgContent) !== false) {
            return "/uploads/images/{$filename}";
        }
    }
    return null;
}

/**
 * Base64 または SVG Data URI を画像ファイルとして保存し、相対URL (/uploads/images/...) を返す
 * すでに URL（/uploads/... や http...）の場合はそのまま返す
 */
function saveImageUriToFile(?string $dataUri, ?string $preferredName = null): string
{
    if (empty($dataUri) || !is_string($dataUri)) {
        return '';
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

    $targetDirs = getUploadTargetDirectories();
    if (empty($targetDirs)) {
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
        return $trimmed;
    }

    if ($fileData === false || $fileData === null || strlen($fileData) === 0) {
        return $trimmed;
    }

    $timestamp = time();
    $random = bin2hex(random_bytes(4));
    $prefix = !empty($preferredName) ? preg_replace('/[^a-zA-Z0-9_\-]/', '_', $preferredName) : 'img';
    $filename = "{$prefix}_{$timestamp}_{$random}.{$ext}";

    foreach ($targetDirs as $dir) {
        $dest = rtrim($dir, '/\\') . '/' . $filename;
        if (@file_put_contents($dest, $fileData) !== false) {
            return "/uploads/images/{$filename}";
        }
    }

    return $trimmed;
}
