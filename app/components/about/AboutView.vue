<template lang="pug">
.about-view-container
  .about-hero-section
    .app-icon-wrapper
      img.app-icon(src="/icon.png" alt="ENOKI Appcenter")
    h2.app-name ENOKI Appcenter
    p.app-subtitle エノキ電気公式プラットフォーム

  .about-content-section
    .section-card
      h3.card-section-title 開発者情報
      .settings-list
        .setting-item(
          v-ripple
        )
          .icon
            img.author-avatar(src="/jikantoki.jpg" width="36" height="36" alt="ときえのき")
          .text
            p.title ときえのき
            p.description jikantoki / エノキ電気 代表
        p
          | 2003年爆誕。
    .section-card
      h3.card-section-title リンク
      .settings-list
        .setting-item(
          v-ripple
          @click="openURL('https://enoki.xyz')"
        )
          .icon
            img.author-avatar(src="/jikantoki-homepage.jpg" width="36" height="36" alt="ホームページ")
          .text
            p.title ホームページ
            p.description https://enoki.xyz

        .setting-item(
          v-ripple
          @click="openURL('https://www.youtube.com/@jikantoki')"
        )
          .icon(style="background: #FF0000; color: white;")
            v-icon mdi-youtube
          .text
            p.title YouTube
            p.description https://www.youtube.com/@jikantoki

        .setting-item(
          v-ripple
          @click="openURL('https://twitter.com/jikantoki')"
        )
          .icon(style="background: #1DA1F2; color: white;")
            v-icon mdi-twitter
          .text
            p.title Twitter / X
            p.description https://twitter.com/jikantoki

        .setting-item(
          v-ripple
          @click="openURL('https://github.com/jikantoki')"
        )
          .icon(style="background: #111111; color: white;")
            v-icon mdi-github
          .text
            p.title GitHub
            p.description https://github.com/jikantoki
    .section-card
      h3.card-section-title アプリケーション情報
      .settings-list
        .setting-item(
          v-ripple
        )
          .icon
            v-icon mdi-application-outline
          .text
            p.title ENOKI Appcenter
            p.description &copy; 2019 エノキ電気

        .setting-item(
          v-ripple
          @click="developerOptionToggle"
        )
          .icon
            v-icon mdi-information-outline
          .text
            p.title バージョン情報
            p.description v1.0.0 (タップで開発者オプション解放)

        .setting-item(
          v-if="settings.developerOptions.enabled"
          v-ripple
          @click="$router.push('/settings/developer-options')"
        )
          .icon.highlight-icon
            v-icon mdi-bug-outline
          .text
            p.title 開発者オプション
            p.description 特定のモバイル向けの機能を強制有効
</template>

<script lang="ts">
import { Browser } from '@capacitor/browser'
import { Toast } from '@capacitor/toast'
import { useSettingsStore } from '@/stores/settings'

export default {
  name: 'AboutView',
  data() {
    return {
      settings: useSettingsStore(),
      developerOptionClickCount: 0,
    }
  },
  methods: {
    async openURL(url: string) {
      await Browser.open({ url: url })
    },
    async developerOptionToggle() {
      if (this.settings.developerOptions.enabled) {
        await Toast.show({
          text: '開発者オプションは既に有効です',
          duration: 'long',
        })
        return
      }
      this.developerOptionClickCount += 1
      if (this.developerOptionClickCount >= 8) {
        this.settings.developerOptions.enabled = true
        await Toast.show({
          text: '開発者オプションが有効になりました',
          duration: 'long',
        })
      } else {
        await Toast.show({
          text: `開発者オプションを有効にするまであと ${
            8 - this.developerOptionClickCount
          } 回タップ`,
        })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.about-view-container {
  padding: 16px;
  max-width: 680px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;

  .about-hero-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 24px 16px;
    background: rgba(var(--v-theme-on-surface), 0.03);
    border-radius: 20px;
    text-align: center;

    .app-icon-wrapper {
      width: 90px;
      height: 90px;
      border-radius: 22px;
      overflow: hidden;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      margin-bottom: 12px;

      .app-icon {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .app-name {
      font-size: 24px;
      font-weight: 800;
      margin: 0;
      color: rgb(var(--v-theme-on-surface));
    }

    .app-subtitle {
      font-size: 13px;
      color: rgba(var(--v-theme-on-surface), 0.6);
      margin: 4px 0;
    }

    .hero-links {
      display: flex;
      gap: 12px;
    }
  }

  .about-content-section {
    display: flex;
    flex-direction: column;
    gap: 16px;

    .section-card {
      background: rgba(var(--v-theme-on-surface), 0.02);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.06);
      border-radius: 16px;
      padding: 16px;

      .card-section-title {
        font-size: 15px;
        font-weight: 700;
        margin: 0 0 12px 0;
        color: rgba(var(--v-theme-on-surface), 0.8);
      }
    }
  }

  .settings-list {
    display: flex;
    flex-direction: column;
    gap: 8px;

    .setting-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 10px 12px;
      border-radius: 12px;
      cursor: pointer;
      transition: background-color 0.15s;

      &:hover {
        background-color: rgba(var(--v-theme-on-surface), 0.06);
      }

      .icon {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        background: rgba(var(--v-theme-on-surface), 0.08);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;

        &.highlight-icon {
          background-color: rgb(var(--v-theme-primary));
          color: white;
        }

        .author-avatar {
          border-radius: 50%;
          width: 36px;
          height: 36px;
          object-fit: cover;
        }
      }

      .text {
        flex: 1;
        min-width: 0;

        .title {
          font-size: 14px;
          font-weight: 700;
          color: rgb(var(--v-theme-on-surface));
          margin: 0;
        }

        .description {
          font-size: 12px;
          color: rgba(var(--v-theme-on-surface), 0.6);
          margin: 2px 0 0 0;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }
    }
  }
}
</style>
