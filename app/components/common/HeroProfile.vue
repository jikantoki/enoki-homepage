<template lang="pug">
.hero-profile(
  v-ripple
  role="button"
  tabindex="0"
  @click="goToProfile"
  @keydown.enter="goToProfile"
)
  //- 背景スライドショー (3秒間隔でランダム切り替え & クロスフェード)
  .hero-bg-container
    .hero-bg-slide(
      v-for="(bg, idx) in heroBackgrounds"
      :key="bg"
      :style="{ backgroundImage: `url('${bg}')` }"
      :class="{ active: currentHeroBgIndex === idx }"
    )
    //- 視認性を保つダークグラスオーバーレイ
    .hero-bg-overlay

  //- コンテンツ本体
  .hero-profile-inner
    //- 左側: アイコン & テキスト群
    .hero-main-group
      .hero-avatar-wrapper
        img.hero-avatar(
          src="/icon.png"
          alt="エノキ電気"
          onerror="this.src='/account_default.jpg'"
        )
        .hero-status-badge
          span.status-dot
          span.status-text OFFICIAL

      .hero-text-block
        .hero-title-row
          h1.hero-brand-name エノキ電気
          span.hero-brand-en ENOKI ELECTRONICS
          span.hero-representative-badge 代表 ときえのき

        p.hero-catchphrase
          span.hero-quote 「自由」をデザインする
          span.hero-divider ──
          span.hero-subcatch 音楽も、プログラミングも、それ以外も。

        .hero-tag-chips
          span.hero-chip
            v-icon(size="11" color="#38bdf8") mdi-music
            span 音楽・ボカロP
          span.hero-chip
            v-icon(size="11" color="#818cf8") mdi-code-braces
            span ソフトウェア開発
          span.hero-chip
            v-icon(size="11" color="#34d399") mdi-wrench
            span ハード・弱電

    //- 右側: プロフィール誘導ボタン
    .hero-action-group
      .hero-cta-btn
        span.cta-text プロフィール・実績
        v-icon.cta-arrow(size="16") mdi-arrow-right

  //- 3秒タイマーの進捗インジケーター（視覚的フィードバック）
  .hero-slide-indicators
    span.indicator-bar(
      v-for="(bg, idx) in heroBackgrounds"
      :key="'ind-' + idx"
      :class="{ active: currentHeroBgIndex === idx }"
    )
</template>

<script lang="ts">
const HERO_BACKGROUNDS = [
  '/backgrounds/20250816-_NIK0445.JPG',
  '/backgrounds/IMG_1484.jpg',
  '/backgrounds/IMG_20210813_013325_793.webp',
  encodeURI('/backgrounds/IMG_20250809_184240 (1).jpg'),
  encodeURI('/backgrounds/PXL_20260412_104232273 (1).jpg'),
  '/backgrounds/PXL_20260623_141509354.jpg',
  '/backgrounds/PXL_20260627_083339375.MP.jpg',
  '/backgrounds/PXL_20260707_055552550.jpg',
]

export default {
  name: 'HeroProfile',
  data() {
    return {
      heroBackgrounds: HERO_BACKGROUNDS,
      currentHeroBgIndex: 0,
      heroBgTimer: null as any,
    }
  },
  mounted() {
    if (this.heroBackgrounds && this.heroBackgrounds.length > 0) {
      this.currentHeroBgIndex = Math.floor(Math.random() * this.heroBackgrounds.length)
      this.startHeroBgTimer()
    }
  },
  unmounted() {
    if (this.heroBgTimer) {
      clearInterval(this.heroBgTimer)
      this.heroBgTimer = null
    }
  },
  methods: {
    startHeroBgTimer() {
      if (this.heroBgTimer) {
        clearInterval(this.heroBgTimer)
      }
      this.heroBgTimer = setInterval(() => {
        this.rotateHeroBackground()
      }, 3000)
    },
    rotateHeroBackground() {
      if (!this.heroBackgrounds || this.heroBackgrounds.length <= 1) return
      let nextIdx = Math.floor(Math.random() * (this.heroBackgrounds.length - 1))
      if (nextIdx >= this.currentHeroBgIndex) {
        nextIdx += 1
      }
      this.currentHeroBgIndex = nextIdx
    },
    goToProfile() {
      this.$router.push('/profile')
    },
  },
}
</script>

