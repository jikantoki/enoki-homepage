<template lang="pug">
.mini-player-wrapper(
  v-if="currentTrack"
  :style="{ bottom: bottomOffset + 'px' }"
  @click="openModal"
)
  //- 最上部のプログレスバー
  .progress-bar-container
    .progress-fill(:style="{ width: progressPercent + '%' }")

  .player-inner
    //- 左側: カバーアート + タイトル
    .track-info
      .cover-wrapper
        img.cover-img(:src="currentTrack.cover || currentTrack.icon" :alt="currentTrack.title")
        .playing-halo(v-if="isPlaying")

      .title-group
        .track-title
          span.title-text {{ currentTrack.title || currentTrack.name }}
          v-chip.unfinished-mini-chip(
            v-if="isUnfinished"
            size="x-small"
            color="warning"
            variant="flat"
            density="compact"
          ) 未完成
        .track-artist(:class="{ 'text-error': !!playError }") {{ playError || currentTrack.artist }}

    //- 右側: コントロール
    .player-controls(@click.stop)
      //- お気に入り
      v-btn.control-btn(
        icon
        size="small"
        variant="text"
        :color="isLiked ? 'error' : undefined"
        @click="toggleLike"
      )
        v-icon(:icon="isLiked ? 'mdi-heart' : 'mdi-heart-outline'" size="20")

      //- 前の曲（中画面以上）
      v-btn.control-btn(
        icon="mdi-skip-previous"
        size="small"
        variant="text"
        @click="prev"
      )

      //- 再生 / 一時停止
      v-btn.play-toggle-btn(
        icon
        color="primary"
        size="small"
        elevation="2"
        @click="togglePlay"
      )
        v-icon(:icon="isPlaying ? 'mdi-pause' : 'mdi-play'" size="22" color="white")

      //- 次の曲
      v-btn.control-btn(
        icon="mdi-skip-next"
        size="small"
        variant="text"
        @click="next"
      )
</template>

<script lang="ts">
import { useMusicStore, isTrackUnfinished } from '@/stores/music'

export default {
  name: 'MiniPlayer',
  props: {
    bottomOffset: {
      type: Number,
      default: 56, // ボトムナビの高さ
    },
  },
  setup() {
    const musicStore = useMusicStore()
    return { musicStore }
  },
  computed: {
    currentTrack() {
      return this.musicStore.currentTrack
    },
    isPlaying() {
      return this.musicStore.isPlaying
    },
    isLiked() {
      return this.musicStore.isCurrentLiked
    },
    isUnfinished() {
      return isTrackUnfinished(this.currentTrack)
    },
    playError() {
      return this.musicStore.playError
    },
    progressPercent() {
      if (!this.currentTrack || !this.currentTrack.duration) return 0
      return Math.min(
        100,
        (this.musicStore.currentTime / this.currentTrack.duration) * 100,
      )
    },
  },
  methods: {
    openModal() {
      this.musicStore.openNowPlaying()
    },
    togglePlay() {
      this.musicStore.togglePlay()
    },
    next() {
      this.musicStore.next()
    },
    prev() {
      this.musicStore.prev()
    },
    toggleLike() {
      if (this.currentTrack) {
        this.musicStore.toggleLike(this.currentTrack.id)
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.mini-player-wrapper {
  position: fixed;
  left: 8px;
  right: 8px;
  height: 58px;
  background-color: rgba(var(--v-theme-surface), 0.4);
  backdrop-filter: blur(4px);
  border: 1px solid rgba(var(--v-theme-on-surface), 0.12);
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
  z-index: 45;
  width: 600px;
  max-width: calc(100% - 16px);
  justify-self: center;
  transform: translateY(-16px);
  cursor: pointer;
  overflow: hidden;
  transition: transform 0.2s, background-color 0.2s;

  &:hover {
    background-color: rgba(var(--v-theme-surface), 0.6);
  }

  .progress-bar-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 2.5px;
    background-color: rgba(var(--v-theme-on-surface), 0.08);

    .progress-fill {
      height: 100%;
      background-color: rgb(var(--v-theme-primary));
      transition: width 0.3s linear;
    }
  }

  .player-inner {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 10px 0 8px;
  }

  .track-info {
    display: flex;
    align-items: center;
    gap: 10px;
    flex: 1;
    min-width: 0;
    margin-right: 8px;

    .cover-wrapper {
      position: relative;
      width: 42px;
      height: 42px;
      border-radius: 8px;
      overflow: hidden;
      flex-shrink: 0;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);

      .cover-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .title-group {
      display: flex;
      flex-direction: column;
      min-width: 0;

      .track-title {
        font-size: 13.5px;
        font-weight: 700;
        color: rgb(var(--v-theme-on-surface));
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        line-height: 1.3;
      }

      .track-artist {
        font-size: 11.5px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }
  }

  .player-controls {
    display: flex;
    align-items: center;
    gap: 4px;
    flex-shrink: 0;

    .control-btn {
      color: rgba(var(--v-theme-on-surface), 0.7);
    }

    .play-toggle-btn {
      width: 36px;
      height: 36px;
      border-radius: 50%;
    }
  }
}

@media (max-width: 600px) {
  .mini-player-wrapper {
    transform: translateY(-8px);
  }
}
</style>
