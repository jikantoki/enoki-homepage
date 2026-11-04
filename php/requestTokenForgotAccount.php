<?php
require_once '../env.php'; //環境変数読み込み
require_once './settings.php'; //ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; //自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; //APIが有効かどうか自動判定

if (
  !isset($_SERVER['HTTP_ID']) ||
  !isset($_SERVER['HTTP_MAILADDRESS'])
) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid authentication information',
    'errCode' => 10
  ]);
  exit;
}

$id = $_SERVER['HTTP_ID'];
$mailAddress = $_SERVER['HTTP_MAILADDRESS'];

$secretId = idToSecretId($id);
if (!$secretId || !isUserAdmin($secretId)) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントのみパスワードリセット可能です。',
    'errCode' => 403
  ]);
  exit;
}

$otp = requestOnetimeTokenForgotPassword($id, $mailAddress);
if ($otp) {
  echo json_encode([
    'status' => 'ok',
    'reason' => 'Send mail to your mailaddress!',
    'id' => $id
  ]);
  $mailAddress = secretIdToMailAddress($secretId);
  sendMail($mailAddress, '【エノキ電気】管理者パスワードリセット用アクセストークンのお知らせ', '<p>管理者アクセストークンはこちら！</p><h1>' . $otp . '</h1><p>このコードは一回のみ有効です。<br>身に覚えがない場合はパスワードの安全を確認してください。</p>');
} else {
  echo json_encode([
    'status' => 'ng',
    'reason' => 'ユーザー名またはメールアドレスが間違っています',
    'errCode' => 20
  ]);
}
