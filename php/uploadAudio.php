<?php
require_once '../env.php'; // 環境変数読み込み
require_once './settings.php'; // ルートディレクトリ読み込み
require_once DIR_ROOT . '/php/myAutoLoad.php'; // 自動読み込み
require_once DIR_ROOT . '/php/functions/authAPIforUse.php'; // API有効判定
require_once DIR_ROOT . '/php/functions/authAccountforUse.php'; // ログイン認証判定
require_once DIR_ROOT . '/php/functions/id3Parser.php'; // ID3タグ解析・ジャケット保存

header('Content-Type: application/json; charset=UTF-8');

// アップロード先ディレクトリの準備（/php/public/uploads/audio/）
$upload_rel_dir = 'public/uploads/audio/';
$upload_dir = __DIR__ . '/' . $upload_rel_dir;

if (!is_dir($upload_dir)) {
  if (!mkdir($upload_dir, 0755, true)) {
    echo json_encode([
      'status' => 'error',
      'reason' => 'アップロードディレクトリの作成に失敗しました。',
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
}

// 許可する拡張子
$allowed_exts = ['mp3', 'wav', 'm4a', 'ogg', 'flac', 'aac', 'webm'];
$origin_url = getApiOriginUrl();
$base_url = rtrim($origin_url, '/') . '/' . $upload_rel_dir;

// 1. 通常の multipart/form-data によるファイルアップロードの場合
if (isset($_FILES['audio']) || isset($_FILES['file'])) {
  $file = isset($_FILES['audio']) ? $_FILES['audio'] : $_FILES['file'];

  if ($file['error'] !== UPLOAD_ERR_OK) {
    $size_errors = [UPLOAD_ERR_INI_SIZE, UPLOAD_ERR_FORM_SIZE];
    echo json_encode([
      'status' => 'error',
      'reason' => in_array($file['error'], $size_errors)
        ? 'ファイルサイズがサーバーの上限 (upload_max_filesize=' . ini_get('upload_max_filesize') . ') を超えています。'
        : 'ファイルアップロードエラーコード: ' . $file['error'],
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $orig_name = $file['name'];
  $ext = strtolower(pathinfo($orig_name, PATHINFO_EXTENSION));

  if (!in_array($ext, $allowed_exts)) {
    echo json_encode([
      'status' => 'error',
      'reason' => '許可されていない音声ファイル形式です。許可: ' . implode(', ', $allowed_exts),
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $timestamp = time();
  $random = bin2hex(random_bytes(4));
  $file_name = "audio_{$timestamp}_{$random}.{$ext}";
  $dest_path = $upload_dir . $file_name;

  if (move_uploaded_file($file['tmp_name'], $dest_path)) {
    // ID3タグ解析とジャケット保存
    $metadata = null;
    if ($ext === 'mp3') {
      try {
        $parsed = extractMp3MetadataAndCover($dest_path);
        if (!empty($parsed)) {
          if (!empty($parsed['coverUrl'])) {
            $parsed['coverUrl'] = toApiPublicAssetUrl($parsed['coverUrl']);
          }
          $metadata = $parsed;
        }
      } catch (\Throwable $th) {
        error_log('ID3 extraction error: ' . $th->getMessage());
      }
    }

    echo json_encode([
      'status' => 'ok',
      'url' => $base_url . $file_name,
      'filename' => $file_name,
      'originalName' => $orig_name,
      'size' => $file['size'],
      'metadata' => $metadata,
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

if (isset($body_data['audioBase64'])) {
  $base64_data = $body_data['audioBase64'];
  $ext = 'mp3';
  if (preg_match('/^data:audio\/(mpeg|mp3|wav|ogg|x-m4a|aac);base64,(.*)$/', $base64_data, $matches)) {
    $matched_type = $matches[1];
    if ($matched_type === 'mpeg' || $matched_type === 'mp3') $ext = 'mp3';
    elseif ($matched_type === 'wav') $ext = 'wav';
    elseif ($matched_type === 'ogg') $ext = 'ogg';
    elseif ($matched_type === 'x-m4a') $ext = 'm4a';
    elseif ($matched_type === 'aac') $ext = 'aac';
    $base64_data = $matches[2];
  }

  $decoded = base64_decode($base64_data);
  if ($decoded === false) {
    echo json_encode([
      'status' => 'error',
      'reason' => 'Base64デコードに失敗しました。',
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }

  $timestamp = time();
  $random = bin2hex(random_bytes(4));
  $file_name = "audio_{$timestamp}_{$random}.{$ext}";
  $dest_path = $upload_dir . $file_name;

  if (file_put_contents($dest_path, $decoded) !== false) {
    // ID3タグ解析とジャケット保存
    $metadata = null;
    if ($ext === 'mp3') {
      try {
        $parsed = extractMp3MetadataAndCover($dest_path);
        if (!empty($parsed)) {
          if (!empty($parsed['coverUrl'])) {
            $parsed['coverUrl'] = toApiPublicAssetUrl($parsed['coverUrl']);
          }
          $metadata = $parsed;
        }
      } catch (\Throwable $th) {
        error_log('ID3 extraction error: ' . $th->getMessage());
      }
    }

    echo json_encode([
      'status' => 'ok',
      'url' => $base_url . $file_name,
      'filename' => $file_name,
      'size' => strlen($decoded),
      'metadata' => $metadata,
    ], JSON_UNESCAPED_UNICODE);
    exit;
  }
}

$content_length = isset($_SERVER['CONTENT_LENGTH']) ? intval($_SERVER['CONTENT_LENGTH']) : 0;
echo json_encode([
  'status' => 'error',
  'reason' => $content_length > 0
    ? '音声ファイルデータが見つかりません。ファイルサイズがサーバーの上限 (post_max_size=' . ini_get('post_max_size') . ') を超えている可能性があります。'
    : '音声ファイルデータが見つかりません。',
], JSON_UNESCAPED_UNICODE);
