<template lang="pug">
v-dialog(
  :model-value="modelValue"
  @update:model-value="$emit('update:modelValue', $event)"
  fullscreen
  transition="dialog-bottom-transition"
)
  v-card.app-detail-card(v-if="app")
    //- 上部アプリバー
    v-toolbar(density="compact" color="surface" elevation="1")
      v-btn(icon="mdi-arrow-left" @click="$emit('update:modelValue', false)")
      v-toolbar-title.text-subtitle-1 {{ app.name }}
      v-spacer
      v-btn(icon="mdi-magnify" @click="$emit('search')")
      v-btn(icon="mdi-share-variant" @click="shareApp")

    //- メインコンテンツ
    .detail-body
      //- ヘッダー情報
      .detail-header
        .header-main
          .icon-box
            img.app-icon(:src="app.icon" :alt="app.name")
          .meta-box
            h1.app-name {{ app.name }}
            p.app-dev {{ app.developer || 'Enoki Studio' }}
            .app-badges
              span.badge {{ app.category || (app.type === 'game' ? 'ゲーム' : 'アプリ') }}
              span.badge-sub(v-if="app.price && app.price > 0") 有料
              span.badge-sub(v-else) アプリ内課金あり

      //- 統計バー (Google Play風)
      .stats-bar
        .stat-item
          .stat-val
            span.num {{ app.rating || 4.7 }}
            v-icon(size="14" color="amber-darken-2") mdi-star
          .stat-lbl 1.8万件のレビュー
        v-divider(vertical inset)
        .stat-item
          .stat-val
            v-icon(size="16" color="primary") mdi-download
            span.num {{ app.downloads || '100万+' }}
          .stat-lbl ダウンロード
        v-divider(vertical inset)
        .stat-item
          .stat-val
            v-icon(size="16" color="success") mdi-shield-check
            span.num 3+
          .stat-lbl 全年齢対象

      //- インストールボタン
      .action-row
        v-btn.install-btn(
          color="primary"
          rounded="pill"
          size="large"
          block
          :loading="installing"
          @click="handleInstall"
        )
          span(v-if="installed") 開く
          span(v-else-if="app.price && app.price > 0") ¥{{ app.price }} で購入
          span(v-else) インストール

      //- スクリーンショット
      .screenshots-section(v-if="app.images && app.images.length")
        .section-title スクリーンショット
        .screenshot-scroll
          .screenshot-item(v-for="(img, idx) in app.images" :key="idx")
            img.screenshot-img(:src="img" :alt="`Screenshot ${idx + 1}`" loading="lazy")

      //- このアプリについて
      .about-section
        .section-title この{{ app.type === 'game' ? 'ゲーム' : 'アプリ' }}について
        .about-text
          p.summary-lead {{ app.summary }}
          .desc-markdown(v-html="renderedDescription")

      //- プラットフォーム & 言語チップ
      .tags-section
        .section-title 詳細情報
        .tag-group
          span.group-label 対応プラットフォーム:
          .chips-wrap
            v-chip(v-for="plat in (app.platforms || ['Android', 'iOS', 'Web'])" :key="plat" size="small" variant="tonal" color="primary")
              v-icon(start size="14") {{ getPlatformIcon(plat) }}
              | {{ plat }}
        .tag-group.mt-3
          span.group-label 言語:
          .chips-wrap
            v-chip(v-for="lang in (app.languages || ['日本語'])" :key="lang" size="small" variant="outlined") {{ lang }}

      //- 外部リンクボタン
      .links-section(v-if="app.links && app.links.length")
        .section-title 外部リンク
        .link-buttons
          v-btn(
            v-for="link in app.links"
            :key="link.text"
            variant="tonal"
            rounded="pill"
            size="small"
            :prepend-icon="link.icon || 'mdi-open-in-new'"
            @click="openExternal(link.url)"
          ) {{ link.text }}
          v-btn(
            v-if="app.githubUrl"
            variant="tonal"
            rounded="pill"
            size="small"
            prepend-icon="mdi-github"
            @click="openExternal(app.githubUrl)"
          ) GitHub

      //- フッター余白
      .footer-spacer
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Browser } from '@capacitor/browser'
import { Share } from '@capacitor/share'
import type { AppOrMusicItem } from '~/stores/app'

const props = defineProps<{
  modelValue: boolean
  app: AppOrMusicItem | null
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', val: boolean): void
  (e: 'search'): void
}>()

const installing = ref(false)
const installed = ref(false)

const handleInstall = () => {
  if (installed.value) {
    if (props.app?.links?.[0]?.url) {
      openExternal(props.app.links[0].url)
    }
    return
  }
  installing.value = true
  setTimeout(() => {
    installing.value = false
    installed.value = true
  }, 1200)
}

const shareApp = async () => {
  if (!props.app) return
  try {
    await Share.share({
      title: props.app.name,
      text: `${props.app.name} をチェックしよう！`,
      url: window.location.href,
    })
  } catch {
    // クリップボード等のフォールバック
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(window.location.href)
      alert('リンクをコピーしました')
    }
  }
}

const openExternal = async (url?: string) => {
  if (!url) return
  try {
    await Browser.open({ url })
  } catch {
    window.open(url, '_blank')
  }
}

