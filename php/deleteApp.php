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

$appId = !empty($data['id']) ? trim($data['id']) : (!empty($data['appId']) ? trim($data['appId']) : '');

if (empty($appId)) {
  echo json_encode([
    'status' => 'error',
    'reason' => '削除対象のアプリID (id または appId) が指定されていません。',
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
  $stmt = $pdo->prepare("DELETE FROM `app_list` WHERE `appId` = :appId");
  $mysqlDeleted = $stmt->execute([':appId' => $appId]);
  $deletedRows = $stmt->rowCount();
} catch (\Throwable $th) {
  $mysqlError = $th->getMessage();
  error_log("MySQL App Delete Error: " . $mysqlError);
}

if (!$mysqlDeleted) {
  echo json_encode([
    'status' => 'error',
    'reason' => 'アプリをデータベースから削除できませんでした。' . ($mysqlError ? " ({$mysqlError})" : ''),
    'mysqlDeleted' => false,
    'mysqlError' => $mysqlError,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

echo json_encode([
  'status' => 'ok',
  'deletedRows' => $deletedRows,
  'message' => "アプリ (ID: {$appId}) を削除しました。",
  'mysqlDeleted' => $mysqlDeleted,
  'mysqlError' => $mysqlError,
  'id' => $appId,
], JSON_UNESCAPED_UNICODE);
