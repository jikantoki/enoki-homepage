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

$appId = !empty($data['id']) ? trim($data['id']) : (!empty($data['appId']) ? trim($data['appId']) : '');

if (empty($appId)) {
  echo json_encode([
    'status' => 'error',
    'reason' => '削除対象のアプリID (id または appId) が指定されていません。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$mysqlDeleted = false;
$mysqlError = null;

// ==================== MySQL からの削除 ====================
try {
  $pdo = SQLConnect();
  if ($pdo) {
    $stmt = $pdo->prepare("DELETE FROM `app_list` WHERE `appId` = :appId");
    $mysqlDeleted = $stmt->execute([':appId' => $appId]);
  }
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL App Delete Error: " . $mysqlError);
}

// ==================== JSON ファイルからの削除 ====================
$files = [
  DIR_ROOT . '/app/data/apps.json',
  DIR_ROOT . '/public/data/apps.json',
];

foreach ($files as $filePath) {
  if (file_exists($filePath)) {
    $existing = json_decode(file_get_contents($filePath), true) ?: [];
    $filtered = array_values(array_filter($existing, function ($item) use ($appId) {
      return ($item['id'] ?? '') !== $appId;
    }));
    file_put_contents($filePath, json_encode($filtered, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
  }
}

echo json_encode([
  'status' => 'ok',
  'message' => "アプリ (ID: {$appId}) を削除しました。",
  'mysqlDeleted' => $mysqlDeleted,
  'mysqlError' => $mysqlError,
  'id' => $appId,
], JSON_UNESCAPED_UNICODE);
