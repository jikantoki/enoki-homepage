<template lang="pug">
v-card.playstore-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- ================= Google Play 検索バーヘッダー =================
  .store-top-bar
    .search-pill
      v-icon.search-icon mdi-magnify
      input.search-input(
        v-model="searchQuery"
        placeholder="アプリやゲームを検索"
        @focus="isSearchActive = true"
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
          :src="myProfile && myProfile.icon ? myProfile.icon : '/account_default.jpg'"
          alt="Avatar"
          onerror="this.src='/account_default.jpg'"
        )

  //- ================= タブバー（非検索時） =================
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

    //- ---------------- 2. おすすめタブ ----------------
    .tab-content(v-else-if="activeTab === 'foryou'")
      //- ヒーローカルーセル
      HeroBanner(
        :items="featuredApps"
        @click="openDetail"
      )

      //- 棚: あなたへのおすすめ
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

      //- 棚: 注目の新作ゲーム
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

      //- 棚: 日常と仕事を便利にするツール
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

      //- 棚: 高評価セレクション
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

      //- 棚: 癒しとライフスタイル
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

    //- ---------------- 3. ランキングタブ ----------------
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

    //- ---------------- 4. ゲームタブ ----------------
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

    //- ---------------- 5. アプリタブ ----------------
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

    //- ---------------- 6. カテゴリ一覧タブ ----------------
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

  //- ================= Google Play風ボトムナビゲーション =================
  .store-bottom-nav
    .nav-buttons
      .nav-btn(
        :class="{ active: activeTab === 'games' && !searchQuery }"
        v-ripple
        @click="switchBottomNav('games')"
      )
        v-icon {{ activeTab === 'games' && !searchQuery ? 'mdi-gamepad-variant' : 'mdi-gamepad-variant-outline' }}
        span ゲーム
      .nav-btn(
        :class="{ active: (activeTab === 'apps' || activeTab === 'foryou') && !searchQuery }"
        v-ripple
        @click="switchBottomNav('foryou')"
      )
        v-icon {{ (activeTab === 'apps' || activeTab === 'foryou') && !searchQuery ? 'mdi-apps' : 'mdi-apps' }}
        span アプリ
      .nav-btn(
        :class="{ active: activeTab === 'ranking' && !searchQuery }"
        v-ripple
        @click="switchBottomNav('ranking')"
      )
        v-icon {{ activeTab === 'ranking' && !searchQuery ? 'mdi-trophy' : 'mdi-trophy-outline' }}
        span ランキング
      .nav-btn(
        :class="{ active: optionsDialog }"
        v-ripple
        @click="optionsDialog = true"
      )
        v-icon mdi-dots-horizontal
        span その他
    .bottom-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher")

  //- ================= アプリ詳細ダイアログ =================
  AppDetailModal(
    v-model="detailDialogOpen"
    :app="selectedApp"
    @search="detailDialogOpen = false; searchQuery = ''"
  )

  //- ================= その他 / ようこそダイアログ（既存機能継承） =================
  v-dialog(
    v-model="optionsDialog"
    transition="dialog-bottom-transition"
    fullscreen
  )
    v-card
      .top-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher")
      v-card-actions
        p.ml-2(class="headline" style="font-size: 1.3em") ようこそ
        v-spacer
        v-btn(
          text
          @click="optionsDialog = false"
          icon="mdi-close"
        )
      v-card-text
        .account-details(
          style="display: flex; flex-direction: column; align-items: center; gap: 1em; margin-bottom: 1em;"
        )
          .account-img
            img(
              :src="myProfile && myProfile.icon ? myProfile.icon : '/account_default.jpg'"
              style="height: 8em; width: 8em; border-radius: 9999px;"
              onerror="this.src='/account_default.jpg'"
            )
          .account-info(style="text-align: center;")
            p(
              v-if="myProfile.userId && !myProfile.guest"
              style="font-size: 1.2em; margin: 0; padding: 0;"
            ) {{ myProfile.name ? myProfile.name : myProfile.userId }}
            p(v-else style="font-size: 1.2em; margin: 0; padding: 0;") ログインしていません
            p(style="margin: 0; padding: 0;")
              | {{ myProfile.userId && !myProfile.guest ? `@${myProfile.userId}` : 'データは同期されていません' }}
            v-btn.my-2(
              v-if="myProfile.userId && !myProfile.guest"
              text
              @click="$router.push(`/user/${myProfile.userId}`)"
              append-icon="mdi-account-outline"
              style="background-color: rgb(var(--v-theme-primary)); color: white;"
            ) プロフィールを表示
            v-btn.my-2(
              v-else
              text
              @click="$router.push('/login')"
              append-icon="mdi-login"
              style="background-color: rgb(var(--v-theme-primary)); color: white;"
            ) ログイン

        v-list.options-list
          v-list-item.item(@click="$router.push('/qrcode')")
            .icon-and-text
              v-icon mdi-qrcode-scan
              v-list-item-title QRコードで探す
          v-list-item.item(@click="$router.push('/settings')")
            .icon-and-text
              v-icon mdi-cog
              v-list-item-title 設定
          v-list-item.item(@click="$router.push('/terms')")
            .icon-and-text
              v-icon mdi-file-document-outline
              v-list-item-title 利用規約
          v-list-item.item(@click="$router.push('/privacy')")
            .icon-and-text
              v-icon mdi-shield-lock-outline
              v-list-item-title プライバシーポリシー
          v-list-item.item(@click="$router.push('/about')")
            .icon-and-text
              v-icon mdi-information
              v-list-item-title 運営情報
          v-list-item.item(@click="share('https://enoki.xyz?openExternalBrowser=1', 'ENOKI Appcenter')")
            .icon-and-text
              v-icon mdi-share-variant
              v-list-item-title 共有する
          v-list-item.item(@click="reloadMockData")
            .icon-and-text
              v-icon mdi-refresh
              v-list-item-title モックデータを再読み込み (100件)
