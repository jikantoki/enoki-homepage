<?php
//管理者アカウント作成用
require_once '../env.php'; //環境変数読み込み
require_once './settings.php'; //ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; //自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; //APIが有効かどうか自動判定

if (
  !isset($_SERVER['HTTP_USERNAME']) ||
  !isset($_SERVER['HTTP_PASSWORD']) ||
  !isset($_SERVER['HTTP_MAILADDRESS'])
) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid authentication information',
    'errCode' => 10
  ]);
  exit;
}
if (
  $_SERVER['HTTP_USERNAME'] === '' ||
  $_SERVER['HTTP_PASSWORD'] === '' ||
  $_SERVER['HTTP_MAILADDRESS'] === ''
) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid authentication information',
    'errCode' => 11
  ]);
  exit;
}

// ----------------------------------------------------
// 管理者専用登録制限チェック（自分以外が作成できないようにする条件）
// ----------------------------------------------------
// 1. 管理者登録用シークレットキーの検証
$reqAdminKey = $_SERVER['HTTP_ADMINKEY'] ?? $_SERVER['HTTP_ADMIN_KEY'] ?? $_POST['adminKey'] ?? '';
$expectedAdminKey = defined('Admin_Register_Key') ? Admin_Register_Key : null;

if (empty($expectedAdminKey) || $reqAdminKey !== $expectedAdminKey) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者登録キーが無効です。管理者以外はアカウントを作成できません。',
    'errCode' => 403
  ]);
  exit;
}

// 2. 登録可能アカウント数の制限チェック（初期管理者のみ作成可能・自分以外の作成を防止）
$maxAdmins = defined('Admin_Register_Max') ? (int)Admin_Register_Max : 1;
$currentAdminCount = getAdminCount();
if ($currentAdminCount >= $maxAdmins) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントは既に作成されています。追加の登録は制限されています。',
    'errCode' => 409
  ]);
  exit;
}

// 3. メールアドレス制限（設定されている場合）
if (defined('Admin_Allowed_Email') && Admin_Allowed_Email !== '') {
  if (strtolower(trim($_SERVER['HTTP_MAILADDRESS'])) !== strtolower(trim(Admin_Allowed_Email))) {
    echo json_encode([
      'status' => 'forbidden',
      'reason' => '指定されたメールアドレスでは管理者登録できません。',
      'errCode' => 403
    ]);
    exit;
  }
}

$username = $_SERVER['HTTP_USERNAME'];
$password = $_SERVER['HTTP_PASSWORD'];
$mailAddress = $_SERVER['HTTP_MAILADDRESS'];

//論理桁数でカウントするためmb_strlenしない
$passwordLength = strlen($password);
if ($passwordLength < 4 || $passwordLength > 64) {
  echo json_encode([
    'status' => 'invalid',
    'reason' => 'invalid password',
    'errCode' => 20
  ]);
  exit;
}

$response = makeAccount($username, $password, $mailAddress, 'admin');
if (!$response) {
  sendMail(
    $mailAddress,
    '【エノキ電気】管理者アカウント作成完了のお知らせ',
    "
    <p>管理者アカウントの作成が完了しました。</p>
    <br>
    <h3>管理者ID: {$username}</h3>
    <br>
    <p>管理画面へアクセスし、ログインを行ってください。</p>
    <p>引き続き エノキ電気 をよろしくお願いいたします。</p>"
  );
  //アカウント作れた
  echo json_encode([
    'status' => 'ok',
    'reason' => '管理者アカウントを作成しました！メールボックスをご確認ください。'
  ]);
} else {
  //既に存在しているとか
  echo json_encode([
    'status' => 'ng',
    'reason' => 'This account already exists',
    'errCode' => 30
  ]);
}
