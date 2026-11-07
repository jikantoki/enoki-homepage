<template lang="pug">
v-card(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
  )
  v-card-actions
    p.ml-2(style="font-size: 1.3em") 設定
    v-spacer
    v-btn(
      text
      @click="$router.back()"
      icon="mdi-close"
      )
  v-card-text(style="height: inherit; overflow-y: auto;")
    .settings-list
      .setting-item(
        v-ripple
        @click="$router.push('/settings/display')"
        )
        .icon
          v-icon mdi-palette-outline
        .text
          p.title 外観
          p.description テーマ、色、言語
      .setting-item(
        v-ripple
        @click="openNotificationSettings"
        )
        .icon
          v-icon mdi-bell-outline
        .text
          p.title 通知
          p.description メール、プッシュ通知
      .setting-item(
        v-ripple
        @click="$router.push('/terms')"
        )
        .icon
          v-icon mdi-file-document-outline
        .text
          p.title 利用規約
      .setting-item(
        v-ripple
        @click="$router.push('/privacy')"
        )
        .icon
          v-icon mdi-shield-lock-outline
        .text
          p.title プライバシーポリシー
          p.description 個人情報の取り扱いについて
      .setting-item(
        v-ripple
        @click="$router.push('/about')"
        )
        .icon
          v-icon mdi-information-outline
        .text
          p.title 運営情報
          p.description エノキ電気について
      .setting-item(
        v-ripple
        @click="$router.push('/sponsors')"
        )
        .icon
          v-icon mdi-handshake-outline
        .text
          p.title スポンサー・友人紹介
          p.description 支援者およびクリエイター仲間
      .setting-item(
        v-if="settings.developerOptions.enabled"
        v-ripple
        @click="$router.push('/settings/developer-options')"
        )
        .icon(
          style="background-color: rgba(var(--v-theme-primary), 1); color: white;"
        )
          v-icon mdi-bug-outline
        .text
          p.title 開発者オプション
          p.description 特定のモバイル向けの機能を強制有効
      .setting-item(
        v-if="myProfile.guest"
        v-ripple
        @click="$router.push('/login')"
        )
        .icon(
          style="background-color: rgba(var(--v-theme-primary), 0.15); color: rgb(var(--v-theme-primary));"
        )
          v-icon mdi-shield-account-outline
        .text
          p.title 管理者ログイン
          p.description 管理者アカウントでログイン
      //.setting-item(
        v-else
        v-ripple
        @click="$router.push('/settings/profile')"
        )
        .icon(
          style="background-color: rgba(var(--v-theme-primary), 0.15); color: rgb(var(--v-theme-primary));"
        )
          v-icon mdi-shield-check-outline
        .text
          p.title 管理者プロファイル ({{ myProfile.userId }})
          p.description 管理者プロフィールの確認・編集
      .setting-item(
        v-if="!myProfile.guest"
        v-ripple
        @click="$router.push('/admin/manage')"
        )
        .icon(
          style="background-color: rgba(var(--v-theme-primary), 1); color: white;"
        )
          v-icon mdi-format-list-checks
        .text
          p.title コンテンツ管理 (編集・削除)
          p.description 既存アプリ・楽曲の一覧確認、編集、削除
      .setting-item(
        v-if="!myProfile.guest"
        v-ripple
        @click="$router.push('/admin/register')"
        )
        .icon(
          style="background-color: rgba(var(--v-theme-primary), 0.85); color: white;"
        )
          v-icon mdi-shield-plus-outline
        .text
          p.title コンテンツ新規登録 (アプリ・音楽)
          p.description 管理者権限で新規アプリや楽曲、音声を登録
      .setting-item(
        v-ripple
        @click="logoutRequest()"
        v-if="!myProfile.guest"
        )
        .icon(style="background: rgba(var(--v-theme-error), 1); color: white;")
          v-icon mdi-logout
        .text
          p.title 管理者ログアウト
          p.description ログアウトしてゲスト状態に戻ります
      .my-16
v-dialog(
  v-model="logoutDialog"
  max-width="400"
  )
  v-card
    v-card-title(class="headline font-weight-bold") 管理者ログアウトしますか？
    v-card-text
      | ログアウトすると管理者セッションが解除され、ゲスト状態に戻ります。
    v-card-actions
      v-spacer
      v-btn(
        text
        @click="logoutDialog = false"
        append-icon="mdi-close"
        ) キャンセル
      v-btn(
        text
        style="background: rgba(var(--v-theme-error), 1); color: white;"
        append-icon="mdi-logout"
        :loading="loggingOut"
        @click="logout"
        ) ログアウト
</template>

<script lang="ts">
import { Browser } from '@capacitor/browser'
import {
  AndroidSettings,
  IOSSettings,
  NativeSettings,
} from 'capacitor-native-settings'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import { logoutAccountFromPHP } from '@/js/contentApi'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'
import { Capacitor } from '@capacitor/core'
import { Toast } from '@capacitor/toast'

export default {
  name: 'SettingsPage',
  mixins: [mixins],
  data() {
    return {
      logoutDialog: false,
      loggingOut: false,
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
    }
  },
  setup() {
    //サーバーサイドで仮のタイトルを設定、mountedで言語ごとに再設定する
    Setup.setTitle('設定')
    Setup.setDescription('設定ページです')
  },
  async mounted() {
    this.setTitle('設定')
  },
  methods: {
    logoutRequest() {
      this.logoutDialog = true
    },
    async logout() {
      this.loggingOut = true
      try {
        await logoutAccountFromPHP()
        Toast.show({ text: '管理者からログアウトしました' })
      } catch (error) {
        console.error('Logout error:', error)
        Toast.show({ text: 'ログアウトしました' })
      } finally {
        this.loggingOut = false
        this.logoutDialog = false
        this.$router.push('/login')
      }
    },
    async openNotificationSettings() {
      if (Capacitor.isNativePlatform()) {
        try {
          await NativeSettings.open({
            optionAndroid: AndroidSettings.AppNotification,
            optionIOS: IOSSettings.AppNotification,
          })
        } catch (error) {
          Toast.show({
            text: '通知設定を開くことができませんでした',
          })
          console.error('Failed to open notification settings:', error)
        }
      } else {
        // Webブラウザの場合は、トーストでエラー表示
        Toast.show({
          text: 'Webブラウザでは通知設定を開くことができません',
        })
      }
    },
    /** URLをブラウザで開く */
    async openURL(url: string) {
      await Browser.open({ url: url })
    },
  },
}
</script>

<style lang="scss" scoped>
.settings-list {
  display: flex;
  flex-direction: column;
  gap: 1em;
  .setting-item {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 1em;
    padding: 1em;
    border-radius: 8px;
    cursor: pointer;
    .icon {
      background: rgba(var(--v-theme-on-surface), 0.1);
      border-radius: 50%;
      width: 40px;
      min-width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .text {
      .title {
        font-weight: bold;
        font-size: 0.7em;
        margin-bottom: 0.5em;
      }
      .description {
        font-size: 0.5em;
        color: #666;
      }
    }
  }
}

.top-android-15-or-higher {
  height: calc(100vh - 40px - 16px) !important;
  height: calc(100dvh - 40px - 16px) !important;
}
</style>
