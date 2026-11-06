<template lang="pug">
.music-track-row(
  :class="{ 'is-active': isPlayingThis, 'is-unfinished': isUnfinished }"
  v-ripple
  @click="$emit('click', item)"
)
  //- 順位または再生アイコン
  .rank-col
    span.rank-num(v-if="!isPlayingThis") {{ rank !== undefined ? rank : '' }}
    .playing-eq(v-else)
      .eq-bar
      .eq-bar
      .eq-bar

  //- カバーアート
  .thumb-col
    img.thumb-img(
      :src="item.cover || item.icon"
      :alt="item.title"
      loading="lazy"
    )
    .thumb-play-btn(@click.stop="$emit('play', item)")
      v-icon(:icon="isPlayingThis ? 'mdi-pause' : 'mdi-play'" size="18" color="white")
    .thumb-wip-dot(v-if="isUnfinished" title="未完成")

  //- 曲名 & アーティスト
  .info-col
    .title-row
      span.title-line(:class="{ active: isPlayingThis }") {{ item.title || item.name }}
      v-chip.unfinished-chip(
        v-if="isUnfinished"
        size="x-small"
        color="warning"
        variant="flat"
        density="compact"
      ) 未完成
    .artist-line
      span.artist-name {{ item.artist }}
      span.dot •
      span.album-name {{ item.album }}

  //- 再生回数 / ジャンル（中〜大画面）
  .extra-col.is-not-mobile
    span.genre-chip {{ item.genre }}

  //- 再生時間 & お気に入り & アクション
  .action-col
    v-btn.like-btn(
      icon
      size="x-small"
      variant="text"
      :color="isLiked ? 'error' : undefined"
      @click.stop="$emit('like', item.id)"
    )
      v-icon(:icon="isLiked ? 'mdi-heart' : 'mdi-heart-outline'" size="18")

    span.duration-text {{ item.durationFormatted }}

    v-btn(
      icon="mdi-dots-vertical"
      size="x-small"
      variant="text"
      @click.stop="$emit('options', item)"
    )
</template>

<script lang="ts">
import type { PropType } from 'vue'
import { isTrackUnfinished, type MusicItem } from '@/stores/music'

export default {
  name: 'MusicTrackRow',
  props: {
    item: {
      type: Object as PropType<MusicItem>,
      required: true,
    },
    rank: {
      type: Number,
      default: undefined,
    },
    isPlaying: {
      type: Boolean,
      default: false,
    },
    currentTrackId: {
      type: String,
      default: '',
    },
    isLiked: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['click', 'play', 'like', 'options'],
  computed: {
    isPlayingThis(): boolean {
      return this.isPlaying && this.currentTrackId === this.item.id
    },
    isUnfinished(): boolean {
      return isTrackUnfinished(this.item)
    },
  },
}
</script>

<style lang="scss" scoped>
.music-track-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.15s;
  user-select: none;

  &:hover {
    background-color: rgba(var(--v-theme-on-surface), 0.06);

    .thumb-play-btn {
      opacity: 1;
    }
  }

  &.is-active {
    background-color: rgba(var(--v-theme-primary), 0.12);
  }

  .rank-col {
    width: 24px;
    text-align: center;
    font-size: 14px;
    font-weight: 600;
    color: rgba(var(--v-theme-on-surface), 0.5);

    .playing-eq {
      display: flex;
      align-items: flex-end;
      justify-content: center;
      gap: 2px;
      height: 14px;

      .eq-bar {
        width: 3px;
        background-color: rgb(var(--v-theme-primary));
        border-radius: 1px;
        animation: eqBounce 0.8s ease-in-out infinite alternate;

        &:nth-child(1) { height: 10px; animation-delay: 0.1s; }
        &:nth-child(2) { height: 6px; animation-delay: 0.3s; }
        &:nth-child(3) { height: 12px; animation-delay: 0.2s; }
      }
    }
  }

  .thumb-col {
    position: relative;
    width: 44px;
    height: 44px;
    min-width: 44px;
    border-radius: 6px;
    overflow: hidden;
    background-color: rgba(var(--v-theme-on-surface), 0.05);

    .thumb-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .thumb-wip-dot {
      position: absolute;
      top: 2px;
      left: 2px;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background-color: #f59e0b;
      box-shadow: 0 0 4px rgba(0,0,0,0.5);
    }

    .thumb-play-btn {
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: opacity 0.15s;
    }
  }

  .info-col {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;

    .title-row {
      display: flex;
      align-items: center;
      gap: 6px;
      min-width: 0;

      .title-line {
        font-size: 14px;
        font-weight: 500;
        color: rgb(var(--v-theme-on-surface));
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;

        &.active {
          color: rgb(var(--v-theme-primary));
          font-weight: 700;
        }
      }

      .unfinished-chip {
        font-size: 9px !important;
        height: 16px !important;
        padding: 0 4px !important;
        font-weight: 700;
        flex-shrink: 0;
      }
    }

    .artist-line {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: rgba(var(--v-theme-on-surface), 0.6);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-top: 2px;

      .dot {
        opacity: 0.5;
      }
    }
  }

  .extra-col {
    width: 120px;
    display: flex;
    align-items: center;

    .genre-chip {
      font-size: 11px;
      padding: 2px 8px;
      border-radius: 4px;
      background: rgba(var(--v-theme-on-surface), 0.06);
      color: rgba(var(--v-theme-on-surface), 0.7);
    }
  }

  .action-col {
    display: flex;
    align-items: center;
    gap: 8px;

    .duration-text {
      font-size: 12px;
      color: rgba(var(--v-theme-on-surface), 0.6);
      min-width: 32px;
      text-align: right;
    }
  }
}

@media (max-width: 600px) {
  .extra-col.is-not-mobile {
    display: none;
  }
}

@keyframes eqBounce {
  0% { height: 2px; }
  100% { height: 12px; }
}
</style>
