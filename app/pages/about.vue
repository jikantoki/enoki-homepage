<template lang="pug">
v-card.about-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.about-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title 運営・プロフィール情報
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="sharePage"
    )

  //- メインスクロールエリア
  v-card-text.about-page-content
    AboutView(initialTab="profile")
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import AboutView from '@/components/about/AboutView.vue'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'AboutPage',
  components: {
    AboutView,
  },
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
    }
  },
  setup() {
    Setup.setTitle('プロフィール')
    Setup.setDescription(
      'エノキ電気のプロフィールや運営情報、および代表ときえのきの経歴・実績一覧です。',
    )
  },
  async mounted() {
    this.setTitle('プロフィール')
    // 開発者オプション
    const developerOptions = localStorage.getItem('developerOptions')
    if (developerOptions) {
      const options = JSON.parse(developerOptions)
      if (options.statusBarNotch !== undefined) {
        this.settings.hidden.isAndroid15OrHigher = options.statusBarNotch
      }
    }
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/')
      }
    },
    async sharePage() {
      try {
        await Share.share({
          title: '運営情報・プロフィール - エノキ電気',
          text: 'エノキ電気の運営情報と、代表ときえのきのプロフィール・実績です。',
          url: 'https://enoki.xyz/profile/',
          dialogTitle: '共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/profile/')
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.about-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  position: relative;
  overflow: hidden;

  .about-page-header {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    background-color: rgba(var(--v-theme-surface), 0.6);
    backdrop-filter: blur(6px);
    z-index: 20;
    flex-shrink: 0;

    .header-title {
      font-size: 1.15em;
      font-weight: 800;
      margin: 0 0 0 8px;
      color: rgb(var(--v-theme-on-surface));
    }
  }

  .about-page-content {
    flex: 1;
    height: 100%;
    overflow-y: auto;
    padding: 64px 4px 80px;
    -webkit-overflow-scrolling: touch;
    scroll-behavior: smooth;
  }
}

.top-android-15-or-higher {
  height: calc(100vh - 40px - 16px) !important;
  height: calc(100dvh - 40px - 16px) !important;
}
</style>
