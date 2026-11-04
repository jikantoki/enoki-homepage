import { defineStore } from 'pinia'
import mockAppsData from '../data/apps.json'

/**
 * サポートされているプラットフォーム種別
 */
export const SUPPORTED_PLATFORMS = [
  'Windows',
  'Linux',
  'Mac OS',
  'Android',
  'iOS',
  'Web',
  'その他',
] as const

export type SupportedPlatform = (typeof SUPPORTED_PLATFORMS)[number]

/**
 * プラットフォーム一致判定ヘルパー関数
 * 表記ゆれ（大文字小文字、win/windows, mac/macos/osx, etc.）を柔軟に正規化して判定
 */
export function isPlatformMatch(
  platforms: string[] | undefined,
  targetPlatform: string,
): boolean {
  if (!platforms || !Array.isArray(platforms) || platforms.length === 0) {
    return targetPlatform === 'その他'
  }

  const normalized = platforms.map((p) => String(p).toLowerCase().trim())
  const target = targetPlatform.toLowerCase().trim()

  if (target === 'windows' || target === 'win') {
    return normalized.some((p) => p.includes('windows') || p.includes('win'))
  }
  if (target === 'linux') {
    return normalized.some((p) => p.includes('linux'))
  }
  if (
    target === 'mac os' ||
    target === 'macos' ||
    target === 'mac' ||
    target === 'osx'
  ) {
    return normalized.some(
      (p) =>
        p.includes('mac') ||
        p.includes('macos') ||
        p.includes('osx') ||
        p.includes('darwin'),
    )
  }
  if (target === 'android') {
    return normalized.some((p) => p.includes('android'))
  }
  if (target === 'ios' || target === 'iphone' || target === 'ipad') {
    return normalized.some(
      (p) => p.includes('ios') || p.includes('iphone') || p.includes('ipad'),
    )
  }
  if (target === 'web' || target === 'browser') {
    return normalized.some((p) => p.includes('web') || p.includes('browser'))
  }
  if (target === 'その他' || target === 'other') {
    return normalized.some(
      (p) =>
        ![
          'windows',
          'win',
          'linux',
          'mac',
          'macos',
          'osx',
          'darwin',
          'android',
          'ios',
          'iphone',
          'ipad',
          'web',
          'browser',
        ].some((known) => p.includes(known)),
    )
  }

  return normalized.some((p) => p.includes(target) || target.includes(p))
}

/**
 * アプリリンク情報
 */
export interface AppLink {
  /** ボタンに表示するテキスト */
  text: string
  /** ボタン表示用MDIアイコン */
  icon?: string
  /** 遷移先URL */
  url: string
}

/**
 * アプリ情報
 */
export interface AppInfo {
  /** アプリ名 */
  name: string
  /** アプリID（URLに使う） */
  id: string
  /** リリース日 (unixtime) */
  releaseDate: number
  /** アプリアイコンURL又はBase64 */
  icon: string
  /** サムネイルURL又はBase64 */
  thumbnail: string
  /** 紹介文（マークダウン対応） */
  description: string
  /** 価格 */
  price: number
  /** 対応プラットフォーム（複数選択） */
  platforms: string[]
  /** 使用言語（複数選択） */
  languages: string[]
  /** アプリリンク */
  links: AppLink[]
  /** Github URL */
  githubUrl?: string
  /** 紹介動画 Youtube URL */
  videoUrl?: string
  /** 紹介画像URL又はBase64 */
  images: string[]
  /** アプリかゲームか */
  type: string
  /** カテゴリ・ジャンル */
  category?: string
  /** レーティング (例: 4.8) */
  rating?: number
  /** ダウンロード数 (例: '500万+') */
  downloads?: string
  /** 開発者名 */
  developer?: string
  /** 概要 */
  summary?: string
  /** ピックアップ/注目 */
  featured?: boolean
}

/**
 * 楽曲リスト情報（アルバム用）
 */
export interface TrackInfo {
  /** 楽曲名 */
  name: string
  /** 楽曲シングルのURL */
  url: string
}

/**
 * その他URLリンク情報
 */
export interface OtherLink {
  /** ボタンに表示するテキスト */
  text: string
  /** ボタン表示用MDIアイコン */
  icon: string
  /** 遷移先URL */
  url: string
}

/**
 * 楽曲情報
 */
export interface MusicInfo {
  /** 楽曲名 */
  name: string
  /** 楽曲ID（URLに使う） */
  id: string
  /** 楽曲アイコンURL又はBase64 */
  icon: string
  /** オーディオファイル（mp3）URL */
  audioUrl: string
  /** リリース日 (unixtime) */
  releaseDate: number
  /** シングル？アルバム？ */
  albumType: string
  /** （アルバムの場合）楽曲リスト */
  tracks?: TrackInfo[]
  /** 作詞者（デフォルトでアカウント名が出てくる） */
  lyricist: string
  /** 作曲者（デフォルトでアカウント名が出てくる） */
  composer: string
  /** 紹介文（マークダウン対応） */
  description: string
  /** 価格 */
  price: number
  /** 歌詞（マークダウン対応） */
  lyrics?: string
  /** MV Youtube URL */
  mvUrl?: string
  /** その他URL */
  otherLinks: OtherLink[]
}

