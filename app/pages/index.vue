<template lang="pug">
v-card.home-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- ================= メインスクロールコンテナ =================
  .home-scroll-container(ref="scrollContainer")

    //- ================= ヒーロービューポート（画面いっぱい） =================
    section.hero-section
      //- フルスクリーン背景スライドショー（3秒ごとランダム切り替え）
      .bg-slider-container
        .bg-layer.layer-base(:style="baseLayerStyle")
        .bg-layer.layer-fade(
          :class="{ active: isCrossFading }"
          :style="fadeLayerStyle"
        )
        .bg-overlay

      //- ヒーローコンテンツ（中央配置）
      .hero-content
        //- バッジ
        .hero-badge
          v-icon(size="16" color="#38bdf8") mdi-lightning-bolt
          span.badge-text エノキ電気 / ENOKI ELECTRONICS

        //- ページの一番大きい文字
        h1.hero-main-title 「自由」をデザインする

        //- その次に大きい文字
        h2.hero-sub-title 音楽も、プログラミングも、それ以外も。

        //- Webサイトの概要（enoki.xyz 準拠）
        p.hero-summary
          | 作曲とプログラミングを同時にこなすマルチクリエイター。
          br.d-none.d-sm-inline
          | 作りたいものを作る。それだけです。

        //- 導線ボタングループ
        .hero-actions
          v-btn.hero-btn.btn-apps(
            size="large"
            rounded="pill"
            prepend-icon="mdi-apps"
            color="primary"
            elevation="6"
            @click="$router.push('/apps')"
          )
            span ソフトウェアを見る
            v-icon.ml-1(size="18") mdi-arrow-right

          v-btn.hero-btn.btn-music(
            size="large"
            rounded="pill"
            prepend-icon="mdi-music"
            color="indigo-darken-1"
            elevation="4"
            @click="$router.push('/music')"
          )
            span 音楽を聴く

          v-btn.hero-btn.btn-youtube(
            size="large"
            rounded="pill"
            prepend-icon="mdi-youtube"
            color="red-darken-2"
            elevation="4"
            @click="openURL('https://www.youtube.com/@jikantoki')"
            target="_blank"
            rel="noopener noreferrer"
          )
            span YouTubeで曲を聴く

          v-btn.hero-btn.btn-profile(
            size="large"
            rounded="pill"
            prepend-icon="mdi-account-circle-outline"
            variant="outlined"
            color="white"
            @click="$router.push('/profile')"
          )
            span プロフィール・実績

      //- スクロール促進ヒント
      .scroll-down-hint(@click="scrollToContent")
        span.hint-label 概要・活動一覧を見る
        v-icon.bounce-icon(size="22") mdi-chevron-down

    //- ================= 詳細コンテンツエリア（enoki.xyz 準拠） =================
    .home-content-section(ref="contentSection")
      .section-inner

        //- セクション1: 前提を覆す新しいエンターテイメント
        .content-block
          .section-tagline NEW ENTERTAINMENT
          h3.section-heading 前提を覆す新しいエンターテイメント
          p.section-lead
            | 作曲とプログラミングを高いレベルで両立するマルチクリエイター、ときえのき（jikantoki）の公式サイトです。
            | 枠にとらわれず、ジャンルや技術の境界を越えて自らの手でゼロから形にしていく創作を展開しています。

        //- 事業・活動の柱
        .works-grid
          //- 音楽
          .work-card
            .card-icon-wrap.music-icon-bg
              v-icon(size="32" color="#ec4899") mdi-music-note
            h4.card-title いつでも聞ける音楽としての展開
            p.card-desc
              | 自作のボカロ曲やオリジナル楽曲はSpotify、LINE Music、Apple Musicをはじめ世界各社でストリーミング配信中。カラオケ配信も実施しています。
            v-btn.mt-auto(
              variant="tonal"
              color="pink"
              rounded="pill"
              size="small"
              prepend-icon="mdi-music"
              @click="$router.push('/music')"
            ) 楽曲を視聴する

          //- ソフトウェア
          .work-card
            .card-icon-wrap.software-icon-bg
              v-icon(size="32" color="#3b82f6") mdi-laptop
            h4.card-title ゆるく楽しめるソフトウェアの展開
            p.card-desc
              | 開発したプログラムやWebサービス・スマートフォンアプリは当サイトやGitHubで無料公開。誰でも手軽に試して楽しんでいただけます。
            v-btn.mt-auto(
              variant="tonal"
              color="primary"
              rounded="pill"
              size="small"
              prepend-icon="mdi-apps"
              @click="$router.push('/apps')"
            ) アプリ一覧を見る

          //- クリエイティブ & 独立
          .work-card
            .card-icon-wrap.create-icon-bg
              v-icon(size="32" color="#10b981") mdi-compass-outline
            h4.card-title 自由なクリエイションと挑戦
            p.card-desc
              | Web・アプリ開発だけでなく、Linuxディストリビューション自作、弱電工事、バイクのレストアなど「知りたい・作りたい」好奇心を満たす挑戦を続けています。
            v-btn.mt-auto(
              variant="tonal"
              color="success"
              rounded="pill"
              size="small"
              prepend-icon="mdi-account-details-outline"
              @click="$router.push('/profile')"
            ) 経歴・実績を見る

        //- セクション2: 時間は有限でも、希望は無限
        .quote-banner
          .quote-icon
            v-icon(size="36" color="#f59e0b") mdi-format-quote-open
          blockquote.quote-text
            | 「私の趣味は単なる趣味ではありません。時間はかかるものの将来の仕事や力に直結する制作物やアクションは、自身の即戦力を意味します。」
          p.quote-author — エノキ電気 代表 ときえのき

        //- セクション3: 私がここにいる理由 (Why am I here)
        .content-block.why-block
          .section-tagline WHY AM I HERE
          h3.section-heading 私がここにいる理由
          .why-cards
            .why-item
              .why-num 01
              .why-body
                h5.why-title 好奇心は普通ではない
                p.why-desc
                  | 物が動く仕組み、プログラミング、音の重なり、そして自力で価値を生み出す方法。知りたすぎる熱意がすべての原動力です。
            .why-item
              .why-num 02
              .why-body
                h5.why-title オリジナルへのこだわり
                p.why-desc
                  | 他者の制作物を眺めるだけでは終わらない。良いものに出会ったら技術の本質を学び、独自のスパイスを加えて自分だけの作品へ昇華させます。

        //- セクション4: 各種公式リンク
        .links-section
          h4.links-heading 公式リンク・SNS
          .links-chip-container
            v-btn.sns-btn(
              href="https://www.youtube.com/@jikantoki"
              target="_blank"
              rel="noopener noreferrer"
              color="#FF0000"
              prepend-icon="mdi-youtube"
              variant="flat"
              rounded="pill"
            ) YouTube
            v-btn.sns-btn(
              href="https://twitter.com/jikantoki"
              target="_blank"
              rel="noopener noreferrer"
              color="#1DA1F2"
              prepend-icon="mdi-twitter"
              variant="flat"
              rounded="pill"
            ) Twitter / X
            v-btn.sns-btn(
              href="https://github.com/jikantoki"
              target="_blank"
              rel="noopener noreferrer"
              color="#24292e"
              prepend-icon="mdi-github"
              variant="flat"
              rounded="pill"
            ) GitHub
            v-btn.sns-btn(
              href="https://www.nicovideo.jp/user/89659039"
              target="_blank"
              rel="noopener noreferrer"
              color="#252525"
              prepend-icon="mdi-video-vintage"
              variant="flat"
              rounded="pill"
            ) ニコニコ動画

        //- フッター著作権
        footer.site-footer
          .footer-logo エノキ電気
          .footer-sub ENOKI ELECTRONICS - OFFICIAL WEB SITE
          .footer-copy &copy; 2019 エノキ電気

      //- ボトムナビ用余白
      .bottom-nav-spacer

  //- ================= ボトムナビゲーション =================
  BottomNav(v-model="optionsDialog")
