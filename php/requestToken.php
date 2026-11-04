<?php
require_once '../env.php'; //環境変数読み込み
require_once './settings.php'; //ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; //自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; //APIが有効かどうか自動判定

if (
  !isset($_SERVER['HTTP_ID']) ||
  !isset($_SERVER['HTTP_PASSWORD'])
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

$secretId = idToSecretId($id);
if (!$secretId) {
  echo json_encode([
    'status' => 'ng',
    'reason' => 'ユーザー名またはパスワードが間違っています',
    'errCode' => 20
  ]);
  exit;
}

// 管理者以外はログインさせない制限チェック
if (!isUserAdmin($secretId)) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントのみログイン可能です。',
    'errCode' => 403
  ]);
  exit;
}

$otp = requestOnetimeToken($id, $password);
if ($otp) {
  $otpString = (string) $otp;
  $otpFirst = substr($otpString, 0, 3);
  $otpSecond = substr($otpString, 3, 6);
  $otpForMail = $otpFirst . '-' . $otpSecond;
  echo json_encode([
    'status' => 'ok',
    'reason' => 'Send mail to your mailaddress!',
    'id' => $id
  ]);
  $mailAddress = secretIdToMailAddress($secretId);
  sendMail($mailAddress, '【エノキ電気】管理者アクセストークンのお知らせ', "
  <p>管理者ログイン用のアクセストークンはこちら！</p>
  <h1>{$otpForMail}</h1>
  <p>このコードは一回のみ有効です。</p>
  <br>
  <p>もし身に覚えがない場合は、今すぐパスワードを変更してください。</p>
  ");
} else {
  echo json_encode([
    'status' => 'ng',
    'reason' => 'ユーザー名またはパスワードが間違っています',
    'errCode' => 20
  ]);
}
