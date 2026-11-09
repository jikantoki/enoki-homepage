<template lang="pug">
.store-shelf
  .shelf-header
    .title-group
      h3.shelf-title {{ title }}
      p.shelf-subtitle(v-if="subtitle") {{ subtitle }}
    .header-actions
      v-btn(
        v-if="showMore"
        variant="text"
        density="comfortable"
        color="primary"
        append-icon="mdi-arrow-right"
        @click="$emit('more')"
        rounded="pill"
        size="small"
      ) もっと見る
      .scroll-controls.is-not-mobile
        v-btn.scroll-btn(
          icon="mdi-chevron-left"
          size="x-small"
          variant="tonal"
          @click="scrollLeft"
        )
        v-btn.scroll-btn(
          icon="mdi-chevron-right"
          size="x-small"
          variant="tonal"
          @click="scrollRight"
        )
  .shelf-scroll-container(ref="scrollContainer")
    slot
</template>

<script setup lang="ts">
import { ref } from 'vue'

defineProps<{
  title: string
  subtitle?: string
  showMore?: boolean
}>()

defineEmits<{
  (e: 'more'): void
}>()

const scrollContainer = ref<HTMLElement | null>(null)

function scrollLeft() {
  if (scrollContainer.value) {
    scrollContainer.value.scrollBy({ left: -320, behavior: 'smooth' })
  }
}

function scrollRight() {
  if (scrollContainer.value) {
    scrollContainer.value.scrollBy({ left: 320, behavior: 'smooth' })
  }
}
</script>

<style lang="scss" scoped>
.store-shelf {
  margin: 18px 0;

  .shelf-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px 8px 16px;

    .title-group {
      display: flex;
      flex-direction: column;

      .shelf-title {
        font-size: 16px;
        font-weight: 700;
        letter-spacing: -0.2px;
        color: rgb(var(--v-theme-on-surface));
        margin: 0;
      }

      .shelf-subtitle {
        font-size: 12px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        margin: 2px 0 0 0;
      }
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 8px;

      .scroll-controls {
        display: flex;
        gap: 6px;

        .scroll-btn {
          width: 28px;
          height: 28px;
          border-radius: 50%;
        }
      }
    }
  }

  .shelf-scroll-container {
    display: flex;
    gap: 12px;
    overflow-x: auto;
    padding: 6px 16px 12px 16px;
    scroll-behavior: smooth;
    -webkit-overflow-scrolling: touch;

    /* スクロールバー非表示（Google Play風） */
    scrollbar-width: none;
    &::-webkit-scrollbar {
      display: none;
    }
  }
}
</style>
