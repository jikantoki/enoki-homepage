<template lang="pug">
v-card.profile-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップヘッダーバー
  v-card-actions.profile-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title プロフィール・実績
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="shareProfile"
    )

  //- メインスクロールエリア
  v-card-text.profile-page-content(ref="scrollContainer")
    AboutView(initialTab="profile")
    .bottom-nav-spacer

</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import AboutView from '@/components/about/AboutView.vue'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'ProfilePage',
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
      'エノキ電気代表・ときえのき（jikantoki）の経歴、実績、保有資格、スキル一覧です。',
    )
  },
  mounted() {
    this.setTitle('プロフィール')
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/')
      }
    },
    async shareProfile() {
      try {
        await Share.share({
          title: 'ときえのき プロフィール・経歴・実績 - エノキ電気',
          text: 'エノキ電気代表 ときえのきのプロフィール、経歴年表、実績まとめです。',
          url: 'https://enoki.xyz/profile',
          dialogTitle: 'プロフィールを共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/profile')
          await Toast.show({ text: 'プロフィールURLをコピーしました' })
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.profile-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  overflow: hidden;
  position: relative;
  background-color: rgb(var(--v-theme-surface));

  .profile-page-header {
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
      margin-left: 8px;
    }
  }

  .profile-page-content {
    flex: 1;
    height: 100%;
    overflow-y: auto;
    padding: 56px 0 0 0;
    -webkit-overflow-scrolling: touch;
    scroll-behavior: smooth;
  }

  .bottom-nav-spacer {
    height: 72px;
  }
}
</style>
