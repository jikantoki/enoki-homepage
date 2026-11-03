<template lang="pug">
v-dialog(
  v-model="isOpen"
  transition="dialog-bottom-transition"
  fullscreen
)
  .now-playing-container(
    v-if="track"
    :style="{ '--track-theme': track.themeColor || '#4F46E5' }"
  )
    //- 背景ブラーグラデーション
    .backdrop-gradient

    //- ヘッダーバー
    .modal-header
      v-btn(
        icon="mdi-chevron-down"
        variant="text"
        color="white"
        @click="close"
      )
      .header-title-group
        span.header-sub-label 再生中
        span.header-album-name {{ track.album }}
      v-btn(
        icon="mdi-dots-horizontal"
        variant="text"
        color="white"
        @click="showTrackInfo = !showTrackInfo"
      )

    //- コンテンツエリア
    .modal-body
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
      .player-view(v-if="viewMode === 'player'")
        //- 大判カバーアート
        .artwork-container
          .artwork-glow(:style="{ background: track.themeColor || '#4F46E5' }")
          img.artwork-img(:src="track.cover || track.icon" :alt="track.title")

        //- 楽曲情報 & お気に入り
        .meta-row
          .title-area
            h1.song-main-title {{ track.title || track.name }}
            p.song-main-artist {{ track.artist }}
          v-btn.like-btn(
            icon
            variant="text"
            size="large"
            :color="isLiked ? 'error' : 'white'"
            @click="toggleLike"
          )
            v-icon(:icon="isLiked ? 'mdi-heart' : 'mdi-heart-outline'" size="28")

        //- シークバー
        .scrubber-container
          v-slider.scrubber-slider(
            v-model="sliderTime"
            :max="track.duration || 180"
            :step="1"
            color="white"
            track-color="rgba(255, 255, 255, 0.2)"
            thumb-size="12"
            hide-details
            @start="isScrubbing = true"
            @end="onScrubEnd"
          )
          .time-labels
            span {{ formatTime(displayTime) }}
            span -{{ formatTime(remainingTime) }}

        //- メイン再生コントロール
        .playback-controls
          v-btn(
            icon
            variant="text"
            :color="musicStore.shuffle ? 'primary' : 'white'"
            size="small"
            @click="musicStore.toggleShuffle()"
          )
            v-icon(icon="mdi-shuffle" size="22")

          v-btn(
            icon
            variant="text"
            color="white"
            size="large"
            @click="musicStore.prev()"
          )
            v-icon(icon="mdi-skip-previous" size="36")

          v-btn.main-play-btn(
            icon
            color="white"
            size="x-large"
            elevation="6"
            @click="musicStore.togglePlay()"
          )
            v-icon(:icon="musicStore.isPlaying ? 'mdi-pause' : 'mdi-play'" size="38" color="black")

          v-btn(
            icon
            variant="text"
            color="white"
            size="large"
            @click="musicStore.next()"
          )
            v-icon(icon="mdi-skip-next" size="36")

          v-btn(
            icon
            variant="text"
            :color="musicStore.repeat !== 'off' ? 'primary' : 'white'"
            size="small"
            @click="musicStore.toggleRepeat()"
          )
            v-icon(:icon="musicStore.repeat === 'one' ? 'mdi-repeat-once' : 'mdi-repeat'" size="22")

        //- ボリュームコントロール
        .volume-row
          v-icon(
            :icon="musicStore.isMuted || musicStore.volume === 0 ? 'mdi-volume-off' : 'mdi-volume-medium'"
            size="20"
            color="rgba(255, 255, 255, 0.7)"
            @click="musicStore.toggleMute()"
            style="cursor: pointer;"
          )
          v-slider.volume-slider(
            v-model="volumeModel"
            :min="0"
            :max="1"
            :step="0.01"
            color="white"
            track-color="rgba(255, 255, 255, 0.2)"
            thumb-size="10"
            hide-details
            @update:model-value="onVolumeChange"
          )
          v-icon(icon="mdi-volume-high" size="20" color="rgba(255, 255, 255, 0.7)")

      //- 2. 歌詞ビュー
      .lyrics-view(v-else-if="viewMode === 'lyrics'")
        .lyrics-scroll
          p.lyrics-header {{ track.title }} - 歌詞
          .lyrics-body
            p.lyrics-line(
              v-for="(line, idx) in parsedLyrics"
              :key="idx"
              :class="{ empty: !line.text, active: currentLyricIndex === idx }"
            ) {{ line.text || '♪' }}

      //- 3. 楽曲情報ビュー
      .info-view(v-else-if="viewMode === 'info'")
        .info-card
          .info-header
            img.info-thumb(:src="track.cover || track.icon")
            .info-titles
              h3 {{ track.title }}
              p {{ track.artist }}
              span.info-genre-chip {{ track.genre }}

          v-divider.my-4(color="rgba(255, 255, 255, 0.15)")

          .info-details-list
            .info-detail-item
              span.label アルバム
              span.value {{ track.album }} ({{ track.albumType.toUpperCase() }})
            .info-detail-item
              span.label 作詞・作曲
              span.value {{ track.lyricist }} / {{ track.composer }}
            .info-detail-item
              span.label リリース日
              span.value {{ track.releaseDateFormatted }}
            .info-detail-item
              span.label 再生回数
              span.value {{ track.plays }} 回
            .info-detail-item
              span.label BPM / 音源
              span.value {{ track.bpm }} BPM / {{ track.audioPreset }}
            .info-detail-item
              span.label レーティング
              span.value ★ {{ track.rating }} / 5.0

          v-divider.my-4(color="rgba(255, 255, 255, 0.15)")

          .description-box
            h4 楽曲解説 / ライナーノーツ
            p {{ track.description }}
