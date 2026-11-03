import { defineStore } from 'pinia'
import mockAppsData from '../data/apps.json'

/**
 * アプリリンク情報
 */
export interface AppLink {
  /** ボタンに表示するテキスト */
  text: string
  /** ボタン表示用MDIアイコン */
  icon: string
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
     * モックデータを強制再読み込み
     */
    loadMockData(force = false) {
      if (force || !this.list || this.list.length === 0) {
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
