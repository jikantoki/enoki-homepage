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
    template(v-if="isAdmin && app")
      v-btn(icon="mdi-pencil-outline" color="primary" variant="text" @click="editModalOpen = true")
        v-icon mdi-pencil-outline
        v-tooltip(activator="parent" location="bottom") 編集 (管理者)
      v-btn(icon="mdi-delete-outline" color="error" variant="text" @click="deleteDialogOpen = true")
        v-icon mdi-delete-outline
        v-tooltip(activator="parent" location="bottom") 削除 (管理者)
    v-btn(icon="mdi-magnify" variant="text" @click="$router.push('/apps')")
    v-btn(icon="mdi-share-variant" variant="text" @click="shareApp")

  //- 管理者向けアクションバナー
  v-alert.admin-action-banner.ma-3.pa-2(
    v-if="isAdmin && app"
    color="primary"
    variant="tonal"
    density="compact"
    rounded="lg"
    style="max-height: fit-content;"
  )
    .d-flex.align-center.justify-space-between.flex-wrap.gap-2
      .d-flex.align-center.gap-2
        v-icon(size="18") mdi-shield-check
        span.font-weight-medium.text-caption 管理者権限: このアプリの編集・削除が可能です
      .d-flex.gap-2
        v-btn(size="x-small" variant="text" prepend-icon="mdi-format-list-checks" @click="$router.push('/admin/manage')") 管理一覧
        v-btn(size="x-small" color="primary" variant="flat" prepend-icon="mdi-pencil" @click="editModalOpen = true") 編集
        v-btn(size="x-small" color="error" variant="tonal" prepend-icon="mdi-delete" @click="deleteDialogOpen = true") 削除

  //- ================= メインスクロールエリア =================
  .detail-scroll-content(v-if="app")
    .detail-body
      //- 未完成（開発中）注意バナー
      v-alert.unfinished-banner.mb-4.pa-4(
        v-if="isUnfinished"
        type="warning"
        variant="tonal"
        rounded="xl"
        density="comfortable"
        icon="mdi-hammer-wrench"
      )
        .d-flex.align-center.justify-space-between.flex-wrap.gap-2
          div
            .font-weight-bold.text-body-2 このアプリは「未完成（開発中）」です
            .text-caption.text-medium-emphasis 機能の追加や仕様変更が進行中であり、一部機能や動作が不安定な場合があります。
          v-chip(size="x-small" color="warning" variant="flat") 制作中 / WIP

      //- ヘッダー情報 (アイコン・名前・開発者・バッジ)
      .detail-header
        .header-main
          .icon-box
            img.app-icon(:src="app.icon" :alt="app.name" onerror="this.src='/icon.png'")
            .wip-corner-badge(v-if="isUnfinished")
              v-icon(size="11") mdi-progress-wrench
              span 未完成
          .meta-box
            h1.app-name {{ app.name }}
            p.app-dev {{ app.developer || 'エノキ電気' }}
            .app-badges
              span.badge {{ app.category || (app.type === 'game' ? 'ゲーム' : 'アプリ') }}
              span.badge.wip-badge(v-if="isUnfinished")
                v-icon.mr-1(size="11") mdi-progress-wrench
                | 未完成 (WIP)

      //- リンクボタン群（旧インストール/購入ボタンを置き換え、linksをv-forで表示）
      .action-row(v-if="(app.links && app.links.length) || app.githubUrl || app.videoUrl")
        .links-container
          v-btn.link-btn(
            v-for="link in (app.links || [])"
            :key="link.text + link.url"
            :href="link.url"
            target="_blank"
            rel="noopener noreferrer"
            color="primary"
            rounded="pill"
            size="large"
            variant="flat"
            :prepend-icon="link.icon || 'mdi-open-in-new'"
          ) {{ link.text }}

          v-btn.link-btn(
            v-if="app.githubUrl && (!app.links || !app.links.some(l => l.url === app.githubUrl))"
            :href="app.githubUrl"
            target="_blank"
            rel="noopener noreferrer"
            variant="tonal"
            rounded="pill"
            size="large"
            prepend-icon="mdi-github"
          ) GitHub

          v-btn.link-btn(
            v-if="app.videoUrl && (!app.links || !app.links.some(l => l.url === app.videoUrl))"
            :href="app.videoUrl"
            target="_blank"
            rel="noopener noreferrer"
            color="error"
            variant="tonal"
            rounded="pill"
            size="large"
            prepend-icon="mdi-youtube"
          ) YouTube

      //- スクリーンショット
      .screenshots-section(v-if="app.images && app.images.length")
        .section-title スクリーンショット
        .screenshot-scroll
          .screenshot-item(v-for="(img, idx) in app.images" :key="idx")
            img.screenshot-img(:src="img" :alt="`Screenshot ${idx + 1}`" loading="lazy")

      //- このアプリについて (Markdown表示対応)
      .about-section
        .section-title この{{ app.type === 'game' ? 'ゲーム' : 'アプリ' }}について
        .about-text
          p.summary-lead(v-if="app.summary") {{ app.summary }}
          .markdown-body(v-html="renderedDescription")

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

  //- データベースから読み込み中
  .not-found-view(v-else-if="appStore.dbLoading")
    v-progress-circular(indeterminate color="primary" size="48")
    p 読み込み中...

  //- アプリが見つからなかった場合
  .not-found-view(v-else)
    v-icon(size="64" color="grey") mdi-application-outline
    h2 ソフトウェアが見つかりませんでした
    p お探しのアプリやゲームは存在しないか、削除された可能性があります。
    v-btn(
      color="primary"
      rounded="pill"
      prepend-icon="mdi-arrow-left"
      @click="$router.push('/apps')"
    ) ソフトウェア一覧へ戻る

  //- 削除確認モーダル
  v-dialog(v-model="deleteDialogOpen" max-width="480")
    v-card(rounded="xl")
      v-card-title.d-flex.align-center.gap-2.pt-4.px-4
        v-icon(color="error" size="26") mdi-alert-circle-outline
        span.font-weight-bold アプリの削除
      v-card-text.px-4.py-2
        p.mb-2
          | 「
          strong.text-primary {{ app?.name }}
          | 」(ID: 
          code {{ app?.id }}
          | ) を完全に削除しますか？
        v-alert(
          type="error"
          variant="tonal"
          density="compact"
          rounded="lg"
          class="mt-3"
        )
          | MySQLデータベース (app_list) および永続化ファイルから完全に削除されます。元に戻すことはできません。
      v-card-actions.pa-4.d-flex.justify-end.gap-2
        v-btn(variant="text" :disabled="deleteDialogLoading" @click="deleteDialogOpen = false") キャンセル
        v-btn(color="error" variant="flat" rounded="pill" :loading="deleteDialogLoading" @click="handleDeleteApp") 削除する

  //- 編集モーダル
  AdminRegisterModal(
    v-model="editModalOpen"
    initialTab="app"
    :editItem="app"
    @updated="onAppUpdated"
  )
