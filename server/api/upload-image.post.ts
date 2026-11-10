import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readMultipartFormData } from 'h3'

const ALLOWED_EXTENSIONS = ['.png', '.jpg', '.jpeg', '.webp', '.svg', '.gif']
const MAX_FILE_SIZE = 15 * 1024 * 1024 // 15MB

export default defineEventHandler(async (event) => {
  try {
    const formData = await readMultipartFormData(event)

    if (!formData || formData.length === 0) {
      throw createError({
        statusCode: 400,
        statusMessage: '画像ファイルが見つかりません。',
      })
    }

    const filePart =
      formData.find((part) => part.name === 'image' || part.name === 'file') ||
      formData.find((part) => part.filename)

    if (!filePart || !filePart.filename || !filePart.data) {
      throw createError({
        statusCode: 400,
        statusMessage: '有効な画像データが含まれていません。',
      })
    }

    if (filePart.data.length > MAX_FILE_SIZE) {
      throw createError({
        statusCode: 400,
        statusMessage: '画像サイズが上限（15MB）を超えています。',
      })
    }

    const rawExt = path.extname(filePart.filename).toLowerCase()
    const ext = rawExt || '.png'

    if (!ALLOWED_EXTENSIONS.includes(ext)) {
      throw createError({
        statusCode: 400,
        statusMessage: `非対応の画像形式です。許可されている形式: ${ALLOWED_EXTENSIONS.join(', ')}`,
      })
    }

    const subDirPart = formData.find((part) => part.name === 'subDir')
    const subDir = subDirPart && subDirPart.data ? subDirPart.data.toString().trim() : 'images'
    const safeSubDir = (subDir === 'apps' || subDir === 'music') ? subDir : 'images'

    const config = useRuntimeConfig()
    const apiHost = String(config.public?.apiHost || '').replace(/\/+$/, '')

    // 1. PHP API サーバーが設定されている場合は PHP サーバーへ転送して保存
    if (apiHost) {
      try {
        const phpFormData = new FormData()
        const blob = new Blob([filePart.data], { type: filePart.type || 'image/png' })
        phpFormData.append('image', blob, filePart.filename)
        phpFormData.append('subDir', safeSubDir)

        const phpRes = await fetch(`${apiHost}/uploadImage.php`, {
          method: 'POST',
          headers: {
            apiid: String(config.public?.apiId || ''),
            apitoken: String(config.public?.apiToken || ''),
            apipassword: String(config.public?.apiAccesskey || ''),
          },
          body: phpFormData,
        })

        if (phpRes.ok) {
          const phpJson = await phpRes.json()
          if (phpJson && phpJson.status === 'ok') {
            return phpJson
          }
        }
      } catch (proxyErr) {
        console.warn('PHP upload proxy error:', proxyErr)
      }
    }

    // 2. フォールバック: ローカルの php/public/uploads/images に保存
    const subPath = safeSubDir === 'images' ? '' : `/${safeSubDir}`
    const uploadDir = path.resolve(process.cwd(), `php/public/uploads/images${subPath}`)
    await fs.mkdir(uploadDir, { recursive: true })

    const timestamp = Date.now()
    const randomHex = Math.random().toString(36).substring(2, 10)
    const finalFilename = `img_${timestamp}_${randomHex}${ext}`
    const targetFilePath = path.join(uploadDir, finalFilename)

    await fs.writeFile(targetFilePath, filePart.data)

    const hostBase = apiHost || 'https://api.home.enoki.xyz'
    const publicUrl = `${hostBase}/public/uploads/images${subPath}/${finalFilename}`

    return {
      status: 'ok',
      url: publicUrl,
      filename: finalFilename,
      originalName: filePart.filename,
      size: filePart.data.length,
    }
  } catch (error: any) {
    console.error('Image upload error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || '画像のアップロード中にエラーが発生しました。',
    })
  }
})
