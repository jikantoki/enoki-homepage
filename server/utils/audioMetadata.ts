/**
 * Node.js サーバー環境用 音声メタデータ (ID3v2, ID3v1, M4A) 解析ユーティリティ
 */

export interface ServerAudioCover {
  data: Buffer
  mime: string
  format: 'jpeg' | 'png' | 'webp' | 'gif'
}

export interface ServerAudioMetadata {
  title?: string
  artist?: string
  album?: string
  albumArtist?: string
  genre?: string
  year?: string
  cover?: ServerAudioCover
}

function decodeText(bytes: Buffer, encoding: number): string {
  if (!bytes || bytes.length === 0) return ''
  try {
    if (encoding === 0) {
      // UTF-8 or CP932 or Latin1
      try {
        const utf8 = bytes.toString('utf8')
        if (!utf8.includes('\ufffd')) return utf8.replace(/\0+$/, '').trim()
      } catch {}
      return bytes.toString('latin1').replace(/\0+$/, '').trim()
    } else if (encoding === 1) {
      // UTF-16 with BOM
      return bytes.toString('utf16le').replace(/\0+$/, '').trim()
    } else if (encoding === 2) {
      // UTF-16BE
      const swapped = Buffer.alloc(bytes.length)
      for (let i = 0; i < bytes.length - 1; i += 2) {
        swapped[i] = bytes[i + 1]
        swapped[i + 1] = bytes[i]
      }
      return swapped.toString('utf16le').replace(/\0+$/, '').trim()
    } else if (encoding === 3) {
      // UTF-8
      return bytes.toString('utf8').replace(/\0+$/, '').trim()
    }
  } catch (e) {
    console.warn('Server text decode error:', e)
  }
  return ''
}

function detectImage(buf: Buffer, start: number = 0): {
  offset: number
  mime: string
  format: ServerAudioCover['format']
} | null {
  for (let i = start; i < buf.length - 3; i++) {
    if (buf[i] === 0xff && buf[i + 1] === 0xd8 && buf[i + 2] === 0xff) {
      return { offset: i, mime: 'image/jpeg', format: 'jpeg' }
    }
    if (
      buf[i] === 0x89 &&
      buf[i + 1] === 0x50 &&
      buf[i + 2] === 0x4e &&
      buf[i + 3] === 0x47
    ) {
      return { offset: i, mime: 'image/png', format: 'png' }
    }
    if (
      buf[i] === 0x52 &&
      buf[i + 1] === 0x49 &&
      buf[i + 2] === 0x46 &&
      buf[i + 3] === 0x46 &&
      i + 11 < buf.length &&
      buf[i + 8] === 0x57 &&
      buf[i + 9] === 0x45 &&
      buf[i + 10] === 0x42 &&
      buf[i + 11] === 0x50
    ) {
      return { offset: i, mime: 'image/webp', format: 'webp' }
    }
    if (
      buf[i] === 0x47 &&
      buf[i + 1] === 0x49 &&
      buf[i + 2] === 0x46 &&
      buf[i + 3] === 0x38
    ) {
      return { offset: i, mime: 'image/gif', format: 'gif' }
    }
  }
  return null
}

