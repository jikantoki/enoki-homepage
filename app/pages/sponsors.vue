<template lang="pug">
v-card.sponsors-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.sponsors-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title スポンサー・友人紹介
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="sharePage"
    )

  //- メインスクロールエリア
  v-card-text.sponsors-page-content(ref="contentContainer")
    .content-wrapper
      //- ヒーローバナー
      .sponsors-hero-card
        .hero-bg-accent
        .hero-inner
          .hero-icon-circle
            v-icon(size="36" color="primary") mdi-handshake-outline
          h1.hero-title スポンサー ＆ 友人
          p.hero-subtitle SPONSORS & FRIENDS
          p.hero-desc
            | エノキ電気（ときえのき）の活動や創作を支えてくださっているスポンサーの皆様、
            br.d-none.d-sm-inline
            | そして日々刺激を与え合っているクリエイター・エンジニアの友人をご紹介します。

      //- 統計・概要チップ
      .stats-bar
        v-chip.stat-chip(variant="tonal" color="amber-darken-2" prepend-icon="mdi-star-circle")
          | スポンサー: {{ sponsorList.length }}名
        v-chip.stat-chip(variant="tonal" color="teal" prepend-icon="mdi-account-heart")
          | 友人: {{ friendList.length }}名
        v-chip.stat-chip(variant="tonal" color="primary" prepend-icon="mdi-account-group")
          | 合計: {{ allItems.length }}名

      //- タブフィルター
      .filter-tabs-wrapper
        v-tabs(
          v-model="activeFilter"
          color="primary"
          density="comfortable"
          align-tabs="center"
          grow
        )
          v-tab(value="all")
            v-icon(start) mdi-view-grid-outline
            | すべて ({{ allItems.length }})
          v-tab(value="sponsor")
            v-icon(start) mdi-star-circle
            | スポンサー ({{ sponsorList.length }})
          v-tab(value="friend")
            v-icon(start) mdi-account-heart
            | 友人 ({{ friendList.length }})

      //- ================= 1. スポンサーセクション =================
      section.sponsor-section.mt-8(v-if="activeFilter === 'all' || activeFilter === 'sponsor'")
        .section-header
          .section-title-wrap
            v-icon(color="amber-darken-2" size="24") mdi-star-circle
            h2.section-heading スポンサー
            span.section-badge {{ sponsorList.length }}
          p.section-subtext
            | サーバーインフラ、音源・機材提供、活動資金など、創作と技術開発を直接支えてくださっているパートナーの皆様です。

        .cards-grid
          v-card.sponsor-card(
            v-for="item in sponsorList"
            :key="item.id"
            variant="outlined"
          )
            .card-header-bar
              v-chip(
                size="small"
                variant="flat"
                :color="item.tierColor || 'primary'"
                class="font-weight-bold"
              ) {{ item.tier }}
              span.since-text(v-if="item.since") {{ item.since }}

            .card-profile-header
              .avatar-container
                img.sponsor-avatar(
                  :src="item.avatar"
                  :alt="item.name"
                  onerror="this.src='/account_default.jpg'"
                )
              .profile-names
                h3.name-text {{ item.name }}
                p.role-text {{ item.role }}
                p.org-text(v-if="item.organization") {{ item.organization }}

            v-card-text.card-body
              p.desc-text {{ item.description }}

            v-card-actions.card-footer(v-if="item.links && item.links.length")
              v-btn(
                v-for="link in item.links"
                :key="link.title"
                size="small"
                variant="tonal"
                rounded="pill"
                :prepend-icon="link.icon"
                :color="link.color"
                @click="openURL(link.url)"
              ) {{ link.title }}

      //- ================= 2. 友人セクション =================
      section.friend-section.mt-10(v-if="activeFilter === 'all' || activeFilter === 'friend'")
        .section-header
          .section-title-wrap
            v-icon(color="teal" size="24") mdi-account-heart
            h2.section-heading 友人
            span.section-badge {{ friendList.length }}
          p.section-subtext
            | 音楽・イラスト・映像・プログラム・ハードウェアなど、日頃から刺激を受け合いながら共に歩んでいるクリエイター仲間です。

        .cards-grid
          v-card.sponsor-card.friend-card(
            v-for="item in friendList"
            :key="item.id"
            variant="outlined"
          )
            .card-header-bar
              v-chip(
                size="small"
                variant="tonal"
                :color="item.tierColor || 'teal'"
                class="font-weight-bold"
              ) {{ item.tier }}
              span.since-text(v-if="item.since") {{ item.since }}

            .card-profile-header
              .avatar-container
                img.sponsor-avatar(
                  :src="item.avatar"
                  :alt="item.name"
                  onerror="this.src='/account_default.jpg'"
                )
              .profile-names
                h3.name-text {{ item.name }}
                p.role-text {{ item.role }}

            v-card-text.card-body
              p.desc-text {{ item.description }}

            v-card-actions.card-footer(v-if="item.links && item.links.length")
              v-btn(
                v-for="link in item.links"
                :key="link.title"
                size="small"
                variant="tonal"
                rounded="pill"
                :prepend-icon="link.icon"
                :color="link.color"
                @click="openURL(link.url)"
              ) {{ link.title }}

      //- ================= 3. スポンサー募集・コンタクト案内カード =================
      .join-sponsor-banner.my-10
        v-card.sponsor-cta-card(variant="tonal" color="primary")
          v-card-item
            template(#prepend)
              .cta-icon-circle
                v-icon(size="32" color="primary") mdi-heart-flash
            v-card-title.cta-title スポンサー・ご支援について
            v-card-subtitle.cta-subtitle 創作活動・技術開発のパートナーを歓迎しています
          v-card-text.cta-desc
            | エノキ電気では、自由でオープンなソフトウェア開発や音楽制作、自作ハードウェアの挑戦を継続するため、
            | 個人・企業を問わずスポンサーや協賛、コラボレーションを随時歓迎しております。
          v-card-actions.cta-actions
            v-btn(
              color="primary"
              variant="flat"
              prepend-icon="mdi-github"
              @click="openURL('https://github.com/sponsors/jikantoki')"
            ) GitHub Sponsors
            v-btn(
              variant="outlined"
              prepend-icon="mdi-email-outline"
              @click="openURL('mailto:info@enoki.xyz')"
            ) お問い合わせ
</template>

<script lang="ts">
import { Browser } from '@capacitor/browser'
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { SPONSORS_DATA, type SponsorItem } from '@/data/sponsors'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'SponsorsPage',
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
      activeFilter: 'all',
      allItems: SPONSORS_DATA as SponsorItem[],
    }
  },
  setup() {
    Setup.setTitle('スポンサー・友人紹介')
    Setup.setDescription(
      'エノキ電気（ときえのき）の活動を支えてくださっているスポンサーの皆様、および親交の深いクリエイター仲間のご紹介です。',
    )
  },
  computed: {
    sponsorList(): SponsorItem[] {
      return this.allItems.filter((item) => item.category === 'sponsor')
    },
    friendList(): SponsorItem[] {
      return this.allItems.filter((item) => item.category === 'friend')
    },
  },
  mounted() {
    this.setTitle('スポンサー・友人紹介')
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
          title: 'スポンサー・友人紹介 - エノキ電気',
          text: 'エノキ電気（ときえのき）を支えてくださるスポンサーと友人のご紹介です。',
          url: 'https://enoki.xyz/sponsors',
          dialogTitle: '共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/sponsors')
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
    async openURL(url: string) {
      try {
        await Browser.open({ url })
      } catch {
        window.open(url, '_blank')
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.sponsors-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  background-color: rgb(var(--v-theme-surface));

  .sponsors-page-header {
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    flex-shrink: 0;

    .header-title {
      font-size: 1.15rem;
      font-weight: 700;
      margin: 0 0 0 8px;
    }
  }

  .sponsors-page-content {
    flex: 1;
    overflow-y: auto;
    padding: 20px 16px 40px;
    -webkit-overflow-scrolling: touch;

    .content-wrapper {
      max-width: 960px;
      margin: 0 auto;
    }
  }
}

// ヒーローカード
.sponsors-hero-card {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  padding: 32px 20px;
  text-align: center;
  background: linear-gradient(135deg, rgba(var(--v-theme-primary), 0.12), rgba(var(--v-theme-primary), 0.03));
  border: 1px solid rgba(var(--v-theme-primary), 0.2);
  margin-bottom: 20px;

  .hero-icon-circle {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: rgba(var(--v-theme-primary), 0.15);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
  }

  .hero-title {
    font-size: 1.8rem;
    font-weight: 800;
    margin-bottom: 4px;
    letter-spacing: -0.02em;
  }

  .hero-subtitle {
    font-size: 0.8rem;
    font-weight: 700;
    letter-spacing: 0.15em;
    color: rgb(var(--v-theme-primary));
    margin-bottom: 12px;
  }

  .hero-desc {
    font-size: 0.95rem;
    line-height: 1.7;
    opacity: 0.85;
    margin: 0;
  }
}

// 統計バー
.stats-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  justify-content: center;
  margin-bottom: 20px;

  .stat-chip {
    font-weight: 600;
  }
}

