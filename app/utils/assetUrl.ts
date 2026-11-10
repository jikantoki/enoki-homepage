/**
 * assetUrl.ts
 *
 * PHP サーバー側 (/php/public/ 配下) でホストされている静的アセット
 * (download, customfiles, uploads) の URL を安全に解決・生成するユーティリティ
 */

/**
 * API サーバーのベースURL (例: https://api.home.enoki.xyz) を取得
 */
export function getApiHost(): string {
  try {
    const config = useRuntimeConfig()
    if (config?.public?.apiHost) {
      return String(config.public.apiHost).replace(/\/+$/, '')
    }
  } catch {
    // useRuntimeConfig が使えないコンテキスト (初期化前等) は環境変数をフォールバック
  }

  if (typeof process !== 'undefined' && process.env?.NUXT_API_HOST) {
    return String(process.env.NUXT_API_HOST).replace(/\/+$/, '')
  }

  return 'https://api.home.enoki.xyz'
}

/**
 * 指定されたアセットパスを、別端末の PHP サーバー (/php/public/ 配下) の完全URLへ解決する
 *
 * 例:
 * - '/customfiles/jinseitimec.zip' -> 'https://api.home.enoki.xyz/public/customfiles/jinseitimec.zip'
 * - '/download/images/caramel.jpg' -> 'https://api.home.enoki.xyz/public/download/images/caramel.jpg'
 * - '/uploads/images/apps/stella.svg' -> 'https://api.home.enoki.xyz/public/uploads/images/apps/stella.svg'
 * - '/public/uploads/...' -> 'https://api.home.enoki.xyz/public/uploads/...'
 * - 'data:image/...' -> そのまま
 * - 'blob:...' -> そのまま
 * - 'https://...' -> そのまま (ただし /public 抜けは自動補正)
 * - '/img/...', '/favicon.ico' (Nuxt 側アセット) -> そのまま
 */
export function resolvePublicAssetUrl(rawPath: string | undefined | null): string {
  if (!rawPath || typeof rawPath !== 'string') {
    return ''
  }

  const trimmed = rawPath.trim()
  if (trimmed === '') {
    return ''
  }

  // Data URI や Blob URL はそのまま
  if (trimmed.startsWith('data:') || trimmed.startsWith('blob:')) {
    return trimmed
  }

  const apiHost = getApiHost()

  // 完全な URL の場合
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    // APIホストへのリクエストで /public が抜けている場合は補正
    if (trimmed.startsWith(`${apiHost}/uploads/`)) {
      return trimmed.replace(`${apiHost}/uploads/`, `${apiHost}/public/uploads/`)
    }
    if (trimmed.startsWith(`${apiHost}/customfiles/`)) {
      return trimmed.replace(`${apiHost}/customfiles/`, `${apiHost}/public/customfiles/`)
    }
    if (trimmed.startsWith(`${apiHost}/download/`)) {
      return trimmed.replace(`${apiHost}/download/`, `${apiHost}/public/download/`)
    }
    return trimmed
  }

  const cleanPath = trimmed.startsWith('/') ? trimmed : `/${trimmed}`

  // すでに /public/ で始まっている場合
  if (cleanPath.startsWith('/public/')) {
    return `${apiHost}${cleanPath}`
  }

  // /uploads/, /customfiles/, /download/ で始まっている場合は /public を付与して API ホストへ向ける
  if (
    cleanPath.startsWith('/uploads/') ||
    cleanPath.startsWith('/customfiles/') ||
    cleanPath.startsWith('/download/')
  ) {
    return `${apiHost}/public${cleanPath}`
  }

  // Nuxt 側の静的アセット (/img/, /icons/, /favicon.ico 等) はそのまま返す
  return cleanPath
}

/**
 * アプリ情報の画像URL群を正規化
 */
export function normalizeAppAssetUrls<T extends Record<string, any>>(app: T): T {
  if (!app) return app

  const copy = { ...app }
  if (copy.icon) {
    copy.icon = resolvePublicAssetUrl(copy.icon)
  }
  if (copy.thumbnail) {
    copy.thumbnail = resolvePublicAssetUrl(copy.thumbnail)
  }
  if (Array.isArray(copy.images)) {
    copy.images = copy.images.map((img: string) => resolvePublicAssetUrl(img))
  }
  return copy
}

/**
 * 楽曲情報の音声・画像URL群を正規化
 */
export function normalizeMusicAssetUrls<T extends Record<string, any>>(music: T): T {
  if (!music) return music

  const copy = { ...music }
  if (copy.audioUrl) {
    copy.audioUrl = resolvePublicAssetUrl(copy.audioUrl)
  }
  if (copy.cover) {
    copy.cover = resolvePublicAssetUrl(copy.cover)
  }
  if (copy.icon) {
    copy.icon = resolvePublicAssetUrl(copy.icon)
  }
  if (copy.thumbnail) {
    copy.thumbnail = resolvePublicAssetUrl(copy.thumbnail)
  }
  return copy
}
