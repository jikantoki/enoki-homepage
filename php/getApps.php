<?php
// これがないとメモリがオーバーして処理が止まる（Base64 URL化により今後は少量で動作）
ini_set('memory_limit', '-1');
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';
require_once DIR_ROOT . '/php/functions/imageStorage.php';

header('Content-Type: application/json; charset=UTF-8');

try {
  $pdo = SQLConnect();
  if ($pdo) {
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $pdo->query("SELECT * FROM `app_list` ORDER BY `createdAt` DESC");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $apps = [];
    $updateStmt = null;

    foreach ($rows as $row) {
      $appId = $row['appId'];
      $safeId = preg_replace('/[^a-zA-Z0-9_\-]/', '_', $appId) ?: 'app';

      $rawIcon = $row['icon'];
      $rawThumbnail = $row['thumbnail'];
      $rawImages = $row['images'];

      // 画像が Base64 / Data URI であればファイル保存して URL に変換
      $iconUrl = saveImageUriToFile($rawIcon, 'apps', "{$safeId}_icon");
      $thumbnailUrl = saveImageUriToFile($rawThumbnail, 'apps', "{$safeId}_thumb");
      $imagesUrls = processAppImagesList($rawImages, $safeId);

      // もしDB内の生データが Base64 だった場合、DBレコードも自動更新（オンザフライマイグレーション）
      $needsDbUpdate = false;
      if ($rawIcon !== $iconUrl && str_starts_with(trim($rawIcon ?? ''), 'data:image/')) {
        $needsDbUpdate = true;
      }
      if ($rawThumbnail !== $thumbnailUrl && str_starts_with(trim($rawThumbnail ?? ''), 'data:image/')) {
        $needsDbUpdate = true;
      }
      $encodedImages = json_encode($imagesUrls, JSON_UNESCAPED_UNICODE);
      if ($rawImages !== $encodedImages && str_contains($rawImages ?? '', 'data:image/')) {
        $needsDbUpdate = true;
      }

      if ($needsDbUpdate) {
        try {
          if (!$updateStmt) {
            $updateStmt = $pdo->prepare(
              "UPDATE `app_list` SET `icon` = :icon, `thumbnail` = :thumbnail, `images` = :images WHERE `appId` = :appId"
            );
          }
          $updateStmt->execute([
            ':icon' => $iconUrl,
            ':thumbnail' => $thumbnailUrl,
            ':images' => $encodedImages,
            ':appId' => $appId,
          ]);
        } catch (\Throwable $updateErr) {
          error_log("getApps On-the-fly update error for {$appId}: " . $updateErr->getMessage());
        }
      }

      $apps[] = [
        'id' => $row['appId'],
        'name' => $row['name'],
        'type' => $row['type'],
        'category' => $row['category'],
        'price' => intval($row['price']),
        'icon' => $iconUrl,
        'thumbnail' => $thumbnailUrl,
        'description' => $row['description'],
        'summary' => $row['summary'],
        'platforms' => json_decode($row['platforms'], true) ?: [],
        'languages' => json_decode($row['languages'], true) ?: [],
        'links' => json_decode($row['links'], true) ?: [],
        'githubUrl' => $row['githubUrl'],
        'videoUrl' => $row['videoUrl'],
        'images' => $imagesUrls,
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
