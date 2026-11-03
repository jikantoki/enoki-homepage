<template lang="pug">
.about-view-container
  //- ================= ヒーローヘッダー =================
  .profile-hero-card
    .hero-cover
      img.cover-img(src="/img/default_cover.jpg" alt="Cover" onerror="this.src='/img/thumbnail.jpg'")
      .cover-overlay
    .hero-body
      .avatar-wrapper
        img.profile-avatar(src="/jikantoki.jpg" alt="ときえのき" onerror="this.src='/account_default.jpg'")
      .profile-titles
        .name-row
          h2.profile-name {{ profile.name }}
          span.profile-english ({{ profile.englishName }})
        p.profile-role {{ profile.title }}
        p.profile-motto {{ profile.motto }}

      //- 属性チップ
      .profile-badges
        v-chip(size="small" variant="tonal" prepend-icon="mdi-baby-carriage" color="primary") {{ profile.birthDate }} 生まれ
        v-chip(size="small" variant="tonal" prepend-icon="mdi-map-marker" color="teal") {{ profile.birthPlace }}
        v-chip(size="small" variant="tonal" prepend-icon="mdi-office-building" color="amber-darken-2") エノキ電気グループ 代表

      //- SNSクイックリンクボタン群
      .social-links
        v-btn(
          v-for="social in profile.socials"
          :key="social.title"
          size="small"
          rounded="pill"
          variant="flat"
          :style="{ background: social.bg, color: social.color }"
          :prepend-icon="social.icon"
          @click="openURL(social.url)"
        ) {{ social.title }}

  //- ================= セクション切り替えタブ =================
  .profile-tabs-wrapper
    v-tabs(
      v-model="currentTab"
      color="primary"
      density="comfortable"
      align-tabs="center"
      grow
    )
      v-tab(value="profile")
        v-icon(start) mdi-account
        | プロフィール
      v-tab(value="achievements")
        v-icon(start) mdi-trophy
        | 実績 ({{ profile.achievements.length }})
      v-tab(value="career")
        v-icon(start) mdi-timeline-clock
        | 経歴年表
      v-tab(value="app")
        v-icon(start) mdi-application
        | アプリ

  //- ================= タブコンテンツ =================
  .tab-content-area
    //- ---------------- 1. プロフィール・スキル ----------------
    .tab-pane(v-if="currentTab === 'profile'")
      //- 自己紹介カード
      .content-card
        .card-header
          v-icon(color="primary") mdi-text-box-outline
          h3 自己紹介
        .bio-text
          p(v-for="(paragraph, idx) in bioParagraphs" :key="idx") {{ paragraph }}

      //- 活動ジャンル・スキル
      .content-card
        .card-header
          v-icon(color="primary") mdi-star-circle-outline
          h3 活動分野・スキル
        .skills-grid
          .skill-box(
            v-for="skill in profile.skills"
            :key="skill.title"
            :style="{ borderColor: skill.color + '40' }"
          )
            .skill-box-header
              .skill-icon-circle(:style="{ background: skill.color + '20', color: skill.color }")
                v-icon {{ skill.icon }}
              .skill-header-text
                h4.skill-title {{ skill.title }}
                p.skill-summary {{ skill.summary }}
            ul.skill-items-list
              li(v-for="(item, i) in skill.items" :key="i") {{ item }}

      //- 保有資格・免許
      .content-card
        .card-header
          v-icon(color="primary") mdi-certificate-outline
          h3 保有資格・免許
        .licenses-list
          .license-item(v-for="lic in profile.licenses" :key="lic.name")
            .license-icon-box
              v-icon(color="primary") {{ lic.icon }}
            .license-info
              .license-top
                span.license-name {{ lic.name }}
                v-chip(size="x-small" variant="outlined" color="primary") {{ lic.category }}
              span.license-date 取得日: {{ lic.date }}

      //- お問い合わせ
      .content-card
        .card-header
          v-icon(color="primary") mdi-email-outline
          h3 お問い合わせ
        .contact-content
          p.contact-desc
            | お問い合わせは
            a.contact-link(@click.prevent="openURL('mailto:info@enoki.xyz')") info@enoki.xyz
            | もしくはTwitter
            a.contact-link(@click.prevent="openURL('https://twitter.com/jikantoki')") @jikantoki
            | にて受け付けております。
          .contact-actions
            v-btn(
              size="small"
              variant="tonal"
              color="primary"
              prepend-icon="mdi-email"
              @click="openURL('mailto:info@enoki.xyz')"
            ) メールで問い合わせる
            v-btn(
              size="small"
              variant="tonal"
              color="info"
              prepend-icon="mdi-twitter"
              @click="openURL('https://twitter.com/jikantoki')"
            ) Twitterで問い合わせる

      //- 特定商取引に関する表記
      .content-card
        .card-header
          v-icon(color="primary") mdi-store-outline
          h3 特定商取引に関する表記
        .commerce-disclosure-table
          .commerce-row
            .commerce-th 販売事業者名
            .commerce-td ENOKI ELECTRONICS
          .commerce-row
            .commerce-th メールアドレス
            .commerce-td
              a.contact-link(@click.prevent="openURL('mailto:info@enoki.xyz')") info@enoki.xyz
          .commerce-row
            .commerce-th 所在地
            .commerce-td
              | 1-10-8, DOGENZAKA<br>
              | SHIBUYA DOGENZAKA TOKYU BLDG. 2F-C<br>
              | SHIBUYA-KU, 東京都 150-0043<br>
              | Japan
          .commerce-row
            .commerce-th 電話番号
            .commerce-td
              a.contact-link(@click.prevent="openURL('tel:+819038867986')") +81 90-3886-7986

    //- ---------------- 2. 主な実績 ----------------
    .tab-pane(v-else-if="currentTab === 'achievements'")
      .content-card
        .card-header
          v-icon(color="amber-darken-2") mdi-trophy-variant
          h3 主な実績ハイライト
          span.card-badge {{ profile.achievements.length }}件
        .achievements-list
          .achievement-card(
            v-for="item in profile.achievements"
            :key="item.id"
          )
            .achieve-icon-wrapper
              v-icon(:color="item.badgeColor || 'primary'") {{ item.icon }}
            .achieve-content
              .achieve-top
                v-chip(
                  size="x-small"
                  :color="item.badgeColor || 'primary'"
                  variant="tonal"
                ) {{ item.badge }}
                span.achieve-date {{ item.date }}
              h4.achieve-title {{ item.title }}
              p.achieve-desc(v-if="item.description") {{ item.description }}

    //- ---------------- 3. 経歴年表 ----------------
    .tab-pane(v-else-if="currentTab === 'career'")
      .content-card
        .card-header
          v-icon(color="primary") mdi-history
          h3 経歴・沿革タイムライン
        //- 年代フィルターチップ
        .timeline-filter-chips
          v-chip(
            size="small"
            :variant="careerFilter === 'all' ? 'flat' : 'outlined'"
            :color="careerFilter === 'all' ? 'primary' : undefined"
            @click="careerFilter = 'all'"
          ) すべて ({{ profile.career.length }})
          v-chip(
            size="small"
            :variant="careerFilter === 'recent' ? 'flat' : 'outlined'"
            :color="careerFilter === 'recent' ? 'primary' : undefined"
            @click="careerFilter = 'recent'"
          ) 2024年〜現在
          v-chip(
            size="small"
            :variant="careerFilter === 'middle' ? 'flat' : 'outlined'"
            :color="careerFilter === 'middle' ? 'primary' : undefined"
            @click="careerFilter = 'middle'"
          ) 2021〜2023年 (独立・創業期)
          v-chip(
            size="small"
            :variant="careerFilter === 'early' ? 'flat' : 'outlined'"
            :color="careerFilter === 'early' ? 'primary' : undefined"
            @click="careerFilter = 'early'"
          ) 〜2020年 (学生・原点)

        //- タイムラインリスト
        .custom-timeline
          .timeline-row(
            v-for="item in filteredCareer"
            :key="item.id"
            :class="{ 'is-highlight': item.highlight }"
          )
            .timeline-indicator
              .timeline-dot(:class="{ 'dot-highlight': item.highlight }")
                v-icon(size="14" :color="item.highlight ? '#FFFFFF' : 'primary'") {{ item.icon }}
              .timeline-line
            .timeline-card
              .timeline-card-header
                span.timeline-date {{ item.date }}
                v-chip(
                  v-if="item.tag"
                  size="x-small"
                  :variant="item.highlight ? 'flat' : 'tonal'"
                  :color="item.highlight ? 'primary' : undefined"
                ) {{ item.tag }}
              .timeline-card-title {{ item.title }}

    //- ---------------- 4. アプリケーション情報 ----------------
    .tab-pane(v-else-if="currentTab === 'app'")
      .content-card
        .card-header
          v-icon(color="primary") mdi-application-outline
          h3 アプリケーション情報
        .app-info-card
          .app-info-hero
            img.app-logo(src="/icon.png" alt="エノキ電気")
            .app-info-text
              h4.app-title.mb-1 エノキ電気 公式ホームページ
              p.app-copy ENOKI ELECTRONICS
              p.app-copyright &copy; 2019-{{ currentYear }} エノキ電気
          v-divider.my-3

          .app-action-list
            .action-item(v-ripple @click="developerOptionToggle")
              .action-icon
                v-icon mdi-information-outline
              .action-text
                p.action-title バージョン情報
                p.action-sub v1.0.0 (タップで開発者オプション解放)

            .action-item(
              v-if="settings.developerOptions.enabled"
              v-ripple
              @click="$router.push('/settings/developer-options')"
            )
              .action-icon.highlight-icon
                v-icon mdi-bug-outline
              .action-text
                p.action-title 開発者オプション
                p.action-sub 有効中 - 追加設定を開く
