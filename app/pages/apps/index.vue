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
        @click="optionsDialog = true"
      )
        img(
          :src="myProfile && myProfile.icon ? myProfile.icon : '/icon.png'"
          alt="Avatar"
          onerror="this.src='/icon.png'"
        )

  //- ================= ヒーロー自己紹介エリア =================
  HeroProfile

  //- ================= サブナビバー（ソフトウェア選択時） =================
  .store-sub-nav(v-if="!searchQuery")
    v-tabs(
      v-model="activeTab"
      color="primary"
      density="compact"
      align-tabs="center"
      show-arrows
    )
      v-tab(value="foryou") おすすめ
      v-tab(value="ranking") ランキング
      v-tab(value="games") ゲーム
      v-tab(value="apps") アプリ
      v-tab(value="categories") カテゴリ

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

    //- ---------------- 2. アプリタブ（サブナビ連動） ----------------
    template(v-else)
      //- おすすめタブ
      .tab-content(v-if="activeTab === 'foryou'")
        HeroBanner(
          :items="featuredApps"
          @click="openDetail"
        )

        AppShelf(
          title="あなたへのおすすめ"
          subtitle="利用傾向に基づいてピックアップ"
          showMore
          @more="activeTab = 'ranking'"
        )
          AppCard(
            v-for="item in recommendedApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="注目の新作ゲーム"
          subtitle="話題の最新タイトルをプレイしよう"
          showMore
          @more="activeTab = 'games'"
        )
          AppCard(
            v-for="item in newGames"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="生産性を高めるおすすめツール"
          subtitle="日々のタスクや作業効率をアップ"
          showMore
          @more="activeTab = 'apps'"
        )
          AppCard(
            v-for="item in productivityApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="★ 4.7 以上の高評価アプリ＆ゲーム"
          subtitle="ユーザー満足度の高い定番コレクション"
        )
          AppCard(
            v-for="item in topRatedApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(
          title="健康＆ライフスタイル"
          subtitle="毎日の生活をサポート"
        )
          AppCard(
            v-for="item in lifestyleApps"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

      //- ランキングタブ
      .tab-content(v-else-if="activeTab === 'ranking'")
        .ranking-filter-row
          v-chip-group(v-model="rankingType" selected-class="text-primary" mandatory)
            v-chip(value="all" variant="tonal" size="small") 総合人気
            v-chip(value="free" variant="tonal" size="small") 人気の無料
            v-chip(value="paid" variant="tonal" size="small") 人気の有料
            v-chip(value="games" variant="tonal" size="small") ゲーム人気
            v-chip(value="apps" variant="tonal" size="small") アプリ人気

        .ranking-list
          AppRankItem(
            v-for="(item, idx) in currentRankings"
            :key="item.id"
            :item="item"
            :rank="idx + 1"
            @click="openDetail(item)"
          )

      //- ゲームタブ
      .tab-content(v-else-if="activeTab === 'games'")
        HeroBanner(
          :items="featuredGames"
          @click="openDetail"
        )

        AppShelf(title="ロールプレイング" subtitle="壮大な物語と冒険の世界")
          AppCard(
            v-for="item in gamesByCategory('RPG')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="アクション＆バトル" subtitle="爽快なアクションを楽しもう")
          AppCard(
            v-for="item in gamesByCategory('アクション')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="パズル＆脳トレ" subtitle="ひらめきと直感でパズルを解こう")
          AppCard(
            v-for="item in gamesByCategory('パズル')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="シミュレーション" subtitle="自分だけの街や世界を創ろう")
          AppCard(
            v-for="item in gamesByCategory('シミュレーション')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="レース＆ドライブ" subtitle="スピードとスリルを体感")
          AppCard(
            v-for="item in gamesByCategory('レース')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

      //- アプリタブ
      .tab-content(v-else-if="activeTab === 'apps'")
        HeroBanner(
          :items="featuredAppItems"
          @click="openDetail"
        )

        AppShelf(title="ツール＆ユーティリティ" subtitle="スマホをさらに便利にする便利ツール")
          AppCard(
            v-for="item in appsByCategory('ツール')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="仕事効率化" subtitle="日々の作業や予定をスマートに")
          AppCard(
            v-for="item in appsByCategory('仕事効率化')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="写真＆動画" subtitle="思い出を美しく残そう")
          AppCard(
            v-for="item in appsByCategory('写真')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="音楽＆オーディオ" subtitle="最高の音響体験")
          AppCard(
            v-for="item in appsByCategory('音楽＆オーディオ')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

        AppShelf(title="ファイナンス" subtitle="お金の管理・家計簿")
          AppCard(
            v-for="item in appsByCategory('ファイナンス')"
            :key="item.id"
            :item="item"
            @click="openDetail(item)"
          )

      //- カテゴリ一覧タブ
      .tab-content(v-else-if="activeTab === 'categories'")
        .categories-view
          .category-select-row(v-if="selectedCategory")
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

    //- 下部ナビゲーションバー用の余白
    .bottom-nav-spacer

  //- ================= ボトムナビゲーション =================
  BottomNav(v-model="optionsDialog")
</template>

<script lang="ts">
import { App } from '@capacitor/app'
import { Toast } from '@capacitor/toast'
import mixins from '@/mixins/mixins'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import { useAppStore, type AppOrMusicItem } from '@/stores/app'
import Setup from '@/js/setup'
import HeroProfile from '@/components/common/HeroProfile.vue'
import BottomNav from '@/components/common/BottomNav.vue'
import AppCard from '@/components/store/AppCard.vue'
import AppRankItem from '@/components/store/AppRankItem.vue'
import AppShelf from '@/components/store/AppShelf.vue'
import HeroBanner from '@/components/store/HeroBanner.vue'

export default {
  name: 'AppsPage',
  components: {
    HeroProfile,
    BottomNav,
    AppCard,
    AppRankItem,
    AppShelf,
    HeroBanner,
  },
  mixins: [mixins],
  data() {
    return {
      optionsDialog: false,
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
      appStore: useAppStore(),
      searchQuery: '',
      searchFilter: 'all' as 'all' | 'game' | 'app' | 'free',
      activeTab: 'foryou',
      rankingType: 'all',
      selectedCategory: null as string | null,
    }
  },
  computed: {
    allApps(): AppOrMusicItem[] {
      return this.appStore.list
    },
    featuredApps(): AppOrMusicItem[] {
      return this.allApps.filter((item) => item.featured).slice(0, 6)
    },
    featuredGames(): AppOrMusicItem[] {
      return this.allApps
        .filter((item) => item.type === 'game' && item.featured)
        .slice(0, 5)
    },
    featuredAppItems(): AppOrMusicItem[] {
      return this.allApps
        .filter((item) => item.type === 'app' && item.featured)
        .slice(0, 5)
    },
    recommendedApps(): AppOrMusicItem[] {
      return this.allApps.slice(0, 12)
    },
    newGames(): AppOrMusicItem[] {
      return this.allApps.filter((item) => item.type === 'game').slice(10, 22)
    },
    productivityApps(): AppOrMusicItem[] {
      return this.allApps
        .filter(
          (item) =>
            item.category === '仕事効率化' || item.category === 'ツール',
        )
        .slice(0, 12)
    },
    topRatedApps(): AppOrMusicItem[] {
      return [...this.allApps]
        .filter((item) => (item.rating || 0) >= 4.7)
        .slice(0, 12)
    },
    lifestyleApps(): AppOrMusicItem[] {
      return this.allApps
        .filter(
          (item) =>
            item.category === '健康＆フィットネス' ||
            item.category === 'ライフスタイル',
        )
        .slice(0, 12)
    },
    currentRankings(): AppOrMusicItem[] {
      let list = [...this.allApps]
      if (this.rankingType === 'free') {
        list = list.filter((item) => !item.price || item.price === 0)
      } else if (this.rankingType === 'paid') {
        list = list.filter((item) => item.price && item.price > 0)
      } else if (this.rankingType === 'games') {
        list = list.filter((item) => item.type === 'game')
      } else if (this.rankingType === 'apps') {
        list = list.filter((item) => item.type === 'app')
      }
      return list.sort((a, b) => (b.rating || 0) - (a.rating || 0)).slice(0, 30)
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
      return this.allApps.filter(
        (item) => item.category === this.selectedCategory,
      )
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
  setup() {
    Setup.setTitle('ソフトウェア')
    Setup.setDescription(
      'エノキ電気の公式ソフトウェア・ゲーム・ツール一覧プラットフォーム。',
    )
  },
  async mounted() {
    this.setTitle('ソフトウェア')

    if (!this.appStore.list || this.appStore.list.length === 0) {
      this.appStore.loadMockData(true)
    }

    /** バックボタンのリスナーを追加 */
    App.addListener('backButton', () => {
      if (this.optionsDialog) {
        this.optionsDialog = false
      } else if (this.selectedCategory) {
        this.selectedCategory = null
      } else if (this.searchQuery) {
        this.searchQuery = ''
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
    gamesByCategory(category: string): AppOrMusicItem[] {
      return this.allApps.filter(
        (item) => item.type === 'game' && item.category === category,
      )
    },
    appsByCategory(category: string): AppOrMusicItem[] {
      return this.allApps.filter(
        (item) => item.type === 'app' && item.category === category,
      )
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

  // ---------------- サブナビ（アプリ用タブバー） ----------------
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

  // ---------------- ランキング画面 ----------------
  .ranking-filter-row {
    padding: 8px 16px;
    background-color: rgb(var(--v-theme-surface));
    position: sticky;
    top: 0;
    z-index: 5;
  }

  .ranking-list {
    display: flex;
    flex-direction: column;
    padding: 0 8px;
  }

  // ---------------- カテゴリ画面 ----------------
  .categories-view {
    padding: 12px 16px;

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

    .category-select-row {
      display: flex;
      flex-direction: column;
      gap: 16px;

      .category-heading {
        font-size: 1.15rem;
        font-weight: 800;
      }

      .category-apps-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
        gap: 12px;
      }
    }
  }

  .bottom-nav-spacer {
    height: 72px;
  }
}
</style>
