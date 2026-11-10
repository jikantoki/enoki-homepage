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

if (empty($data['title']) || empty($data['id'])) {
  echo json_encode([
    'status' => 'error',
    'reason' => '楽曲タイトルと楽曲IDは必須です。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$now = time();
$musicId = trim($data['id']);
$title = trim($data['title']);
$name = !empty($data['name']) ? trim($data['name']) : $title;
$artist = !empty($data['artist']) ? trim($data['artist']) : 'エノキ電気';
$album = !empty($data['album']) ? trim($data['album']) : $title;
$albumType = !empty($data['albumType']) ? $data['albumType'] : 'single';
$genre = !empty($data['genre']) ? $data['genre'] : '歌モノ';
$bpm = isset($data['bpm']) ? intval($data['bpm']) : 120;
$price = isset($data['price']) ? intval($data['price']) : 0;
$audioUrl = !empty($data['audioUrl']) ? toApiPublicAssetUrl($data['audioUrl']) : null;
$cover = !empty($data['cover']) ? $data['cover'] : '';
$cover = saveImageUriToFile($cover, 'cover_' . $musicId);
$icon = !empty($data['icon']) ? $data['icon'] : $cover;
$icon = saveImageUriToFile($icon, 'cover_' . $musicId);
$thumbnail = !empty($data['thumbnail']) ? $data['thumbnail'] : $cover;
$thumbnail = saveImageUriToFile($thumbnail, 'cover_' . $musicId);
$duration = isset($data['duration']) ? intval($data['duration']) : 180;
$durationFormatted = !empty($data['durationFormatted']) ? $data['durationFormatted'] : '3:00';
$releaseDate = isset($data['releaseDate']) ? $data['releaseDate'] : ($now * 1000);
$releaseDateFormatted = !empty($data['releaseDateFormatted']) ? $data['releaseDateFormatted'] : date('Y/m/d', $now);
$plays = !empty($data['plays']) ? $data['plays'] : 'NEW';
$rating = isset($data['rating']) ? floatval($data['rating']) : 5.0;
$featured = !empty($data['featured']) ? 1 : 0;
$isTrending = !empty($data['isTrending']) ? 1 : 0;
$isUnfinished = (!empty($data['isUnfinished']) || (isset($data['tags']) && is_array($data['tags']) && in_array('未完成', $data['tags']))) ? 1 : 0;
$tags = isset($data['tags']) ? (is_array($data['tags']) ? json_encode($data['tags'], JSON_UNESCAPED_UNICODE) : $data['tags']) : ($isUnfinished ? json_encode(['未完成'], JSON_UNESCAPED_UNICODE) : '[]');
$themeColor = !empty($data['themeColor']) ? $data['themeColor'] : '#4F46E5';
$accentColor = !empty($data['accentColor']) ? $data['accentColor'] : '#38BDF8';
$audioPreset = !empty($data['audioPreset']) ? $data['audioPreset'] : 'citypop';
$description = !empty($data['description']) ? $data['description'] : '';
$lyrics = !empty($data['lyrics']) ? $data['lyrics'] : '';
$composer = !empty($data['composer']) ? $data['composer'] : $artist;
$lyricist = !empty($data['lyricist']) ? $data['lyricist'] : $artist;

$mysqlSaved = false;
$mysqlError = null;

// ==================== MySQL データベースへの保存 ====================
try {
  $pdo = SQLConnect();
  if (!$pdo) {
    throw new \RuntimeException('MySQLに接続できませんでした。');
  }
  $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $sql = "INSERT INTO `music_list` (
    `musicId`, `title`, `name`, `artist`, `album`, `albumType`,
    `genre`, `bpm`, `price`, `audioUrl`, `cover`, `icon`, `thumbnail`,
    `duration`, `durationFormatted`, `releaseDate`, `releaseDateFormatted`,
    `plays`, `rating`, `featured`, `isTrending`, `isUnfinished`, `tags`, `themeColor`, `accentColor`,
    `audioPreset`, `description`, `lyrics`, `composer`, `lyricist`,
    `createdAt`, `updatedAt`
  ) VALUES (
    :musicId, :title, :name, :artist, :album, :albumType,
    :genre, :bpm, :price, :audioUrl, :cover, :icon, :thumbnail,
    :duration, :durationFormatted, :releaseDate, :releaseDateFormatted,
    :plays, :rating, :featured, :isTrending, :isUnfinished, :tags, :themeColor, :accentColor,
    :audioPreset, :description, :lyrics, :composer, :lyricist,
    :createdAt, :updatedAt
  ) ON DUPLICATE KEY UPDATE
    `title` = VALUES(`title`),
    `name` = VALUES(`name`),
    `artist` = VALUES(`artist`),
    `album` = VALUES(`album`),
    `albumType` = VALUES(`albumType`),
    `genre` = VALUES(`genre`),
    `bpm` = VALUES(`bpm`),
    `price` = VALUES(`price`),
    `audioUrl` = VALUES(`audioUrl`),
    `cover` = VALUES(`cover`),
    `icon` = VALUES(`icon`),
    `thumbnail` = VALUES(`thumbnail`),
    `duration` = VALUES(`duration`),
    `durationFormatted` = VALUES(`durationFormatted`),
    `featured` = VALUES(`featured`),
    `isTrending` = VALUES(`isTrending`),
    `isUnfinished` = VALUES(`isUnfinished`),
    `tags` = VALUES(`tags`),
    `themeColor` = VALUES(`themeColor`),
    `accentColor` = VALUES(`accentColor`),
    `audioPreset` = VALUES(`audioPreset`),
    `description` = VALUES(`description`),
    `lyrics` = VALUES(`lyrics`),
    `composer` = VALUES(`composer`),
    `lyricist` = VALUES(`lyricist`),
    `updatedAt` = VALUES(`updatedAt`)";

  $stmt = $pdo->prepare($sql);
  $mysqlSaved = $stmt->execute([
    ':musicId' => $musicId,
    ':title' => $title,
    ':name' => $name,
    ':artist' => $artist,
    ':album' => $album,
    ':albumType' => $albumType,
    ':genre' => $genre,
    ':bpm' => $bpm,
    ':price' => $price,
    ':audioUrl' => $audioUrl,
    ':cover' => $cover,
    ':icon' => $icon,
    ':thumbnail' => $thumbnail,
    ':duration' => $duration,
    ':durationFormatted' => $durationFormatted,
    ':releaseDate' => $releaseDate,
    ':releaseDateFormatted' => $releaseDateFormatted,
    ':plays' => $plays,
    ':rating' => $rating,
    ':featured' => $featured,
    ':isTrending' => $isTrending,
    ':isUnfinished' => $isUnfinished,
    ':tags' => $tags,
    ':themeColor' => $themeColor,
    ':accentColor' => $accentColor,
    ':audioPreset' => $audioPreset,
    ':description' => $description,
    ':lyrics' => $lyrics,
    ':composer' => $composer,
    ':lyricist' => $lyricist,
    ':createdAt' => $now,
    ':updatedAt' => $now,
  ]);
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL Music Save Error: " . $mysqlError);
}

if (!$mysqlSaved) {
  echo json_encode([
    'status' => 'error',
    'reason' => '楽曲情報をデータベースに保存できませんでした。' . ($mysqlError ? " ({$mysqlError})" : ''),
    'mysqlSaved' => false,
    'mysqlError' => $mysqlError,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

echo json_encode([
  'status' => 'ok',
  'message' => '楽曲情報をデータベースに登録・更新しました。',
  'mysqlSaved' => $mysqlSaved,
  'mysqlError' => $mysqlError,
  'musicId' => $musicId,
  'data' => $data,
], JSON_UNESCAPED_UNICODE);
