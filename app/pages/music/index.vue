<template lang="pug">
v-card.music-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- ================= トップ検索バーヘッダー =================
  .store-top-bar
    .search-pill
      v-icon.search-icon mdi-magnify
      input.search-input(
        v-model="searchQuery"
        placeholder="楽曲、アーティスト、アルバムを検索"
      )
      v-btn(
        v-if="searchQuery"
        icon="mdi-close"
        size="x-small"
        variant="text"
        @click="searchQuery = ''"
      )
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

  //- ================= メインスクロールエリア =================
  .store-scroll-content(ref="scrollContainer")

    //- 検索結果表示モード
    .search-results-view(v-if="searchQuery")
      .search-header
        .search-title 「{{ searchQuery }}」の楽曲検索結果 ({{ musicSearchResults.length }}件)
      .results-list(v-if="musicSearchResults.length > 0")
        MusicTrackRow(
          v-for="(item, idx) in musicSearchResults"
          :key="item.id"
          :item="item"
          :rank="idx + 1"
          :isPlaying="musicStore.isPlaying"
          :currentTrackId="musicStore.currentTrack?.id || ''"
          :isLiked="musicStore.isLiked(item.id)"
          @click="openTrackDetail(item)"
          @play="musicStore.play(item, musicSearchResults)"
          @like="musicStore.toggleLike($event)"
        )
      .no-results(v-else)
        v-icon(size="48" color="grey") mdi-music-note-off
        p 一致する楽曲やアーティストが見つかりませんでした

    //- 通常モード（Spotify / Apple Music風 MusicView）
    .music-content-view(v-else)
      MusicView

    //- 下部ナビゲーションバー用の余白
    .bottom-nav-spacer

  //- 管理者用 コンテンツ管理FABボタン
  v-btn.admin-manage-fab(
    v-if="isAdmin"
    color="surface"
    icon="mdi-format-list-checks"
    size="large"
    elevation="4"
    @click="$router.push('/admin/manage?tab=music')"
  )
    v-icon(size="24" color="secondary") mdi-format-list-checks
    v-tooltip(activator="parent" location="left") 音楽管理・編集・削除

  //- 管理者用 音楽登録FABボタン
  v-btn.admin-register-fab(
    v-if="isAdmin"
    color="primary"
    icon="mdi-plus"
    size="large"
    elevation="4"
    @click="adminRegisterModalOpen = true"
  )
    v-icon(size="28") mdi-plus
    v-tooltip(activator="parent" location="left") 音楽を登録 (管理者)

  //- 管理者コンテンツ登録モーダル
  AdminRegisterModal(
    v-model="adminRegisterModalOpen"
    initialTab="music"
  )

</template>

<script lang="ts">
import HeroProfile from '@/components/common/HeroProfile.vue'
import { useNavigationStore } from '@/stores/navigation'
import MusicView from '@/components/music/MusicView.vue'
import MusicTrackRow from '@/components/music/MusicTrackRow.vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'
import { useMusicStore, type MusicItem } from '@/stores/music'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'MusicPage',
  components: {
    HeroProfile,
    MusicView,
    MusicTrackRow,
    AdminRegisterModal,
  },
  mixins: [mixins],
  data() {
    return {
      searchQuery: '',
      navStore: useNavigationStore(),
      adminRegisterModalOpen: false,
      musicStore: useMusicStore(),
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
    }
  },
  setup() {
    Setup.setTitle('音楽')
    Setup.setDescription(
      'エノキ電気の公式音楽・ボカロ曲・インスト楽曲一覧。リアルタイム視聴・歌詞・楽曲情報が楽しめます。',
    )
  },
  computed: {
    isAdmin(): boolean {
      return Boolean(
        this.myProfile.isAdmin ||
        this.myProfile.role === 'admin' ||
        (!this.myProfile.guest && this.myProfile.canRegisterApp)
      )
    },
    musicSearchResults(): MusicItem[] {
      const q = this.searchQuery.trim().toLowerCase()
      if (!q) return []
      return this.musicStore.list.filter((item) => {
        const titleMatch = (item.title || item.name || '')
          .toLowerCase()
          .includes(q)
        const artistMatch = (item.artist || '').toLowerCase().includes(q)
        const albumMatch = (item.album || '').toLowerCase().includes(q)
        const genreMatch = (item.genre || '').toLowerCase().includes(q)
        return titleMatch || artistMatch || albumMatch || genreMatch
      })
    },
  },
  mounted() {
    this.setTitle('音楽')
    if (!this.musicStore.list || this.musicStore.list.length === 0) {
      this.musicStore.loadMockData(true)
    }
  },
  methods: {
    openTrackDetail(item: MusicItem) {
      this.$router.push(`/music/${item.id}`)
    },
  },
}
</script>

<style lang="scss" scoped>
.music-page-root {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  height: 100%;
  height: 100dvh;
  position: relative;
  background-color: rgb(var(--v-theme-surface));

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
      border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

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

  .store-scroll-content {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    -webkit-overflow-scrolling: touch;
    padding-bottom: 24px;
  }

  .search-results-view {
    padding: 16px;

    .search-header {
      margin-bottom: 12px;
      .search-title {
        font-size: 1.05rem;
        font-weight: 700;
        color: rgb(var(--v-theme-on-surface));
      }
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

  .bottom-nav-spacer {
    height: 72px;
  }
}
</style>
