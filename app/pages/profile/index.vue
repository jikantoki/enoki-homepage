<template lang="pug">
v-card.profile-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.profile-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title ときえのき プロフィール
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="shareProfile"
    )

  //- メインスクロールエリア
  v-card-text.profile-page-content
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
    Setup.setTitle('ときえのき プロフィール・経歴・実績')
    Setup.setDescription('エノキ電気代表・ときえのき（jikantoki）の経歴、実績、保有資格、スキル一覧です。')
  },
  async mounted() {
    this.setTitle('ときえのき プロフィール・経歴・実績')
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
    async shareProfile() {
      try {
        await Share.share({
          title: 'ときえのき プロフィール・経歴・実績 - エノキ電気',
          text: 'エノキ電気代表 ときえのきのプロフィール、経歴年表、実績まとめです。',
          url: 'https://enoki.xyz/profile/',
          dialogTitle: 'プロフィールを共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/profile/')
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

  .profile-page-header {
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    flex-shrink: 0;

    .header-title {
      font-size: 1.15em;
      font-weight: 800;
      margin: 0 0 0 8px;
      color: rgb(var(--v-theme-on-surface));
    }
  }

  .profile-page-content {
    flex: 1;
    overflow-y: auto;
    padding: 8px 4px 60px;
    -webkit-overflow-scrolling: touch;
  }
}

.top-android-15-or-higher {
  height: calc(100vh - 40px - 16px) !important;
}
</style>
