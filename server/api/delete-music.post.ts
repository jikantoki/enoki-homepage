import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)
    const musicId = body?.id || body?.musicId

    if (!musicId) {
      throw createError({
        statusCode: 400,
        statusMessage: '削除対象の楽曲IDが指定されていません。',
      })
    }

    const musicPaths = [
      path.resolve(process.cwd(), 'app/data/music.json'),
      path.resolve(process.cwd(), 'public/data/music.json'),
    ]

    for (const filePath of musicPaths) {
      try {
        const content = await fs.readFile(filePath, 'utf-8')
        const existingList: any[] = JSON.parse(content)
        const filtered = existingList.filter((item) => item.id !== musicId)
        await fs.writeFile(filePath, JSON.stringify(filtered, null, 2), 'utf-8')
      } catch (err) {
        console.warn(`Failed to update ${filePath}:`, err)
      }
    }

    return {
      status: 'ok',
      message: `楽曲 (ID: ${musicId}) を削除しました。`,
      id: musicId,
    }
  } catch (error: any) {
    console.error('Delete music error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || '楽曲削除中にエラーが発生しました。',
    })
  }
})
