import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

function getAppPalette(name: string): { c1: string; c2: string; accent: string } {
  const palettes = [
    { c1: '#4F46E5', c2: '#06B6D4', accent: '#38BDF8' },
    { c1: '#7C3AED', c2: '#DB2777', accent: '#F472B6' },
    { c1: '#059669', c2: '#10B981', accent: '#34D399' },
    { c1: '#D97706', c2: '#EA580C', accent: '#FBBF24' },
    { c1: '#2563EB', c2: '#4F46E5', accent: '#60A5FA' },
    { c1: '#DC2626', c2: '#E11D48', accent: '#FB7185' },
    { c1: '#0D9488', c2: '#0284C7', accent: '#2DD4BF' },
  ]
  let hash = 0
  for (let i = 0; i < (name || '').length; i++) {
    hash = (hash << 5) - hash + name.charCodeAt(i)
    hash |= 0
  }
  return palettes[Math.abs(hash) % palettes.length]
}

function escapeXml(str: string): string {
  return (str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
}

function generateAppIconSvg(name: string): string {
  const safeName = (name || 'App').trim()
  const char = Array.from(safeName)[0] || 'A'
  const p = getAppPalette(safeName)

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="icon_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${p.c1}"/>
      <stop offset="100%" stop-color="${p.c2}"/>
    </linearGradient>
    <filter id="icon_shadow" x="-10%" y="-10%" width="130%" height="130%">
      <feDropShadow dx="0" dy="6" stdDeviation="8" flood-color="#000000" flood-opacity="0.3"/>
    </filter>
  </defs>
  <rect width="256" height="256" rx="56" fill="url(#icon_bg)"/>
  <circle cx="128" cy="128" r="90" fill="none" stroke="${p.accent}" stroke-width="3" opacity="0.25"/>
  <text x="128" y="162" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="96" fill="#ffffff" filter="url(#icon_shadow)">${escapeXml(char)}</text>
</svg>`
}

function generateAppThumbnailSvg(name: string, category: string = 'アプリ'): string {
  const safeName = (name || 'App').trim()
  const safeCat = (category || 'アプリ').trim()
  const p = getAppPalette(safeName)

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 360" width="640" height="360">
  <defs>
    <linearGradient id="thumb_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${p.c1}"/>
      <stop offset="100%" stop-color="${p.c2}"/>
    </linearGradient>
    <linearGradient id="thumb_overlay" x1="0%" y1="100%" x2="0%" y2="0%">
      <stop offset="0%" stop-color="#000000" stop-opacity="0.85"/>
      <stop offset="55%" stop-color="#000000" stop-opacity="0.3"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect width="640" height="360" rx="16" fill="url(#thumb_bg)"/>
  <circle cx="540" cy="90" r="130" fill="#ffffff" opacity="0.08"/>
  <circle cx="100" cy="70" r="110" fill="#ffffff" opacity="0.05"/>
  <circle cx="580" cy="270" r="160" fill="#000000" opacity="0.15"/>
  <rect width="640" height="360" rx="16" fill="url(#thumb_overlay)"/>
  <rect x="36" y="32" width="100" height="24" rx="12" fill="${p.accent}" opacity="0.9"/>
  <text x="86" y="48" font-family="system-ui, sans-serif" font-weight="700" font-size="11" fill="#000000" text-anchor="middle">${escapeXml(safeCat)}</text>
  <text x="36" y="270" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="28" fill="#ffffff">${escapeXml(safeName)}</text>
  <text x="36" y="305" font-family="system-ui, -apple-system, sans-serif" font-weight="500" font-size="15" fill="#e0e0e0">公式ハイライト • ENOKI APPS</text>
</svg>`
}

async function saveSvgToFile(svg: string, prefix: string): Promise<string> {
  const uploadDir = path.resolve(process.cwd(), 'public/uploads/images')
  await fs.mkdir(uploadDir, { recursive: true })
  const filename = `${prefix}_${Date.now()}_${Math.random().toString(36).substring(2, 8)}.svg`
  await fs.writeFile(path.join(uploadDir, filename), svg, 'utf-8')
  return `/uploads/images/${filename}`
}

async function saveImageUri(dataUri: string | undefined, filenameBase: string): Promise<string> {
  if (!dataUri || typeof dataUri !== 'string') {
    return ''
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

  const uploadDir = path.resolve(process.cwd(), 'public/uploads/images')
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
    const filename = `${filenameBase}_${Date.now()}.svg`
    await fs.writeFile(path.join(uploadDir, filename), svgContent, 'utf-8')
    return `/uploads/images/${filename}`
  }

  // 2. ラスター画像
  const rasterMatch = dataUri.match(/^data:image\/(png|jpe?g|webp|gif);base64,(.+)$/i)
  if (rasterMatch) {
    const rawExt = rasterMatch[1].toLowerCase()
    const ext = rawExt === 'jpeg' ? 'jpg' : rawExt
    const buffer = Buffer.from(rasterMatch[2], 'base64')
    const filename = `${filenameBase}_${Date.now()}.${ext}`
    await fs.writeFile(path.join(uploadDir, filename), buffer)
    return `/uploads/images/${filename}`
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

    // アイコン：未設定ならアプリ名からSVG生成、Base64ならファイル保存
    let iconUrl = ''
    if (!body.icon) {
      const svg = generateAppIconSvg(body.name)
      iconUrl = await saveSvgToFile(svg, `icon_${safeId}`)
    } else {
      iconUrl = await saveImageUri(body.icon, `icon_${safeId}`)
    }

    // サムネイル：未設定ならアプリ名からSVG生成、Base64ならファイル保存
    let thumbnailUrl = ''
    if (!body.thumbnail) {
      const svg = generateAppThumbnailSvg(body.name, body.category)
      thumbnailUrl = await saveSvgToFile(svg, `thumb_${safeId}`)
    } else {
      thumbnailUrl = await saveImageUri(body.thumbnail, `thumb_${safeId}`)
    }

    let imageUrls: string[] = []
    if (Array.isArray(body.images) && body.images.length > 0) {
      const processed: string[] = []
      for (let i = 0; i < body.images.length; i++) {
        const imgUrl = await saveImageUri(body.images[i], `screen_${safeId}_${i + 1}`)
        if (imgUrl) processed.push(imgUrl)
      }
      imageUrls = processed.length > 0 ? processed : [thumbnailUrl]
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
