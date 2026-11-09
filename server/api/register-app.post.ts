import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

async function saveImageUri(dataUri: string | undefined, filenameBase: string): Promise<string> {
  if (!dataUri || typeof dataUri !== 'string') {
    return '/uploads/images/apps/default_app_thumb.svg'
  }
  if (
    dataUri.startsWith('/uploads/') ||
    dataUri.startsWith('http://') ||
    dataUri.startsWith('https://') ||
    dataUri.startsWith('/img/') ||
    dataUri.startsWith('/icons/')
  ) {
    return dataUri
  }

  const uploadDir = path.resolve(process.cwd(), 'public/uploads/images/apps')
  await fs.mkdir(uploadDir, { recursive: true })

  // 1. SVG Data URI
  if (dataUri.startsWith('data:image/svg+xml')) {
    let svgContent = ''
    if (dataUri.includes(';base64,')) {
      svgContent = Buffer.from(dataUri.split(';base64,')[1], 'base64').toString('utf-8')
    } else {
      const raw = dataUri.replace(/^data:image\/svg\+xml;?(?:utf8|charset=utf-8)?,/i, '')
      try {
        svgContent = decodeURIComponent(raw)
      } catch {
        svgContent = raw
      }
    }
    const filename = `${filenameBase}.svg`
    await fs.writeFile(path.join(uploadDir, filename), svgContent, 'utf-8')
    return `/uploads/images/apps/${filename}`
  }

  // 2. ラスター画像
  const rasterMatch = dataUri.match(/^data:image\/(png|jpe?g|webp|gif);base64,(.+)$/i)
  if (rasterMatch) {
    const rawExt = rasterMatch[1].toLowerCase()
    const ext = rawExt === 'jpeg' ? 'jpg' : rawExt
    const buffer = Buffer.from(rasterMatch[2], 'base64')
    const filename = `${filenameBase}.${ext}`
    await fs.writeFile(path.join(uploadDir, filename), buffer)
    return `/uploads/images/apps/${filename}`
  }

  return dataUri
}

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)

    if (!body || !body.name || !body.id) {
      throw createError({
        statusCode: 400,
        statusMessage: 'アプリ名とアプリIDは必須です。',
      })
    }

    const safeId = String(body.id).replace(/[^a-zA-Z0-9_-]/g, '_') || 'app'

    // 画像が Base64 / Data URI であればファイル保存して URL に置換
    const iconUrl = await saveImageUri(body.icon, `${safeId}_icon`)
    const thumbnailUrl = await saveImageUri(body.thumbnail, `${safeId}_thumb`)

    let imageUrls: string[] = []
    if (Array.isArray(body.images) && body.images.length > 0) {
      const processed: string[] = []
      for (let i = 0; i < body.images.length; i++) {
        const imgUrl = await saveImageUri(body.images[i], `${safeId}_screen_${i + 1}`)
        processed.push(imgUrl)
      }
      imageUrls = processed
    } else {
      imageUrls = [thumbnailUrl]
    }

    const updatedItem = {
      ...body,
      icon: iconUrl,
      thumbnail: thumbnailUrl,
      images: imageUrls,
    }

    const appPaths = [
      path.resolve(process.cwd(), 'app/data/apps.json'),
      path.resolve(process.cwd(), 'public/data/apps.json'),
    ]

    for (const filePath of appPaths) {
      try {
        let existingList: any[] = []
        try {
          const content = await fs.readFile(filePath, 'utf-8')
          existingList = JSON.parse(content)
        } catch {
          existingList = []
        }

        // 既存の同一IDがあれば上書き、なければ先頭に追加
        const existingIndex = existingList.findIndex((item) => item.id === body.id)
        if (existingIndex !== -1) {
          existingList[existingIndex] = { ...existingList[existingIndex], ...updatedItem }
        } else {
          existingList.unshift(updatedItem)
        }

        await fs.writeFile(filePath, JSON.stringify(existingList, null, 2), 'utf-8')
      } catch (err) {
        console.warn(`Failed to update ${filePath}:`, err)
      }
    }

    return {
      status: 'ok',
      message: 'アプリを登録しました。',
      data: updatedItem,
    }
  } catch (error: any) {
    console.error('Register app error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || 'アプリ登録中にエラーが発生しました。',
    })
  }
})