const getPlatformIcon = (platform: string) => {
  const p = platform.toLowerCase()
  if (p.includes('android')) return 'mdi-android'
  if (p.includes('ios') || p.includes('apple')) return 'mdi-apple'
  if (p.includes('web')) return 'mdi-web'
  if (p.includes('windows')) return 'mdi-microsoft-windows'
  return 'mdi-devices'
}

// 簡易Markdownレンダラー（見出し、太字、箇条書き）
const renderedDescription = computed(() => {
  if (!props.app?.description) return ''
  let text = props.app.description
  // エスケープ
  text = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  // 見出し
  text = text.replace(/^#### (.*$)/gim, '<h4 class="md-h4">$1</h4>')
  text = text.replace(/^### (.*$)/gim, '<h3 class="md-h3">$1</h3>')
  text = text.replace(/^## (.*$)/gim, '<h2 class="md-h2">$1</h2>')
  // 太字
  text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
  // 箇条書き
  text = text.replace(/^\- (.*$)/gim, '<li class="md-li">$1</li>')
  // 改行
  text = text.replace(/\n\n/g, '<br><br>')
  return text
})
</script>

<style lang="scss" scoped>
.app-detail-card {
  height: 100vh;
  width: 100%;
  display: flex;
  flex-direction: column;
  background-color: rgb(var(--v-theme-surface));

  .detail-body {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
    max-width: 720px;
    margin: 0 auto;
    width: 100%;

    .detail-header {
      .header-main {
        display: flex;
        gap: 16px;
        align-items: center;

        .icon-box {
          width: 76px;
          height: 76px;
          min-width: 76px;
          border-radius: 20px;
          overflow: hidden;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
          background-color: #f1f3f4;

          .app-icon {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
          }
        }

        .meta-box {
          flex: 1;
          min-width: 0;

          .app-name {
            font-size: 19px;
            font-weight: 700;
            line-height: 1.25;
            color: rgb(var(--v-theme-on-surface));
            margin: 0;
            word-break: break-word;
          }

          .app-dev {
            font-size: 13px;
            color: rgb(var(--v-theme-primary));
            font-weight: 600;
            margin: 4px 0 6px 0;
          }

          .app-badges {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 11px;

            .badge {
              color: rgba(var(--v-theme-on-surface), 0.75);
              font-weight: 500;
            }

            .badge-sub {
              color: rgba(var(--v-theme-on-surface), 0.5);
            }
          }
        }
      }
    }

    .stats-bar {
      display: flex;
      align-items: center;
      justify-content: space-around;
      margin: 20px 0 16px 0;
      padding: 10px 0;
      background-color: rgba(var(--v-theme-on-surface), 0.03);
      border-radius: 16px;

      .stat-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        flex: 1;

        .stat-val {
          display: flex;
          align-items: center;
          gap: 4px;
          font-weight: 700;
          font-size: 15px;
          color: rgb(var(--v-theme-on-surface));

          .num {
            line-height: 1;
          }
        }

        .stat-lbl {
          font-size: 10.5px;
          color: rgba(var(--v-theme-on-surface), 0.55);
          margin-top: 4px;
        }
      }
    }

    .action-row {
      margin: 16px 0 24px 0;

      .install-btn {
        font-weight: 700;
        font-size: 15px;
        letter-spacing: 0.5px;
        box-shadow: 0 4px 12px rgba(var(--v-theme-primary), 0.35);
      }
    }

    .section-title {
      font-size: 16px;
      font-weight: 700;
      color: rgb(var(--v-theme-on-surface));
      margin-bottom: 12px;
    }

    .screenshots-section {
      margin-bottom: 24px;

      .screenshot-scroll {
        display: flex;
        gap: 12px;
        overflow-x: auto;
        padding-bottom: 8px;
        scrollbar-width: none;
        &::-webkit-scrollbar {
          display: none;
        }

        .screenshot-item {
          width: 140px;
          height: 248px;
          min-width: 140px;
          border-radius: 14px;
          overflow: hidden;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
          background-color: #000;

          .screenshot-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
          }
        }
      }
    }

    .about-section {
      margin-bottom: 24px;

      .summary-lead {
        font-size: 13.5px;
        color: rgba(var(--v-theme-on-surface), 0.85);
        font-weight: 500;
        line-height: 1.5;
        margin-bottom: 12px;
      }

      .desc-markdown {
        font-size: 13px;
        line-height: 1.6;
        color: rgba(var(--v-theme-on-surface), 0.75);

        :deep(.md-h3) {
          font-size: 14px;
          font-weight: 700;
          margin: 14px 0 6px 0;
          color: rgb(var(--v-theme-on-surface));
        }

        :deep(.md-h4) {
          font-size: 13px;
          font-weight: 600;
          margin: 10px 0 4px 0;
          color: rgb(var(--v-theme-on-surface));
        }

        :deep(.md-li) {
          margin-left: 18px;
          margin-bottom: 4px;
        }
      }
    }

    .tags-section {
      margin-bottom: 24px;

      .tag-group {
        display: flex;
        flex-direction: column;
        gap: 6px;

        .group-label {
          font-size: 12px;
          font-weight: 600;
          color: rgba(var(--v-theme-on-surface), 0.65);
        }

        .chips-wrap {
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
        }
      }
    }

    .links-section {
      margin-bottom: 24px;

      .link-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
      }
    }

    .footer-spacer {
      height: 48px;
    }
  }
}
</style>
