<template lang="pug">
.store-app-card(:class="{ 'is-unfinished': isUnfinished }" v-ripple @click="$emit('click', item)")
  .icon-wrapper
    img.app-icon(:src="item.icon" :alt="item.name" loading="lazy")
  .info-wrapper
    .app-title {{ item.name }}
    .app-sub
      span {{ item.category || (item.type === 'game' ? 'ゲーム' : 'アプリ') }}
    .app-footer
      .app-price(v-if="item.price && item.price > 0") ¥{{ item.price }}
      .app-price.free(v-else) 無料
      v-chip.unfinished-pill(
        v-if="isUnfinished"
        size="x-small"
        color="warning"
        variant="flat"
        density="compact"
      ) 未完成
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { isItemUnfinished, type AppOrMusicItem } from '~/stores/app'

const props = defineProps<{
  item: AppOrMusicItem
}>()

defineEmits<{
  (e: 'click', item: AppOrMusicItem): void
}>()

const isUnfinished = computed(() => isItemUnfinished(props.item))
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
  position: relative;

  &:hover {
    background-color: rgba(var(--v-theme-on-surface), 0.05);
    transform: translateY(-2px);
  }

  &:active {
    transform: scale(0.97);
  }

  .icon-wrapper {
    position: relative;
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

    .wip-badge {
      position: absolute;
      top: 6px;
      left: 6px;
      background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
      color: #ffffff;
      font-size: 9.5px;
      font-weight: 700;
      padding: 2px 6px;
      border-radius: 6px;
      display: flex;
      align-items: center;
      gap: 3px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.35);
      letter-spacing: 0.3px;
      z-index: 2;

      .wip-icon {
        color: #ffffff;
      }
    }
  }

  &.is-unfinished {
    .icon-wrapper {
      outline: 2px solid rgba(245, 158, 11, 0.55);
      outline-offset: -1px;
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
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .app-footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 3px;
      font-size: 11px;

      .app-price {
        font-size: 10.5px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        font-weight: 500;

        &.free {
          color: rgba(var(--v-theme-on-surface), 0.55);
        }
      }

      .unfinished-pill {
        font-size: 9px !important;
        height: 17px !important;
        padding: 0 4px !important;
        font-weight: 700;
      }
    }
  }
}
</style>
