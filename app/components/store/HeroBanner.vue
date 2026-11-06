<template lang="pug">
.hero-banner-container
  v-carousel(
    cycle
    height="190"
    hide-delimiter-background
    show-arrows="hover"
    delimiter-icon="mdi-circle-small"
  )
    v-carousel-item(
      v-for="item in items"
      :key="item.id"
      @click="$emit('click', item)"
    )
      .hero-card(v-ripple)
        img.hero-bg(:src="item.thumbnail" :alt="item.name" loading="lazy")
        .hero-overlay
          .hero-content
            .badge-row
              span.hero-badge {{ item.category }} • 注目のピックアップ
              span.hero-wip-badge(v-if="isItemUnfinished(item)")
                v-icon.mr-1(size="11") mdi-progress-wrench
                | 未完成
            h2.hero-title {{ item.name }}
            p.hero-summary {{ item.summary || '今すぐダウンロードして新しい世界を体験' }}
            .hero-action
              v-btn(
                color="white"
                variant="flat"
                rounded="pill"
                size="small"
                prepend-icon="mdi-arrow-right-circle"
                style="color: #1a73e8; font-weight: 700;"
              ) 詳細を見る
</template>

<script setup lang="ts">
import { isItemUnfinished, type AppOrMusicItem } from '~/stores/app'

defineProps<{
  items: AppOrMusicItem[]
}>()

defineEmits<{
  (e: 'click', item: AppOrMusicItem): void
}>()
</script>

<style lang="scss" scoped>
.hero-banner-container {
  padding: 0 16px;
  margin-bottom: 8px;
  margin-top: 1em;

  :deep(.v-carousel) {
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  }

  .hero-card {
    position: relative;
    width: 100%;
    height: 100%;
    cursor: pointer;
    overflow: hidden;

    .hero-bg {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      transition: transform 0.4s ease;
    }

    &:hover .hero-bg {
      transform: scale(1.03);
    }

    .hero-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(
        to top,
        rgba(0, 0, 0, 0.85) 0%,
        rgba(0, 0, 0, 0.35) 60%,
        rgba(0, 0, 0, 0.1) 100%
      );
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 16px 20px;

      .badge-row {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
        flex-wrap: wrap;
      }

      .hero-badge {
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: #93c5fd;
      }

      .hero-wip-badge {
        font-size: 10px;
        font-weight: 700;
        background: #f59e0b;
        color: #fff;
        padding: 2px 7px;
        border-radius: 9999px;
        display: inline-flex;
        align-items: center;
        letter-spacing: 0.3px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.3);
      }

      .hero-title {
        font-size: 18px;
        font-weight: 700;
        color: #ffffff;
        margin-bottom: 4px;
        line-height: 1.3;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .hero-summary {
        font-size: 12.5px;
        color: rgba(255, 255, 255, 0.85);
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 8px;
      }

      .hero-action {
        display: flex;
        align-items: center;
      }
    }
  }
}
</style>
