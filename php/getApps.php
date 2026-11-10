<?php
// メモリ制限設定
ini_set('memory_limit', '256M');
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';

header('Content-Type: application/json; charset=UTF-8');

try {
  $pdo = SQLConnect();
  if ($pdo) {
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $pdo->query("SELECT * FROM `app_list` ORDER BY `createdAt` DESC");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $apps = [];
    foreach ($rows as $row) {
      $rawImages = json_decode($row['images'], true) ?: [];
      $normalizedImages = is_array($rawImages) ? array_map('toApiPublicAssetUrl', $rawImages) : [];

      $apps[] = [
        'id' => $row['appId'],
        'name' => $row['name'],
        'type' => $row['type'],
        'category' => $row['category'],
        'price' => intval($row['price']),
        'icon' => toApiPublicAssetUrl($row['icon']),
        'thumbnail' => toApiPublicAssetUrl($row['thumbnail']),
        'description' => $row['description'],
        'summary' => $row['summary'],
        'platforms' => json_decode($row['platforms'], true) ?: [],
        'languages' => json_decode($row['languages'], true) ?: [],
        'links' => json_decode($row['links'], true) ?: [],
        'githubUrl' => $row['githubUrl'],
        'videoUrl' => $row['videoUrl'],
        'images' => $normalizedImages,
        'rating' => floatval($row['rating']),
        'downloads' => $row['downloads'],
        'developer' => $row['developer'],
        'featured' => boolval($row['featured']),
        'isUnfinished' => boolval($row['isUnfinished'] ?? false) || (isset($row['tags']) && in_array('未完成', json_decode($row['tags'] ?? '[]', true) ?: [])),
        'tags' => json_decode($row['tags'] ?? '[]', true) ?: (!empty($row['isUnfinished']) ? ['未完成'] : []),
        'releaseDate' => intval($row['createdAt']) * 1000,
      ];
    }

    echo json_encode([
      'status' => 'ok',
      'source' => 'mysql',
      'count' => count($apps),
      'data' => $apps,
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
} catch (\Throwable $th) {
  $dbError = $th->getMessage();
  error_log("getApps Error: " . $th->getMessage());
}

echo json_encode([
  'status' => 'error',
  'reason' => 'アプリ情報をデータベースから取得できませんでした。' . (!empty($dbError) ? " ({$dbError})" : ''),
], JSON_UNESCAPED_UNICODE);