</template>

<script lang="ts">
import BottomNav from '@/components/common/BottomNav.vue'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'
import { useSettingsStore } from '@/stores/settings'
import { Browser } from '@capacitor/browser'

// 背景画像の候補リスト（/backgrounds フォルダ）
const BACKGROUND_IMAGES = [
  '/backgrounds/20250816-_NIK0445.JPG',
  '/backgrounds/IMG_1484.jpg',
  '/backgrounds/IMG_20210813_013325_793.webp',
  '/backgrounds/IMG_20250809_184240 (1).jpg',
  '/backgrounds/PXL_20260412_104232273 (1).jpg',
  '/backgrounds/PXL_20260623_141509354.jpg',
  '/backgrounds/PXL_20260627_083339375.MP.jpg',
  '/backgrounds/PXL_20260707_055552550.jpg',
]

export default {
  name: 'HomePage',
  components: {
    BottomNav,
  },
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
      optionsDialog: false,
      images: BACKGROUND_IMAGES,
      currentImageIndex: 0,
      nextImageIndex: 0,
      isCrossFading: false,
      intervalId: null as any,
      fadeTimerId: null as any,
    }
  },
  setup() {
    Setup.setTitle('エノキ電気 - 公式ホームページ（ときえのき）')
    Setup.setDescription(
      'エノキ電気（ときえのき）公式ホームページ。「自由」をデザインする - 音楽も、プログラミングも、それ以外も。',
    )
  },
  computed: {
    baseLayerStyle(): Record<string, string> {
      const url = encodeURI(this.images[this.currentImageIndex] || '')
      return {
        backgroundImage: `url("${url}")`,
      }
    },
    fadeLayerStyle(): Record<string, string> {
      const url = encodeURI(this.images[this.nextImageIndex] || '')
      return {
        backgroundImage: `url("${url}")`,
      }
    },
  },
  mounted() {
    this.setTitle('エノキ電気 - 公式ホームページ（ときえのき）')

    // 最初にランダムな背景画像を決定
    this.currentImageIndex = Math.floor(Math.random() * this.images.length)
    this.nextImageIndex = this.currentImageIndex

    // 画像の事前プリロード（切り替え時のチラつき防止）
    if (typeof window !== 'undefined') {
      this.images.forEach((src) => {
        const img = new Image()
        img.src = encodeURI(src)
      })
    }

    // 3秒ごとにランダムで背景画像を変更
    this.startSlideShow()
  },
  beforeUnmount() {
    this.stopSlideShow()
  },
  methods: {
    getRandomIndex(excludeIndex: number): number {
      if (this.images.length <= 1) return 0
      let next: number
      do {
        next = Math.floor(Math.random() * this.images.length)
      } while (next === excludeIndex)
      return next
    },
    nextRandomImage() {
      const next = this.getRandomIndex(this.currentImageIndex)
      this.nextImageIndex = next
      this.isCrossFading = true

      // 1秒間のフェード完了後にベース画像を切り替えてリセット
      if (this.fadeTimerId) clearTimeout(this.fadeTimerId)
      this.fadeTimerId = setTimeout(() => {
        this.currentImageIndex = next
        this.isCrossFading = false
      }, 1000)
    },
    startSlideShow() {
      this.stopSlideShow()
      this.intervalId = setInterval(() => {
        this.nextRandomImage()
      }, 3000)
    },
    stopSlideShow() {
      if (this.intervalId) {
        clearInterval(this.intervalId)
        this.intervalId = null
      }
      if (this.fadeTimerId) {
        clearTimeout(this.fadeTimerId)
        this.fadeTimerId = null
      }
    },
    scrollToContent() {
      const el = this.$refs.contentSection as HTMLElement | undefined
      if (el) {
        el.scrollIntoView({ behavior: 'smooth' })
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
.home-page-root {
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
  background-color: #0b0f19;
  color: #f8fafc;
}

.home-scroll-container {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
}

// ================= ヒーローセクション =================
.hero-section {
  position: relative;
  width: 100%;
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32px 20px 80px;
  overflow: hidden;
  box-sizing: border-box;
}

// フルスクリーン背景スライドショー
.bg-slider-container {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 1;

  .bg-layer {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
    transform: scale(1.04);
    will-change: opacity, transform;
    transition: transform 6s ease-out;

    &.layer-fade {
      opacity: 0;
      transition: opacity 1s ease-in-out;
      z-index: 2;

      &.active {
        opacity: 1;
      }
    }
  }

  // 暗幕グラデーションオーバーレイ（昼夜どちらの写真でも白文字を美しく際立たせる）
  .bg-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      180deg,
      rgba(11, 15, 25, 0.45) 0%,
      rgba(11, 15, 25, 0.68) 50%,
      rgba(11, 15, 25, 0.92) 100%
    );
    backdrop-filter: blur(2px);
    z-index: 3;
  }
}

// ヒーローコンテンツ（中央）
.hero-content {
  position: relative;
  z-index: 5;
  max-width: 860px;
  width: 100%;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: auto 0;
  padding: 16px 8px;

  .hero-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 6px 18px;
    border-radius: 9999px;
    background: rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 0.08em;
    color: #e0f2fe;
    margin-bottom: 24px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
  }

  // ページの一番大きい文字
  .hero-main-title {
    font-size: clamp(2.2rem, 6.5vw, 4.2rem);
    font-weight: normal;
    line-height: 1.25;
    letter-spacing: -0.01em;
    color: #ffffff;
    margin: 0 0 14px 0;
    text-shadow: 0 3px 12px rgba(0, 0, 0, 0.7), 0 8px 30px rgba(0, 0, 0, 0.5);
    word-break: keep-all;
    overflow-wrap: break-word;
  }

  // その次に大きい文字
  .hero-sub-title {
    font-size: clamp(1.15rem, 3.4vw, 1.9rem);
    font-weight: 100;
    line-height: 1.45;
    color: #e2e8f0;
    margin: 0 0 20px 0;
    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.7), 0 4px 16px rgba(0, 0, 0, 0.5);
    word-break: keep-all;
    overflow-wrap: break-word;
  }

  // Webサイトの概要
  .hero-summary {
    font-size: clamp(0.95rem, 2.2vw, 1.2rem);
    font-weight: 500;
    line-height: 1.7;
    color: #cbd5e1;
    margin: 0 0 32px 0;
    max-width: 680px;
    text-shadow: 0 2px 6px rgba(0, 0, 0, 0.6);
  }

  // 導線ボタングループ
  .hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
    justify-content: center;
    align-items: center;
    width: 100%;
    max-width: 720px;

    .hero-btn {
      font-weight: 800;
      letter-spacing: 0.03em;
      transition: transform 0.2s, box-shadow 0.2s;

      &:hover {
        transform: translateY(-2px);
      }

      &.btn-apps {
        background: linear-gradient(135deg, #2563eb, #1d4ed8) !important;
        color: #ffffff !important;
        box-shadow: 0 8px 24px rgba(37, 99, 235, 0.45) !important;
      }

      &.btn-music {
        background: linear-gradient(135deg, #4f46e5, #4338ca) !important;
        color: #ffffff !important;
        box-shadow: 0 8px 24px rgba(79, 70, 229, 0.4) !important;
      }

      &.btn-youtube {
        background: linear-gradient(135deg, #dc2626, #b91c1c) !important;
        color: #ffffff !important;
        box-shadow: 0 8px 24px rgba(220, 38, 38, 0.4) !important;
      }

      &.btn-profile {
        background: rgba(255, 255, 255, 0.12) !important;
        border-color: rgba(255, 255, 255, 0.35) !important;
        backdrop-filter: blur(8px);
        color: #ffffff !important;
      }
    }
  }
}

// スクロールダウン案内
.scroll-down-hint {
  position: absolute;
  bottom: 84px;
  z-index: 5;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  transition: color 0.2s;

  &:hover {
    color: #ffffff;
  }

  .hint-label {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.05em;
  }

  .bounce-icon {
    animation: bounce 1.8s infinite;
  }
}

@keyframes bounce {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(6px);
  }
  60% {
    transform: translateY(3px);
  }
}

