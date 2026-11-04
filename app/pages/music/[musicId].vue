<template lang="pug">
v-card.music-detail-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
  :style="{ '--track-theme': track ? track.themeColor || '#4F46E5' : '#4F46E5' }"
)
  //- ================= 上部ツールバー =================
  v-toolbar.music-toolbar(density="compact" color="surface" elevation="1")
    v-btn(icon="mdi-arrow-left" variant="text" @click="handleBack")
    v-toolbar-title.text-subtitle-1 {{ track ? track.title : '楽曲詳細' }}
    v-spacer
    template(v-if="isAdmin && track")
      v-btn(icon="mdi-pencil-outline" color="primary" variant="text" @click="editModalOpen = true")
        v-icon mdi-pencil-outline
        v-tooltip(activator="parent" location="bottom") 編集 (管理者)
      v-btn(icon="mdi-delete-outline" color="error" variant="text" @click="deleteDialogOpen = true")
        v-icon mdi-delete-outline
        v-tooltip(activator="parent" location="bottom") 削除 (管理者)
    v-btn(
      v-if="track"
      icon
      variant="text"
      :color="isLiked ? 'error' : undefined"
      @click="toggleLike"
    )
      v-icon(:icon="isLiked ? 'mdi-heart' : 'mdi-heart-outline'")
    v-btn(icon="mdi-share-variant" variant="text" @click="shareTrack")

  //- 管理者向けアクションバナー
  v-alert.admin-action-banner.ma-3(
    v-if="isAdmin && track"
    color="primary"
    variant="tonal"
    density="compact"
    rounded="lg"
  )
    .d-flex.align-center.justify-space-between.flex-wrap.gap-2
      .d-flex.align-center.gap-2
        v-icon(size="18") mdi-shield-check
        span.font-weight-medium.text-caption 管理者権限: この楽曲の編集・削除が可能です
      .d-flex.gap-2
        v-btn(size="x-small" variant="text" prepend-icon="mdi-format-list-checks" @click="$router.push('/admin/manage?tab=music')") 管理一覧
        v-btn(size="x-small" color="primary" variant="flat" prepend-icon="mdi-pencil" @click="editModalOpen = true") 編集
        v-btn(size="x-small" color="error" variant="tonal" prepend-icon="mdi-delete" @click="deleteDialogOpen = true") 削除

  //- ================= メインスクロールエリア =================
  .music-scroll-content(v-if="track")
    //- 背景ブラーオーバーレイ
    .backdrop-glow

    .music-body
      //- ビュー切り替えタブ（プレイヤー / 歌詞 / 楽曲情報）
      .mode-toggle-chips
        v-chip(
          :variant="viewMode === 'player' ? 'flat' : 'text'"
          :color="viewMode === 'player' ? 'primary' : undefined"
          size="small"
          @click="viewMode = 'player'"
        ) プレイヤー
        v-chip(
          :variant="viewMode === 'lyrics' ? 'flat' : 'text'"
          :color="viewMode === 'lyrics' ? 'primary' : undefined"
          size="small"
          @click="viewMode = 'lyrics'"
        ) 歌詞
        v-chip(
          :variant="viewMode === 'info' ? 'flat' : 'text'"
          :color="viewMode === 'info' ? 'primary' : undefined"
          size="small"
          @click="viewMode = 'info'"
        ) 楽曲情報

      //- 1. プレイヤービュー
      .player-section(v-if="viewMode === 'player'")
        //- 大判カバーアート
        .artwork-container
          .artwork-glow
          img.artwork-img(:src="track.cover || track.icon" :alt="track.title" onerror="this.src='/icon.png'")

        //- 楽曲タイトル & アーティスト
        .track-meta
          h1.track-title {{ track.title }}
          p.track-artist {{ track.artist }}
          .track-tags
            span.genre-tag {{ track.genre }}
            span.album-tag {{ track.album }}

        //- シークバー
        .scrubber-container
          v-slider.scrubber-slider(
            v-model="sliderTime"
            :max="track.duration || 180"
            color="primary"
            track-color="rgba(var(--v-theme-on-surface), 0.2)"
            thumb-size="14"
            hide-details
            @start="isScrubbing = true"
            @end="onScrubberEnd"
          )
          .time-labels
            span.current-time {{ formatTime(isScrubbing ? sliderTime : musicStore.currentTime) }}
            span.duration-time {{ track.durationFormatted || formatTime(track.duration || 180) }}

        //- 再生コントロールボタン群
        .controls-row
          //- シャッフル
          v-btn.side-btn(
            icon
            variant="text"
            size="small"
            :color="musicStore.shuffle ? 'primary' : undefined"
            @click="musicStore.toggleShuffle"
          )
            v-icon(size="20") mdi-shuffle-variant

          //- 前の曲
          v-btn.main-ctrl-btn(
            icon="mdi-skip-previous"
            variant="text"
            size="large"
            @click="musicStore.prev"
          )

          //- 再生 / 一時停止（メイン巨大ボタン）
          v-btn.play-pause-btn(
            icon
            color="primary"
            size="x-large"
            elevation="6"
            @click="togglePlay"
          )
            v-icon(:icon="isPlayingThis ? 'mdi-pause' : 'mdi-play'" size="36" color="white")

          //- 次の曲
          v-btn.main-ctrl-btn(
            icon="mdi-skip-next"
            variant="text"
            size="large"
            @click="musicStore.next"
          )

          //- リピート
          v-btn.side-btn(
            icon
            variant="text"
            size="small"
            :color="musicStore.repeat !== 'off' ? 'primary' : undefined"
            @click="musicStore.cycleRepeat"
          )
            v-icon(size="20") {{ musicStore.repeat === 'one' ? 'mdi-repeat-once' : 'mdi-repeat' }}

        //- 音量スライダー
        .volume-row
          v-btn(icon variant="text" size="small" @click="musicStore.toggleMute")
            v-icon(size="20") {{ musicStore.isMuted || musicStore.volume === 0 ? 'mdi-volume-off' : 'mdi-volume-high' }}
          v-slider(
            v-model="musicStore.volume"
            :max="1"
            :step="0.01"
            color="primary"
            track-color="rgba(var(--v-theme-on-surface), 0.2)"
            hide-details
            thumb-size="12"
          )

      //- 2. 歌詞ビュー
      .lyrics-section(v-else-if="viewMode === 'lyrics'")
        .lyrics-box
          h2.lyrics-heading 歌詞
          p.lyrics-lead {{ track.title }} - {{ track.artist }}
          .lyrics-content {{ track.lyrics || '歌詞情報は登録されていません。' }}

      //- 3. 楽曲情報ビュー
      .info-section(v-else)
        .info-card
          h2.info-heading 楽曲詳細情報
          .info-list
            .info-item
              span.label タイトル
              span.value {{ track.title }}
            .info-item
              span.label アーティスト
              span.value {{ track.artist }}
            .info-item
              span.label 収録アルバム
              span.value {{ track.album }} ({{ track.albumType.toUpperCase() }})
            .info-item
              span.label ジャンル
              span.value {{ track.genre }}
            .info-item
              span.label 作曲 / 編曲
              span.value {{ track.composer || 'ときえのき' }}
            .info-item
              span.label 作詞
              span.value {{ track.lyricist || 'ときえのき' }}
            .info-item
              span.label BPM
              span.value {{ track.bpm }}
            .info-item
              span.label 音源エンジン
              span.value Web Audio API Synth ({{ track.audioPreset }})
            .info-item
              span.label リリース日
              span.value {{ track.releaseDateFormatted }}
            .info-item(v-if="track.description")
              span.label ライナーノーツ
              span.value.pre-line {{ track.description }}

      //- 関連楽曲棚
      .related-music-section(v-if="relatedTracks.length > 0")
        h3.section-title 関連する{{ track.genre }}楽曲
        .related-music-grid
          MusicCard(
            v-for="item in relatedTracks"
            :key="item.id"
            :item="item"
            :isPlaying="musicStore.isPlaying"
            :currentTrackId="musicStore.currentTrack?.id || ''"
            @click="goToOtherTrack(item)"
            @play="musicStore.play(item)"
          )

    .bottom-spacer

  //- 楽曲が見つからなかった場合
  .not-found-view(v-else)
    v-icon(size="64" color="grey") mdi-music-note-off
    h2 楽曲が見つかりませんでした
    p お探しの楽曲は存在しないか、削除された可能性があります。
    v-btn(
      color="primary"
      rounded="pill"
      prepend-icon="mdi-arrow-left"
      @click="$router.push('/music')"
    ) 音楽一覧へ戻る

  //- 削除確認モーダル
  v-dialog(v-model="deleteDialogOpen" max-width="480")
    v-card(rounded="xl")
      v-card-title.d-flex.align-center.gap-2.pt-4.px-4
        v-icon(color="error" size="26") mdi-alert-circle-outline
        span.font-weight-bold 楽曲の削除
      v-card-text.px-4.py-2
        p.mb-2
          | 「
          strong.text-primary {{ track?.title }}
          | 」(ID: 
          code {{ track?.id }}
          | ) を完全に削除しますか？
        v-alert(
          type="error"
          variant="tonal"
          density="compact"
          rounded="lg"
          class="mt-3"
        )
          | MySQLデータベース (music_list) および永続化ファイルから完全に削除されます。元に戻すことはできません。
      v-card-actions.pa-4.d-flex.justify-end.gap-2
        v-btn(variant="text" :disabled="deleteDialogLoading" @click="deleteDialogOpen = false") キャンセル
        v-btn(color="error" variant="flat" rounded="pill" :loading="deleteDialogLoading" @click="handleDeleteTrack") 削除する

  //- 編集モーダル
  AdminRegisterModal(
    v-model="editModalOpen"
    initialTab="music"
    :editItem="track"
    @updated="onTrackUpdated"
  )
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { useMusicStore, type MusicItem } from '@/stores/music'
import { useSettingsStore } from '@/stores/settings'
import MusicCard from '@/components/music/MusicCard.vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'
import { useMyProfileStore } from '@/stores/myProfile'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'MusicDetailPage',
  components: {
    MusicCard,
    AdminRegisterModal,
  },
  mixins: [mixins],
  data() {
    return {
      musicStore: useMusicStore(),
      settings: useSettingsStore(),
      myProfile: useMyProfileStore(),
      editModalOpen: false,
      deleteDialogOpen: false,
      deleteDialogLoading: false,
      viewMode: 'player' as 'player' | 'lyrics' | 'info',
      sliderTime: 0,
      isScrubbing: false,
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
    musicId(): string {
      return (this.$route.params.musicId as string) || ''
    },
    track(): MusicItem | undefined {
      return this.musicStore.list.find((item) => item.id === this.musicId)
    },
    isPlayingThis(): boolean {
      return (
        this.musicStore.isPlaying &&
        this.musicStore.currentTrack?.id === this.track?.id
      )
    },
    isLiked(): boolean {
      if (!this.track) return false
      return this.musicStore.isLiked(this.track.id)
    },
    relatedTracks(): MusicItem[] {
      if (!this.track) return []
      return this.musicStore.list
        .filter((t) => t.id !== this.track?.id && t.genre === this.track?.genre)
        .slice(0, 8)
    },
  },
  setup() {
    const route = useRoute()
    const musicStore = useMusicStore()
    const musicId = (route.params.musicId as string) || ''
    const track = musicStore.list.find((i) => i.id === musicId)
    if (track) {
      Setup.setTitle(`${track.title} - エノキ電気 音楽`)
      Setup.setDescription(track.description || `${track.title} - ${track.artist}`)
    } else {
      Setup.setTitle('音楽詳細 - エノキ電気')
    }
  },
  watch: {
    'musicStore.currentTime'(val) {
      if (!this.isScrubbing) {
        this.sliderTime = Math.floor(val)
      }
    },
    track(newTrack) {
      if (newTrack && typeof document !== 'undefined') {
        this.setTitle(newTrack.title)
      }
    },
  },
  created() {
    if (!this.musicStore.list || this.musicStore.list.length === 0) {
      this.musicStore.loadMockData(true)
    }
  },
  mounted() {
    if (this.track) {
      this.setTitle(this.track.title)
      // もし現在再生中の曲と異なり、まだ何も再生していない場合は自動でこの曲をセット（再生はユーザー操作）
      if (!this.musicStore.currentTrack) {
        this.musicStore.currentTrack = this.track
      }
    }
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/music')
      }
    },
    goToOtherTrack(item: MusicItem) {
      this.$router.push(`/music/${item.id}`)
    },
    togglePlay() {
      if (!this.track) return
      if (this.musicStore.currentTrack?.id === this.track.id) {
        this.musicStore.togglePlay()
      } else {
        this.musicStore.play(this.track)
      }
    },
    toggleLike() {
      if (this.track) {
        this.musicStore.toggleLike(this.track.id)
      }
    },
    onScrubberEnd() {
      this.musicStore.seekTo(this.sliderTime)
      this.isScrubbing = false
    },
    formatTime(sec: number): string {
      const s = Math.floor(sec || 0)
      const m = Math.floor(s / 60)
      const rest = s % 60
      return `${m}:${rest < 10 ? '0' : ''}${rest}`
    },
    async shareTrack() {
      if (!this.track) return
      const url = `https://enoki.xyz/music/${this.track.id}`
      try {
        await Share.share({
          title: `${this.track.title} - ${this.track.artist}`,
          text: `エノキ電気 音楽配信: ${this.track.title}`,
          url: url,
          dialogTitle: `${this.track.title} を共有`,
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText(url)
          await Toast.show({ text: '楽曲URLをコピーしました' })
        }
      }
    },
    async handleDeleteTrack() {
      if (!this.track || !this.track.id) return
      this.deleteDialogLoading = true
      const authHeaders: Record<string, string> = {
        'Content-Type': 'application/json',
      }
      if (this.myProfile.userId) authHeaders['id'] = this.myProfile.userId
      if (this.myProfile.userToken) authHeaders['token'] = this.myProfile.userToken

      const trackId = this.track.id
      const trackTitle = this.track.title
      try {
        // 1. PHP MySQL 削除
        try {
          await fetch('/php/deleteMusic.php', {
            method: 'POST',
            headers: authHeaders,
            body: JSON.stringify({ musicId: trackId, id: trackId }),
          })
        } catch (phpErr) {
          console.warn('PHP deleteMusic error:', phpErr)
        }

        // 2. Nitro JSON 永続化ファイル削除
        try {
          await fetch('/api/delete-music', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ musicId: trackId, id: trackId }),
          })
        } catch (nitroErr) {
          console.warn('Nitro delete-music error:', nitroErr)
        }

        // 3. Pinia Store から削除
        this.musicStore.removeTrack(trackId)
        try {
          await Toast.show({ text: `「${trackTitle}」を削除しました` })
        } catch (_) {}

        this.deleteDialogOpen = false
        this.$router.push('/music')
      } catch (err: any) {
        console.error('Delete track error:', err)
      } finally {
        this.deleteDialogLoading = false
      }
    },
    onTrackUpdated(payload: any) {
      if (payload?.item) {
        this.setTitle(payload.item.title)
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.music-detail-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  overflow: hidden;
  position: relative;
  background-color: rgb(var(--v-theme-surface));

  .music-toolbar {
    flex-shrink: 0;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    z-index: 10;
  }

  .backdrop-glow {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 350px;
    background: radial-gradient(circle at 50% 20%, var(--track-theme), transparent 70%);
    opacity: 0.25;
    pointer-events: none;
    z-index: 1;
  }

  .music-scroll-content {
    flex: 1;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    position: relative;
    z-index: 2;
  }

  .music-body {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px 20px 40px 20px;
    display: flex;
    flex-direction: column;
    gap: 20px;
  }

  .mode-toggle-chips {
    display: flex;
    justify-content: center;
    gap: 8px;
  }

  .player-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 18px;

    .artwork-container {
      position: relative;
      width: 240px;
      height: 240px;
      margin-top: 10px;

      .artwork-glow {
        position: absolute;
        inset: -12px;
        background: var(--track-theme);
        filter: blur(28px);
        opacity: 0.45;
        border-radius: 36px;
      }

      .artwork-img {
        position: relative;
        width: 100%;
        height: 100%;
        border-radius: 24px;
        object-fit: cover;
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.35);
      }
    }

    .track-meta {
      text-align: center;
      width: 100%;

      .track-title {
        font-size: 1.45rem;
        font-weight: 800;
        line-height: 1.25;
      }

      .track-artist {
        font-size: 1.05rem;
        color: rgb(var(--v-theme-primary));
        font-weight: 600;
        margin-top: 4px;
      }

      .track-tags {
        display: flex;
        justify-content: center;
        gap: 6px;
        margin-top: 8px;
        flex-wrap: wrap;

        span {
          font-size: 11px;
          padding: 2px 8px;
          border-radius: 6px;
          background: rgba(var(--v-theme-on-surface), 0.08);
          font-weight: 600;
        }
      }
    }

    .scrubber-container {
      width: 100%;
      padding: 0 8px;

      .scrubber-slider {
        margin: 0;
      }

      .time-labels {
        display: flex;
        justify-content: space-between;
        font-size: 11px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        margin-top: -6px;
      }
    }

    .controls-row {
      display: flex;
      align-items: center;
      justify-content: space-around;
      width: 100%;
      max-width: 380px;

      .play-pause-btn {
        width: 64px;
        height: 64px;
      }
    }

    .volume-row {
      display: flex;
      align-items: center;
      gap: 12px;
      width: 100%;
      max-width: 300px;
      opacity: 0.85;
    }
  }

  .lyrics-section {
    .lyrics-box {
      background: rgba(var(--v-theme-on-surface), 0.04);
      border-radius: 20px;
      padding: 24px;
      border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

      .lyrics-heading {
        font-size: 1.2rem;
        font-weight: 800;
        margin-bottom: 4px;
      }

      .lyrics-lead {
        font-size: 0.85rem;
        color: rgba(var(--v-theme-on-surface), 0.6);
        margin-bottom: 16px;
      }

      .lyrics-content {
        font-size: 1rem;
        line-height: 2;
        white-space: pre-line;
        color: rgb(var(--v-theme-on-surface));
      }
    }
  }

  .info-section {
    .info-card {
      background: rgba(var(--v-theme-on-surface), 0.04);
      border-radius: 20px;
      padding: 24px;
      border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

      .info-heading {
        font-size: 1.2rem;
        font-weight: 800;
        margin-bottom: 16px;
      }

      .info-list {
        display: flex;
        flex-direction: column;
        gap: 12px;

        .info-item {
          display: flex;
          justify-content: space-between;
          font-size: 13.5px;
          border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.06);
          padding-bottom: 8px;

          .label {
            font-weight: 700;
            color: rgba(var(--v-theme-on-surface), 0.65);
            flex-shrink: 0;
            margin-right: 12px;
          }

          .value {
            font-weight: 600;
            text-align: right;
            word-break: break-word;

            &.pre-line {
              white-space: pre-line;
              text-align: left;
            }
          }
        }
      }
    }
  }

  .related-music-section {
    margin-top: 10px;

    .section-title {
      font-size: 1.1rem;
      font-weight: 800;
      margin-bottom: 12px;
    }

    .related-music-grid {
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
