<template lang="pug">
v-card.admin-manage-page(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-toolbar.manage-toolbar(density="comfortable" color="surface" elevation="1")
    v-btn(icon="mdi-arrow-left" variant="text" @click="handleBack")
    v-toolbar-title.font-weight-bold.text-subtitle-1 コンテンツ管理 (編集・削除)
    v-chip.mr-2(color="primary" size="small" variant="flat")
      v-icon.mr-1(size="14") mdi-shield-check
      | 管理者モード
    v-spacer
    v-btn(
      color="primary"
      variant="flat"
      rounded="pill"
      size="small"
      prepend-icon="mdi-plus"
      @click="openCreateModal"
    ) 新規登録

  //- タブ切り替え
  v-tabs.manage-tabs(
    v-model="currentTab"
    color="primary"
    grow
    density="comfortable"
    style="max-height: fit-content;"
  )
    v-tab(value="apps")
      v-icon.mr-2 mdi-apps
      | アプリ・ゲーム
      v-badge.ml-2(
        :content="appStore.list.length.toString()"
        color="primary"
        inline
      )
    v-tab(value="music")
      v-icon.mr-2 mdi-music
      | 音楽・楽曲
      v-badge.ml-2(
        :content="musicStore.list.length.toString()"
        color="secondary"
        inline
      )

  //- メインコンテンツエリア (直接タブ内容を描画し余計な余白・レイアウトシフトを排除)
  .manage-content-scroll
    //- ==================== 1. アプリ管理タブ ====================
    .tab-inner.pa-4(v-if="currentTab === 'apps'")
      //- 検索 ＆ 絞り込みバー
      v-row(dense align="center")
        v-col(cols="12" sm="7" md="8")
          v-text-field(
            v-model="appSearch"
            placeholder="アプリ名、ID、説明文で検索..."
            variant="outlined"
            density="compact"
            prepend-inner-icon="mdi-magnify"
            clearable
            hide-details
          )
        v-col(cols="12" sm="5" md="4")
          v-select(
            v-model="appCategoryFilter"
            :items="['すべて', ...appCategories]"
            label="カテゴリ絞り込み"
            variant="outlined"
            density="compact"
            hide-details
          )

      //- 件数表示
      .d-flex.align-center.justify-space-between.mt-4.mb-2
        .text-caption.text-grey
          | 全 {{ appStore.list.length }} 件中 {{ filteredApps.length }} 件表示
        v-btn(
          variant="text"
          density="compact"
          size="small"
          prepend-icon="mdi-plus-circle-outline"
          color="primary"
          @click="openCreateModal('app')"
        ) アプリを追加

      //- アプリリスト
      .items-list.mt-2
        v-alert(
          v-if="filteredApps.length === 0"
          type="info"
          variant="tonal"
          rounded="lg"
        )
          | 該当するソフトウェアが見つかりませんでした。

        v-card.item-manage-card.mb-3.pa-3(
          v-for="app in filteredApps"
          :key="app.id"
          variant="outlined"
          rounded="xl"
        )
          .d-flex.align-start.gap-3
            //- アイコン
            .item-icon-box
              img.item-icon(
                :src="app.icon || '/icon.png'"
                :alt="app.name"
                onerror="this.src='/icon.png'"
              )

            //- 詳細メタデータ
            .flex-grow-1.overflow-hidden
              .d-flex.align-center.gap-2.flex-wrap
                .font-weight-bold.text-body-1.text-truncate {{ app.name }}
                v-chip(size="x-small" variant="flat" color="primary") {{ app.type === 'game' ? 'ゲーム' : 'アプリ' }}
                v-chip(size="x-small" variant="tonal") {{ app.category || 'ツール' }}
                v-chip(v-if="app.featured" size="x-small" color="warning" variant="flat")
                  v-icon(size="10" start) mdi-star
                  | 注目

              .text-caption.text-grey.mt-1
                span.font-weight-medium ID:
                code.mx-1 {{ app.id }}
                span.mx-1 •
                span {{ app.price ? `¥${app.price.toLocaleString()}` : '無料' }}
                span.mx-1 •
                span {{ app.developer || 'エノキ電気' }}

              p.text-caption.text-grey-darken-1.text-truncate.mt-1.mb-0(v-if="app.summary")
                | {{ app.summary }}

              //- プラットフォームタグ
              .platform-chips.mt-2(v-if="app.platforms && app.platforms.length")
                v-chip(
                  v-for="p in app.platforms"
                  :key="p"
                  size="x-small"
                  variant="outlined"
                  class="mr-1"
                ) {{ p }}

            //- アクションボタン群
            .item-actions.d-flex.flex-column.gap-1.align-end
              v-btn(
                icon="mdi-open-in-new"
                size="small"
                variant="text"
                color="grey-darken-1"
                @click="$router.push(`/apps/${app.id}`)"
              )
                v-icon(size="18") mdi-open-in-new
                v-tooltip(activator="parent" location="left") ページを開く

              v-btn(
                icon="mdi-pencil-outline"
                size="small"
                variant="tonal"
                color="primary"
                @click="openEditModal(app, 'app')"
              )
                v-icon(size="18") mdi-pencil-outline
                v-tooltip(activator="parent" location="left") 編集

              v-btn(
                icon="mdi-delete-outline"
                size="small"
                variant="tonal"
                color="error"
                @click="confirmDelete(app, 'app')"
              )
                v-icon(size="18") mdi-delete-outline
                v-tooltip(activator="parent" location="left") 削除

    //- ==================== 2. 音楽管理タブ ====================
    .tab-inner.pa-4(v-if="currentTab === 'music'")
      //- 検索 ＆ 絞り込みバー
      v-row(dense align="center")
        v-col(cols="12" sm="7" md="8")
          v-text-field(
            v-model="musicSearch"
            placeholder="楽曲名、アーティスト、アルバムで検索..."
            variant="outlined"
            density="compact"
            prepend-inner-icon="mdi-magnify"
            clearable
            hide-details
          )
        v-col(cols="12" sm="5" md="4")
          v-select(
            v-model="musicGenreFilter"
            :items="['すべて', ...musicGenres]"
            label="ジャンル絞り込み"
            variant="outlined"
            density="compact"
            hide-details
          )

      //- 件数表示
      .d-flex.align-center.justify-space-between.mt-4.mb-2
        .text-caption.text-grey
          | 全 {{ musicStore.list.length }} 件中 {{ filteredMusic.length }} 件表示
        v-btn(
          variant="text"
          density="compact"
          size="small"
          prepend-icon="mdi-plus-circle-outline"
          color="secondary"
          @click="openCreateModal('music')"
        ) 楽曲を追加

      //- 音楽リスト
      .items-list.mt-2
        v-alert(
          v-if="filteredMusic.length === 0"
          type="info"
          variant="tonal"
          rounded="lg"
        )
          | 該当する楽曲が見つかりませんでした。

        v-card.item-manage-card.mb-3.pa-3(
          v-for="track in filteredMusic"
          :key="track.id"
          variant="outlined"
          rounded="xl"
        )
          .d-flex.align-start.gap-3
            //- カバー画像 ＆ 再生ボタン
            .item-cover-box
              img.item-cover(
                :src="track.cover || track.icon || '/icon.png'"
                :alt="track.title"
                onerror="this.src='/icon.png'"
              )
              v-btn.cover-play-btn(
                :icon="isCurrentPlaying(track) ? 'mdi-pause' : 'mdi-play'"
                size="x-small"
                color="primary"
                variant="flat"
                @click="handleTrackPlayToggle(track)"
              )

            //- 詳細メタデータ
            .flex-grow-1.overflow-hidden
              .d-flex.align-center.gap-2.flex-wrap
                .font-weight-bold.text-body-1.text-truncate {{ track.title }}
                v-chip(size="x-small" variant="flat" color="secondary") {{ track.genre || 'J-Pop' }}
                v-chip(
                  v-if="track.audioUrl"
                  size="x-small"
                  color="success"
                  variant="tonal"
                )
                  v-icon(size="10" start) mdi-volume-high
                  | 音声ファイル連携済
                v-chip(
                  v-else
                  size="x-small"
                  color="grey"
                  variant="tonal"
                )
                  v-icon(size="10" start) mdi-volume-off
                  | 音声未登録
                v-chip(v-if="track.featured" size="x-small" color="warning" variant="flat")
                  v-icon(size="10" start) mdi-star
                  | 注目

              .text-caption.text-grey.mt-1
                span.font-weight-medium ID:
                code.mx-1 {{ track.id }}
                span.mx-1 •
                span {{ track.artist || 'エノキ電気' }}
                span.mx-1 •
                span {{ track.album || track.title }}
                span.mx-1 •
                span ⏱ {{ track.durationFormatted || formatTime(track.duration) }}

              p.text-caption.text-grey-darken-1.text-truncate.mt-1.mb-0(v-if="track.description")
                | {{ track.description }}

              //- 音声URLプレビュー
              .text-caption.text-grey.text-truncate.mt-1(v-if="track.audioUrl")
                v-icon(size="12" color="success") mdi-link-variant
                span.ml-1 {{ track.audioUrl }}

            //- アクションボタン群
            .item-actions.d-flex.flex-column.gap-1.align-end
              v-btn(
                icon="mdi-open-in-new"
                size="small"
                variant="text"
                color="grey-darken-1"
                @click="$router.push(`/music/${track.id}`)"
              )
                v-icon(size="18") mdi-open-in-new
                v-tooltip(activator="parent" location="left") ページを開く

              v-btn(
                icon="mdi-pencil-outline"
                size="small"
                variant="tonal"
                color="primary"
                @click="openEditModal(track, 'music')"
              )
                v-icon(size="18") mdi-pencil-outline
                v-tooltip(activator="parent" location="left") 編集

              v-btn(
                icon="mdi-delete-outline"
                size="small"
                variant="tonal"
                color="error"
                @click="confirmDelete(track, 'music')"
              )
                v-icon(size="18") mdi-delete-outline
                v-tooltip(activator="parent" location="left") 削除

    .bottom-spacer(style="height: 80px;")

  //- ================= 削除確認モーダル =================
  v-dialog(v-model="deleteDialog.open" max-width="480")
    v-card.delete-confirm-card(rounded="xl")
      v-card-title.d-flex.align-center.gap-2.pt-4.px-4
        v-icon(color="error" size="26") mdi-alert-circle-outline
        span.font-weight-bold {{ deleteDialog.type === 'app' ? 'アプリの削除' : '楽曲の削除' }}
      v-card-text.px-4.py-2
        p.mb-2
          | 「
          strong.text-primary {{ deleteDialog.item?.name || deleteDialog.item?.title }}
          | 」(ID: 
          code {{ deleteDialog.item?.id }}
          | ) を完全に削除しますか？
        v-alert(
          type="error"
          variant="tonal"
          density="compact"
          rounded="lg"
          class="mt-3"
        )
          | この操作を実行すると、MySQLデータベース ({{ deleteDialog.type === 'app' ? 'app_list' : 'music_list' }}) およびサーバー上のJSONデータから完全に削除されます。元に戻すことはできません。

      v-card-actions.pa-4.d-flex.justify-end.gap-2
        v-btn(
          variant="text"
          :disabled="deleteDialog.loading"
          @click="deleteDialog.open = false"
        ) キャンセル
        v-btn(
          color="error"
          variant="flat"
          rounded="pill"
          :loading="deleteDialog.loading"
          @click="executeDelete"
        ) 完全に削除する

  //- ================= 新規登録 / 編集モーダル =================
  AdminRegisterModal(
    v-model="modalOpen"
    :initialTab="modalTab"
    :editItem="editingItem"
    @registered="handleRegistered"
    @updated="handleUpdated"
  )

  //- スナックバー通知
  v-snackbar(v-model="snackbar.show" :color="snackbar.color" :timeout="4000")
    | {{ snackbar.message }}

</template>

<script lang="ts">
import { defineComponent } from 'vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'
import { useAppStore, type AppOrMusicItem } from '@/stores/app'
import { useMusicStore, type MusicItem } from '@/stores/music'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default defineComponent({
  name: 'AdminManagePage',
  components: {
    AdminRegisterModal,
  },
  mixins: [mixins],
  data() {
    return {
      currentTab: 'apps', // 'apps' | 'music'
      appStore: useAppStore(),
      musicStore: useMusicStore(),
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),

      // 検索・フィルタ
      appSearch: '',
      appCategoryFilter: 'すべて',
      musicSearch: '',
      musicGenreFilter: 'すべて',

      // 編集・登録モーダル状態
      modalOpen: false,
      modalTab: 'app',
      editingItem: null as any | null,

      // 削除ダイアログ状態
      deleteDialog: {
        open: false,
        loading: false,
        type: 'app' as 'app' | 'music',
        item: null as any | null,
      },

      // トースト
      snackbar: {
        show: false,
        message: '',
        color: 'success',
      },
    }
  },
  setup() {
    Setup.setTitle('コンテンツ管理 - 管理者')
    Setup.setDescription('エノキ電気 アプリ・音楽の一覧、編集、削除管理')
  },
  computed: {
    isAdmin(): boolean {
      return Boolean(
        this.myProfile.isAdmin ||
          this.myProfile.role === 'admin' ||
          (!this.myProfile.guest && this.myProfile.canRegisterApp),
      )
    },
    appCategories(): string[] {
      const set = new Set<string>()
      this.appStore.list.forEach((app) => {
        if (app.category) set.add(app.category)
      })
      return Array.from(set)
    },
    musicGenres(): string[] {
      const set = new Set<string>()
      this.musicStore.list.forEach((track) => {
        if (track.genre) set.add(track.genre)
      })
      return Array.from(set)
    },
    filteredApps(): AppOrMusicItem[] {
      let list = this.appStore.list
      if (this.appCategoryFilter && this.appCategoryFilter !== 'すべて') {
        list = list.filter((app) => app.category === this.appCategoryFilter)
      }
      if (this.appSearch.trim()) {
        const query = this.appSearch.toLowerCase().trim()
        list = list.filter((app) => {
          return (
            (app.name && app.name.toLowerCase().includes(query)) ||
            (app.id && app.id.toLowerCase().includes(query)) ||
            (app.summary && app.summary.toLowerCase().includes(query)) ||
            (app.category && app.category.toLowerCase().includes(query))
          )
        })
      }
      return list
    },
    filteredMusic(): MusicItem[] {
      let list = this.musicStore.list
      if (this.musicGenreFilter && this.musicGenreFilter !== 'すべて') {
        list = list.filter((track) => track.genre === this.musicGenreFilter)
      }
      if (this.musicSearch.trim()) {
        const query = this.musicSearch.toLowerCase().trim()
        list = list.filter((track) => {
          return (
            (track.title && track.title.toLowerCase().includes(query)) ||
            (track.name && track.name.toLowerCase().includes(query)) ||
            (track.id && track.id.toLowerCase().includes(query)) ||
            (track.artist && track.artist.toLowerCase().includes(query)) ||
            (track.album && track.album.toLowerCase().includes(query)) ||
            (track.genre && track.genre.toLowerCase().includes(query))
          )
        })
      }
      return list
    },
  },
  mounted() {
    this.setTitle('コンテンツ管理')

    // 管理者判定
    if (!this.isAdmin) {
      this.$router.replace('/login?redirect=/admin/manage')
      return
    }

    // クエリパラメータによるタブ初期化 (?tab=music または ?tab=app)
    const tabParam = this.$route.query.tab as string
    if (tabParam === 'music') {
      this.currentTab = 'music'
    } else if (tabParam === 'app' || tabParam === 'apps') {
      this.currentTab = 'apps'
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
    showToast(
      message: string,
      color: 'success' | 'error' | 'info' = 'success',
    ) {
      this.snackbar.message = message
      this.snackbar.color = color
      this.snackbar.show = true
    },
    formatTime(sec?: number): string {
      if (!sec) return '0:00'
      const m = Math.floor(sec / 60)
      const s = Math.floor(sec % 60)
      return `${m}:${s < 10 ? '0' : ''}${s}`
    },

    // 音楽再生トグル
    isCurrentPlaying(track: MusicItem): boolean {
      return (
        this.musicStore.currentTrack?.id === track.id &&
        this.musicStore.isPlaying
      )
    },
    handleTrackPlayToggle(track: MusicItem) {
      if (this.musicStore.currentTrack?.id === track.id) {
        this.musicStore.togglePlay()
      } else {
        this.musicStore.play(track)
      }
    },

    // モーダルオープン操作
    openCreateModal(type: 'app' | 'music' = 'app') {
      this.editingItem = null
      this.modalTab =
        type === 'music'
          ? 'music'
          : this.currentTab === 'music'
          ? 'music'
          : 'app'
      this.modalOpen = true
    },
    openEditModal(item: any, type: 'app' | 'music') {
      this.editingItem = item
      this.modalTab = type
      this.modalOpen = true
    },

    handleRegistered(payload: { type: string; item: any }) {
      this.showToast(
        payload.type === 'app'
          ? `アプリ「${payload.item.name}」を新しく登録しました！`
          : `楽曲「${payload.item.title}」を新しく登録しました！`,
        'success',
      )
    },
    handleUpdated(payload: { type: string; item: any }) {
      this.showToast(
        payload.type === 'app'
          ? `アプリ「${payload.item.name}」の情報を更新しました！`
          : `楽曲「${payload.item.title}」の情報を更新しました！`,
        'success',
      )
    },

    // 削除処理
    confirmDelete(item: any, type: 'app' | 'music') {
      this.deleteDialog.item = item
      this.deleteDialog.type = type
      this.deleteDialog.open = true
    },
    async executeDelete() {
      const item = this.deleteDialog.item
      const type = this.deleteDialog.type
      if (!item || !item.id) return

      this.deleteDialog.loading = true
      const authHeaders: Record<string, string> = {
        'Content-Type': 'application/json',
      }
      if (this.myProfile.userId) authHeaders['id'] = this.myProfile.userId
      if (this.myProfile.userToken)
        authHeaders['token'] = this.myProfile.userToken

      try {
        if (type === 'app') {
          // 1. PHP バックエンド (MySQL) から削除
          try {
            await fetch('/php/deleteApp.php', {
              method: 'POST',
              headers: authHeaders,
              body: JSON.stringify({ appId: item.id, id: item.id }),
            })
          } catch (phpErr) {
            console.warn('PHP deleteApp error:', phpErr)
          }

          // 2. Nitro サーバー側 (JSONファイル) から削除
          try {
            await fetch('/api/delete-app', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ appId: item.id, id: item.id }),
            })
          } catch (nitroErr) {
            console.warn('Nitro delete-app error:', nitroErr)
          }

          // 3. Pinia ストアから削除
          this.appStore.removeById(item.id)
          this.showToast(
            `アプリ「${item.name || item.id}」を削除しました`,
            'success',
          )
        } else {
          // 1. PHP バックエンド (MySQL) から削除
          try {
            await fetch('/php/deleteMusic.php', {
              method: 'POST',
              headers: authHeaders,
              body: JSON.stringify({ musicId: item.id, id: item.id }),
            })
          } catch (phpErr) {
            console.warn('PHP deleteMusic error:', phpErr)
          }

          // 2. Nitro サーバー側 (JSONファイル) から削除
          try {
            await fetch('/api/delete-music', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ musicId: item.id, id: item.id }),
            })
          } catch (nitroErr) {
            console.warn('Nitro delete-music error:', nitroErr)
          }

          // 3. Pinia ストアから削除
          this.musicStore.removeTrack(item.id)
          this.showToast(
            `楽曲「${item.title || item.name || item.id}」を削除しました`,
            'success',
          )
        }

        this.deleteDialog.open = false
      } catch (err: any) {
        console.error('Delete execution error:', err)
        this.showToast(`削除中にエラーが発生しました: ${err.message}`, 'error')
      } finally {
        this.deleteDialog.loading = false
      }
    },
  },
})
</script>

<style lang="scss" scoped>
.admin-manage-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  overflow: hidden;
  position: relative;
  background-color: rgb(var(--v-theme-background));
}

.manage-toolbar {
  flex-shrink: 0;
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}

.manage-tabs {
  flex-shrink: 0;
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  background-color: rgb(var(--v-theme-surface));
}

.manage-content-scroll {
  flex: 1;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

.tab-inner {
  width: 100%;
}

.item-manage-card {
  transition: all 0.2s ease;
  background-color: rgb(var(--v-theme-surface));
  border-color: rgba(var(--v-theme-on-surface), 0.1);

  &:hover {
    border-color: rgba(var(--v-theme-primary), 0.4);
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
  }
}

.item-icon-box {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
  background-color: rgba(var(--v-theme-on-surface), 0.05);

  .item-icon {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.item-cover-box {
  position: relative;
  width: 56px;
  height: 56px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
  background-color: rgba(var(--v-theme-on-surface), 0.05);

  .item-cover {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .cover-play-btn {
    position: absolute;
    bottom: 2px;
    right: 2px;
    opacity: 0.9;
  }
}

.delete-confirm-card {
  background-color: rgb(var(--v-theme-surface));
}
</style>