</template>

<script lang="ts">
import { useMusicStore, type MusicItem } from '@/stores/music'

export default {
  name: 'NowPlayingModal',
  setup() {
    const musicStore = useMusicStore()
    return { musicStore }
  },
  data() {
    return {
      viewMode: 'player' as 'player' | 'lyrics' | 'info',
      showTrackInfo: false,
      isScrubbing: false,
      sliderTime: 0,
      volumeModel: 0.8,
    }
  },
  computed: {
    isOpen: {
      get(): boolean {
        return this.musicStore.nowPlayingModalOpen
      },
      set(val: boolean) {
        this.musicStore.nowPlayingModalOpen = val
      },
    },
    track(): MusicItem | null {
      return this.musicStore.currentTrack
    },
    isLiked(): boolean {
      return this.musicStore.isCurrentLiked
    },
    displayTime(): number {
      if (this.isScrubbing) return this.sliderTime
      return this.musicStore.currentTime
    },
    remainingTime(): number {
      if (!this.track) return 0
      return Math.max(0, this.track.duration - this.displayTime)
    },
    parsedLyrics(): Array<{ time: number; text: string }> {
      if (!this.track || !this.track.lyrics) return []
      return this.track.lyrics.split('\n').map(line => {
        const match = line.match(/^\[(\d{2}):(\d{2}\.\d{2})\](.*)$/)
        if (match) {
          const mins = parseInt(match[1], 10)
          const secs = parseFloat(match[2])
          return { time: mins * 60 + secs, text: match[3].trim() }
        }
        return { time: 0, text: line.trim() }
      })
    },
    currentLyricIndex(): number {
      const currentTime = this.musicStore.currentTime
      const lyrics = this.parsedLyrics
      for (let i = lyrics.length - 1; i >= 0; i--) {
        if (lyrics[i].time > 0 && currentTime >= lyrics[i].time) {
          return i
        }
      }
      return -1
    },
  },
  watch: {
    'musicStore.currentTime'(val: number) {
      if (!this.isScrubbing) {
        this.sliderTime = val
      }
    },
    'musicStore.volume'(val: number) {
      this.volumeModel = val
    },
  },
  mounted() {
    this.volumeModel = this.musicStore.volume
  },
  methods: {
    close() {
      this.musicStore.closeNowPlaying()
    },
    toggleLike() {
      if (this.track) {
        this.musicStore.toggleLike(this.track.id)
      }
    },
    onScrubEnd() {
      this.isScrubbing = false
      this.musicStore.seek(this.sliderTime)
    },
    onVolumeChange(val: number) {
      this.musicStore.setVolume(val)
    },
    formatTime(seconds: number): string {
      const s = Math.floor(seconds)
      const mins = Math.floor(s / 60)
      const secs = s % 60
      return `${mins}:${secs < 10 ? '0' : ''}${secs}`
    },
  },
}
</script>

