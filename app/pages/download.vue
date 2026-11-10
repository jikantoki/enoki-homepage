<template lang="pug">
v-card.download-page-root(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.download-page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title ダウンロード
    v-spacer
    v-btn(
      icon="mdi-share-variant"
      variant="text"
      @click="sharePage"
    )

  //- メインスクロールエリア
  v-card-text.download-page-content(ref="contentContainer")
    .content-wrapper
      //- ヒーローバナー
      .download-hero-card
        .hero-bg-accent
        .hero-inner
          .hero-icon-circle
            v-icon(size="36" color="primary") mdi-download-box-outline
          h1.hero-title ダウンロードセンター
          p.hero-subtitle DOWNLOAD CENTER &amp; ARCHIVE
          p.hero-desc
            | ときえのき（エノキ電気）が製作・管理しているオリジナル楽曲データ、Linux OS、
            br.d-none.d-sm-inline
            | 妄想鉄道路線図Excel、電子工作・電光掲示板制御ファイルなどを無料でダウンロードできます。

      //- ミラーサーバー・アクセス注意事項のアラート
      v-alert.my-4.server-notice-alert(
        variant="tonal"
        color="info"
        rounded="xl"
        density="comfortable"
        icon="mdi-information-outline"
      )
        .notice-content
          span.notice-title 一部ファイルのダウンロードについて: 
          span.notice-text
            | 一部ファイルのダウンロード時には、高速配信サーバー 
            a.notice-link(href="https://山d.com" target="_blank" rel="noopener noreferrer") https://山d.com
            |  にアクセスします。安全にご利用いただけます。

      //- 検索 ＆ コントロールバー
      .search-and-controls-row.my-4
        v-text-field.search-field(
          v-model="searchQuery"
          prepend-inner-icon="mdi-magnify"
          placeholder="ファイル名、路線名、キーワードで検索..."
          variant="outlined"
          density="comfortable"
          rounded="pill"
          hide-details
          clearable
        )

      //- カテゴリタブ
      .category-tabs-wrapper.mb-6
        v-tabs(
          v-model="activeCategory"
          color="primary"
          density="comfortable"
          align-tabs="center"
          show-arrows
        )
          v-tab(value="all")
            v-icon(start) mdi-view-grid-outline
            | すべて ({{ allItems.length }})
          v-tab(value="music")
            v-icon(start) mdi-music
            | 楽曲データ ({{ countByCategory('music') }})
          v-tab(value="os")
            v-icon(start) mdi-linux
            | Linux OS ({{ countByCategory('os') }})
          v-tab(value="railway")
            v-icon(start) mdi-train
            | 鉄道路線図 ({{ countByCategory('railway') }})
          v-tab(value="led")
            v-icon(start) mdi-led-strip-variant
            | 電光掲示板 ({{ countByCategory('led') }})
          v-tab(value="other")
            v-icon(start) mdi-folder-network-outline
            | 外部リソース ({{ externalResources.length }})

      //- ================= ダウンロードアイテム一覧 =================
      .items-container(v-if="activeCategory !== 'other'")
        //- 該当なしの場合
        .empty-state.pa-8.text-center(v-if="filteredItems.length === 0")
          v-icon(size="48" color="medium-emphasis") mdi-file-search-outline
          p.mt-2.text-medium-emphasis 検索条件「{{ searchQuery }}」に一致するファイルが見つかりませんでした。
          v-btn.mt-3(
            variant="tonal"
            size="small"
            rounded="pill"
            prepend-icon="mdi-refresh"
            @click="searchQuery = ''; activeCategory = 'all'"
          ) 条件をクリア

        //- アイテムグリッド
        .download-grid(v-else)
          v-card.download-card(
            v-for="item in filteredItems"
            :key="item.id"
            variant="outlined"
          )
            //- カード上部：カテゴリ & フォーマットバッジ
            .card-badge-row
              .badge-group
                v-chip(
                  size="small"
                  variant="tonal"
                  color="primary"
                  class="font-weight-medium"
                ) {{ item.categoryLabel }}

                v-chip(
                  size="small"
                  variant="flat"
                  :color="item.formatColor"
                  class="font-weight-bold text-white ml-1"
                ) {{ item.format }}

              v-chip(
                v-if="item.badge"
                size="small"
                variant="outlined"
                color="secondary"
              ) {{ item.badge }}

            //- カードタイトル
            .card-title-section
              h3.card-title {{ item.title }}
              p.card-subtitle(v-if="item.subtitle") {{ item.subtitle }}

            //- 画像プレビューエリア（画像がある場合）
            .card-media-wrap(v-if="item.images && item.images.length > 0")
              //- 複数画像の場合はタブ切り替え
              .image-tabs(v-if="item.images.length > 1")
                v-chip.mr-1.mb-2(
                  v-for="(img, idx) in item.images"
                  :key="idx"
                  size="x-small"
                  :variant="(selectedImageIndex[item.id] || 0) === idx ? 'flat' : 'outlined'"
                  color="primary"
                  @click="selectedImageIndex[item.id] = idx"
                ) {{ img.caption || `図面 ${idx + 1}` }}

              .image-container(
                @click="openImageModal(item.images[selectedImageIndex[item.id] || 0].url, item.title, item.images[selectedImageIndex[item.id] || 0].caption)"
              )
                img.preview-img(
                  :src="item.images[selectedImageIndex[item.id] || 0].url"
                  :alt="item.title"
                  loading="lazy"
                )
                .image-zoom-overlay
                  v-icon(size="24" color="white") mdi-magnify-plus-outline
                  span.overlay-text クリックして拡大
                p.caption-text(v-if="item.images[selectedImageIndex[item.id] || 0].caption")
                  | {{ item.images[selectedImageIndex[item.id] || 0].caption }}

            //- 説明文
            v-card-text.card-body
              p.desc-text {{ item.description }}
              v-alert.mt-3.pa-2.note-alert(
                v-if="item.note"
                density="compact"
                variant="tonal"
                color="amber-darken-3"
                icon="mdi-alert-circle-outline"
              )
                span.text-caption {{ item.note }}

            //- YouTube動画トグル・埋め込み（ある場合）
            .card-video-wrap.px-4.pb-2(v-if="item.youtubeId")
              v-btn.toggle-video-btn(
                variant="tonal"
                color="red-darken-1"
                density="comfortable"
                rounded="pill"
                size="small"
                prepend-icon="mdi-youtube"
                @click="toggleVideo(item.id)"
              )
                | {{ showVideo[item.id] ? '動画プレーヤーを閉じる' : '紹介動画を見る' }}
              .video-embed-container.mt-2(v-if="showVideo[item.id]")
                iframe(
                  :src="`https://www.youtube.com/embed/${item.youtubeId}`"
                  title="YouTube video player"
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen
                )

            //- 関連ブログ記事カード（ある場合）
            .card-blog-wrap.px-4.pb-2(v-if="item.blogUrl")
              v-card.blog-link-card(
                variant="tonal"
                color="primary"
                @click="openURL(item.blogUrl)"
              )
                .blog-card-inner
                  img.blog-img(v-if="item.blogImage" :src="item.blogImage" alt="blog thumbnail")
                  .blog-info
                    span.blog-label 関連ブログ・解説記事
                    p.blog-title {{ item.blogTitle || '解説記事を見る' }}
                    v-icon.blog-arrow(size="16") mdi-arrow-right

            //- アクションボタン
            v-card-actions.card-footer
              v-btn.download-btn(
                v-if="item.downloadUrl"
                color="primary"
                variant="flat"
                rounded="pill"
                prepend-icon="mdi-download"
                @click="handleDownload(item)"
              ) ダウンロード

              v-btn.external-btn(
                v-if="item.externalUrl"
                color="indigo"
                variant="tonal"
                rounded="pill"
                prepend-icon="mdi-open-in-new"
                @click="openURL(item.externalUrl)"
              ) 配布ページを開く

      //- ================= 外部リソースセクション =================
      section.external-resources-section.mt-8(v-if="activeCategory === 'all' || activeCategory === 'other'")
        .section-header.mb-4
          .section-title-wrap
            v-icon(color="primary" size="24") mdi-folder-network-outline
            h2.section-heading お探しのファイルが見つからない場合
          p.section-subtext
            | 過去バージョンのOSイメージや最新のソースコード、FascodeNetwork共同開発ツール、
            br.d-none.d-sm-inline
            | 未公表ソフトウェアなどは以下の公式リポジトリ・ミラーサーバーにて保管・配布されています。

        .external-grid
          v-card.external-card(
            v-for="res in externalResources"
            :key="res.title"
            variant="outlined"
            @click="openURL(res.url)"
          )
            .card-top-icon
              v-icon(:color="res.color" size="32") {{ res.icon }}
              v-chip(v-if="res.badge" size="x-small" variant="tonal" :color="res.color") {{ res.badge }}
            h3.res-title {{ res.title }}
            p.res-desc {{ res.description }}
            .res-action
              span.action-text アクセスする
              v-icon(size="16") mdi-arrow-right

  //- ================= 画像拡大モーダルダイアログ =================
  v-dialog(v-model="imageModal.isOpen" max-width="1100" scrollable)
    v-card.image-dialog-card
      v-card-actions.dialog-header
        p.modal-title.text-subtitle-1.font-weight-bold {{ imageModal.title }}
        v-spacer
        v-btn(icon="mdi-close" variant="text" density="comfortable" @click="imageModal.isOpen = false")
      v-card-text.dialog-body.pa-2.text-center
        img.modal-full-img(:src="imageModal.url" :alt="imageModal.title")
        p.mt-2.caption-text(v-if="imageModal.caption") {{ imageModal.caption }}
      v-card-actions.dialog-footer
        v-spacer
        v-btn(
          variant="tonal"
          prepend-icon="mdi-open-in-new"
          rounded="pill"
          @click="openURL(imageModal.url)"
        ) 元画像を直接開く
        v-btn(
          color="primary"
          variant="flat"
          rounded="pill"
          @click="imageModal.isOpen = false"
        ) 閉じる
</template>

<script lang="ts">
import { Share } from '@capacitor/share'
import { Toast } from '@capacitor/toast'
import {
  DOWNLOAD_ITEMS,
  EXTERNAL_RESOURCES,
  type DownloadItem,
  type ExternalResource,
} from '@/data/downloads'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default {
  name: 'DownloadPage',
  mixins: [mixins],
  data() {
    return {
      settings: useSettingsStore(),
      allItems: DOWNLOAD_ITEMS as DownloadItem[],
      externalResources: EXTERNAL_RESOURCES as ExternalResource[],
      activeCategory: 'all',
      searchQuery: '',
      selectedImageIndex: {} as Record<string, number>,
      showVideo: {} as Record<string, boolean>,
      imageModal: {
        isOpen: false,
        url: '',
        title: '',
        caption: '',
      },
    }
  },
  setup() {
    Setup.setTitle('ダウンロード')
    Setup.setDescription(
      'ときえのき（エノキ電気）が製作・管理している楽曲オフボーカル、Linux OS、鉄道路線図Excel、電光掲示板LEDVISION制御ファイル等のダウンロードページです。',
    )
  },
  computed: {
    filteredItems(): DownloadItem[] {
      let items = this.allItems
      if (this.activeCategory !== 'all') {
        items = items.filter((item) => item.category === this.activeCategory)
      }
      if (this.searchQuery && this.searchQuery.trim() !== '') {
        const q = this.searchQuery.trim().toLowerCase()
        items = items.filter((item) => {
          return (
            item.title.toLowerCase().includes(q) ||
            (item.subtitle && item.subtitle.toLowerCase().includes(q)) ||
            item.description.toLowerCase().includes(q) ||
            item.format.toLowerCase().includes(q) ||
            item.categoryLabel.toLowerCase().includes(q) ||
            (item.note && item.note.toLowerCase().includes(q))
          )
        })
      }
      return items
    },
  },
  mounted() {
    this.setTitle('ダウンロード')
  },
  methods: {
    handleBack() {
      if (window.history.length > 1) {
        this.$router.back()
      } else {
        this.$router.push('/')
      }
    },
    countByCategory(cat: string): number {
      return this.allItems.filter((item) => item.category === cat).length
    },
    toggleVideo(id: string) {
      this.showVideo[id] = !this.showVideo[id]
    },
    openImageModal(url: string, title: string, caption?: string) {
      this.imageModal = {
        isOpen: true,
        url,
        title,
        caption: caption || '',
      }
    },
    openURL(url: string) {
      if (!url) return
      window.open(url, '_blank', 'noopener,noreferrer')
    },
    async handleDownload(item: DownloadItem) {
      if (!item.downloadUrl) return
      const filename = item.downloadUrl.split('/').pop() || item.title
      try {
        const link = document.createElement('a')
        link.href = item.downloadUrl
        link.download = decodeURIComponent(filename)
        link.target = '_blank'
        link.rel = 'noopener noreferrer'
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)

        await Toast.show({
          text: `「${item.title}」のダウンロードを開始しました`,
          duration: 'short',
        })
      } catch {
        window.open(item.downloadUrl, '_blank')
      }
    },
    async sharePage() {
      const shareUrl = 'https://enoki.xyz/download/'
      try {
        await Share.share({
          title: 'ダウンロード - エノキ電気',
          text: 'ときえのき製作の楽曲オフボーカル、Linux OS、鉄道路線図Excel、電光掲示板データなどのダウンロード一覧です。',
          url: shareUrl,
          dialogTitle: 'ダウンロードページを共有',
        })
      } catch {
        if (navigator.clipboard) {
          await navigator.clipboard.writeText(shareUrl)
          await Toast.show({ text: 'URLをコピーしました' })
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.download-page-root {
  display: flex;
  flex-direction: column;
  background-color: rgb(var(--v-theme-background));
  height: 100vh;
  height: 100dvh;
  overflow: hidden;
  position: relative;
}

.download-page-header {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 56px;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  background-color: rgba(var(--v-theme-surface), 0.6);
  backdrop-filter: blur(6px);
  z-index: 20;
  flex-shrink: 0;

  .header-title {
    font-size: 1.15rem;
    font-weight: 700;
    margin: 0 0 0 8px;
  }
}

.download-page-content {
  flex: 1;
  height: 100%;
  overflow-y: auto;
  padding: 72px 16px 16px;
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
}

.content-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding-bottom: 96px;
}

/* ================= ヒーローバナー ================= */
.download-hero-card {
  position: relative;
  overflow: hidden;
  border-radius: 24px;
  padding: 36px 24px;
  text-align: center;
  margin-bottom: 16px;
  background: linear-gradient(
    135deg,
    rgba(var(--v-theme-primary), 0.12) 0%,
    rgba(var(--v-theme-surface), 0.95) 100%
  );
  border: 1px solid rgba(var(--v-theme-primary), 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.04);

  .hero-bg-accent {
    position: absolute;
    top: -50%;
    right: -20%;
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: radial-gradient(
      circle,
      rgba(var(--v-theme-primary), 0.15) 0%,
      transparent 70%
    );
    pointer-events: none;
  }

  .hero-inner {
    position: relative;
    z-index: 1;
  }

  .hero-icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 68px;
    height: 68px;
    border-radius: 50%;
    background: rgba(var(--v-theme-primary), 0.12);
    margin-bottom: 16px;
    border: 1px solid rgba(var(--v-theme-primary), 0.25);
  }

  .hero-title {
    font-size: 1.85rem;
    font-weight: 800;
    letter-spacing: -0.02em;
    margin-bottom: 4px;
  }

  .hero-subtitle {
    font-size: 0.85rem;
    font-weight: 700;
    letter-spacing: 0.1em;
    color: rgb(var(--v-theme-primary));
    margin-bottom: 12px;
  }

  .hero-desc {
    font-size: 0.95rem;
    line-height: 1.65;
    color: rgba(var(--v-theme-on-surface), 0.8);
    max-width: 720px;
    margin: 0 auto;
  }
}

/* ================= サーバー通知アラート ================= */
.server-notice-alert {
  .notice-content {
    font-size: 0.9rem;
    line-height: 1.5;

    .notice-title {
      font-weight: 700;
      margin-right: 6px;
    }

    .notice-link {
      color: rgb(var(--v-theme-primary));
      font-weight: 700;
      text-decoration: underline;
    }
  }
}

/* ================= 検索 & タブ ================= */
.search-and-controls-row {
  max-width: 640px;
  margin: 0 auto;
}

.category-tabs-wrapper {
  border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

/* ================= アイテムグリッド ================= */
.download-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 20px;

  @media (max-width: 600px) {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}

.download-card {
  display: flex;
  flex-direction: column;
  border-radius: 20px;
  overflow: hidden;
  background: rgb(var(--v-theme-surface));
  border: 1px solid rgba(var(--v-border-color), 0.6);
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
    border-color: rgba(var(--v-theme-primary), 0.4);
  }

  .card-badge-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 16px 8px;

    .badge-group {
      display: flex;
      align-items: center;
      gap: 6px;
    }
  }

  .card-title-section {
    padding: 4px 16px 10px;

    .card-title {
      font-size: 1.2rem;
      font-weight: 700;
      line-height: 1.35;
      margin-bottom: 4px;
    }

    .card-subtitle {
      font-size: 0.85rem;
      color: rgba(var(--v-theme-on-surface), 0.7);
      margin: 0;
    }
  }

  .card-media-wrap {
    padding: 0 16px 8px;

    .image-tabs {
      display: flex;
      flex-wrap: wrap;
      margin-bottom: 6px;
    }

    .image-container {
      position: relative;
      border-radius: 12px;
      overflow: hidden;
      background: rgba(0, 0, 0, 0.04);
      cursor: pointer;
      aspect-ratio: 16 / 9;
      display: flex;
      align-items: center;
      justify-content: center;

      .preview-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
      }

      .image-zoom-overlay {
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.4);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 4px;
        opacity: 0;
        transition: opacity 0.2s ease;

        .overlay-text {
          color: #fff;
          font-size: 0.8rem;
          font-weight: 600;
        }
      }

      &:hover {
        .preview-img {
          transform: scale(1.03);
        }
        .image-zoom-overlay {
          opacity: 1;
        }
      }

      .caption-text {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 4px 8px;
        background: rgba(0, 0, 0, 0.65);
        color: #fff;
        font-size: 0.75rem;
        text-align: center;
        margin: 0;
      }
    }
  }

  .card-body {
    flex: 1;
    padding: 8px 16px 12px;

    .desc-text {
      font-size: 0.9rem;
      line-height: 1.6;
      color: rgba(var(--v-theme-on-surface), 0.85);
      white-space: pre-line;
      margin: 0;
    }

    .note-alert {
      border-radius: 10px;
    }
  }

  .card-video-wrap {
    .video-embed-container {
      position: relative;
      padding-bottom: 56.25%;
      height: 0;
      overflow: hidden;
      border-radius: 12px;

      iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
      }
    }
  }

  .card-blog-wrap {
    .blog-link-card {
      border-radius: 12px;
      cursor: pointer;
      transition: background 0.2s ease;

      .blog-card-inner {
        display: flex;
        align-items: center;
        padding: 10px;
        gap: 12px;

        .blog-img {
          width: 64px;
          height: 48px;
          object-fit: cover;
          border-radius: 6px;
          flex-shrink: 0;
        }

        .blog-info {
          flex: 1;
          min-width: 0;

          .blog-label {
            font-size: 0.72rem;
            font-weight: 600;
            color: rgb(var(--v-theme-primary));
            display: block;
          }

          .blog-title {
            font-size: 0.85rem;
            font-weight: 600;
            margin: 2px 0 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }
        }

        .blog-arrow {
          color: rgb(var(--v-theme-primary));
        }
      }
    }
  }

  .card-footer {
    padding: 12px 16px 16px;
    display: flex;
    gap: 8px;
    border-top: 1px solid rgba(var(--v-border-color), 0.3);

    .download-btn,
    .external-btn {
      flex: 1;
      font-weight: 700;
      text-transform: none;
    }
  }
}

