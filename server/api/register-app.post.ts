import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)

    if (!body || !body.name || !body.id) {
      throw createError({
        statusCode: 400,
        statusMessage: 'アプリ名とアプリIDは必須です。',
      })
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
      message: 'アプリを登録しました。',
      data: body,
    }
  } catch (error: any) {
    console.error('Register app error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || 'アプリ登録中にエラーが発生しました。',
    })
  }
})
