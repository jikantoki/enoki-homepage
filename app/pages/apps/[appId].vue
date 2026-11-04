<template lang="pug">
v-card.app-detail-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- ================= 上部ツールバー =================
  v-toolbar.detail-toolbar(density="compact" color="surface" elevation="1")
    v-btn(icon="mdi-arrow-left" variant="text" @click="handleBack")
    v-toolbar-title.text-subtitle-1 {{ app ? app.name : 'ソフトウェア詳細' }}
    v-spacer
    v-btn(icon="mdi-magnify" variant="text" @click="$router.push('/')")
    v-btn(icon="mdi-share-variant" variant="text" @click="shareApp")

  //- ================= メインスクロールエリア =================
  .detail-scroll-content(v-if="app")
    .detail-body
      //- ヘッダー情報 (アイコン・名前・開発者・バッジ)
      .detail-header
        .header-main
          .icon-box
            img.app-icon(:src="app.icon" :alt="app.name" onerror="this.src='/icon.png'")
          .meta-box
            h1.app-name {{ app.name }}
            p.app-dev {{ app.developer || 'エノキ電気' }}
            .app-badges
              span.badge {{ app.category || (app.type === 'game' ? 'ゲーム' : 'アプリ') }}
              span.badge-sub(v-if="app.price && app.price > 0") ¥{{ app.price }}
              span.badge-sub(v-else) 無料

      //- 統計バー (Google Play風)
      .stats-bar
        .stat-item
          .stat-val
            span.num {{ app.rating || 4.7 }}
            v-icon(size="14" color="amber-darken-2") mdi-star
          .stat-lbl 1.8万件のレビュー
        v-divider(vertical inset)
        .stat-item
          .stat-val
            v-icon(size="16" color="primary") mdi-download
            span.num {{ app.downloads || '100万+' }}
          .stat-lbl ダウンロード
        v-divider(vertical inset)
        .stat-item
          .stat-val
            v-icon(size="16" color="success") mdi-shield-check
            span.num 3+
          .stat-lbl 全年齢対象

      //- インストールボタン (シミュレーション機能)
      .action-row
        v-btn.install-btn(
          color="primary"
          rounded="pill"
          size="large"
          block
          :loading="installing"
          @click="handleInstall"
        )
          span(v-if="installed") 開く
          span(v-else-if="app.price && app.price > 0") ¥{{ app.price }} で購入
          span(v-else) インストール

      //- スクリーンショット
      .screenshots-section(v-if="app.images && app.images.length")
        .section-title スクリーンショット
        .screenshot-scroll
          .screenshot-item(v-for="(img, idx) in app.images" :key="idx")
            img.screenshot-img(:src="img" :alt="`Screenshot ${idx + 1}`" loading="lazy")

      //- このアプリについて
      .about-section
        .section-title この{{ app.type === 'game' ? 'ゲーム' : 'アプリ' }}について
        .about-text
          p.summary-lead(v-if="app.summary") {{ app.summary }}
          .desc-body {{ app.description }}

      //- プラットフォーム & 使用言語チップ
      .meta-section
        .section-title プラットフォーム・仕様
        .chip-group(v-if="app.platforms && app.platforms.length")
          span.group-lbl プラットフォーム:
          v-chip(
            v-for="p in app.platforms"
            :key="p"
            size="small"
            variant="tonal"
            color="primary"
          ) {{ p }}

        .chip-group(v-if="app.languages && app.languages.length")
          span.group-lbl 技術スタック:
          v-chip(
            v-for="lang in app.languages"
            :key="lang"
            size="small"
            variant="tonal"
            color="secondary"
          ) {{ lang }}

      //- 外部リンク・ダウンロード導線
      .links-section(v-if="app.links && app.links.length")
        .section-title 外部リンク・公開情報
        .links-grid
          v-btn(
            v-for="link in app.links"
            :key="link.text"
            :href="link.url"
            target="_blank"
            rel="noopener noreferrer"
            variant="outlined"
            rounded="pill"
            size="small"
            :prepend-icon="link.icon || 'mdi-open-in-new'"
          ) {{ link.text }}

          v-btn(
            v-if="app.githubUrl"
            :href="app.githubUrl"
            target="_blank"
            rel="noopener noreferrer"
            variant="outlined"
            rounded="pill"
            size="small"
            prepend-icon="mdi-github"
          ) GitHub

          v-btn(
            v-if="app.videoUrl"
            :href="app.videoUrl"
            target="_blank"
            rel="noopener noreferrer"
            variant="outlined"
            rounded="pill"
            size="small"
            prepend-icon="mdi-youtube"
            color="error"
          ) YouTube

      //- 類似アプリ棚
      .related-section(v-if="relatedApps.length > 0")
        .section-title 関連する{{ app.category || 'おすすめ' }}ソフトウェア
        .related-scroll
          AppCard(
            v-for="item in relatedApps"
            :key="item.id"
            :item="item"
            @click="goToOtherApp(item)"
          )

    .bottom-spacer

  //- アプリが見つからなかった場合
  .not-found-view(v-else)
    v-icon(size="64" color="grey") mdi-application-outline
    h2 ソフトウェアが見つかりませんでした
    p お探しのアプリやゲームは存在しないか、削除された可能性があります。
    v-btn(
      color="primary"
      rounded="pill"
      prepend-icon="mdi-arrow-left"
      @click="$router.push('/')"
    ) ソフトウェア一覧へ戻る
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { useAppStore, type AppOrMusicItem } from '@/stores/app'
import { useSettingsStore } from '@/stores/settings'
import AppCard from '@/components/store/AppCard.vue'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'AppDetailPage',
  components: {
    AppCard,
  },
  mixins: [mixins],
  data() {
    return {
      appStore: useAppStore(),
      settings: useSettingsStore(),
      installing: false,
      installed: false,
    }
  },
  computed: {
    appId(): string {
      return (this.$route.params.appId as string) || ''
    },
    app(): AppOrMusicItem | undefined {
      return this.appStore.list.find((item) => item.id === this.appId)
    },
    relatedApps(): AppOrMusicItem[] {
      if (!this.app) return []
      return this.appStore.list
        .filter((item) => item.id !== this.appId && item.category === this.app?.category)
        .slice(0, 8)
    },
  },
  setup() {
    const route = useRoute()
    const appStore = useAppStore()
    const appId = (route.params.appId as string) || ''
    const item = appStore.list.find((i) => i.id === appId)
    if (item) {
      Setup.setTitle(`${item.name} - ソフトウェア詳細`)
      Setup.setDescription(item.summary || item.description || '')
    } else {
      Setup.setTitle('ソフトウェア詳細 - エノキ電気')
    }
  },
  watch: {
    app(newApp) {
      if (newApp && typeof document !== 'undefined') {
        this.setTitle(newApp.name)
      }
    },
  },
  created() {
    if (!this.appStore.list || this.appStore.list.length === 0) {
      this.appStore.loadMockData(true)
    }
  },
  mounted() {
    if (this.app) {
      this.setTitle(this.app.name)
    }
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/')
      }
    },
    goToOtherApp(item: AppOrMusicItem) {
      this.$router.push(`/apps/${item.id}`)
    },
    async shareApp() {
      if (!this.app) return
      const url = `https://enoki.xyz/apps/${this.app.id}`
      try {
        await Share.share({
          title: `${this.app.name} - エノキ電気`,
          text: this.app.summary || this.app.description,
          url: url,
          dialogTitle: `${this.app.name} を共有`,
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText(url)
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
    async handleInstall() {
      if (this.installed) {
        await Toast.show({ text: `${this.app?.name} を起動しました` })
        return
      }

      this.installing = true
      await new Promise((resolve) => setTimeout(resolve, 1400))
      this.installing = false
      this.installed = true
      await Toast.show({ text: `${this.app?.name} のインストールが完了しました！` })
    },
  },
}
</script>

<style lang="scss" scoped>
.app-detail-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: hidden;
  background-color: rgb(var(--v-theme-surface));

  .detail-toolbar {
    flex-shrink: 0;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  }

  .detail-scroll-content {
    flex: 1;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
  }

  .detail-body {
    max-width: 720px;
    margin: 0 auto;
    padding: 20px 20px 40px 20px;
    display: flex;
    flex-direction: column;
    gap: 22px;
  }

  .detail-header {
    .header-main {
      display: flex;
      gap: 18px;
      align-items: flex-start;

      .icon-box {
        flex-shrink: 0;
        width: 88px;
        height: 88px;

        .app-icon {
          width: 100%;
          height: 100%;
          border-radius: 20px;
          object-fit: cover;
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        }
      }

      .meta-box {
        flex: 1;
        min-width: 0;

        .app-name {
          font-size: 1.45rem;
          font-weight: 800;
          line-height: 1.25;
          margin-bottom: 4px;
        }

        .app-dev {
          font-size: 0.95rem;
          color: rgb(var(--v-theme-primary));
          font-weight: 600;
          margin-bottom: 8px;
        }

        .app-badges {
          display: flex;
          gap: 6px;
          flex-wrap: wrap;

          .badge {
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 6px;
            background: rgba(var(--v-theme-on-surface), 0.08);
            font-weight: 600;
          }

          .badge-sub {
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 6px;
            background: rgba(var(--v-theme-primary), 0.1);
            color: rgb(var(--v-theme-primary));
            font-weight: 600;
          }
        }
      }
    }
  }

  .stats-bar {
    display: flex;
    align-items: center;
    justify-content: space-around;
    padding: 12px 0;
    border-top: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);

    .stat-item {
      text-align: center;
      flex: 1;

      .stat-val {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 3px;
        font-weight: 800;
        font-size: 1.05rem;
      }

      .stat-lbl {
        font-size: 11px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        margin-top: 2px;
      }
    }
  }

  .action-row {
    .install-btn {
      font-weight: 700;
      font-size: 15px;
      letter-spacing: 0.5px;
      height: 46px;
    }
  }

  .section-title {
    font-size: 1.1rem;
    font-weight: 800;
    margin-bottom: 10px;
  }

  .screenshots-section {
    .screenshot-scroll {
      display: flex;
      gap: 12px;
      overflow-x: auto;
      padding-bottom: 8px;
      -webkit-overflow-scrolling: touch;

      .screenshot-item {
        flex-shrink: 0;
        width: 180px;
        border-radius: 14px;
        overflow: hidden;
        border: 1px solid rgba(var(--v-theme-on-surface), 0.08);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

        .screenshot-img {
          width: 100%;
          height: auto;
          display: block;
        }
      }
    }
  }

  .about-section {
    .summary-lead {
      font-size: 0.95rem;
      font-weight: 600;
      color: rgb(var(--v-theme-on-surface));
      margin-bottom: 8px;
    }

    .desc-body {
      font-size: 0.9rem;
      line-height: 1.7;
      color: rgba(var(--v-theme-on-surface), 0.85);
      white-space: pre-line;
    }
  }

  .meta-section {
    display: flex;
    flex-direction: column;
    gap: 8px;

    .chip-group {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;

      .group-lbl {
        font-size: 12px;
        font-weight: 700;
        color: rgba(var(--v-theme-on-surface), 0.7);
      }
    }
  }

  .links-section {
    .links-grid {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
  }

  .related-section {
    .related-scroll {
      display: flex;
      gap: 12px;
      overflow-x: auto;
      padding-bottom: 8px;
      -webkit-overflow-scrolling: touch;
    }
  }

  .bottom-spacer {
    height: 72px;
  }

  .not-found-view {
    padding: 80px 24px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;

    h2 {
      font-size: 1.3rem;
      font-weight: 800;
    }

    p {
      color: rgba(var(--v-theme-on-surface), 0.6);
      max-width: 400px;
    }
  }
}
</style>
