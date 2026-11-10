<?php
/**
 * id3Parser.php
 * MP3ファイルからID3v2 (v2.2, v2.3, v2.4) および ID3v1 タグを抽出し、
 * 埋め込みジャケット画像を画像ファイルとして保存するヘルパー関数群
 */

require_once __DIR__ . '/imageStorage.php';

/**
 * テキストバイナリをUTF-8文字列へデコード
 */
function decodeId3Text(string $bytes, int $encoding): string
{
    if ($bytes === '') {
        return '';
    }

    try {
        if ($encoding === 0) {
            // ISO-8859-1 または CP932 / UTF-8
            if (mb_check_encoding($bytes, 'UTF-8')) {
                return trim(rtrim($bytes, "\0"));
            }
            if (mb_check_encoding($bytes, 'SJIS-win')) {
                return trim(rtrim(mb_convert_encoding($bytes, 'UTF-8', 'SJIS-win'), "\0"));
            }
            return trim(rtrim(mb_convert_encoding($bytes, 'UTF-8', 'ISO-8859-1'), "\0"));
        } elseif ($encoding === 1) {
            // UTF-16 with BOM
            return trim(rtrim(mb_convert_encoding($bytes, 'UTF-8', 'UTF-16'), "\0"));
        } elseif ($encoding === 2) {
            // UTF-16BE without BOM
            return trim(rtrim(mb_convert_encoding($bytes, 'UTF-8', 'UTF-16BE'), "\0"));
        } elseif ($encoding === 3) {
            // UTF-8
            return trim(rtrim($bytes, "\0"));
        }
    } catch (\Throwable $e) {
        error_log('ID3 text decode error: ' . $e->getMessage());
    }

    return trim(rtrim($bytes, "\0"));
}

/**
 * バイナリから画像のマジックバイトを検出
 */
function findImageMagicInId3(string $bytes, int $startOffset = 0): ?array
{
    $len = strlen($bytes);
    for ($i = $startOffset; $i < $len - 3; $i++) {
        $b0 = ord($bytes[$i]);
        $b1 = ord($bytes[$i + 1]);
        $b2 = ord($bytes[$i + 2]);

        // JPEG: FF D8 FF
        if ($b0 === 0xFF && $b1 === 0xD8 && $b2 === 0xFF) {
            return ['offset' => $i, 'mime' => 'image/jpeg', 'ext' => 'jpg'];
        }
        // PNG: 89 50 4E 47
        if ($b0 === 0x89 && $b1 === 0x50 && $b2 === 0x4E && ord($bytes[$i + 3]) === 0x47) {
            return ['offset' => $i, 'mime' => 'image/png', 'ext' => 'png'];
        }
        // WEBP: "RIFF" .... "WEBP"
        if ($b0 === 0x52 && $b1 === 0x49 && $b2 === 0x46 && ord($bytes[$i + 3]) === 0x46 && $i + 11 < $len) {
            if (substr($bytes, $i + 8, 4) === 'WEBP') {
                return ['offset' => $i, 'mime' => 'image/webp', 'ext' => 'webp'];
            }
        }
        // GIF: GIF8
        if ($b0 === 0x47 && $b1 === 0x49 && $b2 === 0x46 && ord($bytes[$i + 3]) === 0x38) {
            return ['offset' => $i, 'mime' => 'image/gif', 'ext' => 'gif'];
        }
    }
    return null;
}

/**
 * MP3ファイルからID3メタデータとジャケット画像を抽出・保存
 *
 * @param string $filePath MP3ファイルの絶対パス
 * @return array{
 *   title?: string,
 *   artist?: string,
 *   album?: string,
 *   genre?: string,
 *   coverUrl?: string
 * }
 */
