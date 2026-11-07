<?php
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/authAccountforUse.php';
require_once DIR_ROOT . '/php/functions/database.php';

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

$musicId = !empty($data['id']) ? trim($data['id']) : (!empty($data['musicId']) ? trim($data['musicId']) : '');

if (empty($musicId)) {
  echo json_encode([
    'status' => 'error',
    'reason' => '削除対象の楽曲ID (id または musicId) が指定されていません。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$mysqlDeleted = false;
$deletedRows = 0;
$mysqlError = null;

// ==================== MySQL からの削除 ====================
try {
  $pdo = SQLConnect();
  if (!$pdo) {
    throw new \RuntimeException('MySQLに接続できませんでした。');
  }
  $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $stmt = $pdo->prepare("DELETE FROM `music_list` WHERE `musicId` = :musicId");
  $mysqlDeleted = $stmt->execute([':musicId' => $musicId]);
  $deletedRows = $stmt->rowCount();
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL Music Delete Error: " . $mysqlError);
}

if (!$mysqlDeleted) {
  echo json_encode([
    'status' => 'error',
    'reason' => '楽曲をデータベースから削除できませんでした。' . ($mysqlError ? " ({$mysqlError})" : ''),
    'mysqlDeleted' => false,
    'mysqlError' => $mysqlError,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

echo json_encode([
  'status' => 'ok',
  'deletedRows' => $deletedRows,
  'message' => "楽曲 (ID: {$musicId}) を削除しました。",
  'mysqlDeleted' => $mysqlDeleted,
  'mysqlError' => $mysqlError,
  'id' => $musicId,
], JSON_UNESCAPED_UNICODE);
