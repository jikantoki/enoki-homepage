/**
 * IndexedDB 永続化ストレージユーティリティ
 * アプリ一覧や楽曲一覧などのオフラインキャッシュ・永続保管をサポートします。
 */

const DB_NAME = 'enoki_homepage_cache'
const DB_VERSION = 1
const STORE_NAME = 'keyval'

export const IDB_KEY_APPS = 'enoki_apps_list'
export const IDB_KEY_MUSIC = 'enoki_music_list'

let dbPromise: Promise<IDBDatabase> | null = null

/**
 * IndexedDB データベースインスタンスを取得（シングルトン接続）
 */
function getDB(): Promise<IDBDatabase> {
  if (typeof window === 'undefined' || !window.indexedDB) {
    return Promise.reject(new Error('IndexedDB is not available in this environment'))
  }

  if (!dbPromise) {
    dbPromise = new Promise((resolve, reject) => {
      const request = window.indexedDB.open(DB_NAME, DB_VERSION)

      request.onupgradeneeded = () => {
        const db = request.result
        if (!db.objectStoreNames.contains(STORE_NAME)) {
          db.createObjectStore(STORE_NAME)
        }
      }

      request.onsuccess = () => {
        const db = request.result
        db.onversionchange = () => {
          db.close()
          dbPromise = null
        }
        resolve(db)
      }

      request.onerror = () => {
        dbPromise = null
        reject(request.error || new Error('Failed to open IndexedDB'))
      }

      request.onblocked = () => {
        console.warn('[IndexedDB] Database upgrade blocked: please close other tabs.')
      }
    })
  }

  return dbPromise
}

/**
 * IndexedDB から値を取得
 * @param key ストレージキー
 * @returns 格納されたデータ、存在しない場合は null
 */
export async function idbGet<T>(key: string): Promise<T | null> {
  if (typeof window === 'undefined' || !window.indexedDB) return null
  try {
    const db = await getDB()
    return await new Promise<T | null>((resolve, reject) => {
      const tx = db.transaction(STORE_NAME, 'readonly')
      const store = tx.objectStore(STORE_NAME)
      const req = store.get(key)
      req.onsuccess = () => {
        resolve(req.result !== undefined ? (req.result as T) : null)
      }
      req.onerror = () => {
        reject(req.error)
      }
    })
  } catch (err) {
    console.warn(`[IndexedDB] idbGet failed for key "${key}":`, err)
    return null
  }
}

/**
 * IndexedDB に値を保存（既存の場合は上書き）
 * @param key ストレージキー
 * @param value 保存するデータ
 * @returns 成功した場合は true
 */
export async function idbSet<T>(key: string, value: T): Promise<boolean> {
  if (typeof window === 'undefined' || !window.indexedDB) return false
  try {
    const db = await getDB()
    return await new Promise<boolean>((resolve, reject) => {
      const tx = db.transaction(STORE_NAME, 'readwrite')
      const store = tx.objectStore(STORE_NAME)
      store.put(value, key)
      tx.oncomplete = () => {
        resolve(true)
      }
      tx.onerror = () => {
        reject(tx.error)
      }
      tx.onabort = () => {
        reject(tx.error || new Error('Transaction aborted'))
      }
    })
  } catch (err) {
    console.warn(`[IndexedDB] idbSet failed for key "${key}":`, err)
    return false
  }
}

/**
 * IndexedDB から特定のキーを削除
 * @param key ストレージキー
 */
export async function idbDelete(key: string): Promise<boolean> {
  if (typeof window === 'undefined' || !window.indexedDB) return false
  try {
    const db = await getDB()
    return await new Promise<boolean>((resolve, reject) => {
      const tx = db.transaction(STORE_NAME, 'readwrite')
      const store = tx.objectStore(STORE_NAME)
      store.delete(key)
      tx.oncomplete = () => {
        resolve(true)
      }
      tx.onerror = () => {
        reject(tx.error)
      }
    })
  } catch (err) {
    console.warn(`[IndexedDB] idbDelete failed for key "${key}":`, err)
    return false
  }
}

/**
 * IndexedDB の全キャッシュをクリア
 */
export async function idbClear(): Promise<boolean> {
  if (typeof window === 'undefined' || !window.indexedDB) return false
  try {
    const db = await getDB()
    return await new Promise<boolean>((resolve, reject) => {
      const tx = db.transaction(STORE_NAME, 'readwrite')
      const store = tx.objectStore(STORE_NAME)
      store.clear()
      tx.oncomplete = () => {
        resolve(true)
      }
      tx.onerror = () => {
        reject(tx.error)
      }
    })
  } catch (err) {
    console.warn('[IndexedDB] idbClear failed:', err)
    return false
  }
}
