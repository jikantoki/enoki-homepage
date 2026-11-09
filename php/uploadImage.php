<?php
require_once '../env.php';
require_once './settings.php';
require_once DIR_ROOT . '/php/myAutoLoad.php';
require_once DIR_ROOT . '/php/functions/authAPIforUse.php';
require_once DIR_ROOT . '/php/functions/authAccountforUse.php';
require_once DIR_ROOT . '/php/functions/imageStorage.php';

header('Content-Type: application/json; charset=UTF-8');

// ==================== 管理者権限チェック ====================
// $secretId は authAccountforUse.php で設定される
if (!isUserAdmin($secretId)) {
  echo json_encode([
    'status' => 'forbidden',
    'reason' => '管理者アカウントのみ画像をアップロードできます。',
    'errCode' => 403,
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

$subDir = isset($_REQUEST['subDir']) ? trim($_REQUEST['subDir'], '/\\') : 'images';
// 安全なサブディレクトリのみ許可
if ($subDir !== 'apps' && $subDir !== 'music' && $subDir !== 'images') {
  $subDir = 'images';
}

$allowed_exts = ['png', 'jpg', 'jpeg', 'webp', 'svg', 'gif'];
$targetDirs = getUploadTargetDirectories($subDir === 'images' ? '' : $subDir);

if (empty($targetDirs)) {
  echo json_encode([
    'status' => 'error',
    'reason' => 'アップロード保存先ディレクトリを作成できませんでした。',
  ], JSON_UNESCAPED_UNICODE);
  exit;
}

// 1. 通常の multipart/form-data によるファイルアップロードの場合
if (isset($_FILES['image']) || isset($_FILES['file'])) {
  $file = isset($_FILES['image']) ? $_FILES['image'] : $_FILES['file'];

  if ($file['error'] !== UPLOAD_ERR_OK) {
    echo json_encode([
      'status' => 'error',
      'reason' => 'ファイルアップロードエラーコード: ' . $file['error'],
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $orig_name = $file['name'];
  $rawExt = strtolower(pathinfo($orig_name, PATHINFO_EXTENSION));
  $ext = ($rawExt === 'jpeg') ? 'jpg' : $rawExt;

  if (!in_array($ext, $allowed_exts)) {
    echo json_encode([
      'status' => 'error',
      'reason' => '許可されていない画像形式です。許可: ' . implode(', ', $allowed_exts),
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $timestamp = time();
  $random = bin2hex(random_bytes(4));
  $file_name = "img_{$timestamp}_{$random}.{$ext}";

  $fileData = file_get_contents($file['tmp_name']);
  if ($fileData === false) {
    echo json_encode([
      'status' => 'error',
      'reason' => '一時ファイルの読み込みに失敗しました。',
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $saved = false;
  foreach ($targetDirs as $dir) {
    $dest = rtrim($dir, '/\\') . '/' . $file_name;
    if (file_put_contents($dest, $fileData) !== false) {
      $saved = true;
    }
  }

  if ($saved) {
    $urlPath = $subDir === 'images' ? "/uploads/images/{$file_name}" : "/uploads/images/{$subDir}/{$file_name}";
    echo json_encode([
      'status' => 'ok',
      'url' => $urlPath,
      'filename' => $file_name,
      'originalName' => $orig_name,
      'size' => strlen($fileData),
    ], JSON_UNESCAPED_UNICODE);
    exit;
  } else {
    echo json_encode([
      'status' => 'error',
      'reason' => 'ファイルの保存に失敗しました。',
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
}

// 2. Base64データによる送信の場合（JSONまたはPOST）
$input_json = file_get_contents('php://input');
$body_data = json_decode($input_json, true) ?: $_POST;

if (isset($body_data['imageBase64']) || isset($body_data['image'])) {
  $dataUri = $body_data['imageBase64'] ?? $body_data['image'];
  $preferredName = !empty($body_data['name']) ? $body_data['name'] : null;
  $url = saveImageUriToFile($dataUri, $subDir === 'images' ? '' : $subDir, $preferredName);

  if ($url && !str_starts_with($url, 'data:')) {
    echo json_encode([
      'status' => 'ok',
      'url' => $url,
    ], JSON_UNESCAPED_UNICODE);
    exit;
  } else {
    echo json_encode([
      'status' => 'error',
      'reason' => 'Base64画像の保存に失敗しました。',
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
}

echo json_encode([
  'status' => 'error',
  'reason' => '画像ファイルまたはBase64データが送信されていません。',
], JSON_UNESCAPED_UNICODE);
