<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:html="http://www.w3.org/TR/REC-html40"
  xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html lang="ja">
      <head>
        <title>XML Sitemap | エノキ電気 公式ホームページ</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <style>
          * { box-sizing: border-box; margin: 0; padding: 0; }
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #0f172a;
            color: #e2e8f0;
            padding: 24px;
            line-height: 1.5;
          }
          .container {
            max-width: 1200px;
            margin: 0 auto;
          }
          .header {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border: 1px solid #334155;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
          }
          .header h1 {
            color: #38bdf8;
            font-size: 26px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
          }
          .header p {
            color: #94a3b8;
            font-size: 14px;
          }
          .badge {
            display: inline-block;
            background-color: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 9999px;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 12px;
          }
          .table-card {
            background-color: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
          }
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
          }
          th {
            background-color: #0f172a;
            color: #94a3b8;
            text-align: left;
            padding: 14px 16px;
            font-weight: 600;
            border-bottom: 1px solid #334155;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.05em;
          }
          td {
            padding: 12px 16px;
            border-bottom: 1px solid #334155;
            vertical-align: middle;
          }
          tr:hover td {
            background-color: rgba(255, 255, 255, 0.02);
          }
          a {
            color: #38bdf8;
            text-decoration: none;
            word-break: break-all;
          }
          a:hover {
            text-decoration: underline;
            color: #7dd3fc;
          }
          .priority-bar {
            display: flex;
            align-items: center;
            gap: 8px;
          }
          .priority-meter {
            width: 50px;
            height: 6px;
            background-color: #334155;
            border-radius: 3px;
            overflow: hidden;
          }
          .priority-fill {
            height: 100%;
            background-color: #e12378;
          }
          .text-muted {
            color: #64748b;
          }
          .footer {
            margin-top: 24px;
            text-align: center;
            font-size: 12px;
            color: #64748b;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>XML Sitemap</h1>
            <p>この XML サイトマップは、検索エンジン（Google, Bing 等）がウェブサイトの全 URL を自動検知・巡回するために動的生成されています。</p>
            <div class="badge">
              掲載 URL 数: <xsl:value-of select="count(sitemap:urlset/sitemap:url)"/> 件
            </div>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th style="width: 50px;">#</th>
                  <th>URL (所在地)</th>
                  <th style="width: 170px;">最終更新日 (Lastmod)</th>
                  <th style="width: 110px;">更新頻度</th>
                  <th style="width: 100px;">優先度</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="sitemap:urlset/sitemap:url">
                  <tr>
                    <td class="text-muted"><xsl:value-of select="position()"/></td>
                    <td>
                      <a href="{sitemap:loc}" target="_blank">
                        <xsl:value-of select="sitemap:loc"/>
                      </a>
                    </td>
                    <td class="text-muted">
                      <xsl:value-of select="sitemap:lastmod"/>
                    </td>
                    <td>
                      <xsl:value-of select="sitemap:changefreq"/>
                    </td>
                    <td>
                      <div class="priority-bar">
                        <span><xsl:value-of select="sitemap:priority"/></span>
                        <div class="priority-meter">
                          <div class="priority-fill" style="width: {sitemap:priority * 100}%;"></div>
                        </div>
                      </div>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>

          <div class="footer">
            エノキ電気 公式ホームページ (https://enoki.xyz) - Nuxt 4 &amp; Nitro Dynamic Sitemap Generator
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
