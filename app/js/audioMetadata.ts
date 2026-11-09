/**
 * 音声ファイル（MP3, M4A, FLAC等）からID3タグ・メタデータおよびジャケット画像を抽出するユーティリティ
 */

export interface AudioCover {
  data: Uint8Array
  mime: string
  format: 'jpeg' | 'png' | 'webp' | 'gif' | 'unknown'
}

export interface AudioMetadata {
  title?: string
  artist?: string
  album?: string
  albumArtist?: string
  genre?: string
  year?: string
  track?: string
  duration?: number
  cover?: AudioCover
}

/**
 * テキストバイナリを適切な文字コードでデコード
 */
function decodeTextBytes(bytes: Uint8Array, encoding: number): string {
  if (!bytes || bytes.length === 0) return ''
  try {
    if (encoding === 0) {
      // 0: ISO-8859-1 (Latin1) または CP932/Shift_JIS / UTF-8
      // 日本語MP3でShift_JISやUTF-8なのにencoding=0になっているケースが多いため順次試行
      try {
        const utf8 = new TextDecoder('utf-8', { fatal: true }).decode(bytes)
        return utf8.replace(/\0+$/, '').trim()
      } catch {
        // UTF-8でなければShift_JISを試す
      }
      try {
        const sjis = new TextDecoder('shift_jis', { fatal: true }).decode(bytes)
        return sjis.replace(/\0+$/, '').trim()
      } catch {
        // どちらでもなければLatin1
      }
      return new TextDecoder('iso-8859-1').decode(bytes).replace(/\0+$/, '').trim()
    } else if (encoding === 1) {
      // 1: UTF-16 with BOM (LE or BE)
      return new TextDecoder('utf-16').decode(bytes).replace(/\0+$/, '').trim()
    } else if (encoding === 2) {
      // 2: UTF-16BE without BOM
      return new TextDecoder('utf-16be').decode(bytes).replace(/\0+$/, '').trim()
    } else if (encoding === 3) {
      // 3: UTF-8
      return new TextDecoder('utf-8').decode(bytes).replace(/\0+$/, '').trim()
    }
  } catch (e) {
    console.warn('Text decode error:', e)
  }
  return ''
}

/**
 * バイナリから画像のマジックバイトを検出
 */
function detectImageMagic(bytes: Uint8Array, startOffset: number = 0): {
  offset: number
  mime: string
  format: AudioCover['format']
} | null {
  const len = bytes.length
  for (let i = startOffset; i < len - 3; i++) {
    // JPEG: FF D8 FF
    if (bytes[i] === 0xff && bytes[i + 1] === 0xd8 && bytes[i + 2] === 0xff) {
      return { offset: i, mime: 'image/jpeg', format: 'jpeg' }
    }
    // PNG: 89 50 4E 47
    if (
      bytes[i] === 0x89 &&
      bytes[i + 1] === 0x50 &&
      bytes[i + 2] === 0x4e &&
      bytes[i + 3] === 0x47
    ) {
      return { offset: i, mime: 'image/png', format: 'png' }
    }
    // WEBP: "RIFF" .... "WEBP"
    if (
      bytes[i] === 0x52 &&
      bytes[i + 1] === 0x49 &&
      bytes[i + 2] === 0x46 &&
      bytes[i + 3] === 0x46 &&
      i + 11 < len &&
      bytes[i + 8] === 0x57 &&
      bytes[i + 9] === 0x45 &&
      bytes[i + 10] === 0x42 &&
      bytes[i + 11] === 0x50
    ) {
      return { offset: i, mime: 'image/webp', format: 'webp' }
    }
    // GIF: GIF8
    if (
      bytes[i] === 0x47 &&
      bytes[i + 1] === 0x49 &&
      bytes[i + 2] === 0x46 &&
      bytes[i + 3] === 0x38
    ) {
      return { offset: i, mime: 'image/gif', format: 'gif' }
    }
  }
  return null
}

