import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readMultipartFormData } from 'h3'
import { parseServerAudioMetadata } from '../utils/audioMetadata'

// 許可する音声拡張子とMIMEタイプ
const ALLOWED_EXTENSIONS = ['.mp3', '.wav', '.m4a', '.ogg', '.flac', '.aac', '.webm']
const ALLOWED_MIME_TYPES = [
  'audio/mpeg',
  'audio/mp3',
  'audio/wav',
  'audio/x-wav',
  'audio/wave',
  'audio/x-pn-wav',
  'audio/ogg',
  'audio/mp4',
  'audio/x-m4a',
  'audio/flac',
  'audio/x-flac',
  'audio/aac',
  'audio/webm',
  'application/octet-stream', // 一部ブラウザでmp3/wavがoctet-streamになる場合がある
]

// 最大ファイルサイズ: 100MB
const MAX_FILE_SIZE = 100 * 1024 * 1024

export default defineEventHandler(async (event) => {
  try {
    const formData = await readMultipartFormData(event)

    if (!formData || formData.length === 0) {
      throw createError({
        statusCode: 400,
        statusMessage: 'アップロードされた音声ファイルが見つかりません。',
      })
    }

    // audio フィールドまたは最初のファイルを探索
    const audioPart =
      formData.find((part) => part.name === 'audio' || part.name === 'file') ||
      formData.find((part) => part.filename)

    if (!audioPart || !audioPart.filename || !audioPart.data) {
      throw createError({
        statusCode: 400,
        statusMessage: '有効な音声ファイルデータが含まれていません。',
      })
    }

    if (audioPart.data.length > MAX_FILE_SIZE) {
      throw createError({
        statusCode: 400,
        statusMessage: 'ファイルサイズが上限（100MB）を超えています。',
      })
    }

    const rawExt = path.extname(audioPart.filename).toLowerCase()
    const ext = rawExt || '.mp3'

    if (!ALLOWED_EXTENSIONS.includes(ext)) {
      throw createError({
        statusCode: 400,
        statusMessage: `非対応の拡張子です。許可されている形式: ${ALLOWED_EXTENSIONS.join(', ')}`,
      })
    }

    // MIMEタイプチェック（設定されている場合）
    if (audioPart.type && !ALLOWED_MIME_TYPES.includes(audioPart.type.toLowerCase())) {
      console.warn(`Warning: Unexpected audio mime type: ${audioPart.type}`)
    }

    // アップロード先ディレクトリの準備
    const uploadDir = path.resolve(process.cwd(), 'public/uploads/audio')
    await fs.mkdir(uploadDir, { recursive: true })

    // 安全で一意なファイル名を生成
    const timestamp = Date.now()
    const randomHex = Math.random().toString(36).substring(2, 10)
    const sanitizedOriginalName = path.basename(audioPart.filename, rawExt).replace(/[^a-zA-Z0-9_\-\u3000-\u303f\u3040-\u309f\u30a0-\u30ff\uff00-\uff9f\u4e00-\u9faf]/g, '_').substring(0, 30)
    const finalFilename = `${timestamp}_${randomHex}_${sanitizedOriginalName}${ext}`
    const targetFilePath = path.join(uploadDir, finalFilename)

    // ファイル保存
    await fs.writeFile(targetFilePath, audioPart.data)

    // 公開URLパス
    const publicUrl = `/uploads/audio/${finalFilename}`

    // ID3タグ・メタデータの自動解析およびジャケット画像の保存
    let metadata: {
      title?: string
      artist?: string
      album?: string
      genre?: string
      year?: string
      coverUrl?: string
    } | undefined = undefined

    try {
      const parsed = parseServerAudioMetadata(audioPart.data)
      let coverUrl: string | undefined = undefined

      if (parsed.cover && parsed.cover.data && parsed.cover.data.length > 0) {
        const imgExt = parsed.cover.format === 'png' ? '.png' : parsed.cover.format === 'webp' ? '.webp' : '.jpg'
        const coverFilename = `img_${timestamp}_${randomHex}_cover${imgExt}`
        const imgDir = path.resolve(process.cwd(), 'public/uploads/images')
        await fs.mkdir(imgDir, { recursive: true })
        const coverPath = path.join(imgDir, coverFilename)
        await fs.writeFile(coverPath, parsed.cover.data)
        coverUrl = `/uploads/images/${coverFilename}`
      }

      if (parsed.title || parsed.artist || parsed.album || parsed.genre || coverUrl) {
        metadata = {
          title: parsed.title,
          artist: parsed.artist,
          album: parsed.album,
          genre: parsed.genre,
          year: parsed.year,
          coverUrl,
        }
      }
    } catch (metaErr) {
      console.warn('Server audio metadata parsing error (skipped):', metaErr)
    }

    return {
      status: 'ok',
      url: publicUrl,
      filename: finalFilename,
      originalName: audioPart.filename,
      size: audioPart.data.length,
      mimeType: audioPart.type || 'audio/mpeg',
      metadata,
    }
  } catch (error: any) {
    console.error('Audio upload error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || '音声ファイルのアップロード中にエラーが発生しました。',
    })
  }
})
