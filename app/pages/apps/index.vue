<template lang="pug">
v-card.playstore-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
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
  HeroProfile

  //- ================= サブナビバー（おすすめ / カテゴリ / プラットフォーム） =================
  .store-sub-nav(v-if="!searchQuery")
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

    //- ---------------- 1. 検索結果表示モード ----------------
    .search-results-view(v-if="searchQuery")
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
    return {
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
      randomPickups: [] as AppOrMusicItem[],
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
      return this.appStore.featuredApps.slice(0, 6)
    },
    recommendedApps(): AppOrMusicItem[] {
      return this.appStore.recommendedApps
    },
    randomPickupApps(): AppOrMusicItem[] {
      if (this.randomPickups.length > 0) return this.randomPickups
      return this.appStore.getRandomPickups(12)
    },
    webServiceApps(): AppOrMusicItem[] {
      return this.appStore.webServices.slice(0, 12)
    },
    androidApps(): AppOrMusicItem[] {
      return this.appStore.androidApps.slice(0, 12)
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
      const iconMap: Record<string, { icon: string; color: string }> = {
        RPG: { icon: 'mdi-sword-cross', color: '#6366f1' },
        アクション: { icon: 'mdi-lightning-bolt', color: '#ef4444' },
        パズル: { icon: 'mdi-puzzle', color: '#f59e0b' },
        シミュレーション: { icon: 'mdi-city', color: '#10b981' },
        音楽ゲーム: { icon: 'mdi-music', color: '#ec4899' },
        レース: { icon: 'mdi-car-sports', color: '#3b82f6' },
        ストラテジー: { icon: 'mdi-shield-crown', color: '#8b5cf6' },
        ツール: { icon: 'mdi-tools', color: '#06b6d4' },
        仕事効率化: { icon: 'mdi-check-decagram', color: '#10b981' },
        写真: { icon: 'mdi-camera', color: '#f97316' },
        ファイナンス: { icon: 'mdi-wallet', color: '#14b8a6' },
        教育: { icon: 'mdi-school', color: '#8b5cf6' },
        '健康＆フィットネス': { icon: 'mdi-heart-pulse', color: '#ef4444' },
        '音楽＆オーディオ': { icon: 'mdi-headphones', color: '#a855f7' },
        天気: { icon: 'mdi-weather-partly-cloudy', color: '#0284c7' },
        ライフスタイル: { icon: 'mdi-coffee', color: '#d97706' },
        'マンガ＆書籍': {
          icon: 'mdi-book-open-page-variant',
          color: '#e11d48',
        },
        ビジネス: { icon: 'mdi-briefcase', color: '#475569' },
      }

      const map = new Map<string, number>()
      this.allApps.forEach((item) => {
        if (item.category) {
          map.set(item.category, (map.get(item.category) || 0) + 1)
        }
      })

      return Array.from(map.entries()).map(([name, count]) => {
        const meta = iconMap[name] || { icon: 'mdi-shape', color: '#64748b' }
        return {
          name,
          count,
          icon: meta.icon,
          color: meta.color,
        }
      })
    },
  },
  watch: {
    allApps: {
      immediate: true,
      handler(newList) {
        if (newList && newList.length > 0 && this.randomPickups.length === 0) {
          this.initRandomPickups()
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

    // キャッシュ済みの一覧を即表示 → データベース (MySQL) の最新一覧で置き換え
    this.initRandomPickups()
    this.appStore.fetchFromDatabase().then(() => {
      this.initRandomPickups()
    })

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
    initRandomPickups() {
      this.randomPickups = this.appStore.getRandomPickups(12)
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
