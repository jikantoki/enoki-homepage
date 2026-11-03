<template lang="pug">
.store-shelf
  .shelf-header
    .title-group
      h3.shelf-title {{ title }}
      p.shelf-subtitle(v-if="subtitle") {{ subtitle }}
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
  .shelf-scroll-container
    slot
</template>

<script setup lang="ts">
defineProps<{
  title: string
  subtitle?: string
  showMore?: boolean
}>()

defineEmits<{
  (e: 'more'): void
}>()
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
