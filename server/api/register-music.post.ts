import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)

    if (!body || !body.title || !body.id) {
      throw createError({
        statusCode: 400,
        statusMessage: '楽曲タイトルと楽曲IDは必須です。',
      })
    }

    const musicPaths = [
      path.resolve(process.cwd(), 'app/data/music.json'),
      path.resolve(process.cwd(), 'public/data/music.json'),
    ]

    for (const filePath of musicPaths) {
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
          existingList[existingIndex] = { ...existingList[existingIndex], ...body }
        } else {
          existingList.unshift(body)
        }

        await fs.writeFile(filePath, JSON.stringify(existingList, null, 2), 'utf-8')
      } catch (err) {
        console.warn(`Failed to update ${filePath}:`, err)
      }
    }

    return {
      status: 'ok',
      message: '楽曲を登録しました。',
      data: body,
    }
  } catch (error: any) {
    console.error('Register music error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || '楽曲登録中にエラーが発生しました。',
    })
  }
})