</template>

<script lang="ts">
import { marked } from 'marked'
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import {
  useAppStore,
  isItemUnfinished,
  type AppOrMusicItem,
} from '@/stores/app'
import { useSettingsStore } from '@/stores/settings'
import { useMyProfileStore } from '@/stores/myProfile'
import AppCard from '@/components/store/AppCard.vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'
import Setup from '@/js/setup'
import { deleteAppFromDB } from '@/js/contentApi'
import mixins from '@/mixins/mixins'

export default {
  name: 'AppDetailPage',
  components: {
    AppCard,
    AdminRegisterModal,
  },
  mixins: [mixins],
  data() {
    return {
      appStore: useAppStore(),
      settings: useSettingsStore(),
      myProfile: useMyProfileStore(),
      editModalOpen: false,
      deleteDialogOpen: false,
      deleteDialogLoading: false,
    }
  },
  computed: {
    isAdmin(): boolean {
      return Boolean(
        this.myProfile.isAdmin ||
          this.myProfile.role === 'admin' ||
          (!this.myProfile.guest && this.myProfile.canRegisterApp),
      )
    },
    appId(): string {
      return (this.$route.params.appId as string) || ''
    },
    app(): AppOrMusicItem | undefined {
      return this.appStore.list.find((item) => item.id === this.appId)
    },
    relatedApps(): AppOrMusicItem[] {
      if (!this.app) return []
      return this.appStore.list
        .filter(
          (item) =>
            item.id !== this.appId && item.category === this.app?.category,
        )
        .slice(0, 8)
    },
    isUnfinished(): boolean {
      return isItemUnfinished(this.app)
    },
    renderedDescription(): string {
      if (!this.app?.description) return ''
      return marked.parse(this.app.description, {
        breaks: true,
        gfm: true,
      }) as string
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
  mounted() {
    // データベース (MySQL) から最新のアプリ情報を読み込み
    this.appStore.fetchFromDatabase()
    if (this.app) {
      this.setTitle(this.app.name)
    }
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/apps')
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
    async handleDeleteApp() {
      if (!this.app || !this.app.id) return
      this.deleteDialogLoading = true
      const appId = this.app.id
      const appName = this.app.name
      try {
        // 1. PHP 経由で MySQL (app_list) から削除（失敗時は throw）
        await deleteAppFromDB(appId)

        // 2. Pinia Store から削除
        this.appStore.removeById(appId)
        try {
          await Toast.show({ text: `「${appName}」を削除しました` })
        } catch (_) {}

        this.deleteDialogOpen = false
        this.$router.push('/apps')
      } catch (err: any) {
        console.error('Delete app error:', err)
        try {
          await Toast.show({
            text: `削除に失敗しました: ${err?.message || err}`,
            duration: 'long',
          })
        } catch (_) {}
      } finally {
        this.deleteDialogLoading = false
      }
    },
    onAppUpdated(payload: any) {
      if (payload?.item) {
        this.setTitle(payload.item.name)
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.app-detail-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
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
        }
      }
    }
  }

  .action-row {
    .links-container {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;

      .link-btn {
        flex: 1 1 200px;
        font-weight: 700;
        font-size: 14.5px;
        letter-spacing: 0.3px;
        height: 48px;
      }
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
      margin-bottom: 12px;
      line-height: 1.6;
    }

    .markdown-body {
      font-size: 0.92rem;
      line-height: 1.75;
      color: rgba(var(--v-theme-on-surface), 0.88);

      :deep(h1),
      :deep(h2),
      :deep(h3),
      :deep(h4),
      :deep(h5),
      :deep(h6) {
        font-weight: 700;
        margin-top: 1.2em;
        margin-bottom: 0.6em;
        color: rgb(var(--v-theme-on-surface));
      }

      :deep(h1) {
        font-size: 1.35rem;
      }
      :deep(h2) {
        font-size: 1.2rem;
      }
      :deep(h3) {
        font-size: 1.05rem;
      }
      :deep(h4) {
        font-size: 0.98rem;
      }

      :deep(p) {
        margin-bottom: 0.8em;
      }

      :deep(ul),
      :deep(ol) {
        padding-left: 20px;
        margin-bottom: 0.8em;
      }

      :deep(li) {
        margin-bottom: 4px;
      }

      :deep(strong) {
        font-weight: 700;
        color: rgb(var(--v-theme-on-surface));
      }

      :deep(code) {
        background: rgba(var(--v-theme-on-surface), 0.08);
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 0.85em;
        font-family: monospace;
      }

      :deep(pre) {
        background: rgba(var(--v-theme-on-surface), 0.06);
        padding: 12px;
        border-radius: 8px;
        overflow-x: auto;
        margin-bottom: 0.8em;

        code {
          background: transparent;
          padding: 0;
        }
      }

      :deep(blockquote) {
        border-left: 4px solid rgb(var(--v-theme-primary));
        padding-left: 12px;
        margin: 12px 0;
        color: rgba(var(--v-theme-on-surface), 0.7);
        font-style: italic;
      }

      :deep(a) {
        color: rgb(var(--v-theme-primary));
        text-decoration: underline;
      }

      :deep(hr) {
        border: none;
        border-top: 1px solid rgba(var(--v-theme-on-surface), 0.12);
        margin: 16px 0;
      }

      :deep(table) {
        width: 100%;
        border-collapse: collapse;
        margin: 12px 0;

        th,
        td {
          border: 1px solid rgba(var(--v-theme-on-surface), 0.15);
          padding: 8px;
          text-align: left;
        }

        th {
          background: rgba(var(--v-theme-on-surface), 0.05);
          font-weight: 700;
        }
      }
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
