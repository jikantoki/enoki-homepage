<?php
/**
 * urlHelper.php
 * APIサーバーのベースURL取得およびアセットURLの正規化ヘルパー
 */

/**
 * APIサーバーのオリジンURL (例: https://api.home.enoki.xyz) を取得
 */
function getApiOriginUrl(): string
{
    // 1. 環境変数 NUXT_API_HOST があれば優先
    $envHost = getenv('NUXT_API_HOST');
    if (!empty($envHost)) {
        return rtrim($envHost, '/');
    }
    if (defined('API_HOST') && constant('API_HOST')) {
        return rtrim(constant('API_HOST'), '/');
    }

    // 2. リクエストヘッダーからの動的判定
    if (empty($_SERVER['HTTP_HOST'])) {
        return 'https://api.home.enoki.xyz';
    }

    $is_https = (!empty($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) !== 'off')
      || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strtolower(explode(',', $_SERVER['HTTP_X_FORWARDED_PROTO'])[0]) === 'https')
      || (isset($_SERVER['HTTP_X_FORWARDED_SSL']) && strtolower($_SERVER['HTTP_X_FORWARDED_SSL']) === 'on')
      || (isset($_SERVER['HTTP_CF_VISITOR']) && strpos($_SERVER['HTTP_CF_VISITOR'], 'https') !== false)
      || (isset($_SERVER['SERVER_PORT']) && intval($_SERVER['SERVER_PORT']) === 443);

    $proto = $is_https ? 'https' : 'http';
    return "{$proto}://{$_SERVER['HTTP_HOST']}";
}

/**
 * 相対URLやホスト名無しURLを APIサーバーの /public/... フルURLへ正規化
 *
 * 例: '/uploads/images/foo.png' -> 'https://api.home.enoki.xyz/public/uploads/images/foo.png'
 * 例: '/public/uploads/images/foo.png' -> 'https://api.home.enoki.xyz/public/uploads/images/foo.png'
 * 例: 'data:image/...' -> そのまま
 * 例: 'https://...' -> そのまま（ただしホスト名一致時の /public 抜けを自動補正）
 */
function toApiPublicAssetUrl(?string $url): string
{
    if (empty($url) || !is_string($url)) {
        return '';
    }
    $trimmed = trim($url);
    if ($trimmed === '') {
        return '';
    }

    // Data URI や Blob URL はそのまま
    if (str_starts_with($trimmed, 'data:') || str_starts_with($trimmed, 'blob:')) {
        return $trimmed;
    }

    $origin = getApiOriginUrl();

    // すでに完全なURLの場合
    if (str_starts_with($trimmed, 'http://') || str_starts_with($trimmed, 'https://')) {
        // もしホスト名付きで /uploads/... や /download/... になっていて /public が抜けている場合のケア
        if (str_starts_with($trimmed, $origin . '/uploads/')) {
            return str_replace($origin . '/uploads/', $origin . '/public/uploads/', $trimmed);
        }
        if (str_starts_with($trimmed, $origin . '/download/')) {
            return str_replace($origin . '/download/', $origin . '/public/download/', $trimmed);
        }
        if (str_starts_with($trimmed, $origin . '/customfiles/')) {
            return str_replace($origin . '/customfiles/', $origin . '/public/customfiles/', $trimmed);
        }
        return $trimmed;
    }

    // 相対パスの場合
    $cleanPath = '/' . ltrim($trimmed, '/');

    if (str_starts_with($cleanPath, '/public/')) {
        return $origin . $cleanPath;
    }

    if (
        str_starts_with($cleanPath, '/uploads/') ||
        str_starts_with($cleanPath, '/download/') ||
        str_starts_with($cleanPath, '/customfiles/')
    ) {
        return $origin . '/public' . $cleanPath;
    }

    return $cleanPath;
}