</template>

<script lang="ts">
import { App } from '@capacitor/app'
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
// @ts-ignore
import mixins from '@/mixins/mixins'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import { useAppStore, type AppOrMusicItem } from '@/stores/app'
import Setup from '@/js/setup'
import AppCard from '@/components/store/AppCard.vue'
import AppRankItem from '@/components/store/AppRankItem.vue'
import AppShelf from '@/components/store/AppShelf.vue'
import HeroBanner from '@/components/store/HeroBanner.vue'
import AppDetailModal from '@/components/store/AppDetailModal.vue'

export default {
  components: {
    AppCard,
    AppRankItem,
    AppShelf,
    HeroBanner,
    AppDetailModal,
  },
  mixins: [mixins],
  data() {
    return {
      optionsDialog: false,
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
      appStore: useAppStore(),
      searchQuery: '',
      isSearchActive: false,
      searchFilter: 'all' as 'all' | 'game' | 'app' | 'free',
      activeTab: 'foryou',
      rankingType: 'all',
      detailDialogOpen: false,
      selectedApp: null as AppOrMusicItem | null,
      selectedCategory: null as string | null,
    }
  },
  computed: {
    allApps(): AppOrMusicItem[] {
      return this.appStore.list
    },
    featuredApps(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.featured).slice(0, 6)
    },
    featuredGames(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.type === 'game' && item.featured).slice(0, 5)
    },
    featuredAppItems(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.type === 'app' && item.featured).slice(0, 5)
    },
    recommendedApps(): AppOrMusicItem[] {
      return this.allApps.slice(0, 12)
    },
    newGames(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.type === 'game').slice(10, 22)
    },
    productivityApps(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.category === '仕事効率化' || item.category === 'ツール').slice(0, 12)
    },
    topRatedApps(): AppOrMusicItem[] {
      return [...this.allApps].filter(item => (item.rating || 0) >= 4.7).slice(0, 12)
    },
    lifestyleApps(): AppOrMusicItem[] {
      return this.allApps.filter(item => item.category === '健康＆フィットネス' || item.category === 'ライフスタイル').slice(0, 12)
    },
    currentRankings(): AppOrMusicItem[] {
      let list = [...this.allApps]
      if (this.rankingType === 'free') {
        list = list.filter(item => !item.price || item.price === 0)
      } else if (this.rankingType === 'paid') {
        list = list.filter(item => item.price && item.price > 0)
      } else if (this.rankingType === 'games') {
        list = list.filter(item => item.type === 'game')
      } else if (this.rankingType === 'apps') {
        list = list.filter(item => item.type === 'app')
      }
      return list.sort((a, b) => (b.rating || 0) - (a.rating || 0)).slice(0, 30)
    },
    searchResults(): AppOrMusicItem[] {
      const q = this.searchQuery.trim().toLowerCase()
      if (!q) return []
      let filtered = this.allApps.filter(item => {
        const nameMatch = item.name.toLowerCase().includes(q)
        const catMatch = (item.category || '').toLowerCase().includes(q)
        const descMatch = (item.description || '').toLowerCase().includes(q)
        return nameMatch || catMatch || descMatch
      })

      if (this.searchFilter === 'game') {
        filtered = filtered.filter(item => item.type === 'game')
      } else if (this.searchFilter === 'app') {
        filtered = filtered.filter(item => item.type === 'app')
      } else if (this.searchFilter === 'free') {
        filtered = filtered.filter(item => !item.price || item.price === 0)
      }
      return filtered
    },
    categoryApps(): AppOrMusicItem[] {
      if (!this.selectedCategory) return []
      return this.allApps.filter(item => item.category === this.selectedCategory)
    },
    allCategoriesWithMeta(): Array<{ name: string; count: number; icon: string; color: string }> {
      const iconMap: Record<string, { icon: string; color: string }> = {
        'RPG': { icon: 'mdi-sword-cross', color: '#6366f1' },
        'アクション': { icon: 'mdi-lightning-bolt', color: '#ef4444' },
        'パズル': { icon: 'mdi-puzzle', color: '#f59e0b' },
        'シミュレーション': { icon: 'mdi-city', color: '#10b981' },
        '音楽ゲーム': { icon: 'mdi-music', color: '#ec4899' },
        'レース': { icon: 'mdi-car-sports', color: '#3b82f6' },
        'ストラテジー': { icon: 'mdi-shield-crown', color: '#8b5cf6' },
        'ツール': { icon: 'mdi-tools', color: '#06b6d4' },
        '仕事効率化': { icon: 'mdi-check-decagram', color: '#10b981' },
        '写真': { icon: 'mdi-camera', color: '#f97316' },
        'ファイナンス': { icon: 'mdi-wallet', color: '#14b8a6' },
        '教育': { icon: 'mdi-school', color: '#8b5cf6' },
        '健康＆フィットネス': { icon: 'mdi-heart-pulse', color: '#ef4444' },
        '音楽＆オーディオ': { icon: 'mdi-headphones', color: '#a855f7' },
        '天気': { icon: 'mdi-weather-partly-cloudy', color: '#0284c7' },
        'ライフスタイル': { icon: 'mdi-coffee', color: '#d97706' },
        'マンガ＆書籍': { icon: 'mdi-book-open-page-variant', color: '#e11d48' },
        'ビジネス': { icon: 'mdi-briefcase', color: '#475569' },
      }

      const map = new Map<string, number>()
      this.allApps.forEach(item => {
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
    Setup.setTitle('ENOKI Appcenter - Play Store')
    Setup.setDescription('エノキ電気公式アプリストア。Google Play Storeライクなアプリ一覧を提供します。')
  },
  async mounted() {
    this.setTitle('ENOKI Appcenter')

    // モックデータが存在しない場合は確実にロード
    if (!this.appStore.list || this.appStore.list.length === 0) {
      this.appStore.loadMockData(true)
    }

    /** バックボタンのリスナーを追加 */
    App.addListener('backButton', () => {
      if (this.detailDialogOpen) {
        this.detailDialogOpen = false
      } else if (this.optionsDialog) {
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
      this.selectedApp = item
      this.detailDialogOpen = true
    },
    switchBottomNav(tab: string) {
      this.searchQuery = ''
      this.activeTab = tab
      // 最上部にスクロール
      const container = this.$refs.scrollContainer as HTMLElement
      if (container) {
        container.scrollTop = 0
      }
    },
    reloadMockData() {
      this.appStore.loadMockData(true)
      Toast.show({ text: '100件のモックデータを再読み込みしました' })
      this.optionsDialog = false
    },
    gamesByCategory(category: string): AppOrMusicItem[] {
      return this.allApps.filter(item => item.type === 'game' && item.category === category)
    },
    appsByCategory(category: string): AppOrMusicItem[] {
      return this.allApps.filter(item => item.type === 'app' && item.category === category)
    },
    async share(content: string, title = '') {
      await Share.share({
        url: content,
        title: title,
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.playstore-root {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: rgb(var(--v-theme-surface));
}

// ---------------- Google Play風トップ検索バー ----------------
.store-top-bar {
  padding: 12px 16px 8px 16px;
  background-color: rgb(var(--v-theme-surface));
  z-index: 10;

  .search-pill {
    display: flex;
    align-items: center;
    background-color: rgba(var(--v-theme-on-surface), 0.08);
    border-radius: 9999px;
    padding: 4px 6px 4px 16px;
    height: 48px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    transition: background-color 0.2s, box-shadow 0.2s;

    &:focus-within {
      background-color: rgb(var(--v-theme-surface));
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.16);
      border: 1px solid rgba(var(--v-theme-primary), 0.3);
    }

    .search-icon {
      color: rgba(var(--v-theme-on-surface), 0.6);
      margin-right: 10px;
    }

    .search-input {
      flex: 1;
      border: none;
      outline: none;
      background: transparent;
      font-size: 15px;
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
      margin-left: 8px;
      flex-shrink: 0;
      border: 1.5px solid rgba(var(--v-theme-on-surface), 0.15);

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }
  }
}

// ---------------- サブナビ（タブバー） ----------------
.store-sub-nav {
  background-color: rgb(var(--v-theme-surface));
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  z-index: 9;

  :deep(.v-tab) {
    font-size: 13.5px;
    font-weight: 600;
    letter-spacing: 0;
    text-transform: none;
    min-width: 72px;
    padding: 0 14px;
  }
}

// ---------------- メインスクロールエリア ----------------
.store-scroll-content {
  flex: 1;
  overflow-y: auto;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 16px;
}

// ---------------- 検索結果表示 ----------------
.search-results-view {
  padding: 16px;

  .search-header {
    margin-bottom: 16px;

    .search-title {
      font-size: 16px;
      font-weight: 700;
      margin-bottom: 10px;
      color: rgb(var(--v-theme-on-surface));
    }

    .filter-chips {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
  }

  .results-list {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .no-results {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 20px;
    gap: 12px;
    color: rgba(var(--v-theme-on-surface), 0.6);
    text-align: center;
  }
}

// ---------------- ランキングタブ ----------------
.ranking-filter-row {
  padding: 8px 16px;
}
.ranking-list {
  padding: 0 8px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

// ---------------- カテゴリタブ ----------------
.categories-view {
  padding: 16px;

  .category-select-row {
    display: flex;
    flex-direction: column;
    gap: 16px;

    .category-heading {
      font-size: 18px;
      font-weight: 700;
    }

    .category-apps-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      justify-content: flex-start;
    }
  }

  .category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 12px;

    .category-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 18px 12px;
      border-radius: 16px;
      background-color: rgba(var(--v-theme-on-surface), 0.04);
      cursor: pointer;
      text-align: center;
      transition: background-color 0.15s, transform 0.15s;

      &:hover {
        background-color: rgba(var(--v-theme-on-surface), 0.08);
        transform: translateY(-2px);
      }

      .cat-name {
        font-size: 13.5px;
        font-weight: 600;
        margin-top: 8px;
        color: rgb(var(--v-theme-on-surface));
      }

      .cat-count {
        font-size: 11px;
        color: rgba(var(--v-theme-on-surface), 0.55);
        margin-top: 2px;
      }
    }
  }
}

// ---------------- Google Play風ボトムナビゲーション ----------------
.store-bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: rgb(var(--v-theme-surface));
  border-top: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  z-index: 50;

  .nav-buttons {
    display: flex;
    justify-content: space-around;
    align-items: center;
    height: 56px;

    .nav-btn {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      flex: 1;
      height: 100%;
      cursor: pointer;
      color: rgba(var(--v-theme-on-surface), 0.65);
      transition: color 0.15s;
      user-select: none;

      v-icon {
        font-size: 22px;
      }

      span {
        font-size: 10px;
        font-weight: 500;
        margin-top: 2px;
      }

      &.active {
        color: rgb(var(--v-theme-primary));
        font-weight: 700;
      }
    }
  }
}

.bottom-nav-spacer {
  height: 64px;
}

.bottom-android-15-or-higher {
  height: 16px;
}
.top-android-15-or-higher {
  padding-top: 40px;
}

.options-list {
  .item {
    padding: 12px 16px;
    border-radius: 12px !important;
    margin: 8px 0;
    cursor: pointer;
    &:hover {
      background-color: rgba(var(--v-theme-primary), 0.1);
    }
    .icon-and-text {
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 16px;
      v-icon {
        font-size: 24px;
      }
    }
  }
}
</style>
