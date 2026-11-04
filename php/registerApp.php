<?php
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/authAccountforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';

header('Content-Type: application/json; charset=UTF-8');

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
$name = trim($data['name']);
$type = !empty($data['type']) ? $data['type'] : 'app';
$category = !empty($data['category']) ? $data['category'] : 'ツール';
$price = isset($data['price']) ? intval($data['price']) : 0;
$icon = !empty($data['icon']) ? $data['icon'] : '';
$thumbnail = !empty($data['thumbnail']) ? $data['thumbnail'] : '';
$description = !empty($data['description']) ? $data['description'] : '';
$summary = !empty($data['summary']) ? $data['summary'] : '';
$platforms = isset($data['platforms']) ? (is_array($data['platforms']) ? json_encode($data['platforms'], JSON_UNESCAPED_UNICODE) : $data['platforms']) : '[]';
$languages = isset($data['languages']) ? (is_array($data['languages']) ? json_encode($data['languages'], JSON_UNESCAPED_UNICODE) : $data['languages']) : '[]';
$links = isset($data['links']) ? (is_array($data['links']) ? json_encode($data['links'], JSON_UNESCAPED_UNICODE) : $data['links']) : '[]';
$githubUrl = !empty($data['githubUrl']) ? $data['githubUrl'] : null;
$videoUrl = !empty($data['videoUrl']) ? $data['videoUrl'] : null;
$images = isset($data['images']) ? (is_array($data['images']) ? json_encode($data['images'], JSON_UNESCAPED_UNICODE) : $data['images']) : '[]';
$rating = isset($data['rating']) ? floatval($data['rating']) : 5.0;
$downloads = !empty($data['downloads']) ? $data['downloads'] : 'NEW';
$developer = !empty($data['developer']) ? $data['developer'] : 'エノキ電気';
$featured = !empty($data['featured']) ? 1 : 0;

$mysqlSaved = false;
$mysqlError = null;

// ==================== MySQL データベースへの保存 ====================
try {
  $pdo = SQLConnect();
  if ($pdo) {
    $sql = "INSERT INTO `app_list` (
      `appId`, `name`, `type`, `category`, `price`, `icon`, `thumbnail`,
      `description`, `summary`, `platforms`, `languages`, `links`,
      `githubUrl`, `videoUrl`, `images`, `rating`, `downloads`, `developer`,
      `featured`, `createdAt`, `updatedAt`
    ) VALUES (
      :appId, :name, :type, :category, :price, :icon, :thumbnail,
      :description, :summary, :platforms, :languages, :links,
      :githubUrl, :videoUrl, :images, :rating, :downloads, :developer,
      :featured, :createdAt, :updatedAt
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
      `featured` = VALUES(`featured`),
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
      ':createdAt' => $now,
      ':updatedAt' => $now,
    ]);
  }
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL App Save Error: " . $mysqlError);
}

// ==================== JSON ファイルへの同期保存 ====================
$files = [
  DIR_ROOT . '/app/data/apps.json',
  DIR_ROOT . '/public/data/apps.json',
];

foreach ($files as $filePath) {
  if (file_exists($filePath)) {
    $existing = json_decode(file_get_contents($filePath), true) ?: [];
    $found = false;
    foreach ($existing as $k => $item) {
      if ($item['id'] === $data['id']) {
        $existing[$k] = array_merge($item, $data);
        $found = true;
        break;
      }
    }
    if (!$found) {
      array_unshift($existing, $data);
    }
    file_put_contents($filePath, json_encode($existing, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
  }
}

echo json_encode([
  'status' => 'ok',
  'message' => 'アプリ情報をMySQLに登録・更新しました。',
  'mysqlSaved' => $mysqlSaved,
  'mysqlError' => $mysqlError,
  'appId' => $appId,
  'data' => $data,
], JSON_UNESCAPED_UNICODE);
