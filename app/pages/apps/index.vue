<template lang="pug">
v-card.playstore-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- バックグラウンド再検証プログレスバー
  v-progress-linear(
    v-if="appStore.dbLoading && !isInitialLoading"
    indeterminate
    color="primary"
    height="2"
    style="position: absolute; top: 0; left: 0; right: 0; z-index: 99;"
  )
  //- ================= トップ検索バーヘッダー =================
  .store-top-bar
    .search-pill
      v-icon.search-icon mdi-magnify
      input.search-input(
        v-model="searchQuery"
        placeholder="アプリやゲームを検索"
      )
      v-btn(
        v-if="searchQuery"
        icon="mdi-close"
        size="x-small"
        variant="text"
        @click="searchQuery = ''"
      )
      //- 右端のアカウントアバター
      .account-avatar(
        v-ripple
        @click="navStore.openOptions()"
      )
        img(
          :src="myProfile && myProfile.icon ? myProfile.icon : '/icon.png'"
          alt="Avatar"
          onerror="this.src='/icon.png'"
        )

  //- ================= ヒーロー自己紹介エリア =================
  HeroProfile(v-if="!isInitialLoading")

  //- ================= サブナビバー（おすすめ / カテゴリ / プラットフォーム） =================
  .store-sub-nav(v-if="!searchQuery && !isInitialLoading")
    v-tabs(
      v-model="activeTab"
      color="primary"
      density="compact"
      align-tabs="center"
      show-arrows
    )
      v-tab(value="foryou") おすすめ
      v-tab(value="categories") カテゴリ
      v-tab(value="platforms") プラットフォーム

  //- ================= メインスクロールエリア =================
  .store-scroll-content(ref="scrollContainer")

    //- ---------------- 0. 初回データ取得中画面 ----------------
    .store-initial-loading(v-if="isInitialLoading")
      v-progress-circular(
        indeterminate
        color="primary"
        size="56"
        width="4"
      )
      .loading-text-wrap
        .loading-title ソフトウェア一覧を取得中...
        .loading-subtitle 最新のアプリ・ゲーム・ツール情報を読み込んでいます

    //- ---------------- 1. 検索結果表示モード ----------------
    .search-results-view(v-else-if="searchQuery")
      .search-header
        .search-title 「{{ searchQuery }}」の検索結果 ({{ searchResults.length }}件)
        .filter-chips
          v-chip(
            :color="searchFilter === 'all' ? 'primary' : undefined"
            :variant="searchFilter === 'all' ? 'flat' : 'outlined'"
            size="small"
            @click="searchFilter = 'all'"
          ) すべて
          v-chip(
            :color="searchFilter === 'game' ? 'primary' : undefined"
            :variant="searchFilter === 'game' ? 'flat' : 'outlined'"
            size="small"
            @click="searchFilter = 'game'"
          ) ゲーム
          v-chip(
            :color="searchFilter === 'app' ? 'primary' : undefined"
            :variant="searchFilter === 'app' ? 'flat' : 'outlined'"
            size="small"
            @click="searchFilter = 'app'"
          ) アプリ
          v-chip(
            :color="searchFilter === 'free' ? 'primary' : undefined"
            :variant="searchFilter === 'free' ? 'flat' : 'outlined'"
            size="small"
            @click="searchFilter = 'free'"
          ) 無料のみ

      .results-list(v-if="searchResults.length > 0")
        AppRankItem(
          v-for="(item, idx) in searchResults"
          :key="item.id"
          :item="item"
          :rank="idx + 1"
          @click="openDetail(item)"
        )
      .no-results(v-else)
        v-icon(size="48" color="grey") mdi-magnify-remove-outline
        p 一致するアプリやゲームが見つかりませんでした

    //- ---------------- 2. メインタブ（おすすめ / カテゴリ / プラットフォーム） ----------------
    template(v-else)
      //- おすすめタブ (stores/app.ts準拠)
      .tab-content(v-if="activeTab === 'foryou'")
        HeroBanner(
          :items="featuredApps"
          @click="openDetail"
        )

        AppShelf(
          title="あなたへのおすすめ"
          subtitle="利用傾向に基づいてピックアップ"
        )
          AppCard(
            v-for="item in recommendedApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="ランダムピックアップ"
          subtitle="気まぐれに出会う新しいソフトウェア"
        )
          AppCard(
            v-for="item in randomPickupApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="Webサービス"
          subtitle="ブラウザから手軽に使えるWebアプリケーション"
        )
          AppCard(
            v-for="item in webServiceApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="Androidアプリ"
          subtitle="スマートフォンでいつでも手軽に利用可能"
        )
          AppCard(
            v-for="item in androidApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

      //- カテゴリ一覧タブ (stores/app.ts準拠)
      .tab-content(v-else-if="activeTab === 'categories'")
        .categories-view
          .category-select-row(v-if="selectedCategory")
            .category-select-header
              v-btn(
                prepend-icon="mdi-arrow-left"
                variant="tonal"
                size="small"
                rounded="pill"
                @click="selectedCategory = null"
              ) カテゴリ一覧に戻る
              span.category-heading {{ selectedCategory }} ({{ categoryApps.length }}件)

            .category-apps-grid
              AppCard(
                v-for="item in categoryApps"
                :key="item.id"
                :item="item"
                @click="openDetail(item)"
              )

          .category-grid(v-else)
            .category-card(
              v-for="cat in allCategoriesWithMeta"
              :key="cat.name"
              v-ripple
              @click="selectedCategory = cat.name"
            )
              v-icon(:color="cat.color" size="28") {{ cat.icon }}
              .cat-name {{ cat.name }}
              .cat-count {{ cat.count }}個のアプリ

      //- プラットフォームタブ (stores/app.ts準拠)
      .tab-content(v-else-if="activeTab === 'platforms'")
        .platform-view
          .platform-buttons-wrap
            v-btn.platform-btn(
              v-for="plat in platformList"
              :key="plat.id"
              :variant="selectedPlatform === plat.id ? 'flat' : 'tonal'"
              :color="selectedPlatform === plat.id ? 'primary' : undefined"
              rounded="pill"
              size="small"
              :prepend-icon="plat.icon"
              @click="selectedPlatform = plat.id"
            )
              | {{ plat.name }}
              span.plat-count ({{ getPlatformCount(plat.id) }})

          .platform-content
            .platform-header
              .platform-title
                v-icon(start :color="currentPlatformMeta.color") {{ currentPlatformMeta.icon }}
                span {{ currentPlatformMeta.name }} 対応ソフトウェア
              span.platform-count-badge {{ currentPlatformApps.length }}件

            .platform-apps-grid(v-if="currentPlatformApps.length > 0")
              AppCard(
                v-for="item in currentPlatformApps"
                :key="item.id"
                :item="item"
                @click="openDetail(item)"
              )
            .no-platform-results(v-else)
              v-icon(size="48" color="grey") mdi-application-outline
              p このプラットフォームに対応するソフトウェアは現在登録されていません

    //- 下部ナビゲーションバー用の余白
    .bottom-nav-spacer

  //- 管理者用 コンテンツ管理FABボタン
  v-btn.admin-manage-fab(
    v-if="isAdmin"
    color="surface"
    icon="mdi-format-list-checks"
    size="large"
    elevation="4"
    @click="$router.push('/admin/manage?tab=apps')"
  )
    v-icon(size="24" color="primary") mdi-format-list-checks
    v-tooltip(activator="parent" location="left") アプリ管理・編集・削除

  //- 管理者用 アプリ登録FABボタン
  v-btn.admin-register-fab(
    v-if="isAdmin"
    color="primary"
    icon="mdi-plus"
    size="large"
    elevation="4"
    @click="adminRegisterModalOpen = true"
  )
    v-icon(size="28") mdi-plus
    v-tooltip(activator="parent" location="left") アプリを登録 (管理者)

  //- 管理者コンテンツ登録モーダル
  AdminRegisterModal(
    v-model="adminRegisterModalOpen"
    initialTab="app"
  )

</template>

<script lang="ts">
import { App } from '@capacitor/app'
import { Toast } from '@capacitor/toast'
import mixins from '@/mixins/mixins'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import {
  useAppStore,
  isPlatformMatch,
  type AppOrMusicItem,
} from '@/stores/app'
import Setup from '@/js/setup'
import HeroProfile from '@/components/common/HeroProfile.vue'
import { useNavigationStore } from '@/stores/navigation'
import AppCard from '@/components/store/AppCard.vue'
import AppRankItem from '@/components/store/AppRankItem.vue'
import AppShelf from '@/components/store/AppShelf.vue'
import HeroBanner from '@/components/store/HeroBanner.vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'

export default {
  name: 'AppsPage',
  components: {
    HeroProfile,
    AppCard,
    AppRankItem,
    AppShelf,
    HeroBanner,
    AdminRegisterModal,
  },
  mixins: [mixins],
  data() {
    const appStore = useAppStore()
    return {
      isInitialLoading: !appStore.list || appStore.list.length === 0,
      navStore: useNavigationStore(),
      adminRegisterModalOpen: false,
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
      appStore: useAppStore(),
      searchQuery: '',
      searchFilter: 'all' as 'all' | 'game' | 'app' | 'free',
      activeTab: 'foryou',
      selectedCategory: null as string | null,
      selectedPlatform: 'Windows',
      displayFeaturedApps: [] as AppOrMusicItem[],
      displayRecommendedApps: [] as AppOrMusicItem[],
      displayRandomPickups: [] as AppOrMusicItem[],
      displayWebApps: [] as AppOrMusicItem[],
      displayAndroidApps: [] as AppOrMusicItem[],
      platformList: [
        {
          id: 'Windows',
          name: 'Windows',
          icon: 'mdi-microsoft-windows',
          color: '#0078d4',
        },
        { id: 'Linux', name: 'Linux', icon: 'mdi-linux', color: '#f59e0b' },
        { id: 'Mac OS', name: 'Mac OS', icon: 'mdi-apple', color: '#64748b' },
        {
          id: 'Android',
          name: 'Android',
          icon: 'mdi-android',
          color: '#3ddc84',
        },
        { id: 'iOS', name: 'iOS', icon: 'mdi-apple', color: '#000000' },
        { id: 'Web', name: 'Web', icon: 'mdi-web', color: '#3b82f6' },
        {
          id: 'その他',
          name: 'その他',
          icon: 'mdi-dots-horizontal-circle-outline',
          color: '#8b5cf6',
        },
      ],
    }
  },
  computed: {
    isAdmin(): boolean {
      return Boolean(
        this.myProfile.isAdmin ||
        this.myProfile.role === 'admin' ||
        (!this.myProfile.guest && this.myProfile.canRegisterApp)
      )
    },
    allApps(): AppOrMusicItem[] {
      return this.appStore.list
    },
    featuredApps(): AppOrMusicItem[] {
      if (this.displayFeaturedApps.length > 0) return this.displayFeaturedApps
      return this.appStore.featuredApps.slice(0, 6)
    },
    recommendedApps(): AppOrMusicItem[] {
      if (this.displayRecommendedApps.length > 0) return this.displayRecommendedApps
      return this.appStore.recommendedApps.slice(0, 25)
    },
    randomPickupApps(): AppOrMusicItem[] {
      if (this.displayRandomPickups.length > 0) return this.displayRandomPickups
      return this.appStore.getRandomPickups(25)
    },
    webServiceApps(): AppOrMusicItem[] {
      if (this.displayWebApps.length > 0) return this.displayWebApps
      return this.appStore.webServices.slice(0, 25)
    },
    androidApps(): AppOrMusicItem[] {
      if (this.displayAndroidApps.length > 0) return this.displayAndroidApps
      return this.appStore.androidApps.slice(0, 25)
    },
    currentPlatformApps(): AppOrMusicItem[] {
      return this.appStore.byPlatform(this.selectedPlatform)
    },
    currentPlatformMeta() {
      return (
        this.platformList.find((p) => p.id === this.selectedPlatform) ||
        this.platformList[0]
      )
    },
    searchResults(): AppOrMusicItem[] {
      const q = this.searchQuery.trim().toLowerCase()
      if (!q) return []
      let filtered = this.allApps.filter((item) => {
        const nameMatch = item.name.toLowerCase().includes(q)
        const catMatch = (item.category || '').toLowerCase().includes(q)
        const descMatch = (item.description || '').toLowerCase().includes(q)
        return nameMatch || catMatch || descMatch
      })

      if (this.searchFilter === 'game') {
        filtered = filtered.filter((item) => item.type === 'game')
      } else if (this.searchFilter === 'app') {
        filtered = filtered.filter((item) => item.type === 'app')
      } else if (this.searchFilter === 'free') {
        filtered = filtered.filter((item) => !item.price || item.price === 0)
      }
      return filtered
    },
    categoryApps(): AppOrMusicItem[] {
      if (!this.selectedCategory) return []
      return this.appStore.byCategory(this.selectedCategory)
    },
    allCategoriesWithMeta(): Array<{
      name: string
      count: number
      icon: string
      color: string
    }> {
      const predefinedCategories: Array<{ name: string; icon: string; color: string }> = [
        { name: 'ゲーム', icon: 'mdi-gamepad-variant', color: '#6366f1' },
        { name: 'メディア', icon: 'mdi-play-circle-outline', color: '#ec4899' },
        { name: 'ポータルサイト', icon: 'mdi-compass-outline', color: '#3b82f6' },
        { name: '便利ツール', icon: 'mdi-tools', color: '#06b6d4' },
        { name: 'ソーシャル', icon: 'mdi-account-group', color: '#10b981' },
        { name: 'Mod・拡張機能', icon: 'mdi-puzzle-outline', color: '#f59e0b' },
        { name: '開発', icon: 'mdi-code-tags', color: '#8b5cf6' },
        { name: 'その他', icon: 'mdi-dots-horizontal-circle-outline', color: '#64748b' },
      ]

      const iconMap: Record<string, { icon: string; color: string }> = {}
      for (const cat of predefinedCategories) {
        iconMap[cat.name] = { icon: cat.icon, color: cat.color }
      }

      const countMap = new Map<string, number>()
      this.allApps.forEach((item) => {
        if (item.category) {
          countMap.set(item.category, (countMap.get(item.category) || 0) + 1)
        }
      })

      // 新カテゴリの定義順を維持してリストを作成
      const result: Array<{ name: string; count: number; icon: string; color: string }> = []
      const processed = new Set<string>()

      for (const cat of predefinedCategories) {
        const count = countMap.get(cat.name) || 0
        result.push({
          name: cat.name,
          count,
          icon: cat.icon,
          color: cat.color,
        })
        processed.add(cat.name)
      }

      // 未定義のカテゴリがもしあれば末尾に追加
      countMap.forEach((count, name) => {
        if (!processed.has(name)) {
          const meta = iconMap[name] || { icon: 'mdi-shape', color: '#64748b' }
          result.push({
            name,
            count,
            icon: meta.icon,
            color: meta.color,
          })
        }
      })

      return result
    },
  },
  watch: {
    allApps: {
      immediate: true,
      handler(newList) {
        if (newList && newList.length > 0 && this.displayRecommendedApps.length === 0) {
          this.initRandomSections()
        }
      },
    },
  },
  setup() {
    Setup.setTitle('ソフトウェア')
    Setup.setDescription(
      'エノキ電気の公式ソフトウェア・ゲーム・ツール一覧プラットフォーム。',
    )
  },
  async mounted() {
    this.setTitle('ソフトウェア')

    // 1. IndexedDB からキャッシュ済みデータを読み込み
    let hasCache = Boolean(this.appStore.list && this.appStore.list.length > 0)
    if (!hasCache) {
      const cached = await this.appStore.loadFromCache()
      if (cached && cached.length > 0) {
        hasCache = true
      }
    }

    if (hasCache) {
      // 【二回目以降（キャッシュあり）】
      // 一旦 IndexedDB の中身を表示
      this.isInitialLoading = false
      this.initRandomSections()

      // バックグラウンドで最新データを取得し、完了したら新しいデータに置き換える
      this.appStore.fetchFromDatabase().then(() => {
        this.initRandomSections()
      })
    } else {
      // 【初回読み込み時（キャッシュなし）】
      // アプリ一覧の取得が完了するまで取得中の画面を表示
      this.isInitialLoading = true
      try {
        await this.appStore.fetchFromDatabase()
        this.initRandomSections()
      } finally {
        this.isInitialLoading = false
      }
    }

    /** バックボタンのリスナーを追加 */
    App.addListener('backButton', () => {
      if (this.navStore.optionsDialog) {
        this.navStore.closeOptions()
      } else if (this.selectedCategory) {
        this.selectedCategory = null
      } else if (this.searchQuery) {
        this.searchQuery = ''
      } else if (this.activeTab !== 'foryou') {
        this.activeTab = 'foryou'
      } else if (this.$route.path === '/') {
        App.minimizeApp()
        Toast.show({ text: 'アプリはバックグラウンドで実行されます' })
      } else {
        this.$router.back()
      }
    })
  },
  unmounted() {
    App.removeAllListeners()
  },
  methods: {
    openDetail(item: AppOrMusicItem) {
      this.$router.push(`/apps/${item.id}`)
    },
    shuffle<T>(array: T[]): T[] {
      const result = [...array]
      for (let i = result.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [result[i], result[j]] = [result[j], result[i]]
      }
      return result
    },
    initRandomSections() {
      if (!this.allApps || this.allApps.length === 0) return

      // 注目アプリ (最大6個)
      const featured = this.appStore.featuredApps
      const featuredSource = featured.length > 0 ? featured : this.allApps
      this.displayFeaturedApps = this.shuffle(featuredSource).slice(0, 6)

      // あなたへのおすすめ (最大25個: 注目アプリ優先＋その他からランダム抽出)
      const featuredList = this.allApps.filter((item) => item.featured)
      const otherList = this.allApps.filter((item) => !item.featured)
      this.displayRecommendedApps = [
        ...this.shuffle(featuredList),
        ...this.shuffle(otherList),
      ].slice(0, 25)

      // ランダムピックアップ (最大25個)
      this.displayRandomPickups = this.shuffle(this.allApps).slice(0, 25)

      // Webサービス (最大25個)
      const web = this.appStore.webServices
      this.displayWebApps = this.shuffle(web).slice(0, 25)

      // Androidアプリ (最大25個)
      const android = this.appStore.androidApps
      this.displayAndroidApps = this.shuffle(android).slice(0, 25)
    },
    getPlatformCount(platId: string): number {
      return this.appStore.platformCounts[platId] || 0
    },
    matchesPlatform(item: AppOrMusicItem, platformId: string): boolean {
      return isPlatformMatch(item.platforms, platformId)
    },
  },
}
</script>

<style lang="scss" scoped>
.playstore-root {
  .store-initial-loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 400px;
    height: 60vh;
    gap: 20px;
    text-align: center;
    padding: 32px 16px;

    .loading-text-wrap {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .loading-title {
      font-size: 1.15rem;
      font-weight: 700;
      color: rgb(var(--v-theme-on-surface));
    }

    .loading-subtitle {
      font-size: 0.88rem;
      color: rgba(var(--v-theme-on-surface), 0.6);
    }
  }
  display: flex;
  flex-direction: column;
  overflow: hidden;
  height: 100%;
  height: 100dvh;
  position: relative;
  background-color: rgb(var(--v-theme-surface));

  // ---------------- トップ検索バー ----------------
  .store-top-bar {
    padding: 10px 16px 8px 16px;
    display: flex;
    align-items: center;
    background-color: rgb(var(--v-theme-surface));
    z-index: 10;
    flex-shrink: 0;

    .search-pill {
      flex: 1;
      height: 48px;
      background-color: rgba(var(--v-theme-on-surface), 0.07);
      border-radius: 9999px;
      display: flex;
      align-items: center;
      padding: 0 8px 0 16px;
      gap: 10px;
      transition: all 0.2s cubic-bezier(0.2, 0, 0, 1);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

      &:focus-within {
        background-color: rgba(var(--v-theme-on-surface), 0.1);
        border-color: rgb(var(--v-theme-primary));
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.12);
      }

      .search-icon {
        color: rgba(var(--v-theme-on-surface), 0.6);
        font-size: 20px;
      }

      .search-input {
        flex: 1;
        border: none;
        outline: none;
        background: transparent;
        font-size: 14.5px;
        color: rgb(var(--v-theme-on-surface));

        &::placeholder {
          color: rgba(var(--v-theme-on-surface), 0.5);
        }
      }

      .account-avatar {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        overflow: hidden;
        cursor: pointer;
        flex-shrink: 0;
        margin-left: 4px;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }
    }
  }

  // ---------------- サブナビ（おすすめ / カテゴリ / プラットフォーム） ----------------
  .store-sub-nav {
    background-color: rgb(var(--v-theme-surface));
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.06);
    flex-shrink: 0;
    z-index: 9;
  }

  // ---------------- スクロールコンテンツ ----------------
  .store-scroll-content {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    -webkit-overflow-scrolling: touch;
    padding-bottom: 24px;
  }

  .tab-content {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  // ---------------- 検索結果画面 ----------------
  .search-results-view {
    padding: 16px;

    .search-header {
      margin-bottom: 16px;

      .search-title {
        font-size: 1.05rem;
        font-weight: 700;
        margin-bottom: 10px;
      }

      .filter-chips {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 4px;
      }
    }

    .results-list {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .no-results {
      padding: 60px 20px;
      text-align: center;
      color: rgba(var(--v-theme-on-surface), 0.5);

      p {
        margin-top: 12px;
        font-size: 14px;
      }
    }
  }

  // ---------------- カテゴリ画面 ----------------
  .categories-view {
    padding: 12px 16px;

    .category-select-row {
      display: flex;
      flex-direction: column;
      gap: 16px;

      .category-select-header {
        display: flex;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;

        .category-heading {
          font-size: 1.15rem;
          font-weight: 800;
        }
      }

      .category-apps-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
        gap: 12px;
      }
    }

    .category-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
      gap: 12px;

      .category-card {
        padding: 18px 14px;
        background-color: rgba(var(--v-theme-on-surface), 0.04);
        border-radius: 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        cursor: pointer;
        transition: transform 0.15s, background-color 0.15s;
        border: 1px solid rgba(var(--v-theme-on-surface), 0.05);

        &:hover {
          background-color: rgba(var(--v-theme-on-surface), 0.08);
          transform: translateY(-2px);
        }

        .cat-name {
          font-weight: 700;
          font-size: 13px;
          margin-top: 8px;
        }

        .cat-count {
          font-size: 11px;
          color: rgba(var(--v-theme-on-surface), 0.55);
          margin-top: 2px;
        }
      }
    }
  }

  // ---------------- プラットフォーム画面 ----------------
  .platform-view {
    padding: 12px 16px;
    display: flex;
    flex-direction: column;
    gap: 16px;

    .platform-buttons-wrap {
      display: flex;
      gap: 8px;
      overflow-x: auto;
      padding-bottom: 6px;
      -webkit-overflow-scrolling: touch;

      .platform-btn {
        flex-shrink: 0;
        font-weight: 700;
        font-size: 13px;

        .plat-count {
          margin-left: 4px;
          font-size: 11px;
          opacity: 0.75;
        }
      }
    }

    .platform-content {
      display: flex;
      flex-direction: column;
      gap: 14px;

      .platform-header {
        display: flex;
        align-items: center;
        justify-content: space-between;

        .platform-title {
          font-size: 1.15rem;
          font-weight: 800;
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .platform-count-badge {
          font-size: 12px;
          font-weight: 700;
          color: rgba(var(--v-theme-on-surface), 0.6);
        }
      }

      .platform-apps-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
        gap: 12px;
      }

      .no-platform-results {
        padding: 60px 20px;
        text-align: center;
        color: rgba(var(--v-theme-on-surface), 0.5);

        p {
          margin-top: 12px;
          font-size: 14px;
        }
      }
    }
  }

  .bottom-nav-spacer {
    height: 72px;
  }

  .admin-manage-fab {
    position: fixed;
    right: 20px;
    bottom: 144px;
    z-index: 95;
    border-radius: 50%;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  }

  .admin-register-fab {
    position: fixed;
    right: 20px;
    bottom: 80px;
    z-index: 95;
    border-radius: 50%;
    box-shadow: 0 4px 16px rgba(var(--v-theme-primary), 0.4);
  }
}
</style>
