<template lang="pug">
v-app
  common-splash-vue(v-show="splashScreen")
  main(style="height: 100vh;")
    .status-bar-padding(:class="settings.hidden.isAndroid15OrHigher ? 'android-15-or-higher' : ''")
    NuxtPage(:style="settings.hidden.isAndroid15OrHigher ? 'height: calc(100vh - 40px - 16px);' : ''")
    MiniPlayer(
      v-if="shouldShowMiniPlayer"
      :bottomOffset="miniPlayerBottomOffset"
    )
    NowPlayingModal
    .nav-bar-padding(:class="settings.hidden.isAndroid15OrHigher ? 'android-15-or-higher' : ''")
</template>

<script lang="ts">
import { Capacitor } from '@capacitor/core'
import { StatusBar, Style } from '@capacitor/status-bar'
import commonSplashVue from '@/components/common/commonSplash.vue'
import MiniPlayer from '@/components/music/MiniPlayer.vue'
import NowPlayingModal from '@/components/music/NowPlayingModal.vue'
import mixins from '@/mixins/mixins'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'

export default {
  name: 'App',
  components: {
    commonSplashVue,
    MiniPlayer,
    NowPlayingModal,
  },
  mixins: [mixins],
  data() {
    return {
      splashScreen: true,
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
    }
  },
  computed: {
    hasBottomNav(): boolean {
      const p = this.$route.path
      return p === '/' || p === '/music' || p === '/profile'
    },
    miniPlayerBottomOffset(): number {
      const isA15 = this.settings.hidden.isAndroid15OrHigher
      if (this.hasBottomNav) {
        return isA15 ? 72 : 56
      }
      return isA15 ? 16 : 0
    },
    shouldShowMiniPlayer(): boolean {
      const p = this.$route.path
      if (p.startsWith('/music/') && p !== '/music') {
        return false
      }
      return true
    },
  },
  methods: {
    applyTheme(theme: 'system' | 'light' | 'dark') {
      const isDark =
        theme === 'dark' ||
        (theme === 'system' &&
          window.matchMedia('(prefers-color-scheme: dark)').matches)
      const targetTheme = isDark ? 'dark' : 'light'

      this.$vuetify.theme.change(targetTheme)

      if (Capacitor.getPlatform() !== 'web') {
        StatusBar.setStyle({ style: isDark ? Style.Dark : Style.Light })
      }
    },
  },
  watch: {
    'settings.display.theme'(newTheme: 'system' | 'light' | 'dark') {
      this.applyTheme(newTheme)
    },
  },
  async mounted() {
    // 開発者オプション
    if (this.settings.developerOptions.statusBarNotch !== 'default') {
      this.settings.hidden.isAndroid15OrHigher =
        this.settings.developerOptions.statusBarNotch == 'true'
    }

    /** ログイン情報 */
    if (this.myProfile.$state.guest == false) {
      setTimeout(async () => {
        const token = this.myProfile.userToken
        const profile = await this.getProfile(this.myProfile.userId ?? '')
        if (profile) {
          profile.userToken = token
          profile.guest = false
          this.myProfile = {
            ...this.myProfile,
            ...profile,
          }
        }
      }, 100)
    } else {
      this.myProfile.$reset()
    }

    // テーマの初期化と適用
    this.applyTheme(this.settings.display.theme)

    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
    mediaQuery.addEventListener('change', () => {
      if (this.settings.display.theme === 'system') {
        this.applyTheme('system')
      }
    })

    /**
     * mountedの最後に記述
     */
    window.setTimeout(() => {
      this.splashScreen = false
    }, 300)
  },
}
</script>

<style lang="scss">
@use 'sass:map';
// フォントをZen Maru Gothicに統一
* {
  font-family: 'Zen Maru Gothic', sans-serif !important;
}

.status-bar-padding.android-15-or-higher {
  height: 40px;
  width: 100vw;
  background-color: rgb(var(--v-theme-surface));
}
.nav-bar-padding.android-15-or-higher {
  height: 16px;
  width: 100vw;
}

body {
  user-select: none;
}

hr {
  border-color: rgba(var(--v-theme-on-surface), 0.3);
  margin: 0.5em 1em;
}

main {
  height: 100vh;
  overflow: hidden;
}

