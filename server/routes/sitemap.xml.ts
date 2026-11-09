import { defineEventHandler, setHeader } from 'h3'
import {
  getSiteUrl,
  escapeXml,
  formatIsoDate,
  fetchAppItems,
  fetchMusicItems,
} from '../utils/siteData'

interface RouteItem {
  path: string
  priority: string
  changefreq: 'always' | 'hourly' | 'daily' | 'weekly' | 'monthly' | 'yearly' | 'never'
  lastmod?: string
}

export default defineEventHandler(async (event) => {
  const siteUrl = getSiteUrl()

  // 1. 静的ルート定義
  const staticRoutes: RouteItem[] = [
    { path: '/', priority: '1.0', changefreq: 'daily' },
    { path: '/apps', priority: '0.9', changefreq: 'daily' },
    { path: '/music', priority: '0.9', changefreq: 'daily' },
    { path: '/download', priority: '0.9', changefreq: 'weekly' },
    { path: '/product', priority: '0.8', changefreq: 'weekly' },
    { path: '/product/it', priority: '0.8', changefreq: 'weekly' },
    { path: '/product/music', priority: '0.8', changefreq: 'weekly' },
    { path: '/about', priority: '0.8', changefreq: 'monthly' },
    { path: '/profile', priority: '0.8', changefreq: 'monthly' },
    { path: '/friendlist', priority: '0.6', changefreq: 'monthly' },
    { path: '/info', priority: '0.6', changefreq: 'monthly' },
    { path: '/tutorial', priority: '0.6', changefreq: 'monthly' },
    { path: '/sponsors', priority: '0.6', changefreq: 'monthly' },
    { path: '/privacy', priority: '0.4', changefreq: 'yearly' },
    { path: '/terms', priority: '0.4', changefreq: 'yearly' },
  ]

  // 2. 動的アイテム取得 (アプリ & 音楽)
  const [apps, musics] = await Promise.all([
    fetchAppItems(),
    fetchMusicItems(),
  ])

  const dynamicRoutes: RouteItem[] = []

  // アプリ詳細ページ
  for (const app of apps) {
    if (!app || !app.id) continue
    dynamicRoutes.push({
      path: `/apps/${encodeURIComponent(String(app.id))}`,
      priority: '0.7',
      changefreq: 'weekly',
      lastmod: formatIsoDate(app.releaseDate),
    })
  }

  // 音楽詳細ページ
  for (const m of musics) {
    if (!m || !m.id) continue
    dynamicRoutes.push({
      path: `/music/${encodeURIComponent(String(m.id))}`,
      priority: '0.7',
      changefreq: 'weekly',
      lastmod: formatIsoDate(m.releaseDate),
    })
  }

  const allRoutes = [...staticRoutes, ...dynamicRoutes]

  // 静的ページの基準日：最新コンテンツの公開日、または日付単位の文字列 (YYYY-MM-DD)
  const latestContentTimestamp = Math.max(
    ...apps.map((a) => Number(a?.releaseDate) || 0),
    ...musics.map((m) => Number(m?.releaseDate) || 0),
  )
  const staticLastmod = latestContentTimestamp > 0
    ? formatIsoDate(latestContentTimestamp)
    : new Date().toISOString().slice(0, 10)

  // 3. XML を構築 (ja と en のマルチ言語対応 & ブラウザ表示用 XSL スタイルシート付き)
  let xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
  xml += '<?xml-stylesheet type="text/xsl" href="/sitemap.xsl"?>\n'
  xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">\n'

  for (const r of allRoutes) {
    const jaPath = r.path === '/' ? '' : r.path
    const enPath = `/en${jaPath}`

    const jaUrl = `${siteUrl}${jaPath || '/'}`
    const enUrl = `${siteUrl}${enPath}`
    const lastmod = r.lastmod || staticLastmod

    // 日本語 (デフォルト言語)
    xml += '  <url>\n'
    xml += `    <loc>${escapeXml(jaUrl)}</loc>\n`
    xml += `    <xhtml:link rel="alternate" hreflang="ja" href="${escapeXml(jaUrl)}" />\n`
    xml += `    <xhtml:link rel="alternate" hreflang="en" href="${escapeXml(enUrl)}" />\n`
    xml += `    <lastmod>${escapeXml(lastmod)}</lastmod>\n`
    xml += `    <changefreq>${r.changefreq}</changefreq>\n`
    xml += `    <priority>${r.priority}</priority>\n`
    xml += '  </url>\n'

    // 英語 (i18n prefix)
    const enPriority = (parseFloat(r.priority) * 0.9).toFixed(1)
    xml += '  <url>\n'
    xml += `    <loc>${escapeXml(enUrl)}</loc>\n`
    xml += `    <xhtml:link rel="alternate" hreflang="ja" href="${escapeXml(jaUrl)}" />\n`
    xml += `    <xhtml:link rel="alternate" hreflang="en" href="${escapeXml(enUrl)}" />\n`
    xml += `    <lastmod>${escapeXml(lastmod)}</lastmod>\n`
    xml += `    <changefreq>${r.changefreq}</changefreq>\n`
    xml += `    <priority>${enPriority}</priority>\n`
    xml += '  </url>\n'
  }

  xml += '</urlset>'

  // 4. レスポンス設定
  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')
  setHeader(event, 'Cache-Control', 'public, max-age=3600, s-maxage=3600')

  return xml
})
