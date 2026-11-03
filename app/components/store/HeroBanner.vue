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
            .hero-badge {{ item.category }} • 注目のピックアップ
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
import type { AppOrMusicItem } from '~/stores/app'

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

      .hero-badge {
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: #93c5fd;
        margin-bottom: 4px;
      }

      .hero-title {
        font-size: 18px;
        font-weight: 800;
        color: #ffffff;
        margin: 0;
        line-height: 1.25;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .hero-summary {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.85);
        margin: 4px 0 10px 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .hero-action {
        display: flex;
        align-items: center;
      }
    }
  }
}
</style>