<style lang="scss" scoped>
.hero-profile {
  position: relative;
  overflow: hidden;
  margin: 0 16px 10px 16px;
  border-radius: 20px;
  min-height: 135px;
  cursor: pointer;
  user-select: none;
  box-shadow: 0 10px 28px rgba(0, 0, 0, 0.22);
  border: 1px solid rgba(255, 255, 255, 0.16);
  transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
  z-index: 8;
  flex-shrink: 0;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 36px rgba(0, 0, 0, 0.32);
    border-color: rgba(56, 189, 248, 0.45);

    .cta-arrow {
      transform: translateX(4px);
    }
  }

  &:active {
    transform: translateY(0);
  }

  // 背景画像レイヤー群 (3秒ごとにクロスフェード＆穏やかなズーム)
  .hero-bg-container {
    position: absolute;
    inset: 0;
    overflow: hidden;
    background-color: #0b1120;

    .hero-bg-slide {
      position: absolute;
      inset: -4px;
      background-size: cover;
      background-position: center;
      opacity: 0;
      transform: scale(1);
      transition: opacity 1.2s cubic-bezier(0.4, 0, 0.2, 1), transform 5s linear;
      will-change: opacity, transform;
      pointer-events: none;

      &.active {
        opacity: 1;
        transform: scale(1.06);
        z-index: 1;
      }
    }

    // ダークグラデーション＋すりガラスオーバーレイ
    .hero-bg-overlay {
      position: absolute;
      inset: 0;
      z-index: 2;
      background: linear-gradient(
        135deg,
        rgba(10, 15, 30, 0.88) 0%,
        rgba(15, 23, 42, 0.74) 45%,
        rgba(2, 6, 23, 0.84) 100%
      );
      backdrop-filter: blur(2px);
      -webkit-backdrop-filter: blur(2px);
    }
  }

  // コンテンツ本体
  .hero-profile-inner {
    position: relative;
    z-index: 3;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px 20px 20px;
    gap: 16px;
    color: #ffffff;

    .hero-main-group {
      display: flex;
      align-items: center;
      gap: 16px;
      flex: 1;
      min-width: 0;
    }

    // アイコン / アバター
    .hero-avatar-wrapper {
      position: relative;
      flex-shrink: 0;
      width: 64px;
      height: 64px;

      .hero-avatar {
        width: 100%;
        height: 100%;
        border-radius: 18px;
        object-fit: cover;
        border: 2px solid rgba(255, 255, 255, 0.35);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
        background-color: #1e293b;
      }

      .hero-status-badge {
        position: absolute;
        bottom: -4px;
        right: -4px;
        display: flex;
        align-items: center;
        gap: 3px;
        padding: 2px 6px;
        border-radius: 9999px;
        background: rgba(16, 185, 129, 0.95);
        color: #ffffff;
        font-size: 8.5px;
        font-weight: 800;
        letter-spacing: 0.5px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.35);

        .status-dot {
          width: 5px;
          height: 5px;
          border-radius: 50%;
          background-color: #ffffff;
          animation: pulse-dot 2s infinite ease-in-out;
        }
      }
    }

    // 自己紹介テキスト
    .hero-text-block {
      display: flex;
      flex-direction: column;
      gap: 4px;
      min-width: 0;
      flex: 1;

      .hero-title-row {
        display: flex;
        align-items: baseline;
        gap: 8px;
        flex-wrap: wrap;

        .hero-brand-name {
          font-size: 1.35rem;
          font-weight: 900;
          letter-spacing: -0.02em;
          color: #ffffff;
          text-shadow: 0 2px 8px rgba(0, 0, 0, 0.6);
          margin: 0;
          line-height: 1.2;
        }

        .hero-brand-en {
          font-size: 0.72rem;
          font-weight: 700;
          letter-spacing: 0.08em;
          color: rgba(255, 255, 255, 0.65);
          text-transform: uppercase;
        }

        .hero-representative-badge {
          font-size: 0.7rem;
          font-weight: 600;
          padding: 1px 7px;
          border-radius: 6px;
          background: rgba(255, 255, 255, 0.16);
          color: #e2e8f0;
          backdrop-filter: blur(4px);
        }
      }

      .hero-catchphrase {
        display: flex;
        align-items: baseline;
        gap: 6px;
        margin: 2px 0 0 0;
        font-size: 0.9rem;
        flex-wrap: wrap;
        text-shadow: 0 1px 4px rgba(0, 0, 0, 0.6);

        .hero-quote {
          font-weight: 800;
          color: #38bdf8;
          letter-spacing: 0.02em;
        }

        .hero-divider {
          color: rgba(255, 255, 255, 0.4);
        }

        .hero-subcatch {
          color: rgba(255, 255, 255, 0.9);
          font-weight: 500;
        }
      }

      .hero-tag-chips {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-top: 4px;
        flex-wrap: wrap;

        .hero-chip {
          display: inline-flex;
          align-items: center;
          gap: 4px;
          font-size: 10px;
          font-weight: 600;
          padding: 2px 8px;
          border-radius: 9999px;
          background: rgba(255, 255, 255, 0.12);
          color: rgba(255, 255, 255, 0.92);
          border: 1px solid rgba(255, 255, 255, 0.12);
        }
      }
    }

    // 右側 CTA ボタン
    .hero-action-group {
      flex-shrink: 0;

      .hero-cta-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 16px;
        border-radius: 9999px;
        background: linear-gradient(135deg, rgba(56, 189, 248, 0.22) 0%, rgba(99, 102, 241, 0.26) 100%);
        border: 1px solid rgba(56, 189, 248, 0.45);
        backdrop-filter: blur(8px);
        color: #ffffff;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.02em;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
        transition: all 0.2s ease;

        .cta-arrow {
          transition: transform 0.2s ease;
        }
      }
    }
  }

  // スライドインジケーター（3秒ごとの切り替え表示）
  .hero-slide-indicators {
    position: absolute;
    bottom: 5px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 4;
    display: flex;
    gap: 4px;

    .indicator-bar {
      width: 14px;
      height: 3px;
      border-radius: 2px;
      background: rgba(255, 255, 255, 0.22);
      transition: all 0.4s ease;

      &.active {
        width: 24px;
        background: #38bdf8;
        box-shadow: 0 0 8px rgba(56, 189, 248, 0.8);
      }
    }
  }
}

