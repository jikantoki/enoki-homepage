<template lang="pug">
.store-app-card(v-ripple @click="$emit('click', item)")
  .icon-wrapper
    img.app-icon(:src="item.icon" :alt="item.name" loading="lazy")
  .info-wrapper
    .app-title {{ item.name }}
    .app-sub {{ item.category || (item.type === 'game' ? 'ゲーム' : 'アプリ') }}
    .app-footer
      .app-rating(v-if="item.rating")
        span.rating-score {{ item.rating }}
        v-icon(size="12" color="amber-darken-2") mdi-star
      .app-price(v-if="item.price && item.price > 0") ¥{{ item.price }}
      .app-price.free(v-else) 無料
</template>

<script setup lang="ts">
import type { AppOrMusicItem } from '~/stores/app'

defineProps<{
  item: AppOrMusicItem
}>()

defineEmits<{
  (e: 'click', item: AppOrMusicItem): void
}>()
</script>

<style lang="scss" scoped>
.store-app-card {
  width: 108px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  padding: 6px;
  border-radius: 14px;
  transition: transform 0.18s cubic-bezier(0.2, 0, 0, 1), background-color 0.18s;
  user-select: none;

  &:hover {
    background-color: rgba(var(--v-theme-on-surface), 0.05);
    transform: translateY(-2px);
  }

  &:active {
    transform: scale(0.97);
  }

  .icon-wrapper {
    width: 96px;
    height: 96px;
    margin: 0 auto 8px auto;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f1f3f4;

    .app-icon {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
  }

  .info-wrapper {
    display: flex;
    flex-direction: column;
    width: 100%;

    .app-title {
      font-size: 12.5px;
      line-height: 1.25;
      font-weight: 500;
      color: rgb(var(--v-theme-on-surface));
      height: 2.5em;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
      word-break: break-all;
    }

    .app-sub {
      font-size: 11px;
      color: rgba(var(--v-theme-on-surface), 0.65);
      margin-top: 2px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .app-footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 3px;
      font-size: 11px;

      .app-rating {
        display: inline-flex;
        align-items: center;
        gap: 2px;
        color: rgba(var(--v-theme-on-surface), 0.85);
        font-weight: 600;

        .rating-score {
          font-size: 11px;
        }
      }

      .app-price {
        font-size: 10.5px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        font-weight: 500;

        &.free {
          color: rgba(var(--v-theme-on-surface), 0.55);
        }
      }
    }
  }
}
</style>
