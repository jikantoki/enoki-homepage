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
      //- 未完成（開発中）注意バナー
      v-alert.unfinished-banner.mb-4.pa-4(
        v-if="isUnfinished"
        type="warning"
        variant="tonal"
        rounded="xl"
        density="comfortable"
        icon="mdi-hammer-wrench"
      )
        .d-flex.align-center.justify-space-between.flex-wrap.gap-2
          div
            .font-weight-bold.text-body-2 このアプリは「未完成（開発中）」です
            .text-caption.text-medium-emphasis 機能の追加や仕様変更が進行中であり、一部機能や動作が不安定な場合があります。
          v-chip(size="x-small" color="warning" variant="flat") 制作中 / WIP

      //- ヘッダー情報
      .detail-header
        .header-main
          .icon-box
            img.app-icon(:src="app.icon" :alt="app.name")
            .wip-corner-badge(v-if="isUnfinished")
              v-icon(size="11") mdi-progress-wrench
              span 未完成
          .meta-box
            h1.app-name {{ app.name }}
            p.app-dev {{ app.developer || 'Enoki Studio' }}
            .app-badges
              span.badge {{ app.category || (app.type === 'game' ? 'ゲーム' : 'アプリ') }}
              span.badge.wip-badge(v-if="isUnfinished")
                v-icon.mr-1(size="11") mdi-progress-wrench
                | 未完成 (WIP)

      //- リンクボタン群（旧インストール/購入ボタンを置き換え、linksをv-forで表示）
      .action-row(v-if="(app.links && app.links.length) || app.githubUrl || app.videoUrl")
        .links-container
          v-btn.link-btn(
            v-for="link in (app.links || [])"
            :key="link.text + link.url"
            color="primary"
            rounded="pill"
            size="large"
            variant="flat"
            :prepend-icon="link.icon || 'mdi-open-in-new'"
            @click="openExternal(link.url)"
          ) {{ link.text }}

          v-btn.link-btn(
            v-if="app.githubUrl && (!app.links || !app.links.some(l => l.url === app.githubUrl))"
            variant="tonal"
            rounded="pill"
            size="large"
            prepend-icon="mdi-github"
            @click="openExternal(app.githubUrl)"
          ) GitHub

          v-btn.link-btn(
            v-if="app.videoUrl && (!app.links || !app.links.some(l => l.url === app.videoUrl))"
            color="error"
            variant="tonal"
            rounded="pill"
            size="large"
            prepend-icon="mdi-youtube"
            @click="openExternal(app.videoUrl)"
          ) YouTube

      //- スクリーンショット
      .screenshots-section(v-if="app.images && app.images.length")
        .section-title スクリーンショット
        .screenshot-scroll
          .screenshot-item(v-for="(img, idx) in app.images" :key="idx")
            img.screenshot-img(:src="img" :alt="`Screenshot ${idx + 1}`" loading="lazy")

      //- このアプリについて (Markdown表示対応)
      .about-section
        .section-title この{{ app.type === 'game' ? 'ゲーム' : 'アプリ' }}について
        .about-text
          p.summary-lead(v-if="app.summary") {{ app.summary }}
          .markdown-body(v-html="renderedDescription")

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

      //- フッター余白
      .footer-spacer
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { marked } from 'marked'
import { Browser } from '@capacitor/browser'
import { Share } from '@capacitor/share'
import { isItemUnfinished, type AppOrMusicItem } from '~/stores/app'

const props = defineProps<{
  modelValue: boolean
  app: AppOrMusicItem | null
}>()

defineEmits<{
  (e: 'update:modelValue', val: boolean): void
  (e: 'search'): void
}>()

const shareApp = async () => {
  if (!props.app) return
  try {
    await Share.share({
      title: props.app.name,
      text: `${props.app.name} をチェックしよう！`,
      url: window.location.href,
    })
  } catch {
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

const isUnfinished = computed(() => isItemUnfinished(props.app))

const renderedDescription = computed(() => {
  if (!props.app?.description) return ''
  return marked.parse(props.app.description, {
    breaks: true,
    gfm: true,
  }) as string
})
</script>

<style lang="scss" scoped>
.app-detail-card {
  height: 100vh;
  height: 100dvh;
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
    display: flex;
    flex-direction: column;
    gap: 20px;

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
            font-size: 1.35rem;
            font-weight: 800;
            line-height: 1.25;
            margin-bottom: 4px;
          }

          .app-dev {
            font-size: 0.9rem;
            color: rgb(var(--v-theme-primary));
            font-weight: 600;
            margin-bottom: 6px;
          }

          .app-badges {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;

            .badge {
              font-size: 11px;
              padding: 2px 8px;
              border-radius: 6px;
              background: rgba(var(--v-theme-on-surface), 0.08);
              font-weight: 600;
            }
          }
        }
      }
    }

    .action-row {
      .links-container {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;

        .link-btn {
          flex: 1 1 180px;
          font-weight: 700;
          font-size: 14px;
          height: 46px;
        }
      }
    }

    .section-title {
      font-size: 1.05rem;
      font-weight: 800;
      margin-bottom: 8px;
    }

    .screenshots-section {
      .screenshot-scroll {
        display: flex;
        gap: 12px;
        overflow-x: auto;
        padding-bottom: 6px;

        .screenshot-item {
          flex-shrink: 0;
          width: 160px;
          border-radius: 12px;
          overflow: hidden;
          border: 1px solid rgba(var(--v-theme-on-surface), 0.08);

          .screenshot-img {
            width: 100%;
            height: auto;
            display: block;
          }
        }
      }
    }

    .about-section {
      .summary-lead {
        font-size: 0.95rem;
        font-weight: 600;
        margin-bottom: 8px;
        line-height: 1.5;
      }

      .markdown-body {
        font-size: 0.9rem;
        line-height: 1.7;
        color: rgba(var(--v-theme-on-surface), 0.88);

        :deep(h1),
        :deep(h2),
        :deep(h3),
        :deep(h4) {
          font-weight: 700;
          margin-top: 1em;
          margin-bottom: 0.5em;
          color: rgb(var(--v-theme-on-surface));
        }

        :deep(p) {
          margin-bottom: 0.7em;
        }
        :deep(ul),
        :deep(ol) {
          padding-left: 20px;
          margin-bottom: 0.7em;
        }
        :deep(li) {
          margin-bottom: 3px;
        }
        :deep(strong) {
          font-weight: 700;
          color: rgb(var(--v-theme-on-surface));
        }
        :deep(code) {
          background: rgba(var(--v-theme-on-surface), 0.08);
          padding: 2px 5px;
          border-radius: 4px;
          font-size: 0.85em;
          font-family: monospace;
        }
      }
    }

    .tags-section {
      .tag-group {
        .group-label {
          font-size: 12px;
          font-weight: 700;
          color: rgba(var(--v-theme-on-surface), 0.7);
          margin-bottom: 6px;
          display: block;
        }

        .chips-wrap {
          display: flex;
          gap: 6px;
          flex-wrap: wrap;
        }
      }
    }

    .footer-spacer {
      height: 40px;
    }
  }
}
</style>
