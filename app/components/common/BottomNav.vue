<template lang="pug">
.bottom-nav-container
  .store-bottom-nav
    .nav-buttons
      //- 1. ホーム
      .nav-btn(
        :class="{ active: isHomeActive }"
        v-ripple
        @click="goTo('/')"
      )
        v-icon {{ isHomeActive ? 'mdi-home' : 'mdi-home-outline' }}
        span ホーム

      //- 2. ソフトウェア
      .nav-btn(
        :class="{ active: isSoftwareActive }"
        v-ripple
        @click="goTo('/apps')"
      )
        v-icon mdi-apps
        span ソフトウェア

      //- 3. 音楽
      .nav-btn(
        :class="{ active: isMusicActive }"
        v-ripple
        @click="goTo('/music')"
      )
        v-icon mdi-music
        span 音楽

      //- 4. プロフィール
      .nav-btn(
        :class="{ active: isProfileActive }"
        v-ripple
        @click="goTo('/profile')"
      )
        v-icon {{ isProfileActive ? 'mdi-account-circle' : 'mdi-account-circle-outline' }}
        span プロフィール

      //- 5. その他
      .nav-btn(
        :class="{ active: optionsDialog }"
        v-ripple
        @click="optionsDialog = true"
      )
        v-icon mdi-dots-horizontal
        span その他

    .bottom-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher")

  //- ================= その他 / ようこそダイアログ =================
  v-dialog.options-dialog(
    v-model="optionsDialog"
    :fullscreen="isMobile"
    :transition="isMobile ? 'dialog-bottom-transition' : 'dialog-transition'"
    :max-width="isMobile ? undefined : 500"
    :width="isMobile ? '100%' : '90%'"
    scrollable
  )
    v-card.options-dialog-card(:class="{ 'is-pc': !isMobile }")
      .top-android-15-or-higher(v-if="settings.hidden.isAndroid15OrHigher && isMobile")
      v-card-actions.dialog-header
        p.ml-4.dialog-title(class="headline font-weight-bold" style="font-size: 1.25em") ようこそ
        v-spacer
        v-btn.dialog-close-btn(
          icon="mdi-close"
          variant="text"
          density="comfortable"
          @click="optionsDialog = false"
        )
      v-card-text.dialog-content
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
          v-list-item.item(@click="optionsDialog = false; $router.push('/')")
            .icon-and-text
              v-icon mdi-home-outline
              v-list-item-title ホーム
          v-list-item.item(@click="optionsDialog = false; $router.push('/qrcode')")
            .icon-and-text
              v-icon mdi-qrcode-scan
              v-list-item-title QRコードで探す
          v-list-item.item(@click="optionsDialog = false; $router.push('/profile')")
            .icon-and-text
              v-icon mdi-account-circle-outline
              v-list-item-title プロフィール
          v-list-item.item(@click="optionsDialog = false; $router.push('/sponsors')")
            .icon-and-text
              v-icon mdi-handshake-outline
              v-list-item-title スポンサー・友人
          v-list-item.item(@click="optionsDialog = false; $router.push('/terms')")
            .icon-and-text
              v-icon mdi-file-document-outline
              v-list-item-title 利用規約
          v-list-item.item(@click="optionsDialog = false; $router.push('/privacy')")
            .icon-and-text
              v-icon mdi-shield-lock-outline
              v-list-item-title プライバシーポリシー
          v-list-item.item(
            v-if="isAdmin"
            @click="optionsDialog = false; $router.push('/admin/manage')"
            style="background: rgba(var(--v-theme-primary), 0.08); border-radius: 8px;"
          )
            .icon-and-text
              v-icon(color="primary") mdi-format-list-checks
              v-list-item-title.font-weight-bold(style="color: rgb(var(--v-theme-primary));") コンテンツ管理 (編集・削除)
          v-list-item.item(
            v-if="isAdmin"
            @click="optionsDialog = false; $router.push('/admin/register')"
            style="background: rgba(var(--v-theme-primary), 0.04); border-radius: 8px; margin-top: 4px;"
          )
            .icon-and-text
              v-icon(color="primary") mdi-shield-plus-outline
              v-list-item-title.font-weight-bold(style="color: rgb(var(--v-theme-primary));") アプリ・音楽を登録
          v-list-item.item(@click="optionsDialog = false; $router.push('/settings')")
            .icon-and-text
              v-icon mdi-cog
              v-list-item-title 設定
          v-list-item.item(@click="shareSite")
            .icon-and-text
              v-icon mdi-share-variant
              v-list-item-title シェア
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { useSettingsStore } from '@/stores/settings'
import { useAppStore } from '@/stores/app'
import { useMusicStore } from '@/stores/music'
import { useMyProfileStore } from '@/stores/myProfile'

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
      myProfile: useMyProfileStore(),
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
    isAdmin(): boolean {
      return Boolean(
        this.myProfile.isAdmin ||
        this.myProfile.role === 'admin' ||
        (!this.myProfile.guest && this.myProfile.canRegisterApp)
      )
    },
    isMobile(): boolean {
      // 画面幅が600px未満（スマホ縦画面など）の場合は全画面ダイアログ
      return Boolean(this.$vuetify?.display?.xs)
    },
    currentPath(): string {
      return this.$route.path
    },
    isHomeActive(): boolean {
      return this.currentPath === '/'
    },
    isSoftwareActive(): boolean {
      return this.currentPath.startsWith('/apps')
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

.options-dialog-card {
  width: 100%;
  max-width: 500px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  background-color: rgb(var(--v-theme-surface));

  &.is-pc {
    border-radius: 24px !important;
    max-height: 85vh;
    max-height: 85dvh;
    box-shadow: 0 16px 40px rgba(0, 0, 0, 0.25) !important;
    border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

    .dialog-header {
      padding: 16px 16px 8px 24px;
      flex-shrink: 0;
    }

    .dialog-content {
      padding: 8px 20px 24px 20px;
      overflow-y: auto;
    }
  }

  &:not(.is-pc) {
    min-height: 100vh;
    min-height: 100dvh;
    height: 100%;
    height: 100dvh;
    border-radius: 0 !important;

    .dialog-header {
      padding: 8px 8px 8px 16px;
      flex-shrink: 0;
    }

    .dialog-content {
      padding: 8px 16px 24px 16px;
      overflow-y: auto;
    }
  }
}

.options-list {
  background: transparent;

  .item {
    cursor: pointer;
    border-radius: 12px !important;
    padding: 0.5em 0.8em;
    margin-bottom: 4px;
    transition: background-color 0.15s ease;

    &:hover {
      background-color: rgba(var(--v-theme-on-surface), 0.06);
    }

    .icon-and-text {
      display: flex;
      align-items: center;
      gap: 14px;
      font-size: 14px;
    }
  }
}
</style>
