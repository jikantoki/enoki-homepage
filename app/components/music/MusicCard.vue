<template lang="pug">
.music-card(
  v-ripple
  @click="$emit('click', item)"
)
  .cover-container
    img.cover-img(
      :src="item.cover || item.icon"
      :alt="item.title"
      loading="lazy"
    )
    .play-overlay
      v-btn.play-btn(
        icon
        color="primary"
        size="small"
        elevation="4"
        @click.stop="$emit('play', item)"
      )
        v-icon(:icon="isPlayingThis ? 'mdi-pause' : 'mdi-play'" size="20" color="white")
    .playing-indicator(v-if="isPlayingThis")
      .eq-bar
      .eq-bar
      .eq-bar

  .meta-container
    .song-title(:class="{ active: isPlayingThis }") {{ item.title || item.name }}
    .song-artist {{ item.artist }}
    .song-extra(v-if="showExtra")
      span.genre-tag {{ item.genre }}
      span.dot •
      span.plays-text {{ item.plays }} 回再生
</template>

<script lang="ts">
import type { PropType } from 'vue'
import type { MusicItem } from '@/stores/music'

export default {
  name: 'MusicCard',
  props: {
    item: {
      type: Object as PropType<MusicItem>,
      required: true,
    },
    isPlaying: {
      type: Boolean,
      default: false,
    },
    currentTrackId: {
      type: String,
      default: '',
    },
    showExtra: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['click', 'play'],
  computed: {
    isPlayingThis(): boolean {
      return this.isPlaying && this.currentTrackId === this.item.id
    },
  },
}
</script>

<style lang="scss" scoped>
.music-card {
  display: flex;
  flex-direction: column;
  width: 150px;
  min-width: 150px;
  cursor: pointer;
  padding: 10px;
  border-radius: 12px;
  transition: background-color 0.2s, transform 0.2s;
  user-select: none;

  &:hover {
    background-color: rgba(var(--v-theme-on-surface), 0.06);
    transform: translateY(-3px);

    .play-overlay {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .cover-container {
    position: relative;
    width: 100%;
    aspect-ratio: 1 / 1;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    background-color: rgba(var(--v-theme-on-surface), 0.05);

    .cover-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .play-overlay {
      position: absolute;
      right: 8px;
      bottom: 8px;
      opacity: 0;
      transform: translateY(6px);
      transition: opacity 0.2s ease, transform 0.2s ease;
      z-index: 2;

      .play-btn {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      }
    }

    .playing-indicator {
      position: absolute;
      top: 8px;
      left: 8px;
      display: flex;
      align-items: flex-end;
      gap: 2px;
      height: 16px;
      padding: 3px 5px;
      background: rgba(0, 0, 0, 0.65);
      border-radius: 4px;
      backdrop-filter: blur(4px);

      .eq-bar {
        width: 3px;
        background-color: rgb(var(--v-theme-primary));
        border-radius: 1px;
        animation: eqBounce 0.8s ease-in-out infinite alternate;

        &:nth-child(1) { height: 12px; animation-delay: 0.1s; }
        &:nth-child(2) { height: 7px; animation-delay: 0.3s; }
        &:nth-child(3) { height: 14px; animation-delay: 0.2s; }
      }
    }
  }

  .meta-container {
    margin-top: 8px;
    display: flex;
    flex-direction: column;

    .song-title {
      font-size: 13.5px;
      font-weight: 700;
      color: rgb(var(--v-theme-on-surface));
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      line-height: 1.3;

      &.active {
        color: rgb(var(--v-theme-primary));
      }
    }

    .song-artist {
      font-size: 12px;
      color: rgba(var(--v-theme-on-surface), 0.6);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-top: 2px;
    }

    .song-extra {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 11px;
      color: rgba(var(--v-theme-on-surface), 0.45);
      margin-top: 4px;

      .genre-tag {
        font-weight: 600;
      }
    }
  }
}

@keyframes eqBounce {
  0% { height: 3px; }
  100% { height: 14px; }
}
</style>
