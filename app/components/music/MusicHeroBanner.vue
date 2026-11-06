<template lang="pug">
.music-hero-banner
  .banner-carousel(ref="carouselContainer")
    .banner-slide(
      v-for="(item, idx) in items"
      :key="item.id"
      :class="{ active: currentSlide === idx }"
      v-ripple
      @click="$emit('click', item)"
    )
      .slide-image-wrapper
        img.slide-img(:src="item.thumbnail || item.cover" :alt="item.title")
        .slide-overlay

      .slide-content
        .badge-row
          span.category-badge {{ item.genre }}
          span.exclusive-tag ピックアップ
          span.wip-hero-badge(v-if="isTrackUnfinished(item)")
            v-icon.mr-1(size="11") mdi-progress-wrench
            | 未完成

        h2.slide-title {{ item.title }}
        p.slide-artist {{ item.artist }} — {{ item.album }}
        p.slide-desc.is-not-mobile {{ item.description }}

        .action-row
          v-btn.play-hero-btn(
            prepend-icon="mdi-play"
            color="primary"
            variant="flat"
            rounded="pill"
            size="small"
            @click.stop="$emit('play', item)"
          ) 再生する

          v-btn.detail-hero-btn(
            variant="tonal"
            rounded="pill"
            size="small"
            @click.stop="$emit('click', item)"
          ) 楽曲詳細

  //- ドットインジケーター
  .indicators-row(v-if="items.length > 1")
    span.dot(
      v-for="(_, idx) in items"
      :key="idx"
      :class="{ active: currentSlide === idx }"
      @click="goToSlide(idx)"
    )
</template>

<script lang="ts">
import type { PropType } from 'vue'
import { isTrackUnfinished, type MusicItem } from '@/stores/music'

export default {
  name: 'MusicHeroBanner',
  props: {
    items: {
      type: Array as PropType<MusicItem[]>,
      required: true,
    },
  },
  emits: ['click', 'play'],
  data() {
    return {
      currentSlide: 0,
      slideTimer: null as number | null,
    }
  },
  mounted() {
    this.startAutoSlide()
  },
  unmounted() {
    this.stopAutoSlide()
  },
  methods: {
    startAutoSlide() {
      this.stopAutoSlide()
      if (this.items.length <= 1) return
      this.slideTimer = window.setInterval(() => {
        this.currentSlide = (this.currentSlide + 1) % this.items.length
      }, 5000)
    },
    stopAutoSlide() {
      if (this.slideTimer !== null) {
        clearInterval(this.slideTimer)
        this.slideTimer = null
      }
    },
    goToSlide(index: number) {
      this.currentSlide = index
      this.startAutoSlide()
    },
    isTrackUnfinished(item: any): boolean {
      return isTrackUnfinished(item)
    },
  },
}
</script>

<style lang="scss" scoped>
.music-hero-banner {
  padding: 12px 16px 6px 16px;

  .banner-carousel {
    position: relative;
    width: 100%;
    min-height: 200px;
    height: 220px;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);

    @media (min-width: 600px) {
      height: 260px;
    }
  }

  .banner-slide {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
    transform: scale(0.98);
    pointer-events: none;
    cursor: pointer;

    &.active {
      opacity: 1;
      transform: scale(1);
      pointer-events: auto;
    }

    .slide-image-wrapper {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;

      .slide-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }

      .slide-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          to right,
          rgba(0, 0, 0, 0.85) 0%,
          rgba(0, 0, 0, 0.5) 60%,
          rgba(0, 0, 0, 0.2) 100%
        );
      }
    }

    .slide-content {
      position: relative;
      z-index: 2;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 20px;
      color: #ffffff;
      max-width: 520px;

      .badge-row {
        display: flex;
        gap: 8px;
        margin-bottom: 8px;

        .category-badge {
          background-color: rgb(var(--v-theme-primary));
          color: #ffffff;
          font-size: 11px;
          font-weight: 700;
          padding: 3px 8px;
          border-radius: 9999px;
          letter-spacing: 0.5px;
          text-transform: uppercase;
        }

        .exclusive-tag {
          background: rgba(255, 255, 255, 0.2);
          backdrop-filter: blur(4px);
          font-size: 11px;
          padding: 3px 8px;
          border-radius: 9999px;
          color: #e0e0e0;
        }

        .wip-hero-badge {
          background: #f59e0b;
          color: #ffffff;
          font-size: 11px;
          font-weight: 700;
          padding: 3px 8px;
          border-radius: 9999px;
          letter-spacing: 0.3px;
          display: inline-flex;
          align-items: center;
          box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }
      }

      .slide-title {
        font-size: 22px;
        font-weight: 800;
        line-height: 1.2;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);

        @media (min-width: 600px) {
          font-size: 28px;
        }
      }

      .slide-artist {
        font-size: 13px;
        color: rgba(255, 255, 255, 0.85);
        margin: 4px 0 0 0;
        font-weight: 600;
      }

      .slide-desc {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.7);
        margin: 6px 0 0 0;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .action-row {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-top: 12px;

        .play-hero-btn {
          font-weight: 700;
          letter-spacing: 0;
        }
      }
    }
  }

  .indicators-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 6px;
    margin-top: 8px;

    .dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background-color: rgba(var(--v-theme-on-surface), 0.25);
      cursor: pointer;
      transition: all 0.2s;

      &.active {
        width: 18px;
        border-radius: 3px;
        background-color: rgb(var(--v-theme-primary));
      }
    }
  }
}
</style>
