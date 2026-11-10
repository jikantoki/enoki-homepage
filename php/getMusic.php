<?php
//これがないとメモリがオーバーして処理が止まる
ini_set('memory_limit', '-1');
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
    $stmt = $pdo->query("SELECT * FROM `music_list` ORDER BY `createdAt` DESC");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $musics = [];
    foreach ($rows as $row) {
      $musics[] = [
        'id' => $row['musicId'],
        'title' => $row['title'],
        'name' => $row['name'] ?: $row['title'],
        'artist' => $row['artist'],
        'album' => $row['album'],
        'albumType' => $row['albumType'],
        'genre' => $row['genre'],
        'bpm' => intval($row['bpm']),
        'price' => intval($row['price']),
        'audioUrl' => toApiPublicAssetUrl($row['audioUrl']),
        'cover' => toApiPublicAssetUrl($row['cover']),
        'icon' => toApiPublicAssetUrl($row['icon'] ?: $row['cover']),
        'thumbnail' => toApiPublicAssetUrl($row['thumbnail'] ?: $row['cover']),
        'duration' => intval($row['duration']),
        'durationFormatted' => $row['durationFormatted'],
        'releaseDate' => intval($row['releaseDate']),
        'releaseDateFormatted' => $row['releaseDateFormatted'],
        'plays' => $row['plays'],
        'rating' => floatval($row['rating']),
        'featured' => boolval($row['featured']),
        'isTrending' => boolval($row['isTrending']),
        'isUnfinished' => boolval($row['isUnfinished'] ?? false) || (isset($row['tags']) && in_array('未完成', json_decode($row['tags'] ?? '[]', true) ?: [])),
        'tags' => json_decode($row['tags'] ?? '[]', true) ?: (!empty($row['isUnfinished']) ? ['未完成'] : []),
        'themeColor' => $row['themeColor'],
        'accentColor' => $row['accentColor'],
        'audioPreset' => $row['audioPreset'],
        'description' => $row['description'],
        'lyrics' => $row['lyrics'],
        'composer' => $row['composer'],
        'lyricist' => $row['lyricist'],
        'type' => 'music',
      ];
    }

    echo json_encode([
      'status' => 'ok',
      'source' => 'mysql',
      'count' => count($musics),
      'data' => $musics,
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
} catch (\Throwable $th) {
  $dbError = $th->getMessage();
  error_log("getMusic Error: " . $th->getMessage());
}

echo json_encode([
  'status' => 'error',
  'reason' => '楽曲情報をデータベースから取得できませんでした。' . (!empty($dbError) ? " ({$dbError})" : ''),
], JSON_UNESCAPED_UNICODE);
