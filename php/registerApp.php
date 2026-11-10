<?php
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/authAccountforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';
require_once DIR_ROOT . '/php/functions/imageStorage.php';

header('Content-Type: application/json; charset=UTF-8');

// ==================== 管理者権限チェック ====================
// $secretId は authAccountforUse.php で設定される
if (!isUserAdmin($secretId)) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントのみ実行できます。',
    'errCode' => 403,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$input = file_get_contents('php://input');
$data = json_decode($input, true) ?: $_POST;

if (empty($data['name']) || empty($data['id'])) {
  echo json_encode([
    'status' => 'error',
    'reason' => 'アプリ名とアプリIDは必須です。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$now = time();
$appId = trim($data['id']);
$safeId = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $appId) ?: 'app';
$name = trim($data['name']);
$type = !empty($data['type']) ? $data['type'] : 'app';
$category = !empty($data['category']) ? $data['category'] : '便利ツール';
$price = isset($data['price']) ? intval($data['price']) : 0;

// ==================== アイコン画像の設定 ====================
$rawIcon = !empty($data['icon']) ? trim($data['icon']) : '';
if ($rawIcon === '') {
  // 画像が未アップロードの場合はアプリ名からアイコンSVGを生成・保存
  $iconSvg = generateAppIconSvgPHP($name);
  $icon = saveSvgContentToFile($iconSvg, "icon_{$safeId}", 'apps') ?: '';
} else {
  // Data URI で送られてきた場合はファイル保存して URL に置換
  $icon = saveImageUriToFile($rawIcon, 'apps', "icon_{$safeId}");
}

// ==================== サムネイル画像の設定 ====================
$rawThumbnail = !empty($data['thumbnail']) ? trim($data['thumbnail']) : '';
if ($rawThumbnail === '') {
  // 画像が未アップロードの場合はアプリ名からサムネイルSVGを生成・保存
  $thumbSvg = generateAppThumbnailSvgPHP($name, $category);
  $thumbnail = saveSvgContentToFile($thumbSvg, "thumb_{$safeId}", 'apps') ?: '';
} else {
  // Data URI で送られてきた場合はファイル保存して URL に置換
  $thumbnail = saveImageUriToFile($rawThumbnail, 'apps', "thumb_{$safeId}");
}

// ==================== スクリーンショット画像一覧 ====================
$rawImages = isset($data['images']) ? $data['images'] : [];
$processedImages = processAppImagesList($rawImages, $safeId, 'apps');
if (empty($processedImages) && !empty($thumbnail)) {
  $processedImages = [$thumbnail];
}
$images = json_encode($processedImages, JSON_UNESCAPED_UNICODE);

$description = !empty($data['description']) ? $data['description'] : '';
$summary = !empty($data['summary']) ? $data['summary'] : '';
$platforms = isset($data['platforms']) ? (is_array($data['platforms']) ? json_encode($data['platforms'], JSON_UNESCAPED_UNICODE) : $data['platforms']) : '[]';
$languages = isset($data['languages']) ? (is_array($data['languages']) ? json_encode($data['languages'], JSON_UNESCAPED_UNICODE) : $data['languages']) : '[]';
$links = isset($data['links']) ? (is_array($data['links']) ? json_encode($data['links'], JSON_UNESCAPED_UNICODE) : $data['links']) : '[]';
$githubUrl = !empty($data['githubUrl']) ? $data['githubUrl'] : null;
$videoUrl = !empty($data['videoUrl']) ? $data['videoUrl'] : null;
$rating = isset($data['rating']) ? floatval($data['rating']) : 5.0;
$downloads = !empty($data['downloads']) ? $data['downloads'] : 'NEW';
$developer = !empty($data['developer']) ? $data['developer'] : 'エノキ電気';
$featured = !empty($data['featured']) ? 1 : 0;
$isUnfinished = (!empty($data['isUnfinished']) || (isset($data['tags']) && is_array($data['tags']) && in_array('未完成', $data['tags']))) ? 1 : 0;
$tags = isset($data['tags']) ? (is_array($data['tags']) ? json_encode($data['tags'], JSON_UNESCAPED_UNICODE) : $data['tags']) : ($isUnfinished ? json_encode(['未完成'], JSON_UNESCAPED_UNICODE) : '[]');

$mysqlSaved = false;
$mysqlError = null;

// ==================== MySQL データベースへの保存 ====================
try {
  $pdo = SQLConnect();
  if (!$pdo) {
    throw new \RuntimeException('MySQLに接続できませんでした。');
  }
  $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $sql = "INSERT INTO `app_list` (
    `appId`, `name`, `type`, `category`, `price`, `icon`, `thumbnail`,
    `description`, `summary`, `platforms`, `languages`, `links`,
    `githubUrl`, `videoUrl`, `images`, `rating`, `downloads`, `developer`,
    `featured`, `isUnfinished`, `tags`, `createdAt`, `updatedAt`
  ) VALUES (
    :appId, :name, :type, :category, :price, :icon, :thumbnail,
    :description, :summary, :platforms, :languages, :links,
    :githubUrl, :videoUrl, :images, :rating, :downloads, :developer,
    :featured, :isUnfinished, :tags, :createdAt, :updatedAt
  ) ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `type` = VALUES(`type`),
    `category` = VALUES(`category`),
    `price` = VALUES(`price`),
    `icon` = VALUES(`icon`),
    `thumbnail` = VALUES(`thumbnail`),
    `description` = VALUES(`description`),
    `summary` = VALUES(`summary`),
    `platforms` = VALUES(`platforms`),
    `languages` = VALUES(`languages`),
    `links` = VALUES(`links`),
    `githubUrl` = VALUES(`githubUrl`),
    `videoUrl` = VALUES(`videoUrl`),
    `images` = VALUES(`images`),
    `developer` = VALUES(`developer`),
    `featured` = VALUES(`featured`),
    `isUnfinished` = VALUES(`isUnfinished`),
    `tags` = VALUES(`tags`),
    `updatedAt` = VALUES(`updatedAt`)";

  $stmt = $pdo->prepare($sql);
  $mysqlSaved = $stmt->execute([
    ':appId' => $appId,
    ':name' => $name,
    ':type' => $type,
    ':category' => $category,
    ':price' => $price,
    ':icon' => $icon,
    ':thumbnail' => $thumbnail,
    ':description' => $description,
    ':summary' => $summary,
    ':platforms' => $platforms,
    ':languages' => $languages,
    ':links' => $links,
    ':githubUrl' => $githubUrl,
    ':videoUrl' => $videoUrl,
    ':images' => $images,
    ':rating' => $rating,
    ':downloads' => $downloads,
    ':developer' => $developer,
    ':featured' => $featured,
    ':isUnfinished' => $isUnfinished,
    ':tags' => $tags,
    ':createdAt' => $now,
    ':updatedAt' => $now,
  ]);
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL App Save Error: " . $mysqlError);
}

if (!$mysqlSaved) {
  echo json_encode([
    'status' => 'error',
    'reason' => 'アプリ情報をデータベースに保存できませんでした。' . ($mysqlError ? " ({$mysqlError})" : ''),
    'mysqlSaved' => false,
    'mysqlError' => $mysqlError,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

// レスポンス用データの更新
$responseData = array_merge($data, [
  'id' => $appId,
  'icon' => $icon,
  'thumbnail' => $thumbnail,
  'images' => !empty($processedImages) ? $processedImages : ($thumbnail ? [$thumbnail] : []),
]);

echo json_encode([
  'status' => 'ok',
  'message' => 'アプリ情報をデータベースに登録・更新しました。',
  'mysqlSaved' => $mysqlSaved,
  'mysqlError' => $mysqlError,
  'appId' => $appId,
  'data' => $responseData,
], JSON_UNESCAPED_UNICODE);