/**
 * ID3v2 (v2.2, v2.3, v2.4) パース
 */
function parseID3v2(buffer: Uint8Array): AudioMetadata | null {
  if (buffer.length < 10) return null
  // "ID3" マジック
  if (buffer[0] !== 0x49 || buffer[1] !== 0x44 || buffer[2] !== 0x33) return null

  const major = buffer[3]
  // revision: buffer[4]
  const flags = buffer[5]
  const tagSize =
    ((buffer[6] & 0x7f) << 21) |
    ((buffer[7] & 0x7f) << 14) |
    ((buffer[8] & 0x7f) << 7) |
    (buffer[9] & 0x7f)

  let offset = 10
  // 拡張ヘッダのスキップ
  if (flags & 0x40) {
    if (major === 3 && offset + 4 <= buffer.length) {
      const extSize =
        (buffer[offset] << 24) |
        (buffer[offset + 1] << 16) |
        (buffer[offset + 2] << 8) |
        buffer[offset + 3]
      offset += 4 + extSize
    } else if (major === 4 && offset + 4 <= buffer.length) {
      const extSize =
        ((buffer[offset] & 0x7f) << 21) |
        ((buffer[offset + 1] & 0x7f) << 14) |
        ((buffer[offset + 2] & 0x7f) << 7) |
        (buffer[offset + 3] & 0x7f)
      offset += extSize
    }
  }

  const tagEnd = Math.min(buffer.length, 10 + tagSize)
  const result: AudioMetadata = {}
  let frontCoverFound = false

  while (offset + (major === 2 ? 6 : 10) <= tagEnd) {
    // パディングチェック (0x00)
    if (buffer[offset] === 0) break

    let id = ''
    let size = 0

    if (major === 2) {
      // ID3v2.2 (3文字ID, 3バイトサイズ)
      id = String.fromCharCode(buffer[offset], buffer[offset + 1], buffer[offset + 2])
      size = (buffer[offset + 3] << 16) | (buffer[offset + 4] << 8) | buffer[offset + 5]
      offset += 6
    } else {
      // ID3v2.3 / ID3v2.4 (4文字ID, 4バイトサイズ, 2バイトフラグ)
      id = String.fromCharCode(
        buffer[offset],
        buffer[offset + 1],
        buffer[offset + 2],
        buffer[offset + 3],
      )

      if (major === 4) {
        // v2.4 は仕様上 synchsafe だが、32bit通常整数のエンコーダも存在
        const synchsafeSize =
          ((buffer[offset + 4] & 0x7f) << 21) |
          ((buffer[offset + 5] & 0x7f) << 14) |
          ((buffer[offset + 6] & 0x7f) << 7) |
          (buffer[offset + 7] & 0x7f)
        const regularSize =
          (buffer[offset + 4] << 24) |
          (buffer[offset + 5] << 16) |
          (buffer[offset + 6] << 8) |
          buffer[offset + 7]

        const hasHighBit =
          (buffer[offset + 4] & 0x80) ||
          (buffer[offset + 5] & 0x80) ||
          (buffer[offset + 6] & 0x80) ||
          (buffer[offset + 7] & 0x80)

        size = hasHighBit ? regularSize : synchsafeSize
      } else {
        // v2.3 は通常 32bit int
        size =
          (buffer[offset + 4] << 24) |
          (buffer[offset + 5] << 16) |
          (buffer[offset + 6] << 8) |
          buffer[offset + 7]
        // もし大きすぎてタグ境界を逸脱する場合、synchsafeとして試行
        if (offset + 10 + size > tagEnd + 32) {
          const altSize =
            ((buffer[offset + 4] & 0x7f) << 21) |
            ((buffer[offset + 5] & 0x7f) << 14) |
            ((buffer[offset + 6] & 0x7f) << 7) |
            (buffer[offset + 7] & 0x7f)
          if (offset + 10 + altSize <= tagEnd) {
            size = altSize
          }
        }
      }
      offset += 10
    }

    if (size <= 0 || offset + size > tagEnd + 64) {
      break
    }

    const frameData = buffer.subarray(offset, Math.min(offset + size, buffer.length))

    if (frameData.length > 0) {
      const enc = frameData[0]
      const textBytes = frameData.subarray(1)

      // タイトル
      if ((id === 'TIT2' || id === 'TT2') && !result.title) {
        result.title = decodeTextBytes(textBytes, enc)
      }
      // アーティスト
      else if ((id === 'TPE1' || id === 'TP1') && !result.artist) {
        result.artist = decodeTextBytes(textBytes, enc)
      }
      // アルバム
      else if ((id === 'TALB' || id === 'TAL') && !result.album) {
        result.album = decodeTextBytes(textBytes, enc)
      }
      // アルバムアーティスト
      else if ((id === 'TPE2' || id === 'TP2') && !result.albumArtist) {
        result.albumArtist = decodeTextBytes(textBytes, enc)
      }
      // ジャンル
      else if ((id === 'TCON' || id === 'TCO') && !result.genre) {
        let genreStr = decodeTextBytes(textBytes, enc)
        // "(17)Rock" -> "Rock" のようなID3v1番号プレフィックスを除去
        genreStr = genreStr.replace(/^\(\d+\)\s*/, '')
        result.genre = genreStr
      }
      // 年
      else if ((id === 'TYER' || id === 'TDRC' || id === 'TYE') && !result.year) {
        result.year = decodeTextBytes(textBytes, enc).substring(0, 4)
      }
      // トラック番号
      else if ((id === 'TRCK' || id === 'TRK') && !result.track) {
        result.track = decodeTextBytes(textBytes, enc).split('/')[0].trim()
      }
      // ジャケット画像 (APIC / PIC)
      else if ((id === 'APIC' || id === 'PIC') && !frontCoverFound) {
        let picType = 3 // デフォルトは Front Cover とみなす
        let searchFrom = 1

        if (id === 'APIC') {
          // APIC: enc(1B) + mime(\0終端) + picType(1B) + desc + image
          let mimeEnd = 1
          while (mimeEnd < frameData.length && frameData[mimeEnd] !== 0) {
            mimeEnd++
          }
          if (mimeEnd + 1 < frameData.length) {
            picType = frameData[mimeEnd + 1]
            searchFrom = mimeEnd + 2
          }
        } else {
          // PIC: enc(1B) + format(3B) + picType(1B) + desc + image
          if (frameData.length >= 5) {
            picType = frameData[4]
            searchFrom = 5
          }
        }

        // 画像データの先頭マジックバイトを探索
        const detected = detectImageMagic(frameData, searchFrom)
        if (detected) {
          const imgBytes = frameData.subarray(detected.offset)
          result.cover = {
            data: imgBytes,
            mime: detected.mime,
            format: detected.format,
          }
          if (picType === 3) {
            frontCoverFound = true // 表ジャケット確定
          }
        }
      }
    }

    offset += size
  }

  return result
}