// フィルタータブ
.filter-tabs-wrapper {
  margin-bottom: 24px;
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}

// 各セクションヘッダー
.section-header {
  margin-bottom: 20px;

  .section-title-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 4px;

    .section-heading {
      font-size: 1.35rem;
      font-weight: 700;
      margin: 0;
    }

    .section-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 24px;
      height: 24px;
      padding: 0 8px;
      border-radius: 12px;
      background: rgba(var(--v-theme-on-surface), 0.1);
      font-size: 0.8rem;
      font-weight: 700;
    }
  }

  .section-subtext {
    font-size: 0.88rem;
    opacity: 0.75;
    margin: 0;
    line-height: 1.6;
  }
}

// カードグリッド
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
  gap: 16px;
}

// スポンサー・友人カード
.sponsor-card {
  border-radius: 16px !important;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  background-color: rgba(var(--v-theme-surface), 0.8) !important;
  border: 1px solid rgba(var(--v-theme-on-surface), 0.12) !important;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
  }

  .card-header-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px 0;

    .since-text {
      font-size: 0.75rem;
      opacity: 0.6;
      font-weight: 500;
    }
  }

  .card-profile-header {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 12px 16px 8px;

    .avatar-container {
      flex-shrink: 0;

      .sponsor-avatar {
        width: 56px;
        height: 56px;
        border-radius: 50%;
        object-fit: cover;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
        border: 2px solid rgba(var(--v-theme-on-surface), 0.1);
      }
    }

    .profile-names {
      overflow: hidden;

      .name-text {
        font-size: 1.05rem;
        font-weight: 700;
        margin: 0 0 2px;
        line-height: 1.3;
        word-break: break-word;
      }

      .role-text {
        font-size: 0.82rem;
        color: rgb(var(--v-theme-primary));
        font-weight: 600;
        margin: 0;
        line-height: 1.3;
      }

      .org-text {
        font-size: 0.75rem;
        opacity: 0.65;
        margin: 2px 0 0;
      }
    }
  }

  .card-body {
    flex: 1;
    padding: 8px 16px 12px;

    .desc-text {
      font-size: 0.88rem;
      line-height: 1.65;
      opacity: 0.88;
      margin: 0;
    }
  }

  .card-footer {
    padding: 0 16px 12px;
    gap: 8px;
    flex-wrap: wrap;
  }
}

.friend-card {
  .role-text {
    color: rgb(var(--v-theme-teal, 20, 184, 166)) !important;
  }
}

// CTAカード
.join-sponsor-banner {
  .sponsor-cta-card {
    border-radius: 20px;
    border: 1px dashed rgba(var(--v-theme-primary), 0.4);

    .cta-icon-circle {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      background: rgba(var(--v-theme-primary), 0.15);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
    }

    .cta-title {
      font-size: 1.2rem;
      font-weight: 700;
    }

    .cta-subtitle {
      font-size: 0.85rem;
      opacity: 0.75;
    }

    .cta-desc {
      font-size: 0.9rem;
      line-height: 1.7;
      opacity: 0.9;
    }

    .cta-actions {
      padding: 8px 16px 16px;
      gap: 12px;
      flex-wrap: wrap;
    }
  }
}
</style>