/* ================= 外部リソースセクション ================= */
.external-resources-section {
  .section-header {
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
    }

    .section-subtext {
      font-size: 0.9rem;
      color: rgba(var(--v-theme-on-surface), 0.7);
      line-height: 1.6;
    }
  }

  .external-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
  }

  .external-card {
    padding: 20px;
    border-radius: 18px;
    cursor: pointer;
    transition: transform 0.2s ease, border-color 0.2s ease,
      box-shadow 0.2s ease;
    display: flex;
    flex-direction: column;

    &:hover {
      transform: translateY(-3px);
      border-color: rgba(var(--v-theme-primary), 0.5);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);

      .res-action .action-text {
        color: rgb(var(--v-theme-primary));
      }
    }

    .card-top-icon {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
    }

    .res-title {
      font-size: 1.1rem;
      font-weight: 700;
      margin-bottom: 6px;
    }

    .res-desc {
      font-size: 0.85rem;
      color: rgba(var(--v-theme-on-surface), 0.75);
      line-height: 1.55;
      flex: 1;
      margin-bottom: 16px;
    }

    .res-action {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 0.85rem;
      font-weight: 600;
      color: rgba(var(--v-theme-on-surface), 0.6);
      transition: color 0.2s ease;
    }
  }
}

/* ================= 画像モーダル ================= */
.image-dialog-card {
  border-radius: 20px;
  overflow: hidden;

  .modal-full-img {
    max-width: 100%;
    max-height: 75vh;
    object-fit: contain;
    border-radius: 8px;
  }
}
</style>