/**
 * ID3v1 (ファイル末尾128バイト) パース
 */
function parseID3v1(tail128: Uint8Array): AudioMetadata | null {
  if (tail128.length < 128) return null
  // 先頭3バイトが "TAG"
  if (tail128[0] !== 0x54 || tail128[1] !== 0x41 || tail128[2] !== 0x47) return null

  const decodeField = (bytes: Uint8Array) => {
    try {
      const sjis = new TextDecoder('shift_jis').decode(bytes)
      const clean = sjis.replace(/\0+$/, '').trim()
      if (clean) return clean
    } catch {}
    return new TextDecoder('utf-8').decode(bytes).replace(/\0+$/, '').trim()
  }

  const title = decodeField(tail128.subarray(3, 33))
  const artist = decodeField(tail128.subarray(33, 63))
  const album = decodeField(tail128.subarray(63, 93))
  const year = decodeField(tail128.subarray(93, 97))

  return {
    title: title || undefined,
    artist: artist || undefined,
    album: album || undefined,
    year: year || undefined,
  }
}

/**
 * M4A (MP4/AAC) メタデータパース
 */
function parseM4A(buffer: Uint8Array): AudioMetadata | null {
  if (buffer.length < 8) return null
  // 先頭付近に ftyp または moov があるか
  const view = new DataView(buffer.buffer, buffer.byteOffset, buffer.byteLength)
  const len = buffer.length
  let isMp4 = false

  // ftyp チェック
  if (len >= 8) {
    const ftyp = String.fromCharCode(buffer[4], buffer[5], buffer[6], buffer[7])
    if (ftyp === 'ftyp') isMp4 = true
  }
  if (!isMp4) return null

  const result: AudioMetadata = {}

  // 単純な再帰または反復で atom を検索
  function searchAtom(start: number, end: number): void {
    let pos = start
    while (pos + 8 <= end) {
      const atomSize = view.getUint32(pos)
      if (atomSize < 8 || pos + atomSize > end) break
      const atomName = String.fromCharCode(
        buffer[pos + 4],
        buffer[pos + 5],
        buffer[pos + 6],
        buffer[pos + 7],
      )

      if (atomName === 'moov' || atomName === 'udta' || atomName === 'ilst') {
        searchAtom(pos + 8, pos + atomSize)
      } else if (atomName === 'meta') {
        // meta atom は 4バイトのバージョン/フラグがある
        searchAtom(pos + 12, pos + atomSize)
      } else if (
        atomName === '©nam' ||
        atomName === '©ART' ||
        atomName === '©alb' ||
        atomName === '©gen' ||
        atomName === 'covr'
      ) {
        // ilst 内のアイテム: 内部の "data" box を探す
        const innerEnd = pos + atomSize
        let innerPos = pos + 8
        while (innerPos + 8 <= innerEnd) {
          const dSize = view.getUint32(innerPos)
          const dName = String.fromCharCode(
            buffer[innerPos + 4],
            buffer[innerPos + 5],
            buffer[innerPos + 6],
            buffer[innerPos + 7],
          )
          if (dName === 'data' && dSize >= 16) {
            const typeFlags = view.getUint32(innerPos + 8)
            const payload = buffer.subarray(innerPos + 16, innerPos + dSize)

            if (atomName === '©nam' && !result.title) {
              result.title = new TextDecoder('utf-8').decode(payload).trim()
            } else if (atomName === '©ART' && !result.artist) {
              result.artist = new TextDecoder('utf-8').decode(payload).trim()
            } else if (atomName === '©alb' && !result.album) {
              result.album = new TextDecoder('utf-8').decode(payload).trim()
            } else if (atomName === '©gen' && !result.genre) {
              result.genre = new TextDecoder('utf-8').decode(payload).trim()
            } else if (atomName === 'covr' && !result.cover) {
              // 13: JPEG, 14: PNG
              let mime = 'image/jpeg'
              let format: AudioCover['format'] = 'jpeg'
              const magic = detectImageMagic(payload, 0)
              if (magic) {
                mime = magic.mime
                format = magic.format
              } else if (typeFlags === 14) {
                mime = 'image/png'
                format = 'png'
              }
              result.cover = {
                data: payload,
                mime,
                format,
              }
            }
            break
          }
          if (dSize <= 0) break
          innerPos += dSize
        }
      }

      pos += atomSize
    }
  }

  try {
    searchAtom(0, Math.min(len, 1024 * 1024 * 10))
  } catch (e) {
    console.warn('M4A parse error:', e)
  }

  return result
}

