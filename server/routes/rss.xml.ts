import { defineEventHandler, setHeader } from 'h3'
import { generateRssFeedXml } from './rssfeed.xml'

export default defineEventHandler(async (event) => {
  const xml = await generateRssFeedXml()
  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')
  setHeader(event, 'Cache-Control', 'public, max-age=1800, s-maxage=1800')
  return xml
})
