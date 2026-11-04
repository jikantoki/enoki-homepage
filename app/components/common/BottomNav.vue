<template lang="pug">
.bottom-nav-container
  .store-bottom-nav
    .nav-buttons
      //- 1. ソフトウェア
      .nav-btn(
        :class="{ active: isSoftwareActive }"
        v-ripple
        @click="goTo('/')"
      )
        v-icon mdi-apps
        span ソフトウェア

      //- 2. 音楽
      .nav-btn(
        :class="{ active: isMusicActive }"
        v-ripple
        @click="goTo('/music')"
      )
        v-icon mdi-music
        span 音楽

      //- 3. プロフィール
      .nav-btn(
        :class="{ active: isProfileActive }"
        v-ripple
        @click="goTo('/profile')"
      )
        v-icon {{ isProfileActive ? 'mdi-account-circle' : 'mdi-account-circle-outline' }}
        span プロフィール

      //- 4. その他
      .nav-btn(
        :class="{ active: optionsDialog }"
        v-ripple
        @click="optionsDialog = true"
      )
        v-icon mdi-dots-horizontal
        span その他

    .bottom-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher")

  //- ================= その他 / ようこそダイアログ =================
  v-dialog(
    v-model="optionsDialog"
    transition="dialog-bottom-transition"
    fullscreen
  )
    v-card
      .top-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher")
      v-card-actions
        p.ml-4(class="headline" style="font-size: 1.3em") ようこそ
        v-spacer
        v-btn(
          text
          @click="optionsDialog = false"
          icon="mdi-close"
        )
      v-card-text
        .account-details(
          style="display: flex; flex-direction: column; align-items: center; gap: 1em; margin-bottom: 1em;"
        )
          .account-img
            img(
              src="/icon.png"
              style="height: 8em; width: 8em; border-radius: 9999px;"
              onerror="this.src='/account_default.jpg'"
            )
          .account-info(style="text-align: center;")
            p(style="font-size: 1.2em; margin: 0; padding: 0;") エノキ電気
            p(style="margin: 0; padding: 0;") ENOKI ELECTRONICS

        v-list.options-list
          v-list-item.item(@click="optionsDialog = false; $router.push('/qrcode')")
            .icon-and-text
              v-icon mdi-qrcode-scan
              v-list-item-title QRコードで探す
          v-list-item.item(@click="optionsDialog = false; $router.push('/settings')")
            .icon-and-text
              v-icon mdi-cog
              v-list-item-title 設定
          v-list-item.item(@click="optionsDialog = false; $router.push('/terms')")
            .icon-and-text
              v-icon mdi-file-document-outline
              v-list-item-title 利用規約
          v-list-item.item(@click="optionsDialog = false; $router.push('/privacy')")
            .icon-and-text
              v-icon mdi-shield-lock-outline
              v-list-item-title プライバシーポリシー
          v-list-item.item(@click="optionsDialog = false; $router.push('/profile')")
            .icon-and-text
              v-icon mdi-account-circle-outline
              v-list-item-title プロフィール・実績（ときえのき）
          v-list-item.item(@click="shareSite")
            .icon-and-text
              v-icon mdi-share-variant
              v-list-item-title 共有する
          v-list-item.item(@click="reloadMockData")
            .icon-and-text
              v-icon mdi-refresh
              v-list-item-title アプリモックデータを再読み込み (100件)
          v-list-item.item(@click="reloadMusicData")
            .icon-and-text
              v-icon mdi-music-box-multiple
              v-list-item-title 音楽モックデータを再読み込み (60曲)
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { useSettingsStore } from '@/stores/settings'
import { useAppStore } from '@/stores/app'
import { useMusicStore } from '@/stores/music'

export default {
  name: 'BottomNav',
  props: {
    // 外部からその他ダイアログを開くための制御用
    modelValue: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['update:modelValue', 'tabClick'],
  data() {
    return {
      settings: useSettingsStore(),
      appStore: useAppStore(),
      musicStore: useMusicStore(),
      optionsDialog: this.modelValue,
    }
  },
  watch: {
    modelValue(val) {
      this.optionsDialog = val
    },
    optionsDialog(val) {
      this.$emit('update:modelValue', val)
    },
  },
  computed: {
    currentPath(): string {
      return this.$route.path
    },
    isSoftwareActive(): boolean {
      return this.currentPath === '/' || this.currentPath.startsWith('/apps')
    },
    isMusicActive(): boolean {
      return this.currentPath.startsWith('/music')
    },
    isProfileActive(): boolean {
      return (
        this.currentPath.startsWith('/profile') ||
        this.currentPath.startsWith('/about')
      )
    },
  },
  methods: {
    goTo(path: string) {
      this.$emit('tabClick', path)
      if (this.currentPath !== path) {
        this.$router.push(path)
      } else {
        // 同じページの場合、トップへスクロール
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    async shareSite() {
      try {
        await Share.share({
          url: 'https://enoki.xyz?openExternalBrowser=1',
          title: 'エノキ電気 公式ホームページ',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz')
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
    reloadMockData() {
      this.appStore.loadMockData(true)
      Toast.show({ text: '100件のアプリモックデータを再読み込みしました' })
      this.optionsDialog = false
    },
    reloadMusicData() {
      this.musicStore.loadMockData(true)
      Toast.show({ text: '60曲の音楽モックデータを再読み込みしました' })
      this.optionsDialog = false
    },
  },
}
</script>

<style lang="scss" scoped>
.store-bottom-nav {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgb(var(--v-theme-surface));
  border-top: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  z-index: 20;

  .nav-buttons {
    display: flex;
    justify-content: space-around;
    align-items: center;
    height: 56px;
    max-width: 600px;
    margin: 0 auto;

    .nav-btn {
      flex: 1;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      user-select: none;
      color: rgba(var(--v-theme-on-surface), 0.65);
      transition: color 0.15s ease;
      font-size: 11px;
      font-weight: 600;
      gap: 3px;

      .v-icon {
        font-size: 22px;
      }

      &.active {
        color: rgb(var(--v-theme-primary));
        font-weight: 800;

        .v-icon {
          transform: scale(1.08);
        }
      }
    }
  }

  .bottom-android-15-or-higher {
    height: 16px;
    background-color: rgb(var(--v-theme-surface));
  }
}

.options-list {
  background: transparent;

  .item {
    cursor: pointer;
    border-radius: 12px !important;
    padding: 0.5em;
    margin-bottom: 4px;

    .icon-and-text {
      display: flex;
      align-items: center;
      gap: 12px;
    }
  }
}
</style>