// ================= 詳細コンテンツエリア =================
.home-content-section {
  position: relative;
  z-index: 6;
  background: linear-gradient(180deg, #0b0f19 0%, #0f172a 100%);
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  padding: 64px 20px 48px;

  .section-inner {
    max-width: 980px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 56px;
  }
}

.content-block {
  text-align: center;
  max-width: 760px;
  margin: 0 auto;

  .section-tagline {
    font-size: 12px;
    font-weight: 400;
    letter-spacing: 0.16em;
    color: #38bdf8;
    margin-bottom: 8px;
    text-transform: uppercase;
  }

  .section-heading {
    font-size: clamp(1.6rem, 3.8vw, 2.4rem);
    font-weight: 400;
    color: #ffffff;
    line-height: 1.35;
    margin-bottom: 16px;
  }

  .section-lead {
    font-size: clamp(0.95rem, 1.8vw, 1.05rem);
    line-height: 1.8;
    color: #94a3b8;
    margin: 0;
  }
}

// 制作物の柱カード
.works-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;

  .work-card {
    background: rgba(30, 41, 59, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 20px;
    padding: 28px 24px;
    display: flex;
    flex-direction: column;
    backdrop-filter: blur(12px);
    transition: transform 0.2s, border-color 0.2s, box-shadow 0.2s;

    &:hover {
      transform: translateY(-4px);
      border-color: rgba(56, 189, 248, 0.4);
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.3);
    }

    .card-icon-wrap {
      width: 56px;
      height: 56px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 18px;

      &.music-icon-bg {
        background: rgba(236, 72, 153, 0.15);
      }
      &.software-icon-bg {
        background: rgba(59, 130, 246, 0.15);
      }
      &.create-icon-bg {
        background: rgba(16, 185, 129, 0.15);
      }
    }

    .card-title {
      font-size: 1.15rem;
      font-weight: 700;
      color: #f1f5f9;
      margin-bottom: 12px;
      line-height: 1.4;
    }

    .card-desc {
      font-size: 0.9rem;
      line-height: 1.7;
      color: #94a3b8;
      margin-bottom: 20px;
    }
  }
}