function extractMp3MetadataAndCover(string $filePath): array
{
    $result = [];
    if (!file_exists($filePath) || !is_readable($filePath)) {
        return $result;
    }

    $fp = @fopen($filePath, 'rb');
    if (!$fp) {
        return $result;
    }

    $header = fread($fp, 10);
    if (strlen($header) < 10 || substr($header, 0, 3) !== 'ID3') {
        fclose($fp);
        return $result;
    }

    $major = ord($header[3]);
    $flags = ord($header[5]);
    $tagSize = ((ord($header[6]) & 0x7f) << 21) |
               ((ord($header[7]) & 0x7f) << 14) |
               ((ord($header[8]) & 0x7f) << 7) |
               (ord($header[9]) & 0x7f);

    // 最大30MBまで読み込み
    $readLen = min($tagSize, 30 * 1024 * 1024);
    $tagData = fread($fp, $readLen);
    fclose($fp);

    $offset = 0;
    // 拡張ヘッダのスキップ
    if ($flags & 0x40 && strlen($tagData) >= 4) {
        if ($major === 3) {
            $extSize = (ord($tagData[0]) << 24) | (ord($tagData[1]) << 16) | (ord($tagData[2]) << 8) | ord($tagData[3]);
            $offset += 4 + $extSize;
        } elseif ($major === 4) {
            $extSize = ((ord($tagData[0]) & 0x7f) << 21) | ((ord($tagData[1]) & 0x7f) << 14) | ((ord($tagData[2]) & 0x7f) << 7) | (ord($tagData[3]) & 0x7f);
            $offset += $extSize;
        }
    }

    $tagEnd = strlen($tagData);
    $coverImageData = null;
    $coverExt = 'jpg';

    while ($offset + ($major === 2 ? 6 : 10) <= $tagEnd) {
        if (ord($tagData[$offset]) === 0) {
            break;
        }

        if ($major === 2) {
            $id = substr($tagData, $offset, 3);
            $size = (ord($tagData[$offset + 3]) << 16) | (ord($tagData[$offset + 4]) << 8) | ord($tagData[$offset + 5]);
            $offset += 6;
        } else {
            $id = substr($tagData, $offset, 4);
            if ($major === 4) {
                $synch = ((ord($tagData[$offset + 4]) & 0x7f) << 21) |
                         ((ord($tagData[$offset + 5]) & 0x7f) << 14) |
                         ((ord($tagData[$offset + 6]) & 0x7f) << 7) |
                         (ord($tagData[$offset + 7]) & 0x7f);
                $norm = (ord($tagData[$offset + 4]) << 24) |
                        (ord($tagData[$offset + 5]) << 16) |
                        (ord($tagData[$offset + 6]) << 8) |
                        ord($tagData[$offset + 7]);
                $hasHigh = (ord($tagData[$offset + 4]) & 0x80) || (ord($tagData[$offset + 5]) & 0x80) || (ord($tagData[$offset + 6]) & 0x80) || (ord($tagData[$offset + 7]) & 0x80);
                $size = $hasHigh ? $norm : $synch;
            } else {
                $size = (ord($tagData[$offset + 4]) << 24) |
                        (ord($tagData[$offset + 5]) << 16) |
                        (ord($tagData[$offset + 6]) << 8) |
                        ord($tagData[$offset + 7]);
                if ($offset + 10 + $size > $tagEnd + 32) {
                    $alt = ((ord($tagData[$offset + 4]) & 0x7f) << 21) |
                           ((ord($tagData[$offset + 5]) & 0x7f) << 14) |
                           ((ord($tagData[$offset + 6]) & 0x7f) << 7) |
                           (ord($tagData[$offset + 7]) & 0x7f);
                    if ($offset + 10 + $alt <= $tagEnd) {
                        $size = $alt;
                    }
                }
            }
            $offset += 10;
        }

        if ($size <= 0 || $offset + $size > $tagEnd + 64) {
            break;
        }

        $frame = substr($tagData, $offset, min($size, $tagEnd - $offset));
        if (strlen($frame) > 0) {
            $enc = ord($frame[0]);
            $textBytes = substr($frame, 1);

            if (($id === 'TIT2' || $id === 'TT2') && empty($result['title'])) {
                $result['title'] = decodeId3Text($textBytes, $enc);
            } elseif (($id === 'TPE1' || $id === 'TP1') && empty($result['artist'])) {
                $result['artist'] = decodeId3Text($textBytes, $enc);
            } elseif (($id === 'TALB' || $id === 'TAL') && empty($result['album'])) {
                $result['album'] = decodeId3Text($textBytes, $enc);
            } elseif (($id === 'TCON' || $id === 'TCO') && empty($result['genre'])) {
                $genre = decodeId3Text($textBytes, $enc);
                $result['genre'] = preg_replace('/^\(\d+\)\s*/', '', $genre);
            } elseif (($id === 'APIC' || $id === 'PIC') && $coverImageData === null) {
                $magic = findImageMagicInId3($frame, 1);
                if ($magic !== null) {
                    $coverImageData = substr($frame, $magic['offset']);
                    $coverExt = $magic['ext'];
                }
            }
        }

        $offset += $size;
    }

    // ジャケット画像のファイル保存
    if ($coverImageData !== null && strlen($coverImageData) > 0) {
        $targetDirs = getUploadTargetDirectories();
        if (!empty($targetDirs)) {
            $timestamp = time();
            $random = bin2hex(random_bytes(4));
            $filename = "img_{$timestamp}_{$random}_cover.{$coverExt}";
            $saved = false;
            foreach ($targetDirs as $dir) {
                $dest = rtrim($dir, '/\\') . '/' . $filename;
                if (@file_put_contents($dest, $coverImageData) !== false) {
                    $saved = true;
                }
            }
            if ($saved) {
                $result['coverUrl'] = toApiPublicAssetUrl("/public/uploads/images/{$filename}");
            }
        }
    }

    return $result;
}
