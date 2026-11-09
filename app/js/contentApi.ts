/**
 * ### contentApi
 * アプリ (app_list) / 音楽 (music_list) を PHP 経由で MySQL とやり取りするヘルパー
 *
 * - 送信先は `NUXT_API_HOST` + `/xxx.php`（未設定時は同一オリジンの `/php/xxx.php`）
 * - API認証ヘッダー (apiid / apitoken / apipassword) を自動付与
 * - 書き込み系はログイン中ユーザーの id / token も付与（PHP側で管理者判定）
 * - PHP から `status: 'ok'` 以外が返った場合は Error を throw する
 */
import { useRuntimeConfig } from '#imports'
import { useMyProfileStore } from '@/stores/myProfile'

export interface ContentApiResponse<T = any> {
  status: string
  reason?: string
  message?: string
  data?: T
  [key: string]: any
}

interface RequestOptions {
  method?: 'GET' | 'POST'
  /** JSON で送るボディ（FormData の場合はそのまま送信） */
  body?: any
  /** ログインユーザーの id / token を付与するか */
  withAccount?: boolean
}

/** PHP エンドポイントのフルURLを組み立てる */
export function contentApiUrl(path: string) {
  const config = useRuntimeConfig()
  const host = String(config.public.apiHost || '').replace(/\/+$/, '')
  const base = host || '/php'
  return `${base}${path.startsWith('/') ? path : `/${path}`}`
}

function buildHeaders(withAccount: boolean, isJson: boolean) {
  const config = useRuntimeConfig()
  const headers: Record<string, string> = {
    apiid: String(config.public.apiId || ''),
    apitoken: String(config.public.apiToken || ''),
    apipassword: String(config.public.apiAccesskey || ''),
  }
  if (isJson) headers['Content-Type'] = 'application/json'
  if (withAccount) {
    const myProfile = useMyProfileStore()
    if (myProfile.userId) headers['id'] = String(myProfile.userId)
    if (myProfile.userToken) headers['token'] = String(myProfile.userToken)
  }
  return headers
}

/**
 * PHP API を呼び出し、JSONを返す（失敗時は throw）
 */
export async function requestContentApi<T = any>(
  path: string,
  options: RequestOptions = {},
): Promise<ContentApiResponse<T>> {
  const method = options.method || (options.body ? 'POST' : 'GET')
  const isFormData =
    typeof FormData !== 'undefined' && options.body instanceof FormData
  const res = await fetch(contentApiUrl(path), {
    method,
    headers: buildHeaders(!!options.withAccount, !!options.body && !isFormData),
    body: options.body
      ? isFormData
        ? options.body
        : JSON.stringify(options.body)
      : undefined,
  })

  const text = await res.text()
  let json: ContentApiResponse<T>
  try {
    json = JSON.parse(text)
  } catch {
    throw new Error(
      `サーバーから不正な応答が返されました (HTTP ${res.status}): ${text.slice(0, 200)}`,
    )
  }
  if (!res.ok || json.status !== 'ok') {
    throw new Error(
      json.reason || json.message || `APIエラー (HTTP ${res.status}, status: ${json.status})`,
    )
  }
  return json
}

// ==================== アプリ ====================

/** app_list の全件取得 */
export async function fetchAppList<T = any>(): Promise<T[]> {
  const res = await requestContentApi<T[]>('/getApps.php', { method: 'GET' })
  return Array.isArray(res.data) ? res.data : []
}

/** app_list へ登録・更新（同一IDなら更新） */
export function saveAppToDB(item: Record<string, any>) {
  return requestContentApi('/registerApp.php', {
    body: item,
    withAccount: true,
  })
}

/** app_list から削除 */
export function deleteAppFromDB(id: string) {
  return requestContentApi('/deleteApp.php', {
    body: { id, appId: id },
    withAccount: true,
  })
}

// ==================== 音楽 ====================

/** music_list の全件取得 */
export async function fetchMusicList<T = any>(): Promise<T[]> {
  const res = await requestContentApi<T[]>('/getMusic.php', { method: 'GET' })
  return Array.isArray(res.data) ? res.data : []
}

/** music_list へ登録・更新（同一IDなら更新） */
export function saveMusicToDB(item: Record<string, any>) {
  return requestContentApi('/registerMusic.php', {
    body: item,
    withAccount: true,
  })
}

/** music_list から削除 */
export function deleteMusicFromDB(id: string) {
  return requestContentApi('/deleteMusic.php', {
    body: { id, musicId: id },
    withAccount: true,
  })
}

/** 音声ファイルを PHP サーバーへアップロード */
export function uploadAudioToPHP(formData: FormData) {
  return requestContentApi<{
    url: string
    filename?: string
    metadata?: {
      title?: string
      artist?: string
      album?: string
      genre?: string
      coverUrl?: string
    }
  }>('/uploadAudio.php', {
    method: 'POST',
    body: formData,
    withAccount: true,
  })
}

/** 画像ファイルを PHP サーバーへアップロード */
export function uploadImageToPHP(formData: FormData) {
  return requestContentApi<{ url: string }>('/uploadImage.php', {
    method: 'POST',
    body: formData,
    withAccount: true,
  })
}

// ==================== 認証・アカウント ====================

/**
 * 管理者/ユーザーのログアウト処理
 * - PHP バックエンド (logoutAccount.php) へリクエストして DB 上のアクセストークンを削除
 * - 完了後に Pinia の myProfile ストアをリセット
 */
export async function logoutAccountFromPHP(): Promise<void> {
  const myProfile = useMyProfileStore()
  const userId = myProfile.userId
  const userToken = myProfile.userToken

  if (userId && userToken) {
    try {
      await requestContentApi('/logoutAccount.php', {
        method: 'POST',
        body: { id: userId, token: userToken },
        withAccount: true,
      })
    } catch (e) {
      console.warn(
        'PHP ログアウト API 呼び出し中にエラーが発生しましたが、クライアントセッションをリセットします:',
        e,
      )
    }
  }

  // クライアント側ストアを初期化
  myProfile.reset()
}
