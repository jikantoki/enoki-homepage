<template lang="pug">
.store-rank-item(:class="{ 'is-unfinished': isUnfinished }" v-ripple @click="$emit('click', item)")
  .rank-badge(:class="{ 'top-three': rank <= 3 }") {{ rank }}
  .icon-wrapper
    img.app-icon(:src="item.icon" :alt="item.name" loading="lazy")
    .wip-indicator(v-if="isUnfinished")
      v-icon(size="9") mdi-progress-wrench
  .info-wrapper
    .app-title-row
      span.app-title {{ item.name }}
      v-chip.unfinished-chip(
        v-if="isUnfinished"
        size="x-small"
        color="warning"
        variant="flat"
        density="compact"
      ) 未完成
    .app-meta
      span.app-category {{ item.category || (item.type === 'game' ? 'ゲーム' : 'アプリ') }}
      span.wip-text(v-if="isUnfinished") • 開発中
  .action-wrapper
    v-btn(
      size="small"
      variant="tonal"
      rounded="pill"
      color="primary"
      @click.stop="$emit('click', item)"
    ) 詳細
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { isItemUnfinished, type AppOrMusicItem } from '~/stores/app'

const props = defineProps<{
  item: AppOrMusicItem
  rank: number
}>()

defineEmits<{
  (e: 'click', item: AppOrMusicItem): void
}>()

const isUnfinished = computed(() => isItemUnfinished(props.item))
</script>

<style lang="scss" scoped>
.store-rank-item {
  display: flex;
  align-items: center;
  padding: 10px 12px;
  border-radius: 16px;
  cursor: pointer;
  transition: background-color 0.15s;
  user-select: none;
  gap: 12px;

  &:hover {
    background-color: rgba(var(--v-theme-on-surface), 0.05);
  }

  .rank-badge {
    font-size: 15px;
    font-weight: 700;
    width: 22px;
    text-align: center;
    color: rgba(var(--v-theme-on-surface), 0.55);

    &.top-three {
      color: rgb(var(--v-theme-primary));
      font-size: 17px;
    }
  }

  .icon-wrapper {
    position: relative;
    width: 56px;
    height: 56px;
    min-width: 56px;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    background-color: #f1f3f4;

    .app-icon {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .wip-indicator {
      position: absolute;
      top: 2px;
      right: 2px;
      background: #f59e0b;
      color: #fff;
      border-radius: 4px;
      padding: 1px 3px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 1px 3px rgba(0,0,0,0.3);
    }
  }

  .info-wrapper {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;

    .app-title-row {
      display: flex;
      align-items: center;
      gap: 6px;
      min-width: 0;

      .app-title {
        font-size: 14px;
        font-weight: 500;
        color: rgb(var(--v-theme-on-surface));
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .unfinished-chip {
        font-size: 9.5px !important;
        height: 18px !important;
        padding: 0 5px !important;
        font-weight: 700;
        flex-shrink: 0;
      }
    }

    .app-meta {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 3px;
      font-size: 12px;
      color: rgba(var(--v-theme-on-surface), 0.65);

      .wip-text {
        color: #d97706;
        font-weight: 600;
      }
    }
  }

  .action-wrapper {
    flex-shrink: 0;
  }
}
</style>