/**
 * 音声ファイル (File または Blob) からタグ・ジャケット画像を解析
 */
export async function parseAudioMetadata(
  fileOrBlob: File | Blob | ArrayBuffer,
): Promise<AudioMetadata> {
  const result: AudioMetadata = {}

  try {
    let headerBytes: Uint8Array

    if (fileOrBlob instanceof ArrayBuffer) {
      headerBytes = new Uint8Array(fileOrBlob)
    } else {
      // 巨大ファイルでも先頭数KBだけ読んでタグサイズを特定
      const firstChunk = await fileOrBlob.slice(0, 16).arrayBuffer()
      const firstBytes = new Uint8Array(firstChunk)

      let readSize = 256 * 1024 // デフォルト 256KB
      if (
        firstBytes.length >= 10 &&
        firstBytes[0] === 0x49 &&
        firstBytes[1] === 0x44 &&
        firstBytes[2] === 0x33
      ) {
        // ID3v2: タグサイズを計算して必要な分だけ切り出し（ジャケット画像も入るように）
        const tagSize =
          ((firstBytes[6] & 0x7f) << 21) |
          ((firstBytes[7] & 0x7f) << 14) |
          ((firstBytes[8] & 0x7f) << 7) |
          (firstBytes[9] & 0x7f)
        readSize = Math.min(fileOrBlob.size, 10 + tagSize + 1024)
      } else {
        // M4Aなど他のフォーマット用
        readSize = Math.min(fileOrBlob.size, 2 * 1024 * 1024) // 2MB
      }

      const headerBuf = await fileOrBlob.slice(0, readSize).arrayBuffer()
      headerBytes = new Uint8Array(headerBuf)
    }

    // 1. ID3v2 のチェック
    const id3v2Result = parseID3v2(headerBytes)
    if (id3v2Result) {
      Object.assign(result, id3v2Result)
    }

    // 2. M4A のチェック
    if (!result.title && !result.artist && !result.cover) {
      const m4aResult = parseM4A(headerBytes)
      if (m4aResult) {
        Object.assign(result, m4aResult)
      }
    }

    // 3. ID3v1 のチェック (末尾 128 バイト、ID3v2でタイトル・アーティストが取れなかった場合の補完)
    if (
      (!result.title || !result.artist) &&
      fileOrBlob instanceof Blob &&
      fileOrBlob.size > 128
    ) {
      try {
        const tailBuf = await fileOrBlob
          .slice(fileOrBlob.size - 128, fileOrBlob.size)
          .arrayBuffer()
        const id3v1Result = parseID3v1(new Uint8Array(tailBuf))
        if (id3v1Result) {
          if (!result.title && id3v1Result.title) result.title = id3v1Result.title
          if (!result.artist && id3v1Result.artist) result.artist = id3v1Result.artist
          if (!result.album && id3v1Result.album) result.album = id3v1Result.album
          if (!result.year && id3v1Result.year) result.year = id3v1Result.year
        }
      } catch (e) {
        console.warn('ID3v1 read error:', e)
      }
    }
  } catch (e) {
    console.error('Failed to parse audio metadata:', e)
  }

  return result
}

/**
 * カバー画像バイナリを File オブジェクトに変換
 */
export function coverToFile(
  cover: AudioCover,
  fileNameBase: string = 'cover',
): File {
  const ext = cover.format === 'png' ? 'png' : cover.format === 'webp' ? 'webp' : 'jpg'
  const mime = cover.mime || `image/${ext}`
  const fileName = `${fileNameBase.replace(/[^a-zA-Z0-9_\-]/g, '_')}_${Date.now()}.${ext}`

  // Uint8Array のコピーを作成して確実に ArrayBuffer のスライスを渡す
  const arrayBuffer = cover.data.buffer.slice(
    cover.data.byteOffset,
    cover.data.byteOffset + cover.data.byteLength,
  )
  const blob = new Blob([arrayBuffer], { type: mime })
  return new File([blob], fileName, { type: mime })
}

/**
 * カバー画像を一時的な Object URL (プレビュー用) に変換
 */
export function coverToObjectUrl(cover: AudioCover): string {
  const arrayBuffer = cover.data.buffer.slice(
    cover.data.byteOffset,
    cover.data.byteOffset + cover.data.byteLength,
  )
  const blob = new Blob([arrayBuffer], { type: cover.mime })
  return URL.createObjectURL(blob)
}
