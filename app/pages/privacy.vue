<template lang="pug">
v-card.privacy-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.privacy-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title プライバシーポリシー
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="sharePage"
    )

  //- メインスクロールエリア
  v-card-text.privacy-page-content(ref="contentContainer")
    .content-wrapper
      h1.main-title プライバシーポリシー

      //- 目次カード
      v-card.toc-card.my-4(variant="outlined")
        v-card-item.toc-header.mx-4.mt-2(@click="isTocOpen = !isTocOpen")
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
                  a.toc-link(@click.prevent="scrollToSection('intro')") 1. はじめに
                li
                  a.toc-link(@click.prevent="scrollToSection('collected-data')") 2. 収集するデータ
                  ul.toc-sub-list
                    li
                      a.toc-link(@click.prevent="scrollToSection('third-party-links')") 2.1. 第三者サービスプロバイダーのプライバシーポリシー
                    li
                      a.toc-link(@click.prevent="scrollToSection('admob-info')") 2.2. Admobが自動的に収集する情報
                li
                  a.toc-link(@click.prevent="scrollToSection('personal-info')") 3. アプリケーションが収集する可能性のある個人情報
                  ul.toc-sub-list
                    li
                      a.toc-link(@click.prevent="scrollToSection('location-info')") 3.1. 正確な位置情報、またはおおよその位置情報
                    li
                      a.toc-link(@click.prevent="scrollToSection('ip-info')") 3.2. IPアドレス
                    li
                      a.toc-link(@click.prevent="scrollToSection('camera-info')") 3.3. カメラ
                li
                  a.toc-link(@click.prevent="scrollToSection('data-usage')") 4. 収集した情報の利用方法
                li
                  a.toc-link(@click.prevent="scrollToSection('security')") 5. お客様の情報を保護する方法
                li
                  a.toc-link(@click.prevent="scrollToSection('sharing')") 6. お客様の情報を共有する方法
                li
                  a.toc-link(@click.prevent="scrollToSection('deletion')") 7. 情報の削除について
                li
                  a.toc-link(@click.prevent="scrollToSection('children')") 8. 個人データに関する詳細情報
                li
                  a.toc-link(@click.prevent="scrollToSection('links')") 9. 他のサイトへのリンク
                li
                  a.toc-link(@click.prevent="scrollToSection('changes')") 10. このプライバシーポリシーの変更
                li
                  a.toc-link(@click.prevent="scrollToSection('contact')") 11. お問い合わせ方法

      //- 1. はじめに
      section#intro.privacy-section
        h2.section-title はじめに
        p.section-p エノキ電気（以下「当社」）は、スマートフォンやモバイル端末向けの様々なモバイルアプリケーションやゲームを開発・公開しています。当社は、ユーザー（以下「ユーザー」）のプライバシー権の保護に尽力しています。
        p.section-p プライバシーポリシーの目的は、当社が提供するアプリケーションまたはソフトウェア（以下「本サービス」）をご利用になるお客様に対し、個人を特定できる情報（以下「個人情報」）の収集、使用、開示に関する当社のポリシーをお知らせすることです。
        p.section-p お客様は、本サービスをご利用いただくことで、本ポリシーに関連する情報の収集および使用に同意したことになります。当社のサービスによって収集された個人情報は、本サービスの提供および改善のために使用されます。当社は、本プライバシーポリシーに記載されている場合を除き、お客様の情報を第三者と共有することはありません。

      v-divider.my-6

      //- 2. 収集するデータ
      section#collected-data.privacy-section
        h2.section-title 収集するデータ
        p.section-p アプリのコンテンツや機能を通じてユーザーが直接提供する情報は収集しません。アプリを通じてユーザーが入力したすべてのデータは、ユーザーのデバイスにのみ保存されます。
        p.section-p ただし、サービスをより快適にご利用いただくために、特定の個人情報の提供をお願いする場合があります。ご提供いただいた情報は当社によって保管され、本プライバシーポリシーに記載されているとおりに使用されます。アプリは、ユーザーを特定するために情報を収集する可能性のあるサードパーティのサービスを使用しています。

        h3#third-party-links.sub-title 本サービスが利用する第三者サービスプロバイダーのプライバシーポリシーへのリンク
        .link-cards.my-3
          v-btn.external-btn.mr-2.mb-2(
            variant="tonal"
            prepend-icon="mdi-shield-account-outline"
            append-icon="mdi-open-in-new"
            @click="openURL('https://policies.google.com/privacy')"
          ) AdMob プライバシーポリシー
          v-btn.external-btn.mb-2(
            variant="tonal"
            prepend-icon="mdi-twitter"
            append-icon="mdi-open-in-new"
            @click="openURL('https://twitter.com/en/privacy')"
          ) Twitter プライバシーポリシー

        h3#admob-info.sub-title Admobがこのアプリケーションから自動的に収集する特定の種類の情報のリスト
        ul.privacy-list
          li Cookie
          li 使用状況データ
          li 広告用の固有デバイス識別子（例：Google 広告主 ID または IDFA）

      v-divider.my-6

      //- 3. アプリケーションが収集する可能性のある個人情報
      section#personal-info.privacy-section
        h2.section-title アプリケーションが収集する可能性のある個人情報
        p.section-p 当社は、一部のアプリケーションにおいて以下の情報を、以下の目的で収集、使用する場合があります。

        h3#location-info.sub-title 正確な位置情報、またはおおよその位置情報（LOCATION）
        p.section-p 当社は、以下のアプリケーションにおいて位置情報を取得します。
        ul.privacy-list
          li 地図機能が含まれるアプリケーション
          li 位置情報を共有することが目的となっているアプリケーション
          li 位置情報を利用してサービスの改善ができる可能性のあるアプリケーション
        p.section-p 当社は、以下の目的で位置情報を取得します。
        ul.privacy-list
          li 地図機能での現在地の提供のため
          li 予め承認した家族又は友人同士で、位置情報をシェアするため
          li アクセス元の地域によって最適なエクスペリエンスを提供するため
          li アプリケーションに必要なサービスを提供するため
        p.section-note 当社は、次に掲げる場合を除いて、取得した個人情報を第三者に開示又は提供することはありません

        h3#ip-info.sub-title IPアドレス
        p.section-p 当社は、以下のアプリケーションにおいてIPアドレスを取得します。
        ul.privacy-list
          li インターネットを使用して、利用者から情報の発信が可能なアプリケーション
          li ユーザーアカウントの作成が必須なアプリケーション
        p.section-p 当社は、以下の目的でIPアドレスを取得します。
        ul.privacy-list
          li アクセス元の地域をおおよそで特定し、統計情報を取るため
          li トラブル時のスムーズな解決のため

        h3#camera-info.sub-title カメラ
        p.section-p 当社は、以下のアプリケーションにおいてカメラを使用します。
        ul.privacy-list
          li 画像や動画の撮影がアプリケーションの動作において必要なアプリ
          li QRコードやバーコードを読み込む機能を持ったアプリ
          li 顔写真や身分証明書を用いた本人確認機能を持ったアプリ
        p.section-p 当社は、以下の目的でカメラにアクセスします。
        ul.privacy-list
          li 利用者が撮影した画像や動画をアップロードして、利用者の同意のもとシェアするため
          li 顔写真や身分証明書を用いた本人確認のため
          li アプリケーションに必要なサービスを提供するため

      v-divider.my-6

      //- 4. 収集した情報の利用方法
      section#data-usage.privacy-section
        h2.section-title 収集した情報の利用方法
        p.section-p 当社は、お客様から収集した情報を以下のいずれかの方法、あるいは複数の方法で使用することがあります。
        ul.privacy-list
          li 当社のサービスを維持し、改善するため
          li 当社のサービスがどのように利用されているかを分析するため
          li 詐欺や違法、非倫理的な活動を防止するため
          li 広告詐欺や不正使用を防ぐため
          li ユーザーの広告体験をパーソナライズするため
          li サービスに関連した広告やプロモーション情報を提供するため
        p.section-p.mt-3 本サービスのユーザーの皆様には、これらの第三者がお客様の特定の個人情報にアクセスする可能性があることをお知らせいたします。これは、当社に代わって割り当てられた業務を遂行するためです。ただし、第三者は、当該情報を他の目的で開示または使用しない義務を負います。

      v-divider.my-6

      //- 5. お客様の情報を保護する方法
      section#security.privacy-section
        h2.section-title お客様の情報を保護する方法
        p.section-p お客様の個人情報のセキュリティと機密性は当社にとって非常に重要です。そのため、当社はお客様の情報を不正アクセスや漏洩から保護するために、適切なセキュリティ対策（物理的、電子的、手続き的対策を含む）を講じています。
        p.section-p ただし、当社の努力にもかかわらず、完璧なセキュリティ対策や侵入不可能なセキュリティ対策は存在しないことをご理解ください。

      v-divider.my-6

      //- 6. お客様の情報を共有する方法
      section#sharing.privacy-section
        h2.section-title お客様の情報を共有する方法
        p.section-p 当社は、本プライバシーポリシーに記載されている場合を除き、お客様の情報を第三者と共有したり、利用したりすることはありません。また、お客様の情報を第三者に販売することもありません。

      v-divider.my-6

      //- 7. 情報の削除について
      section#deletion.privacy-section
        h2.section-title 情報の削除について
        p.section-p アプリを通じて入力された個人情報は、デバイスからアプリを削除すると削除されます。
        p.section-p 自動的に収集された個人情報は、収集目的に必要な期間、処理および保存されます。お客様が当社のサービスをご利用にならなくなった場合、個人情報は相当の期間後に削除されます。

      v-divider.my-6

      //- 8. 個人データに関する詳細情報
      section#children.privacy-section
        h2.section-title 個人データに関する詳細情報
        p.section-p 本サービスは13歳未満のお子様を対象としていません。ユーザーは、適用される法令に基づき成人であることを宣言するものとします。未成年者は、親または保護者の同意がある場合に限り、本アプリケーションを使用することができます。

      v-divider.my-6

      //- 9. 他のサイトへのリンク
      section#links.privacy-section
        h2.section-title 他のサイトへのリンク
        p.section-p 本サービスには、他のサイトへのリンクが含まれている場合があります。第三者のリンクをクリックすると、当該サイトへ移動します。
        p.section-p これらの外部サイトは当社が運営するものではありません。そのため、これらのウェブサイトのプライバシーポリシーをご確認いただくことを強くお勧めします。当社は、第三者のサイトまたはサービスのコンテンツ、プライバシーポリシー、または慣行について一切の管理権を有しておらず、一切の責任を負いません。

      v-divider.my-6

      //- 10. このプライバシーポリシーの変更
      section#changes.privacy-section
        h2.section-title このプライバシーポリシーの変更
        p.section-p 当社はプライバシーポリシーを随時更新することがあります。そのため、このページを定期的にご確認いただき、変更点をご確認ください。
        p.section-p 変更があった場合は、このページに新しいプライバシーポリシーを掲載することによりお知らせいたします。変更は、このページに掲載された後、直ちに有効となります。

      v-divider.my-6

      //- 11. お問い合わせ方法
      section#contact.privacy-section
        h2.section-title お問い合わせ方法
        p.section-p このプライバシーポリシーに関してご質問がある場合は、次のメールアドレスまでお問い合わせください。
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
  name: 'PrivacyPage',
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
      isTocOpen: true,
    }
  },
  setup() {
    Setup.setTitle('プライバシーポリシー')
    Setup.setDescription(
      'エノキ電気（以下「当社」）におけるプライバシーポリシーです。個人情報の収集、使用、開示に関する当社のポリシーをお知らせします。',
    )
  },
  async mounted() {
    this.setTitle('プライバシーポリシー')

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
          title: 'プライバシーポリシー - エノキ電気',
          text: 'エノキ電気のプライバシーポリシーです。',
          url: 'https://enoki.xyz/privacy/',
          dialogTitle: '共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText('https://enoki.xyz/privacy/')
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
.privacy-page-root {
  display: flex;
  flex-direction: column;

  .privacy-page-header {
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

  .privacy-page-content {
    flex: 1;
    overflow-y: auto;
    padding: 16px 20px;
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

    .toc-card {
      border-radius: 12px;
      background-color: rgba(var(--v-theme-surface), 0.35);
      border: 1px solid rgba(var(--v-theme-on-surface), 0.3);

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

          .toc-sub-list {
            list-style-type: none;
            padding-left: 20px;
            margin-top: 4px;

            li {
              margin-bottom: 4px;
              font-size: 0.95em;
            }
          }
        }
      }
    }

    .privacy-section {
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

      .sub-title {
        font-size: 1.1em;
        font-weight: 700;
        margin-top: 16px;
        margin-bottom: 8px;
        color: rgba(var(--v-theme-on-surface), 0.9);
      }

      .section-p {
        margin-bottom: 12px;
        color: rgba(var(--v-theme-on-surface), 0.87);
        word-break: break-word;
      }

      .section-note {
        margin: 12px 0;
        padding: 8px 12px;
        border-radius: 6px;
        background-color: rgba(var(--v-theme-primary), 0.08);
        font-size: 0.95em;
        color: rgba(var(--v-theme-on-surface), 0.9);
      }

      .privacy-list {
        padding-left: 24px;
        margin-bottom: 16px;

        li {
          margin-bottom: 6px;
          color: rgba(var(--v-theme-on-surface), 0.87);
        }
      }

      .link-cards {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;

        .external-btn {
          text-transform: none;
          font-weight: 600;
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
}
</style>