<style lang="scss" scoped>
.now-playing-container {
  position: relative;
  width: 100%;
  height: 100%;
  background-color: #0b0b12;
  color: #ffffff;
  display: flex;
  flex-direction: column;
  overflow: hidden;

  .backdrop-gradient {
    position: absolute;
    top: -20%;
    left: -20%;
    width: 140%;
    height: 140%;
    background: radial-gradient(
      circle at 50% 30%,
      var(--track-theme, #4F46E5) 0%,
      rgba(15, 15, 26, 0.95) 60%,
      #09090f 100%
    );
    opacity: 0.65;
    filter: blur(80px);
    pointer-events: none;
    z-index: 1;
  }

  .modal-header {
    position: relative;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 16px;

    .header-title-group {
      display: flex;
      flex-direction: column;
      align-items: center;
      max-width: 60%;

      .header-sub-label {
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: rgba(255, 255, 255, 0.6);
        font-weight: 600;
      }

      .header-album-name {
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 100%;
      }
    }
  }

  .modal-body {
    position: relative;
    z-index: 10;
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    padding: 8px 24px 24px 24px;
    max-width: 500px;
    margin: 0 auto;
    width: 100%;

    .mode-toggle-chips {
      display: flex;
      justify-content: center;
      gap: 8px;
      margin-bottom: 16px;
    }

    // 1. プレイヤービュー
    .player-view {
      display: flex;
      flex-direction: column;
      flex: 1;
      justify-content: space-around;

      .artwork-container {
        position: relative;
        width: 100%;
        max-width: 320px;
        aspect-ratio: 1 / 1;
        margin: 0 auto 16px auto;

        .artwork-glow {
          position: absolute;
          top: 10%;
          left: 10%;
          width: 80%;
          height: 80%;
          border-radius: 24px;
          filter: blur(28px);
          opacity: 0.5;
        }

        .artwork-img {
          position: relative;
          width: 100%;
          height: 100%;
          border-radius: 16px;
          object-fit: cover;
          box-shadow: 0 12px 36px rgba(0, 0, 0, 0.5);
        }
      }

      .meta-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;

        .title-area {
          flex: 1;
          min-width: 0;

          .song-main-title {
            font-size: 20px;
            font-weight: 800;
            line-height: 1.25;
            margin: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }

          .song-main-artist {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.7);
            margin: 4px 0 0 0;
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
        }
      }

      .scrubber-container {
        margin-bottom: 12px;

        .time-labels {
          display: flex;
          justify-content: space-between;
          font-size: 11px;
          color: rgba(255, 255, 255, 0.55);
          font-weight: 600;
          margin-top: 4px;
        }
      }

      .playback-controls {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 8px;
        margin-bottom: 20px;

        .main-play-btn {
          width: 64px;
          height: 64px;
          border-radius: 50%;
        }
      }

      .volume-row {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 0 8px;

        .volume-slider {
          flex: 1;
        }
      }
    }

    // 2. 歌詞ビュー
    .lyrics-view {
      flex: 1;
      overflow-y: auto;
      padding: 12px 4px;

      .lyrics-scroll {
        .lyrics-header {
          font-size: 13px;
          color: rgba(255, 255, 255, 0.5);
          font-weight: 600;
          margin-bottom: 20px;
          text-align: center;
        }

        .lyrics-body {
          display: flex;
          flex-direction: column;
          gap: 16px;

          .lyrics-line {
            font-size: 20px;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.35);
            transition: color 0.25s, transform 0.25s;
            line-height: 1.4;

            &.active {
              color: #ffffff;
              transform: scale(1.04);
            }

            &.empty {
              opacity: 0.2;
            }
          }
        }
      }
    }

    // 3. 楽曲情報ビュー
    .info-view {
      flex: 1;
      overflow-y: auto;
      padding: 12px 4px;

      .info-card {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        padding: 20px;
        backdrop-filter: blur(10px);

        .info-header {
          display: flex;
          gap: 16px;
          align-items: center;

          .info-thumb {
            width: 72px;
            height: 72px;
            border-radius: 12px;
            object-fit: cover;
          }

          .info-titles {
            h3 { font-size: 18px; font-weight: 800; margin: 0; }
            p { font-size: 13px; color: rgba(255, 255, 255, 0.7); margin: 2px 0 6px 0; }
            .info-genre-chip {
              font-size: 11px;
              background: rgb(var(--v-theme-primary));
              color: white;
              padding: 2px 8px;
              border-radius: 9999px;
              font-weight: 600;
            }
          }
        }

        .info-details-list {
          display: flex;
          flex-direction: column;
          gap: 10px;

          .info-detail-item {
            display: flex;
            justify-content: space-between;
            font-size: 13px;

            .label { color: rgba(255, 255, 255, 0.6); }
            .value { font-weight: 600; color: #ffffff; }
          }
        }

        .description-box {
          h4 { font-size: 14px; font-weight: 700; margin: 0 0 6px 0; }
          p { font-size: 13px; color: rgba(255, 255, 255, 0.8); line-height: 1.6; margin: 0; }
        }
      }
    }
  }
}
</style>
