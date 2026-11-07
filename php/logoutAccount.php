<?php
require_once '../env.php'; //環境変数読み込み
require_once './settings.php'; //ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; //自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; //APIが有効かどうか自動判定

header('Content-Type: application/json; charset=UTF-8');

$input = file_get_contents('php://input');
$body = json_decode($input, true) ?: $_POST;

$userId = $_SERVER['HTTP_ID'] ?? $body['id'] ?? $body['userId'] ?? null;
$token = $_SERVER['HTTP_TOKEN'] ?? $body['token'] ?? $body['userToken'] ?? null;

if (!$userId || !$token) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid authentication information',
    'errCode' => 10,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

// ユーザーの secretId を取得
$secretId = idToSecretId($userId);
if (!$secretId) {
  echo json_encode([
    'status' => 'ok',
    'reason' => 'User not found or already logged out',
    'token' => $token,
    'id' => $userId,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

// DBからアクセストークンを削除
$res = SQLdeleteSome('user_accesstoken_list', [
  [
    'key' => 'secretId',
    'value' => $secretId,
    'func' => '=',
  ],
  [
    'key' => 'token',
    'value' => $token,
    'func' => '=',
  ],
]);

echo json_encode([
  'status' => 'ok',
  'reason' => 'ログアウトしました（トークンを削除しました）',
  'token' => $token,
  'id' => $userId,
], JSON_UNESCAPED_UNICODE);
