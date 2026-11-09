import { promises as fs } from 'fs'
import path from 'path'
import appsFallback from '~/data/apps.json'
import musicFallback from '~/data/music.json'
import { DOWNLOAD_ITEMS, type DownloadItem } from '~/data/downloads'

export interface FeedItem {
  id: string
  title: string
  link: string
  description: string
  pubDate: Date
  category: string
  author?: string
  guid: string
}

/**
 * サイトのベース URL を取得
 */
export function getSiteUrl(): string {
  const config = useRuntimeConfig()
  const configured =
    process.env.NUXT_PUBLIC_SITE_URL ||
    process.env.SITE_URL ||
    (config.public as any)?.siteUrl ||
    'https://enoki.xyz'
  return String(configured).replace(/\/+$/, '')
}

/**
 * XML 特殊文字をエスケープ
 */
export function escapeXml(str: unknown): string {
  if (str === null || str === undefined) return ''
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
}

/**
 * CDATA 内の終了タグを安全にエスケープ
 */
export function escapeCdata(str: unknown): string {
  if (str === null || str === undefined) return ''
  return String(str).replace(/]]>/g, ']]]]><![CDATA[>')
}

/**
 * Markdown や改行を簡易的にクリーンアップした要約テキストを生成
 */
export function cleanDescription(text: unknown, maxLength = 240): string {
  if (!text || typeof text !== 'string') return ''
  const cleaned = text
    .replace(/```[\s\S]*?```/g, '') // コードブロック除去
    .replace(/#+\s+/g, '') // 見出し除去
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1') // リンク文字のみ抽出
    .replace(/[*_~`]/g, '') // 修飾記号除去
    .replace(/\s+/g, ' ') // 連続空白・改行を単一スペース化
    .trim()
  if (cleaned.length <= maxLength) return cleaned
  return cleaned.slice(0, maxLength) + '...'
}

/**
 * W3C Datetime 形式 (例: 2026-11-10T03:00:00Z) を生成 (sitemap 用)
 * 検索エンジンの互換性のためミリ秒を除去した秒精度 ISO 文字列
 */
export function formatIsoDate(input?: number | string | Date): string {
  if (!input) {
    return new Date().toISOString().replace(/\.\d{3}Z$/, 'Z')
  }
  const d = typeof input === 'number' || typeof input === 'string' ? new Date(input) : input
  if (isNaN(d.getTime())) {
    return new Date().toISOString().replace(/\.\d{3}Z$/, 'Z')
  }
  return d.toISOString().replace(/\.\d{3}Z$/, 'Z')
}

/**
 * RFC 822 / RFC 2822 日付文字列 (例: Tue, 10 Nov 2026 03:00:00 GMT) を生成 (RSS 用)
 */
export function formatRfc822Date(input?: number | string | Date): string {
  if (!input) return new Date().toUTCString()
  const d = typeof input === 'number' || typeof input === 'string' ? new Date(input) : input
  if (isNaN(d.getTime())) return new Date().toUTCString()
  return d.toUTCString()
}

/**
 * アプリ一覧を取得 (PHP API -> ローカルファイル -> バンドルフォールバック)
 */
export async function fetchAppItems(): Promise<any[]> {
  const config = useRuntimeConfig()
  const host = String(config.public?.apiHost || '').replace(/\/+$/, '')

  // 1. PHP API からの取得を試行
  if (host) {
    try {
      const controller = new AbortController()
      const timeoutId = setTimeout(() => controller.abort(), 3500)
      const res = await fetch(`${host}/getApps.php`, {
        headers: {
          apiid: String(config.public?.apiId || ''),
          apitoken: String(config.public?.apiToken || ''),
          apipassword: String(config.public?.apiAccesskey || ''),
        },
        signal: controller.signal,
      })
      clearTimeout(timeoutId)

      if (res.ok) {
        const json = await res.json()
        if (json && json.status === 'ok' && Array.isArray(json.data) && json.data.length > 0) {
          return json.data
        }
      }
    } catch {
      // ネットワークや接続エラー時はローカルフォールバックへ
    }
  }

  // 2. ローカルの app/data/apps.json を試行
  try {
    const localPath = path.resolve(process.cwd(), 'app/data/apps.json')
    const content = await fs.readFile(localPath, 'utf-8')
    const parsed = JSON.parse(content)
    if (Array.isArray(parsed) && parsed.length > 0) {
      return parsed
    }
  } catch {
    // 読み込み失敗時はバンドルフォールバックへ
  }

  // 3. 静的インポートされた appsFallback
  return Array.isArray(appsFallback) ? appsFallback : []
}

/**
 * 音楽一覧を取得 (PHP API -> ローカルファイル -> バンドルフォールバック)
 */
export async function fetchMusicItems(): Promise<any[]> {
  const config = useRuntimeConfig()
  const host = String(config.public?.apiHost || '').replace(/\/+$/, '')

  // 1. PHP API からの取得を試行
  if (host) {
    try {
      const controller = new AbortController()
      const timeoutId = setTimeout(() => controller.abort(), 3500)
      const res = await fetch(`${host}/getMusic.php`, {
        headers: {
          apiid: String(config.public?.apiId || ''),
          apitoken: String(config.public?.apiToken || ''),
          apipassword: String(config.public?.apiAccesskey || ''),
        },
        signal: controller.signal,
      })
      clearTimeout(timeoutId)

      if (res.ok) {
        const json = await res.json()
        if (json && json.status === 'ok' && Array.isArray(json.data) && json.data.length > 0) {
          return json.data
        }
      }
    } catch {
      // ネットワークや接続エラー時はローカルフォールバックへ
    }
  }

  // 2. ローカルの app/data/music.json を試行
  try {
    const localPath = path.resolve(process.cwd(), 'app/data/music.json')
    const content = await fs.readFile(localPath, 'utf-8')
    const parsed = JSON.parse(content)
    if (Array.isArray(parsed) && parsed.length > 0) {
      return parsed
    }
  } catch {
    // 読み込み失敗時はバンドルフォールバックへ
  }

  // 3. 静的インポートされた musicFallback
  return Array.isArray(musicFallback) ? musicFallback : []
}

/**
 * ダウンロード一覧を取得
 */
export function getDownloadItems(): DownloadItem[] {
  return Array.isArray(DOWNLOAD_ITEMS) ? DOWNLOAD_ITEMS : []
}