</template>

<script lang="ts">
import { Browser } from '@capacitor/browser'
import { Toast } from '@capacitor/toast'
import { useSettingsStore } from '@/stores/settings'
import { PROFILE_DATA } from '@/data/profile'

export default {
  name: 'AboutView',
  props: {
    initialTab: {
      type: String,
      default: 'profile',
    },
  },
  data() {
    return {
      settings: useSettingsStore(),
      developerOptionClickCount: 0,
      currentTab: this.initialTab,
      careerFilter: 'all' as 'all' | 'recent' | 'middle' | 'early',
      profile: PROFILE_DATA,
      currentYear: new Date().getFullYear(),
    }
  },
  computed: {
    bioParagraphs(): string[] {
      return this.profile.bio.split('\n').filter((p) => p.trim() !== '')
    },
    filteredCareer() {
      const list = this.profile.career
      if (this.careerFilter === 'recent') {
        return list.filter((item) => item.year >= 2024)
      } else if (this.careerFilter === 'middle') {
        return list.filter((item) => item.year >= 2021 && item.year <= 2023)
      } else if (this.careerFilter === 'early') {
        return list.filter((item) => item.year <= 2020)
      }
      return list
    },
  },
  methods: {
    async openURL(url: string) {
      try {
        await Browser.open({ url })
      } catch {
        window.open(url, '_blank')
      }
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
          text: '開発者オプションが有効になりました！',
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
  padding: 12px;
  max-width: 720px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding-bottom: 40px;

  // ヒーローカード
  .profile-hero-card {
    position: relative;
    border-radius: 20px;
    overflow: hidden;
    background: rgba(var(--v-theme-on-surface), 0.03);
    border: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);

    .hero-cover {
      height: 120px;
      position: relative;
      overflow: hidden;

      .cover-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }

      .cover-overlay {
        position: absolute;
        inset: 0;
        background: linear-gradient(
          to bottom,
          rgba(0, 0, 0, 0.1),
          rgba(0, 0, 0, 0.5)
        );
      }
    }

    .hero-body {
      padding: 0 16px 20px;
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
      margin-top: -45px;
      position: relative;

      .avatar-wrapper {
        width: 86px;
        height: 86px;
        border-radius: 50%;
        border: 4px solid rgb(var(--v-theme-surface));
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        background: rgb(var(--v-theme-surface));
        margin-bottom: 8px;

        .profile-avatar {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .profile-titles {
        margin-bottom: 12px;

        .name-row {
          display: flex;
          align-items: baseline;
          justify-content: center;
          gap: 8px;

          .profile-name {
            font-size: 24px;
            font-weight: 900;
            margin: 0;
            color: rgb(var(--v-theme-on-surface));
          }

          .profile-english {
            font-size: 14px;
            color: rgba(var(--v-theme-on-surface), 0.6);
            font-weight: 500;
          }
        }

        .profile-role {
          font-size: 14px;
          font-weight: 700;
          color: rgb(var(--v-theme-primary));
          margin: 2px 0 4px;
        }

        .profile-motto {
          font-size: 12px;
          font-style: italic;
          color: rgba(var(--v-theme-on-surface), 0.65);
          margin: 0;
        }
      }

      .profile-badges {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        justify-content: center;
        margin-bottom: 16px;
      }

      .social-links {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        justify-content: center;
      }
    }
  }

  // タブ部分
  .profile-tabs-wrapper {
    background: rgba(var(--v-theme-on-surface), 0.03);
    border-radius: 14px;
    padding: 4px;
    border: 1px solid rgba(var(--v-theme-on-surface), 0.06);
  }

  // コンテンツカード共通
  .content-card {
    background: rgba(var(--v-theme-on-surface), 0.02);
    border: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 16px;

    .card-header {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 14px;

      h3 {
        font-size: 16px;
        font-weight: 800;
        margin: 0;
        color: rgb(var(--v-theme-on-surface));
      }

      .card-badge {
        margin-left: auto;
        font-size: 12px;
        font-weight: 700;
        background: rgba(var(--v-theme-primary), 0.12);
        color: rgb(var(--v-theme-primary));
        padding: 2px 8px;
        border-radius: 10px;
      }
    }
  }

  // 自己紹介テキスト
  .bio-text {
    p {
      font-size: 13.5px;
      line-height: 1.7;
      color: rgba(var(--v-theme-on-surface), 0.85);
      margin: 0 0 8px;

      &:last-child {
        margin-bottom: 0;
      }
    }
  }

  // スキルグリッド
  .skills-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 12px;

    .skill-box {
      border: 1px solid;
      border-radius: 14px;
      padding: 12px;
      background: rgba(var(--v-theme-on-surface), 0.015);

      .skill-box-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;

        .skill-icon-circle {
          width: 38px;
          height: 38px;
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
        }

        .skill-header-text {
          min-width: 0;

          .skill-title {
            font-size: 14px;
            font-weight: 800;
            margin: 0;
            color: rgb(var(--v-theme-on-surface));
          }

          .skill-summary {
            font-size: 11px;
            color: rgba(var(--v-theme-on-surface), 0.6);
            margin: 2px 0 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
        }
      }

      .skill-items-list {
        margin: 0;
        padding-left: 18px;

        li {
          font-size: 12px;
          color: rgba(var(--v-theme-on-surface), 0.78);
          line-height: 1.5;
          margin-bottom: 4px;

          &:last-child {
            margin-bottom: 0;
          }
        }
      }
    }
  }

  // 免許・資格リスト
  .licenses-list {
    display: flex;
    flex-direction: column;
    gap: 8px;

    .license-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 12px;
      border-radius: 12px;
      background: rgba(var(--v-theme-on-surface), 0.02);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.05);

      .license-icon-box {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        background: rgba(var(--v-theme-primary), 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }

      .license-info {
        flex: 1;
        min-width: 0;

        .license-top {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 8px;

          .license-name {
            font-size: 13.5px;
            font-weight: 700;
            color: rgb(var(--v-theme-on-surface));
          }
        }

        .license-date {
          font-size: 11.5px;
          color: rgba(var(--v-theme-on-surface), 0.55);
        }
      }
    }
  }

  // お問い合わせ
  .contact-content {
    .contact-desc {
      font-size: 13.5px;
      line-height: 1.7;
      color: rgba(var(--v-theme-on-surface), 0.85);
      margin: 0 0 12px;
    }

    .contact-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
  }

  // 特定商取引に関する表記
  .commerce-disclosure-table {
    display: flex;
    flex-direction: column;
    gap: 8px;

    .commerce-row {
      display: flex;
      flex-direction: column;
      gap: 4px;
      padding: 10px 12px;
      border-radius: 10px;
      background: rgba(var(--v-theme-on-surface), 0.02);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.05);

      @media (min-width: 600px) {
        flex-direction: row;
        align-items: flex-start;
      }

      .commerce-th {
        font-size: 12.5px;
        font-weight: 700;
        color: rgba(var(--v-theme-on-surface), 0.65);
        min-width: 140px;
        flex-shrink: 0;
      }

      .commerce-td {
        font-size: 13px;
        font-weight: 500;
        color: rgb(var(--v-theme-on-surface));
        line-height: 1.6;
        word-break: break-word;
      }
    }
  }

  .contact-link {
    color: rgb(var(--v-theme-primary));
    text-decoration: underline;
    cursor: pointer;
    margin: 0 4px;
    font-weight: 600;

    &:hover {
      opacity: 0.8;
    }
  }

  // 実績リスト
  .achievements-list {
    display: flex;
    flex-direction: column;
    gap: 10px;

    .achievement-card {
      display: flex;
      align-items: flex-start;
      gap: 14px;
      padding: 12px 14px;
      border-radius: 14px;
      background: rgba(var(--v-theme-on-surface), 0.02);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.06);
      transition: transform 0.15s, box-shadow 0.15s;

      &:hover {
        background: rgba(var(--v-theme-on-surface), 0.04);
      }

      .achieve-icon-wrapper {
        width: 42px;
        height: 42px;
        border-radius: 12px;
        background: rgba(var(--v-theme-on-surface), 0.06);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }

      .achieve-content {
        flex: 1;
        min-width: 0;

        .achieve-top {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 4px;

          .achieve-date {
            font-size: 11.5px;
            color: rgba(var(--v-theme-on-surface), 0.55);
            font-weight: 500;
          }
        }

        .achieve-title {
          font-size: 14px;
          font-weight: 800;
          color: rgb(var(--v-theme-on-surface));
          margin: 0 0 4px;
          line-height: 1.4;
        }

        .achieve-desc {
          font-size: 12px;
          color: rgba(var(--v-theme-on-surface), 0.7);
          margin: 0;
          line-height: 1.5;
        }
      }
    }
  }

  // タイムラインフィルター
  .timeline-filter-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin-bottom: 16px;
  }

  // カスタムタイムライン
  .custom-timeline {
    display: flex;
    flex-direction: column;

    .timeline-row {
      display: flex;
      align-items: stretch;
      gap: 12px;
      position: relative;

      .timeline-indicator {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 28px;
        flex-shrink: 0;

        .timeline-dot {
          width: 26px;
          height: 26px;
          border-radius: 50%;
          background: rgba(var(--v-theme-on-surface), 0.08);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 1;

          &.dot-highlight {
            background: rgb(var(--v-theme-primary));
            box-shadow: 0 2px 8px rgba(var(--v-theme-primary), 0.4);
          }
        }

        .timeline-line {
          width: 2px;
          flex: 1;
          background: rgba(var(--v-theme-on-surface), 0.1);
          margin: 4px 0;
        }
      }

      &:last-child .timeline-line {
        display: none;
      }

      .timeline-card {
        flex: 1;
        padding-bottom: 14px;

        .timeline-card-header {
          display: flex;
          align-items: center;
          gap: 6px;
          margin-bottom: 2px;

          .timeline-date {
            font-size: 11px;
            font-weight: 700;
            color: rgba(var(--v-theme-on-surface), 0.55);
          }
        }

        .timeline-card-title {
          font-size: 13px;
          font-weight: 600;
          color: rgb(var(--v-theme-on-surface));
          line-height: 1.4;
        }
      }

      &.is-highlight {
        .timeline-card-title {
          font-weight: 800;
          color: rgb(var(--v-theme-primary));
        }
      }
    }
  }

  // アプリ情報カード
  .app-info-card {
    .app-info-hero {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 8px 4px;

      .app-logo {
        width: 60px;
        height: 60px;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }

      .app-info-text {
        .app-title {
          font-size: 18px;
          font-weight: 800;
          margin: 0;
          color: rgb(var(--v-theme-on-surface));
        }

        .app-copy {
          font-size: 12px;
          color: rgba(var(--v-theme-on-surface), 0.65);
          margin: 2px 0 0;
        }

        .app-copyright {
          font-size: 11px;
          color: rgba(var(--v-theme-on-surface), 0.45);
          margin: 2px 0 0;
        }
      }
    }

    .app-action-list {
      display: flex;
      flex-direction: column;
      gap: 8px;

      .action-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 12px;
        border-radius: 12px;
        cursor: pointer;
        transition: background-color 0.15s;

        &:hover {
          background: rgba(var(--v-theme-on-surface), 0.05);
        }

        .action-icon {
          width: 38px;
          height: 38px;
          border-radius: 50%;
          background: rgba(var(--v-theme-on-surface), 0.06);
          display: flex;
          align-items: center;
          justify-content: center;

          &.highlight-icon {
            background: rgb(var(--v-theme-primary));
            color: #ffffff;
          }
        }

        .action-text {
          flex: 1;

          .action-title {
            font-size: 13.5px;
            font-weight: 700;
            color: rgb(var(--v-theme-on-surface));
            margin: 0;
          }

          .action-sub {
            font-size: 11.5px;
            color: rgba(var(--v-theme-on-surface), 0.6);
            margin: 2px 0 0;
          }
        }
      }
    }
  }
}
</style>
