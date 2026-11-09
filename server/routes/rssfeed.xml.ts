import { defineEventHandler, setHeader } from 'h3'
import {
  getSiteUrl,
  escapeXml,
  escapeCdata,
  cleanDescription,
  formatRfc822Date,
  fetchAppItems,
  fetchMusicItems,
  getDownloadItems,
  type FeedItem,
} from '../utils/siteData'

/**
 * RSS フィード XML を生成する共通ハンドラー
 */
export async function generateRssFeedXml(): Promise<string> {
  const siteUrl = getSiteUrl()

  const [apps, musics] = await Promise.all([
    fetchAppItems(),
    fetchMusicItems(),
  ])
  const downloads = getDownloadItems()

  const feedItems: FeedItem[] = []

  // 1. アプリを変換
  for (const app of apps) {
    if (!app || !app.id || !app.name) continue
    const dateVal = app.releaseDate ? new Date(app.releaseDate) : new Date(0)
    feedItems.push({
      id: `app-${app.id}`,
      title: `[アプリ] ${app.name}`,
      link: `${siteUrl}/apps/${encodeURIComponent(String(app.id))}`,
      description: cleanDescription(app.summary || app.description || `${app.name} の紹介`),
      pubDate: isNaN(dateVal.getTime()) ? new Date(0) : dateVal,
      category: `アプリ / ${app.category || 'ソフトウェア'}`,
      author: app.developer || 'ときえのき',
      guid: `${siteUrl}/apps/${encodeURIComponent(String(app.id))}`,
    })
  }

  // 2. 音楽を変換
  for (const m of musics) {
    if (!m || !m.id || (!m.title && !m.name)) continue
    const title = m.title || m.name
    const artist = m.artist || 'ときえのき'
    const dateVal = m.releaseDate ? new Date(m.releaseDate) : new Date(0)
    feedItems.push({
      id: `music-${m.id}`,
      title: `[音楽] ${title}${artist ? ` - ${artist}` : ''}`,
      link: `${siteUrl}/music/${encodeURIComponent(String(m.id))}`,
      description: cleanDescription(m.description || `${title} (${artist}) の楽曲情報`),
      pubDate: isNaN(dateVal.getTime()) ? new Date(0) : dateVal,
      category: `音楽 / ${m.genre || 'オリジナル曲'}`,
      author: artist,
      guid: `${siteUrl}/music/${encodeURIComponent(String(m.id))}`,
    })
  }

  // 3. ダウンロードコンテンツを変換
  // ダウンロードアイテムは releaseDate が無いため、基準日 (2026-11-01) から index に応じて少しずつずらして安定した順序にする
  const baseDownloadTime = new Date('2026-11-01T00:00:00+09:00').getTime()
  downloads.forEach((dl, index) => {
    if (!dl || !dl.id || !dl.title) return
    const fakeTime = baseDownloadTime - index * 86400000 // 1日刻み
    feedItems.push({
      id: `dl-${dl.id}`,
      title: `[配布] ${dl.title}${dl.subtitle ? ` (${dl.subtitle})` : ''}`,
      link: `${siteUrl}/download`,
      description: cleanDescription(dl.description || `${dl.title} の配布データ`),
      pubDate: new Date(fakeTime),
      category: `ダウンロード / ${dl.categoryLabel || dl.category || 'データ'}`,
      author: 'ときえのき',
      guid: `enoki-download-${dl.id}`,
    })
  })

  // 4. 日付の降順（新しい順）でソート
  feedItems.sort((a, b) => b.pubDate.getTime() - a.pubDate.getTime())

  // 最新 50 件に絞り込み
  const latestItems = feedItems.slice(0, 50)
  const lastBuildDate = formatRfc822Date(latestItems[0]?.pubDate || new Date())

  // 5. RSS 2.0 XML 組み立て
  let xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
  xml += '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\n'
  xml += '  <channel>\n'
  xml += `    <title>エノキ電気 公式ホームページ</title>\n`
  xml += `    <link>${escapeXml(siteUrl)}</link>\n`
  xml += `    <description>ときえのき（エノキ電気）が運営する公式ホームページ。自作アプリ・ゲーム・オリジナル楽曲・各種ダウンロードデータの最新情報をお届けします。</description>\n`
  xml += `    <language>ja</language>\n`
  xml += `    <lastBuildDate>${escapeXml(lastBuildDate)}</lastBuildDate>\n`
  xml += `    <generator>Nuxt 4 / Nitro</generator>\n`
  xml += `    <atom:link href="${escapeXml(siteUrl)}/rssfeed.xml" rel="self" type="application/rss+xml" />\n`

  for (const item of latestItems) {
    const isPermalink = item.guid.startsWith('http://') || item.guid.startsWith('https://')
    xml += '    <item>\n'
    xml += `      <title>${escapeXml(item.title)}</title>\n`
    xml += `      <link>${escapeXml(item.link)}</link>\n`
    xml += `      <guid isPermaLink="${isPermalink}">${escapeXml(item.guid)}</guid>\n`
    xml += `      <pubDate>${escapeXml(formatRfc822Date(item.pubDate))}</pubDate>\n`
    xml += `      <category>${escapeXml(item.category)}</category>\n`
    xml += `      <description><![CDATA[${escapeCdata(item.description)}]]></description>\n`
    if (item.author) {
      xml += `      <author>${escapeXml(item.author)}</author>\n`
    }
    xml += '    </item>\n'
  }

  xml += '  </channel>\n'
  xml += '</rss>'

  return xml
}

export default defineEventHandler(async (event) => {
  const xml = await generateRssFeedXml()

  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')
  setHeader(event, 'Cache-Control', 'public, max-age=1800, s-maxage=1800')

  return xml
})