@keyframes pulse-dot {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.4;
    transform: scale(0.8);
  }
}

// モバイル対応（画面幅 680px 以下）
@media (max-width: 680px) {
  .hero-profile {
    margin: 0 12px 8px 12px;
    border-radius: 16px;
    min-height: auto;

    .hero-profile-inner {
      padding: 12px 14px 16px 14px;
      flex-direction: column;
      align-items: flex-start;
      gap: 10px;

      .hero-main-group {
        width: 100%;
        gap: 12px;
      }

      .hero-avatar-wrapper {
        width: 52px;
        height: 52px;

        .hero-avatar {
          border-radius: 14px;
        }

        .hero-status-badge {
          font-size: 8px;
          padding: 1px 4px;
        }
      }

      .hero-text-block {
        .hero-title-row {
          .hero-brand-name {
            font-size: 1.15rem;
          }
          .hero-brand-en {
            font-size: 0.65rem;
          }
          .hero-representative-badge {
            font-size: 0.65rem;
            padding: 1px 5px;
          }
        }

        .hero-catchphrase {
          font-size: 0.82rem;
          gap: 4px;
        }

        .hero-tag-chips {
          display: none;
        }
      }

      .hero-action-group {
        width: 100%;
        display: flex;
        justify-content: flex-end;

        .hero-cta-btn {
          padding: 5px 12px;
          font-size: 11px;
        }
      }
    }
  }
}
</style>
