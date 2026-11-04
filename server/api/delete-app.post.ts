import { promises as fs } from 'fs'
import path from 'path'
import { defineEventHandler, createError, readBody } from 'h3'

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event)
    const appId = body?.id || body?.appId

    if (!appId) {
      throw createError({
        statusCode: 400,
        statusMessage: '削除対象のアプリIDが指定されていません。',
      })
    }

    const appPaths = [
      path.resolve(process.cwd(), 'app/data/apps.json'),
      path.resolve(process.cwd(), 'public/data/apps.json'),
    ]

    for (const filePath of appPaths) {
      try {
        const content = await fs.readFile(filePath, 'utf-8')
        const existingList: any[] = JSON.parse(content)
        const filtered = existingList.filter((item) => item.id !== appId)
        await fs.writeFile(filePath, JSON.stringify(filtered, null, 2), 'utf-8')
      } catch (err) {
        console.warn(`Failed to update ${filePath}:`, err)
      }
    }

    return {
      status: 'ok',
      message: `アプリ (ID: ${appId}) を削除しました。`,
      id: appId,
    }
  } catch (error: any) {
    console.error('Delete app error:', error)
    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || 'アプリ削除中にエラーが発生しました。',
    })
  }
})