/**
 * アプリと楽曲の共通項目を持つ統合型
 * アプリとしても楽曲としても使えるフレキシブルな型
 */
export type AppOrMusicItem = Partial<AppInfo> & Partial<MusicInfo> & {
  /** アプリ名 or 楽曲名 */
  name: string
  /** アプリID or 楽曲ID（URLに使う） */
  id: string
  /** リリース日 (unixtime) */
  releaseDate: number
  /** アイコンURL又はBase64 */
  icon: string
  /** 紹介文（マークダウン対応） */
  description: string
  /** 価格 */
  price: number
}

export const useAppStore = defineStore('app', {
  state: () => ({
    /**
     * アプリと楽曲が混在するリスト
     * 初期値として100個のモックデータを取り込み
     */
    list: [...(mockAppsData as AppOrMusicItem[])] as AppOrMusicItem[],
  }),
  getters: {
    /** ゲーム一覧 */
    games: (state) => state.list.filter(item => item.type === 'game'),
    /** アプリ一覧 */
    regularApps: (state) => state.list.filter(item => item.type === 'app'),
    /** ピックアップ/注目一覧 */
    featuredApps: (state) => state.list.filter(item => item.featured),
    /** あなたへのおすすめ一覧 */
    recommendedApps: (state) => {
      const featured = state.list.filter(item => item.featured)
      const others = state.list.filter(item => !item.featured)
      return [...featured, ...others].slice(0, 12)
    },
    /** Webサービス一覧 */
    webServices: (state) => state.list.filter(item => isPlatformMatch(item.platforms, 'Web')),
    /** Androidアプリ一覧 */
    androidApps: (state) => state.list.filter(item => isPlatformMatch(item.platforms, 'Android')),
    /** プラットフォーム別フィルター関数 */
    byPlatform: (state) => (platform: string) => {
      return state.list.filter(item => isPlatformMatch(item.platforms, platform))
    },
    /** 各プラットフォームの登録件数マップ */
    platformCounts: (state) => {
      const counts: Record<string, number> = {}
      for (const p of SUPPORTED_PLATFORMS) {
        counts[p] = state.list.filter(item => isPlatformMatch(item.platforms, p)).length
      }
      return counts
    },
    /** カテゴリ別フィルター関数 */
    byCategory: (state) => (category: string) => {
      return state.list.filter(item => item.category === category)
    },
    /** 高評価ランキング一覧 */
    topRanked: (state) => [...state.list].sort((a, b) => ((b.rating || 0) - (a.rating || 0))),
    /** 新着順一覧 */
    newReleases: (state) => [...state.list].sort((a, b) => (b.releaseDate - a.releaseDate)),
    /** 人気急上昇（ダウンロード数順など） */
    popularApps: (state) => state.list.slice(0, 30),
    /** 登録されているカテゴリ一覧 */
    allCategories: (state) => {
      const cats = new Set<string>()
      state.list.forEach(item => {
        if (item.category) cats.add(item.category)
      })
      return Array.from(cats)
    },
  },
  actions: {
    /**
     * ランダムピックアップアプリを取得
     * @param count 取得件数 (デフォルト12)
     */
    getRandomPickups(count = 12): AppOrMusicItem[] {
      if (!this.list || this.list.length === 0) return []
      const shuffled = [...this.list].sort(() => Math.random() - 0.5)
      return shuffled.slice(0, count)
    },
    /**
     * モックデータを読み込み
     * 古い永続化データ（platformsにWindowsなどが含まれていない）の場合も自動更新
     */
    loadMockData(force = false) {
      const needsRefresh =
        !this.list ||
        this.list.length === 0 ||
        !this.list.some(item => (item.platforms || []).includes('Windows'))
      if (force || needsRefresh) {
        this.list = [...(mockAppsData as AppOrMusicItem[])]
      }
    },
    /**
     * リストにアイテムを追加
     * @param item - 追加するアプリまたは楽曲情報
     */
    addItem(item: AppOrMusicItem) {
      this.list.push(item)
    },
    /**
     * IDでアイテムを検索
     * @param id - 検索するアイテムのID
     * @returns 見つかったアイテム、見つからない場合はundefined
     */
    findById(id: string): AppOrMusicItem | undefined {
      return this.list.find(item => item.id === id)
    },
    /**
     * IDでアイテムを削除
     * @param id - 削除するアイテムのID
     */
    removeById(id: string) {
      const index = this.list.findIndex(item => item.id === id)
      if (index !== -1) {
        this.list.splice(index, 1)
      }
    },
    /**
     * リストをクリア
     */
    clearList() {
      this.list = []
    },
    /**
     * リスト全体を更新
     * @param newList - 新しいリスト
     */
    setList(newList: AppOrMusicItem[]) {
      this.list = newList
    },
  },
  persist: true,
})
