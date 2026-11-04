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

$musicId = !empty($data['id']) ? trim($data['id']) : (!empty($data['musicId']) ? trim($data['musicId']) : '');

if (empty($musicId)) {
  echo json_encode([
    'status' => 'error',
    'reason' => '削除対象の楽曲ID (id または musicId) が指定されていません。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$mysqlDeleted = false;
$mysqlError = null;

// ==================== MySQL からの削除 ====================
try {
  $pdo = SQLConnect();
  if ($pdo) {
    $stmt = $pdo->prepare("DELETE FROM `music_list` WHERE `musicId` = :musicId");
    $mysqlDeleted = $stmt->execute([':musicId' => $musicId]);
  }
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL Music Delete Error: " . $mysqlError);
}

// ==================== JSON ファイルからの削除 ====================
$files = [
  DIR_ROOT . '/app/data/music.json',
  DIR_ROOT . '/public/data/music.json',
];

foreach ($files as $filePath) {
  if (file_exists($filePath)) {
    $existing = json_decode(file_get_contents($filePath), true) ?: [];
    $filtered = array_values(array_filter($existing, function ($item) use ($musicId) {
      return ($item['id'] ?? '') !== $musicId;
    }));
    file_put_contents($filePath, json_encode($filtered, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
  }
}

echo json_encode([
  'status' => 'ok',
  'message' => "楽曲 (ID: {$musicId}) を削除しました。",
  'mysqlDeleted' => $mysqlDeleted,
  'mysqlError' => $mysqlError,
  'id' => $musicId,
], JSON_UNESCAPED_UNICODE);
