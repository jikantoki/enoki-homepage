<?php
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';

header('Content-Type: application/json; charset=UTF-8');

try {
  $pdo = SQLConnect();
  if ($pdo) {
    $stmt = $pdo->query("SELECT * FROM `app_list` ORDER BY `createdAt` DESC");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $apps = [];
    foreach ($rows as $row) {
      $apps[] = [
        'id' => $row['appId'],
        'name' => $row['name'],
        'type' => $row['type'],
        'category' => $row['category'],
        'price' => intval($row['price']),
        'icon' => $row['icon'],
        'thumbnail' => $row['thumbnail'],
        'description' => $row['description'],
        'summary' => $row['summary'],
        'platforms' => json_decode($row['platforms'], true) ?: [],
        'languages' => json_decode($row['languages'], true) ?: [],
        'links' => json_decode($row['links'], true) ?: [],
        'githubUrl' => $row['githubUrl'],
        'videoUrl' => $row['videoUrl'],
        'images' => json_decode($row['images'], true) ?: [],
        'rating' => floatval($row['rating']),
        'downloads' => $row['downloads'],
        'developer' => $row['developer'],
        'featured' => boolval($row['featured']),
        'releaseDate' => intval($row['createdAt']) * 1000,
      ];
    }

    echo json_encode([
      'status' => 'ok',
      'count' => count($apps),
      'data' => $apps,
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
} catch (\Throwable $th) {
  error_log("getApps Error: " . $th->getMessage());
}

// フォールバック: JSONファイルから読み込み
$jsonFile = DIR_ROOT . '/app/data/apps.json';
if (file_exists($jsonFile)) {
  $apps = json_decode(file_get_contents($jsonFile), true) ?: [];
  echo json_encode([
    'status' => 'ok',
    'count' => count($apps),
    'data' => $apps,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

echo json_encode([
  'status' => 'error',
  'reason' => 'アプリ情報の取得に失敗しました。',
], JSON_UNESCAPED_UNICODE);
