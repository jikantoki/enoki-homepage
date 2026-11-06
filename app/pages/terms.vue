<template lang="pug">
v-card.terms-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.terms-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title 利用規約
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="sharePage"
    )

  //- メインスクロールエリア
  v-card-text.terms-page-content(ref="contentContainer")
    .content-wrapper
      h1.main-title エノキ電機サービス 統一利用規約

      //- イントロカード
      v-card.intro-card.mb-6(variant="tonal" color="primary")
        v-card-text.d-flex.align-start
          v-icon.mr-3.mt-1(size="28") mdi-shield-check-outline
          div
            p.intro-text
              | エノキ電気（以下「当社」）が提供するアプリケーションやサービス（以下「本サービス」）をご利用いただきありがとうございます。
            p.intro-text.mb-0
              | 本サービスを皆様に安心・安全にご利用いただくため、利用条件として本利用規約（以下「本規約」）を定めています。ご利用前にご一読ください。

      //- 目次カード
      v-card.toc-card.my-4(variant="outlined")
        v-card-item.toc-header.mx-4.my-2(@click="isTocOpen = !isTocOpen")
          template(#prepend)
            v-icon(color="primary") mdi-format-list-bulleted
          v-card-title.toc-title 目次
          template(#append)
            v-btn(
              variant="text"
              icon
              size="small"
            )
              v-icon {{ isTocOpen ? 'mdi-chevron-up' : 'mdi-chevron-down' }}
        v-expand-transition
          div(v-show="isTocOpen")
            v-divider
            v-card-text.toc-body
              ul.toc-list
                li
                  a.toc-link(@click.prevent="scrollToSection('prohibited')") 1. ざっくり、こういうのはやめてね！（禁止事項）
                li
                  a.toc-link(@click.prevent="scrollToSection('trouble')") 2. 何かあった時は（免責・トラブル対応）
                li
                  a.toc-link(@click.prevent="scrollToSection('violation')") 3. 運営が被害を受けたと認定した場合（違反への対応）
                li
                  a.toc-link(@click.prevent="scrollToSection('privacy')") 4. プライバシーポリシー
                li
                  a.toc-link(@click.prevent="scrollToSection('changes')") 5. 利用規約の変更
                li
                  a.toc-link(@click.prevent="scrollToSection('contact')") 6. お問い合わせ窓口

      //- 1. ざっくり、こういうのはやめてね！
      section#prohibited.terms-section
        h2.section-title 1. ざっくり、こういうのはやめてね！
        p.section-p
          | 本サービスのご利用にあたり、以下のような他の方への迷惑となる行為や法律・公序良俗に反する行為は禁止とさせていただきます。

        v-card.rule-card.my-3(variant="outlined" style="border: 1px solid rgba(var(--v-theme-on-surface), 0.3)")
          v-list.rule-list(density="comfortable")
            v-list-item
              template(#prepend)
                v-icon(color="error") mdi-close-circle-outline
              v-list-item-title 他人の権利を侵害する行為
              v-list-item-subtitle 著作権・商標権・肖像権・プライバシーの侵害、他者への誹謗中傷や名誉毀損など
            v-divider
            v-list-item
              template(#prepend)
                v-icon(color="error") mdi-close-circle-outline
              v-list-item-title 不正アクセスやシステムの妨害行為
              v-list-item-subtitle サーバーに過度な負荷をかける行為、脆弱性を突く攻撃、不正なスクレイピングなど
            v-divider
            v-list-item
              template(#prepend)
                v-icon(color="error") mdi-close-circle-outline
              v-list-item-title 違法なコンテンツの配布や共有
              v-list-item-subtitle 法令に違反するファイル・情報・画像のアップロードや拡散など
            v-divider
            v-list-item
              template(#prepend)
                v-icon(color="error") mdi-close-circle-outline
              v-list-item-title スパム行為や迷惑行為
              v-list-item-subtitle 広告・宣伝目的の無差別送信、嫌がらせ、なりすましなど

      v-divider.my-6

      //- 2. 何かあった時は
      section#trouble.terms-section
        h2.section-title 2. 何かあった時は
        p.section-p
          | サービス利用中にトラブルやご不明点が発生した際、または問題が生じた場合の対応について定めています。

        .card-grid.my-3
          v-card.action-card.pa-2(variant="outlined" style="border: 1px solid rgba(var(--v-theme-on-surface), 0.3)")
            v-card-item
              template(#prepend)
                v-avatar(color="primary" variant="tonal" size="36")
                  v-icon mdi-message-text-fast-outline
              v-card-title とりあえず連絡してね！
            v-card-text
              | なにか不具合やトラブル、気になる点があれば一人で抱え込まずにお問い合わせ窓口からご連絡ください。迅速な状況把握と対応に努めます。

          v-card.action-card.mt-3.pa-2(variant="outlined" style="border: 1px solid rgba(var(--v-theme-on-surface), 0.3)")
            v-card-item
              template(#prepend)
                v-avatar(color="info" variant="tonal" size="36")
                  v-icon mdi-handshake-outline
              v-card-title IPアドレスの開示は出来るだけ協力するよ！
            v-card-text
              | 法令に基づき警察・裁判所・捜査機関等の公的機関から正当な手続きによる要請があった場合、法令の範囲内でIPアドレス等の情報開示に最大限協力します。

          v-card.action-card.mt-3.pa-2(variant="outlined" style="border: 1px solid rgba(var(--v-theme-on-surface), 0.3)")
            v-card-item
              template(#prepend)
                v-avatar(color="warning" variant="tonal" size="36")
                  v-icon mdi-alert-circle-outline
              v-card-title 余程のことがないと賠償金的なやつは払わないよ！
            v-card-text
              | 当社は本サービスの安全性や完全性について最善を尽くしますが、本サービスに起因して生じたいかなる損害についても、当社の故意または重大な過失による場合を除き、原則として損害賠償責任を負いません。

      v-divider.my-6

      //- 3. 運営が被害を受けたと認定した場合
      section#violation.terms-section
        h2.section-title 3. 運営が被害を受けたと認定した場合
        p.section-p
          | 悪質な攻撃、業務妨害、他ユーザーへの重大な被害など、運営が看過できない被害を受けたと認定した場合は、以下のような断固とした措置を講じます。

        .warning-container.my-3
          v-card.warning-box(variant="tonal" color="error")
            v-card-text
              .d-flex.align-start.mb-3.pa-2
                v-icon.mr-3.mt-1(color="error") mdi-shield-alert-outline
                div
                  h3.warning-heading 常にIPアドレスを保存しているので、それを使って開示請求を試みるよ！
                  p.warning-p
                    | システムのログとしてアクセス時のIPアドレス等を保存しています。悪質な行為が確認された際は、プロバイダ責任制限法等に基づき発信者情報開示請求を行います。

              v-divider.my-2

              .d-flex.align-start.my-3.pa-2
                v-icon.mr-3.mt-1(color="error") mdi-gavel
                div
                  h3.warning-heading いけそうなら、民事と刑事で訴訟するかも！
                  p.warning-p
                    | 被害の規模や悪質性に応じて、損害賠償請求（民事訴訟）および警察への被害届提出・刑事告訴の両面から厳正な法的措置を検討・実行します。

              v-divider.my-2

              .d-flex.align-start.mt-3.pa-2
                v-icon.mr-3.mt-1(color="success") mdi-hand-heart-outline
                div
                  h3.warning-heading(style="color: rgb(var(--v-theme-success))") その前に謝ってくれたら和解も検討するよ！
                  p.warning-p
                    | 大事になる前に非を認め、真摯な謝罪や状況改善を行っていただける場合は、話し合いによる円満な和解も検討します。まずは誠意をもってお話ししましょう。

      v-divider.my-6

      //- 4. プライバシーポリシー
      section#privacy.terms-section
        h2.section-title 4. プライバシーポリシー
        p.section-p
          | 本サービスにおける個人情報の収集・取り扱い方針については、別途定めている「プライバシーポリシー」をご参照ください。

        v-card.privacy-jump-card.my-4.pa-4(
          variant="outlined"
          v-ripple
          style="border: 1px solid rgba(var(--v-theme-on-surface), 0.3)"
          @click="$router.push('/privacy')"
        )
          v-card-item
            template(#prepend)
              v-avatar.mr-2(color="primary" variant="flat")
                v-icon(color="white") mdi-shield-lock-outline
            v-card-title プライバシーポリシー
            v-card-subtitle 個人情報の保護・収集・管理方針について
            template(#append)
              v-icon(color="primary") mdi-chevron-right

      v-divider.my-6

      //- 5. 利用規約の変更
      section#changes.terms-section
        h2.section-title 5. 利用規約の変更
        p.section-p
          | 当社は、法令の改正やサービスの改善等に伴い、必要に応じて本規約を随時変更できるものとします。
        p.section-p
          | 変更後の本規約は、本ページに掲載された時点より効力を生じるものとします。

      v-divider.my-6

      //- 6. お問い合わせ窓口
      section#contact.terms-section
        h2.section-title 6. お問い合わせ窓口
        p.section-p
          | 本規約に関するご質問、サービスに関するトラブル・不具合のご報告、その他お問い合わせは下記メールアドレスまでお願いいたします。
        .contact-box.my-4
          v-btn(
            color="primary"
            variant="flat"
            prepend-icon="mdi-email-outline"
            @click="openURL('mailto:info@enoki.xyz')"
          ) info@enoki.xyz

      .footer-spacer.my-16
</template>

<script lang="ts">
import { Browser } from '@capacitor/browser'
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'TermsPage',
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
      isTocOpen: true,
    }
  },
  setup() {
    Setup.setTitle('利用規約')
    Setup.setDescription(
      'エノキ電気（以下「当社」）が提供する本サービスの利用規約です。安心・安全にご利用いただくためのルールを定めています。',
    )
  },
  async mounted() {
    this.setTitle('利用規約')

    // 開発者オプション（ノッチ対応）
    const developerOptions = localStorage.getItem('developerOptions')
    if (developerOptions) {
      try {
        const options = JSON.parse(developerOptions)
        if (options.statusBarNotch !== undefined) {
          this.settings.hidden.isAndroid15OrHigher = options.statusBarNotch
        }
      } catch (e) {
        console.error(e)
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
          title: '利用規約 - エノキ電気',
          text: 'エノキ電気の利用規約です。',
          url: 'https://enoki.xyz/terms/',
          dialogTitle: '共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/terms/')
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
    async openURL(url: string) {
      if (url.startsWith('mailto:')) {
        window.location.href = url
        return
      }
      try {
        await Browser.open({ url })
      } catch {
        window.open(url, '_blank', 'noopener,noreferrer')
      }
    },
    scrollToSection(id: string) {
      const element = document.getElementById(id)
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.terms-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;

  .terms-page-header {
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    flex-shrink: 0;

    .header-title {
      font-size: 1.15em;
      font-weight: 800;
      margin-left: 8px;
    }
  }

  .terms-page-content {
    flex: 1;
    overflow-y: auto;
    padding: 16px 20px 80px;
    line-height: 1.8;

    .content-wrapper {
      max-width: 800px;
      margin: 0 auto;
    }

    .main-title {
      font-size: 1.8em;
      font-weight: 800;
      margin: 16px 0;
      letter-spacing: -0.02em;
    }

    .intro-card {
      border-radius: 12px;

      .intro-text {
        font-size: 0.95em;
        line-height: 1.6;
        color: rgba(var(--v-theme-on-surface), 0.9);
      }
    }

    .toc-card {
      border-radius: 12px;
      border: 1px solid rgba(var(--v-theme-on-surface), 0.3);
      background-color: rgba(var(--v-theme-surface), 0.35);

      .toc-header {
        cursor: pointer;
        user-select: none;

        .toc-title {
          font-size: 1.05em;
          font-weight: 700;
        }
      }

      .toc-body {
        padding: 12px 20px;

        .toc-list {
          list-style-type: none;
          padding-left: 4px;

          li {
            margin-bottom: 6px;

            .toc-link {
              color: rgb(var(--v-theme-primary));
              text-decoration: none;
              cursor: pointer;
              font-weight: 500;
              transition: opacity 0.2s;

              &:hover {
                text-decoration: underline;
                opacity: 0.8;
              }
            }
          }
        }
      }
    }

    .terms-section {
      margin-top: 24px;
      scroll-margin-top: 20px;

      .section-title {
        font-size: 1.35em;
        font-weight: 700;
        margin-bottom: 12px;
        padding-bottom: 4px;
        border-left: 4px solid rgb(var(--v-theme-primary));
        padding-left: 10px;
      }

      .section-p {
        margin-bottom: 12px;
        color: rgba(var(--v-theme-on-surface), 0.87);
        word-break: break-word;
      }

      .rule-card {
        border-radius: 12px;
        overflow: hidden;

        .rule-list {
          padding: 0;

          .v-list-item {
            padding: 12px 16px;
          }

          .v-list-item-title {
            font-weight: 700;
            font-size: 1em;
          }

          .v-list-item-subtitle {
            font-size: 0.85em;
            opacity: 0.8;
            margin-top: 2px;
          }
        }
      }

      .card-grid {
        .action-card {
          border-radius: 12px;

          .v-card-title {
            font-size: 1.05em;
            font-weight: 700;
          }
        }
      }

      .warning-container {
        .warning-box {
          border-radius: 12px;

          .warning-heading {
            font-size: 1em;
            font-weight: 700;
            margin-bottom: 4px;
          }

          .warning-p {
            font-size: 0.9em;
            line-height: 1.6;
            margin-bottom: 0;
            opacity: 0.9;
          }
        }
      }

      .privacy-jump-card {
        border-radius: 12px;
        cursor: pointer;
        transition: transform 0.2s, box-shadow 0.2s;

        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
      }

      .contact-box {
        margin-top: 8px;
      }
    }
  }
}

.top-android-15-or-higher {
  height: calc(100vh - 40px - 16px) !important;
  height: calc(100dvh - 40px - 16px) !important;
}
</style>