//テーマカラーの変更
//青紫がテーマカラー！
.v-theme--dark {
  --v-theme-primary: 225, 35, 120 !important;
}
.v-theme--light {
  --v-theme-primary: 225, 35, 120 !important;
}
:root {
  --v-theme-primary: 225, 35, 120 !important;
}

:root {
  font-size: 16px;
  --color-allow: #cceeff;
  --color-error: #ffcccc;
  --color-error: #cc2222;
  --color-success: #338833;
  /** アプリの色 */
  --accent-color: rgb(var(--v-theme-primary));
  /** アプリの色に合わせた文字色 */
  --accent-text-color: #ffffff;
  /** デフォルトのボーダー角の大きさ */
  --border-radius: 16px;
}

button {
  text-transform: none !important;
  padding: 1em;
}

/** URLや日報をコピー用 */
pre {
  background: #cccccc;
  color: #000000;
  user-select: all;
  overflow-x: auto;
}

img {
  object-fit: cover;
  object-position: center;
}

// 表示バグ対策
.v-dialog > .v-overlay__content,
.v-dialog > .v-overlay__content > form {
  align-items: center;
}

/* --- 旧default.vueから復元した共通レイアウトスタイル --- */
$breakpoints: (
  'smartPhone': 'screen and (max-width:900px)',
  'tablet': 'screen and (max-width:1400px)',
  'pwa': '(display-mode: standalone)',
) !default;

@mixin mq($breakpoint) {
  @media #{map.get($breakpoints, $breakpoint)} {
    @content;
  }
}

.center {
  width: 60%;
  margin: auto;
  @include mq('tablet') {
    width: 80%;
  }
  @include mq('smartPhone') {
    width: 100%;
  }
}

.wrap {
  display: flex;
  justify-content: center;
  padding: 8px 0px;
  flex-direction: column;
  align-items: center;
}

.content {
  width: 95%;
  display: flex;
  flex-direction: column;
  padding: 8px 16px;
  border-radius: var(--border-radius);
  overflow: hidden;
}

.wrap100vh {
  min-height: 100vh !important;
}

.big-img {
  max-height: 300px;
  object-fit: cover;
  width: 100%;
}

.img-wrap {
  position: relative;
  background-color: #000000;
  p {
    position: absolute;
    top: 50%;
    left: 50%;
    -ms-transform: translate(-50%, -50%);
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
    margin: 0;
    padding: 0;
    color: white;
    white-space: nowrap;
  }
  img {
    opacity: 0.7;
  }
}

.relative {
  position: relative;
}

.absolute {
  position: absolute;
}

.allow-select {
  user-select: auto;
}

.allow-select-all {
  user-select: all;
}

.underline {
  text-decoration: underline;
}

.ontext {
  height: 1em;
  vertical-align: middle;
  object-fit: cover;
}

/** 見出し・テキストスタイル */
.text-h0 {
  font-size: 4em !important;
}
.text-h1 {
  font-size: 3em !important;
}
.text-h2 {
  font-size: 2.8em !important;
}
.text-h3 {
  font-size: 2.4em !important;
}
.text-h4 {
  font-size: 2.2em !important;
}
.text-h5 {
  font-size: 2em !important;
}
.text-h6,
.text {
  font-size: 1.5em !important;
}
.text-h7,
.text-small {
  font-size: 1em !important;
}

.text-h0,
.text-h1,
.text-h2,
.text-h3 {
  white-space: nowrap;
  overflow: hidden;
}

.text-h0,
.text-h1,
.text-h2,
.text-h3,
.text-h4,
.text-h5,
.text-h6 {
  margin-top: 0.2em;
  margin-bottom: 0.2em;
}

/** レスポンシブ表示切り替え */
.is-mobile {
  display: none;
  @include mq('smartPhone') {
    display: initial;
  }
}

.is-not-mobile {
  display: initial;
  @include mq('smartPhone') {
    display: none;
  }
}

.is-pwa {
  display: none;
  @include mq('pwa') {
    display: initial;
  }
}

.is-not-pwa {
  display: initial;
  @include mq('pwa') {
    display: none;
  }
}

.v-card-text {
  padding: 1em;
}

.v-responsive__sizer {
  display: none;
}

.v-chip {
  padding: 0.5em 0.7em;
  margin: 0 0.2em;
}
</style>
