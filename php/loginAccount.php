<?php
require_once '../env.php'; //環境変数読み込み
require_once './settings.php'; //ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; //自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; //APIが有効かどうか自動判定

if (
  !isset($_SERVER['HTTP_ID']) ||
  !isset($_SERVER['HTTP_PASSWORD']) ||
  !isset($_SERVER['HTTP_TOKEN']) ||
  $_SERVER['HTTP_TOKEN'] === ''
) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid authentication information',
    'errCode' => 10
  ]);
  exit;
}

$id = $_SERVER['HTTP_ID'];
$password = $_SERVER['HTTP_PASSWORD'];
$otp = $_SERVER['HTTP_TOKEN'];

$secretId = idToSecretId($id);
if (!$secretId || !isUserAdmin($secretId)) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントのみログイン可能です。',
    'errCode' => 403
  ]);
  exit;
}

$token = createUserToken($id, $password, $otp);
if ($token) {
  echo json_encode([
    'status' => 'ok',
    'reason' => '管理者ログインに成功しました。',
    'token' => $token,
    'id' => $id,
    'role' => 'admin',
    'isAdmin' => true
  ]);
  $mailAddress = secretIdToMailAddress($secretId);
  sendMail($mailAddress, '【エノキ電気】管理者ログイン検知のお知らせ', "
  <p>管理者アカウントで新規のログインを検知しました。</p>
  <br>
  <p>もし身に覚えがない場合は、今すぐパスワードを変更してください。</p>
  ");
  SQLupdate('user_secret_list', 'otp', null, 'secretId', $secretId);
} else {
  echo json_encode([
    'status' => 'ng',
    'reason' => '認証情報またはワンタイムトークンが正しくありません',
    'errCode' => 20
  ]);
}