export function parseServerAudioMetadata(buffer: Buffer): ServerAudioMetadata {
  const result: ServerAudioMetadata = {}
  if (!buffer || buffer.length < 10) return result

  // ID3v2 パース
  if (buffer[0] === 0x49 && buffer[1] === 0x44 && buffer[2] === 0x33) {
    const major = buffer[3]
    const flags = buffer[5]
    const tagSize =
      ((buffer[6] & 0x7f) << 21) |
      ((buffer[7] & 0x7f) << 14) |
      ((buffer[8] & 0x7f) << 7) |
      (buffer[9] & 0x7f)

    let offset = 10
    if (flags & 0x40 && offset + 4 <= buffer.length) {
      const extSize =
        major === 4
          ? ((buffer[offset] & 0x7f) << 21) |
            ((buffer[offset + 1] & 0x7f) << 14) |
            ((buffer[offset + 2] & 0x7f) << 7) |
            (buffer[offset + 3] & 0x7f)
          : (buffer[offset] << 24) |
            (buffer[offset + 1] << 16) |
            (buffer[offset + 2] << 8) |
            buffer[offset + 3]
      offset += (major === 4 ? extSize : 4 + extSize)
    }

    const tagEnd = Math.min(buffer.length, 10 + tagSize)

    while (offset + (major === 2 ? 6 : 10) <= tagEnd) {
      if (buffer[offset] === 0) break

      let id = ''
      let size = 0

      if (major === 2) {
        id = buffer.toString('ascii', offset, offset + 3)
        size = (buffer[offset + 3] << 16) | (buffer[offset + 4] << 8) | buffer[offset + 5]
        offset += 6
      } else {
        id = buffer.toString('ascii', offset, offset + 4)
        if (major === 4) {
          const synch =
            ((buffer[offset + 4] & 0x7f) << 21) |
            ((buffer[offset + 5] & 0x7f) << 14) |
            ((buffer[offset + 6] & 0x7f) << 7) |
            (buffer[offset + 7] & 0x7f)
          const norm =
            (buffer[offset + 4] << 24) |
            (buffer[offset + 5] << 16) |
            (buffer[offset + 6] << 8) |
            buffer[offset + 7]
          const hasHigh =
            (buffer[offset + 4] & 0x80) ||
            (buffer[offset + 5] & 0x80) ||
            (buffer[offset + 6] & 0x80) ||
            (buffer[offset + 7] & 0x80)
          size = hasHigh ? norm : synch
        } else {
          size =
            (buffer[offset + 4] << 24) |
            (buffer[offset + 5] << 16) |
            (buffer[offset + 6] << 8) |
            buffer[offset + 7]
          if (offset + 10 + size > tagEnd + 32) {
            const alt =
              ((buffer[offset + 4] & 0x7f) << 21) |
              ((buffer[offset + 5] & 0x7f) << 14) |
              ((buffer[offset + 6] & 0x7f) << 7) |
              (buffer[offset + 7] & 0x7f)
            if (offset + 10 + alt <= tagEnd) size = alt
          }
        }
        offset += 10
      }

      if (size <= 0 || offset + size > tagEnd + 64) break
      const frameBuf = buffer.subarray(offset, Math.min(offset + size, buffer.length))

      if (frameBuf.length > 0) {
        const enc = frameBuf[0]
        const text = frameBuf.subarray(1)

        if ((id === 'TIT2' || id === 'TT2') && !result.title) {
          result.title = decodeText(text, enc)
        } else if ((id === 'TPE1' || id === 'TP1') && !result.artist) {
          result.artist = decodeText(text, enc)
        } else if ((id === 'TALB' || id === 'TAL') && !result.album) {
          result.album = decodeText(text, enc)
        } else if ((id === 'TCON' || id === 'TCO') && !result.genre) {
          result.genre = decodeText(text, enc).replace(/^\(\d+\)\s*/, '')
        } else if ((id === 'APIC' || id === 'PIC') && !result.cover) {
          const img = detectImage(frameBuf, 1)
          if (img) {
            result.cover = {
              data: frameBuf.subarray(img.offset),
              mime: img.mime,
              format: img.format,
            }
          }
        }
      }

      offset += size
    }
  }

  // ID3v1 フォールバック
  if ((!result.title || !result.artist) && buffer.length >= 128) {
    const tail = buffer.subarray(buffer.length - 128)
    if (tail[0] === 0x54 && tail[1] === 0x41 && tail[2] === 0x47) {
      // 'TAG'
      const clean = (b: Buffer) => b.toString('utf8').replace(/\0+$/, '').trim()
      if (!result.title) result.title = clean(tail.subarray(3, 33))
      if (!result.artist) result.artist = clean(tail.subarray(33, 63))
      if (!result.album) result.album = clean(tail.subarray(63, 93))
      if (!result.year) result.year = clean(tail.subarray(93, 97))
    }
  }

  return result
}
