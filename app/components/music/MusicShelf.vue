<template lang="pug">
.music-shelf
  .shelf-header
    .title-group
      h3.shelf-title {{ title }}
      p.shelf-subtitle(v-if="subtitle") {{ subtitle }}
    .header-actions
      v-btn(
        v-if="showMore"
        variant="text"
        size="small"
        color="primary"
        @click="$emit('more')"
      ) すべて表示
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

  .shelf-scroll(ref="scrollContainer")
    slot
</template>

<script lang="ts">
export default {
  name: 'MusicShelf',
  props: {
    title: {
      type: String,
      required: true,
    },
    subtitle: {
      type: String,
      default: '',
    },
    showMore: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['more'],
  methods: {
    scrollLeft() {
      const container = this.$refs.scrollContainer as HTMLElement
      if (container) {
        container.scrollBy({ left: -320, behavior: 'smooth' })
      }
    },
    scrollRight() {
      const container = this.$refs.scrollContainer as HTMLElement
      if (container) {
        container.scrollBy({ left: 320, behavior: 'smooth' })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.music-shelf {
  margin-bottom: 24px;

  .shelf-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    padding: 0 16px;
    margin-bottom: 12px;

    .title-group {
      .shelf-title {
        font-size: 19px;
        font-weight: 800;
        letter-spacing: -0.3px;
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

  .shelf-scroll {
    display: flex;
    gap: 8px;
    overflow-x: auto;
    padding: 4px 16px 12px 16px;
    scroll-snap-type: x proximity;
    -webkit-overflow-scrolling: touch;

    &::-webkit-scrollbar {
      display: none;
    }
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
}
</style>