// 引用バナー
.quote-banner {
  background: linear-gradient(
    135deg,
    rgba(30, 41, 59, 0.8),
    rgba(15, 23, 42, 0.9)
  );
  border-left: 4px solid #f59e0b;
  border-radius: 0 16px 16px 0;
  padding: 28px 32px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);

  .quote-icon {
    margin-bottom: 8px;
  }

  .quote-text {
    font-size: clamp(1rem, 2.2vw, 1.25rem);
    font-style: italic;
    font-weight: 400;
    line-height: 1.8;
    color: #fde68a;
    margin: 0 0 12px 0;
  }

  .quote-author {
    font-size: 0.9rem;
    font-weight: 400;
    color: #cbd5e1;
    margin: 0;
    text-align: right;
  }
}

// Why cards
.why-block {
  .why-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
    margin-top: 24px;
    text-align: left;
  }

  .why-item {
    background: rgba(30, 41, 59, 0.4);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    padding: 24px;
    display: flex;
    gap: 18px;

    .why-num {
      font-size: 2rem;
      font-weight: 900;
      color: #38bdf8;
      opacity: 0.85;
      line-height: 1;
    }

    .why-title {
      font-size: 1.05rem;
      font-weight: 700;
      color: #f1f5f9;
      margin-bottom: 8px;
    }

    .why-desc {
      font-size: 0.88rem;
      line-height: 1.7;
      color: #94a3b8;
      margin: 0;
    }
  }
}

// リンクセクション
.links-section {
  text-align: center;

  .links-heading {
    font-size: 1.1rem;
    font-weight: 700;
    color: #e2e8f0;
    margin-bottom: 20px;
  }

  .links-chip-container {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    justify-content: center;

    .sns-btn {
      font-weight: 700;
      text-transform: none;
      letter-spacing: 0.02em;
      padding: 6px 18px;
    }
  }
}

// フッター
.site-footer {
  text-align: center;
  padding-top: 32px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);

  .footer-logo {
    font-size: 1.3rem;
    font-weight: 300;
    letter-spacing: 0.05em;
    color: #ffffff;
    margin-bottom: 4px;
  }

  .footer-sub {
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 0.12em;
    color: #64748b;
    margin-bottom: 12px;
  }

  .footer-copy {
    font-size: 12px;
    color: #94a3b8;
  }
}

.bottom-nav-spacer {
  height: 80px;
}
</style>
