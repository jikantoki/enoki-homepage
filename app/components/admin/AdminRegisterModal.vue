<template lang="pug">
v-dialog(
  v-model="isOpen"
  :fullscreen="isMobile"
  :transition="isMobile ? 'dialog-bottom-transition' : 'dialog-transition'"
  :max-width="isMobile ? undefined : 840"
  :width="isMobile ? '100%' : '90%'"
  scrollable
  persistent
)
  v-card.register-modal-card(
    :class="{ 'is-mobile': isMobile }"
    style="max-height: 90dvh; overflow-y: auto; max-width: 90vw; overflow-x: hidden;"
    )
    //- ヘッダー
    v-card-title.d-flex.align-center.modal-header.py-3.px-4
      v-icon.mr-2(color="primary") {{ isEditMode ? 'mdi-pencil-box-outline' : 'mdi-shield-plus-outline' }}
      span(style="overflow: hidden;") {{ isEditMode ? (currentTab === 'app' ? `${appData.type === 'game' ? 'ゲーム' : 'アプリ'}の編集 (${appData.name || appData.id})` : `音楽の編集 (${musicData.title || musicData.id})`) : (currentTab === 'app' ? `管理者コンテンツ登録 (${appData.type === 'game' ? 'ゲーム' : 'アプリ'})` : '管理者コンテンツ登録 (音楽)') }}
      v-spacer
      v-btn(
        icon="mdi-close"
        variant="text"
        density="comfortable"
        @click="closeModal"
      )

    //- タブ選択 (新規登録時のみ表示、または編集時も切り替え可)
    v-tabs.register-tabs(
      v-if="!isEditMode"
      v-model="currentTab"
      color="primary"
      grow
      density="comfortable"
    )
      v-tab(value="app")
        v-icon.mr-2 mdi-apps
        | アプリ・ゲーム登録
      v-tab(value="music")
        v-icon.mr-2 mdi-music
        | 音楽登録

    //- コンテンツスクロールエリア
    v-card-text.modal-body.pa-4(style="max-height: inherit; overflow-y: auto;")
      v-window(v-model="currentTab")

        //- ==================== 1. アプリ登録フォーム ====================
        v-window-item(value="app")
          v-form(ref="appForm" @submit.prevent="submitApp")
            //- アプリ種別トグル
            .form-section-title 基本情報
            .mb-3
              label.v-label.mb-1 種別
              v-btn-toggle.w-100.app-type-toggle(
                v-model="appData.type"
                color="primary"
                mandatory
                density="comfortable"
                rounded="lg"
                variant="outlined"
                divided
                selected-class="app-type-btn--selected"
              )
                v-btn(
                  value="app"
                  style="flex: 1"
                  :style="appData.type === 'app' ? { backgroundColor: 'var(--accent-color) !important', color: 'var(--accent-text-color, #ffffff) !important' } : {}"
                )
                  v-icon.mr-1(
                    :style="appData.type === 'app' ? { color: 'var(--accent-text-color, #ffffff) !important' } : {}"
                  ) mdi-application
                  | アプリ (App)
                v-btn(
                  value="game"
                  style="flex: 1"
                  :style="appData.type === 'game' ? { backgroundColor: 'var(--accent-color) !important', color: 'var(--accent-text-color, #ffffff) !important' } : {}"
                )
                  v-icon.mr-1(
                    :style="appData.type === 'game' ? { color: 'var(--accent-text-color, #ffffff) !important' } : {}"
                  ) mdi-gamepad-variant
                  | ゲーム (Game)

            v-row(dense)
              v-col(cols="12" md="8")
                v-text-field(
                  v-model="appData.name"
                  :label="appData.type === 'game' ? 'ゲーム名 *' : 'アプリ名 *'"
                  placeholder="例: サイバーブレード 2088"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'アプリ名は必須です']"
                  @input="autoGenerateAppId"
                )
              v-col(cols="12" md="4")
                v-text-field(
                  v-model="appData.id"
                  :label="appData.type === 'game' ? 'ゲームID (スラッグ) *' : 'アプリID (スラッグ) *'"
                  placeholder="例: cyberblade-2088"
                  variant="outlined"
                  density="comfortable"
                  :disabled="isEditMode"
                  :hint="isEditMode ? '編集時はIDを変更できません' : '英数字とハイフンのみ'"
                  persistent-hint
                  :rules="[v => !!v || 'アプリIDは必須です']"
                )

            v-row(dense)
              v-col(cols="12" md="6")
                v-combobox(
                  v-model="appData.category"
                  :items="suggestedAppCategories"
                  label="カテゴリ *"
                  placeholder="選択または入力"
                  variant="outlined"
                  density="comfortable"
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model.number="appData.price"
                  label="価格 (円)"
                  type="number"
                  min="0"
                  prefix="¥"
                  variant="outlined"
                  density="comfortable"
                  hint="0で「無料」"
                  persistent-hint
                )

            v-text-field(
              v-model="appData.summary"
              label="キャッチコピー・概要"
              placeholder="例: RPGの決定版！新しい世界を体験しよう。"
              variant="outlined"
              density="comfortable"
            )

            //- 画像ファイル設定
            .form-section-title.mt-4 メディア・画像
            v-row(dense)
              //- アイコン
              v-col(cols="12" md="6")
                v-card.pa-3.mb-2(variant="outlined" rounded="lg")
                  .d-flex.align-center.justify-space-between.mb-2
                    span.font-weight-medium アプリアイコン (正方形)
                    v-chip(v-if="appData.icon" size="x-small" color="success") 設定済み
                  .d-flex.align-center.gap-3
                    .preview-box.square
                      img(v-if="appData.icon" :src="appData.icon" alt="icon")
                      v-icon(v-else size="32" color="grey") mdi-image-outline
                    .flex-grow-1
                      v-file-input(
                        accept="image/*"
                        label="画像を選択"
                        variant="outlined"
                        density="compact"
                        prepend-icon=""
                        prepend-inner-icon="mdi-upload"
                        hide-details
                        @change="handleImageUpload($event, 'app_icon')"
                      )
                      v-text-field.mt-2(
                        v-model="appData.icon"
                        label="または画像URL / SVG"
                        variant="outlined"
                        density="compact"
                        hide-details
                      )

              //- サムネイル
              v-col(cols="12" md="6")
                v-card.pa-3.mb-2(variant="outlined" rounded="lg")
                  .d-flex.align-center.justify-space-between.mb-2
                    span.font-weight-medium サムネイル (16:9)
                    v-chip(v-if="appData.thumbnail" size="x-small" color="success") 設定済み
                  .d-flex.align-center.gap-3
                    .preview-box.landscape
                      img(v-if="appData.thumbnail" :src="appData.thumbnail" alt="thumbnail")
                      v-icon(v-else size="32" color="grey") mdi-image-outline
                    .flex-grow-1
                      v-file-input(
                        accept="image/*"
                        label="画像を選択"
                        variant="outlined"
                        density="compact"
                        prepend-icon=""
                        prepend-inner-icon="mdi-upload"
                        hide-details
                        @change="handleImageUpload($event, 'app_thumbnail')"
                      )
                      v-text-field.mt-2(
                        v-model="appData.thumbnail"
                        label="または画像URL"
                        variant="outlined"
                        density="compact"
                        hide-details
                      )

            //- プラットフォーム & 言語
            .form-section-title.mt-4 対応プラットフォーム & 言語
            .mb-2
              label.v-label.mb-1 プラットフォーム (複数選択可)
              .d-flex.flex-wrap.gap-2
                v-chip(
                  v-for="platform in availablePlatforms"
                  :key="platform"
                  :color="appData.platforms.includes(platform) ? 'primary' : undefined"
                  :variant="appData.platforms.includes(platform) ? 'flat' : 'outlined'"
                  filter
                  @click="togglePlatform(platform)"
                ) {{ platform }}

            .mb-2
              label.v-label.mb-1 言語
              .d-flex.flex-wrap.gap-2
                v-chip(
                  v-for="lang in availableLanguages"
                  :key="lang"
                  :color="appData.languages.includes(lang) ? 'primary' : undefined"
                  :variant="appData.languages.includes(lang) ? 'flat' : 'outlined'"
                  filter
                  @click="toggleLanguage(lang)"
                ) {{ lang }}

            //- 詳細説明
            .form-section-title.mt-4 紹介文 (Markdown対応)
            v-textarea(
              v-model="appData.description"
              placeholder="### アプリの特徴\n\n- 美しいUI\n- 高速な動作\n- 安心のプライバシー"
              variant="outlined"
              rows="5"
              auto-grow
            )

            //- リンク
            .form-section-title.mt-4 リンク & URL
            v-row(dense)
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="appLinks.googlePlay"
                  label="Google Play URL"
                  prepend-inner-icon="mdi-google-play"
                  variant="outlined"
                  density="comfortable"
                  placeholder="https://play.google.com/..."
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="appLinks.appStore"
                  label="App Store URL"
                  prepend-inner-icon="mdi-apple"
                  variant="outlined"
                  density="comfortable"
                  placeholder="https://apps.apple.com/..."
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="appLinks.webUrl"
                  label="Web版 URL"
                  prepend-inner-icon="mdi-web"
                  variant="outlined"
                  density="comfortable"
                  placeholder="https://enoki.xyz/apps/..."
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="appData.githubUrl"
                  label="GitHub リポジトリ URL"
                  prepend-inner-icon="mdi-github"
                  variant="outlined"
                  density="comfortable"
                  placeholder="https://github.com/..."
                )

            v-row(dense)
              v-col(cols="12" md="6")
                v-switch(
                  v-model="appData.featured"
                  color="primary"
                  :label="appData.type === 'game' ? '注目 / ピックアップゲームに設定する' : '注目 / ピックアップアプリに設定する'"
                  hide-details
                )
              v-col(cols="12" md="6")
                v-switch(
                  v-model="appData.isUnfinished"
                  color="warning"
                  label="「未完成」タグを付ける (制作中・ベータ版等)"
                  hide-details
                )

            .d-flex.justify-end.mt-6.gap-3
              v-btn(variant="text" @click="closeModal") キャンセル
              v-btn(
                color="primary"
                type="submit"
                :loading="submittingApp"
                size="large"
                rounded="pill"
                :prepend-icon="isEditMode ? 'mdi-content-save' : 'mdi-check'"
              ) {{ isEditMode ? (appData.type === 'game' ? 'ゲーム情報を更新' : 'アプリ情報を更新') : (appData.type === 'game' ? 'ゲームを登録' : 'アプリを登録') }}

        //- ==================== 2. 音楽登録フォーム ====================
        v-window-item(value="music")
          v-form(ref="musicForm" @submit.prevent="submitMusic")

            //- ★ 音楽ファイルアップロードエリア (最重要) ★
            .form-section-title 🎵 音楽ファイル (mp3 / wav / m4a 等)
            v-card.audio-upload-card.pa-4.mb-4(
              variant="outlined"
              rounded="xl"
              :class="{ 'has-file': !!musicData.audioUrl, 'is-uploading': uploadingAudio }"
            )
              .d-flex.align-center.gap-3
                .audio-icon-box
                  v-icon(size="36" :color="musicData.audioUrl ? 'primary' : 'grey'") {{ musicData.audioUrl ? 'mdi-music-circle' : 'mdi-cloud-upload-outline' }}
                .flex-grow-1
                  .font-weight-bold(style="font-size: 1.05em") 音声ファイルをアップロード
                  .text-caption.text-grey mp3, wav, m4a, ogg, flac, aac 等（最大100MB）

              //- ファイル選択 input
              .mt-3
                v-file-input(
                  accept="audio/*,.mp3,.wav,.m4a,.ogg,.flac,.aac"
                  label="音声ファイルを選択 または ドロップ"
                  variant="outlined"
                  density="comfortable"
                  prepend-icon=""
                  prepend-inner-icon="mdi-file-music-outline"
                  show-size
                  clearable
                  :loading="uploadingAudio"
                  @change="handleAudioFileSelect"
                  @click:clear="clearAudioFile"
                )

              //- アップロード進捗バー
              v-progress-linear.mt-2(
                v-if="uploadingAudio"
                indeterminate
                color="primary"
                rounded
                height="6"
              )

              //- アップロード成功情報 ＆ 試聴プレイヤー
              .audio-preview-container.mt-3(v-if="musicData.audioUrl")
                v-alert(
                  type="success"
                  variant="tonal"
                  density="compact"
                  rounded="lg"
                  class="mb-2"
                )
                  .d-flex.align-center.justify-space-between
                    span
                      v-icon.mr-1 mdi-check-circle
                      | サーバーにアップロード完了！ (長さ: {{ musicData.durationFormatted }})
                    v-chip(size="x-small" color="success") OK

                //- ミニ試聴コントロール
                .mini-preview-player.pa-3.rounded-lg
                  .d-flex.align-center.gap-3
                    v-btn(
                      :icon="previewPlaying ? 'mdi-pause' : 'mdi-play'"
                      color="primary"
                      size="small"
                      @click="togglePreviewAudio"
                    )
                    .flex-grow-1
                      .text-caption.font-weight-medium.text-truncate {{ uploadedAudioName || musicData.title || 'アップロード済み音声' }}
                      .d-flex.align-center.gap-2
                        span.text-caption.text-grey {{ formatTime(previewCurrentTime) }}
                        v-slider(
                          v-model="previewCurrentTime"
                          :max="previewDuration || musicData.duration || 100"
                          hide-details
                          density="compact"
                          color="primary"
                          @update:modelValue="seekPreviewAudio"
                        )
                        span.text-caption.text-grey {{ formatTime(previewDuration || musicData.duration) }}

              //- 直接URL手入力欄（手動指定にも対応）
              .mt-3
                v-text-field(
                  v-model="musicData.audioUrl"
                  label="音声ファイルURL (直接指定または上記で自動反映)"
                  variant="outlined"
                  density="compact"
                  prepend-inner-icon="mdi-link"
                  hide-details
                )

            //- 楽曲基本情報
            .form-section-title.mt-4 楽曲基本情報
            v-row(dense)
              v-col(cols="12" md="8")
                v-text-field(
                  v-model="musicData.title"
                  label="楽曲タイトル *"
                  placeholder="例: ミッドナイト・ブルー"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'タイトルは必須です']"
                  @input="autoGenerateMusicId"
                )
              v-col(cols="12" md="4")
                v-text-field(
                  v-model="musicData.id"
                  label="楽曲ID *"
                  placeholder="例: midnight-blue"
                  variant="outlined"
                  density="comfortable"
                  :disabled="isEditMode"
                  :hint="isEditMode ? '編集時はIDを変更できません' : '半角英数ハイフン'"
                  persistent-hint
                  :rules="[v => !!v || '楽曲IDは必須です']"
                )

            v-row(dense)
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="musicData.artist"
                  label="アーティスト名 *"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'アーティスト名は必須です']"
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="musicData.album"
                  label="アルバム名"
                  placeholder="例: City Lights E.P."
                  variant="outlined"
                  density="comfortable"
                )

            v-row(dense)
              v-col(cols="12" md="4")
                v-select(
                  v-model="musicData.albumType"
                  :items="[{ title: 'シングル (Single)', value: 'single' }, { title: 'アルバム (Album)', value: 'album' }, { title: 'EP', value: 'ep' }]"
                  label="作品種別"
                  variant="outlined"
                  density="comfortable"
                )
              v-col(cols="12" md="4")
                v-combobox(
                  v-model="musicData.genre"
                  :items="['歌モノ', 'インスト', 'AI楽曲']"
                  label="ジャンル *"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'ジャンルは必須です']"
                )
              v-col(cols="12" md="4")
                v-text-field(
                  v-model.number="musicData.bpm"
                  label="BPM (テンポ)"
                  type="number"
                  min="40"
                  max="300"
                  variant="outlined"
                  density="comfortable"
                )

            //- カバーアート画像
            .form-section-title.mt-4 カバー・ジャケットアート
            v-card.pa-3.mb-3(variant="outlined" rounded="lg")
              .d-flex.align-center.gap-3
                .preview-box.square
                  img(v-if="musicData.cover" :src="musicData.cover" alt="cover")
                  v-icon(v-else size="32" color="grey") mdi-album
                .flex-grow-1
                  v-file-input(
                    accept="image/*"
                    label="ジャケット画像を選択"
                    variant="outlined"
                    density="compact"
                    prepend-icon=""
                    prepend-inner-icon="mdi-upload"
                    hide-details
                    @change="handleImageUpload($event, 'music_cover')"
                  )
                  v-text-field.mt-2(
                    v-model="musicData.cover"
                    label="または画像URL / SVG"
                    variant="outlined"
                    density="compact"
                    hide-details
                  )

            //- 作詞・作曲
            .form-section-title.mt-4 クレジット情報
            v-row(dense)
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="musicData.lyricist"
                  label="作詞者"
                  variant="outlined"
                  density="comfortable"
                )
              v-col(cols="12" md="6")
                v-text-field(
                  v-model="musicData.composer"
                  label="作曲者"
                  variant="outlined"
                  density="comfortable"
                )

            //- 楽曲紹介文
            .form-section-title.mt-4 楽曲解説
            v-textarea(
              v-model="musicData.description"
              placeholder="楽曲の背景や聴きどころ、コンセプトを記載してください。"
              variant="outlined"
              rows="3"
              auto-grow
            )

            //- 歌詞
            .form-section-title.mt-4 歌詞 (タイムタグまたはテキスト)
            v-textarea(
              v-model="musicData.lyrics"
              placeholder="[00:00.00] 曲名\n[00:10.00] 最初のフレーズ...\n\nまたはプレーンテキストで歌詞を記載"
              variant="outlined"
              rows="4"
              auto-grow
            )

            v-row(dense)
              v-col(cols="12" md="4")
                v-switch(
                  v-model="musicData.featured"
                  color="primary"
                  label="注目・ピックアップ曲に設定"
                  hide-details
                )
              v-col(cols="12" md="4")
                v-switch(
                  v-model="musicData.isTrending"
                  color="secondary"
                  label="トレンド曲に設定"
                  hide-details
                )
              v-col(cols="12" md="4")
                v-switch(
                  v-model="musicData.isUnfinished"
                  color="warning"
                  label="「未完成」タグを付ける (制作中・デモ音源等)"
                  hide-details
                )

            .d-flex.justify-end.mt-6.gap-3
              v-btn(variant="text" @click="closeModal") キャンセル
              v-btn(
                color="primary"
                type="submit"
                :loading="submittingMusic"
                size="large"
                rounded="pill"
                :prepend-icon="isEditMode ? 'mdi-content-save' : 'mdi-check'"
              ) {{ isEditMode ? '楽曲情報を更新' : '音楽を登録' }}

    //- 成功・エラー用スナックバー
    v-snackbar(v-model="snackbar.show" :color="snackbar.color" :timeout="4000")
      | {{ snackbar.message }}
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { useAppStore, type AppInfo } from '@/stores/app'
import { useMusicStore, type MusicItem } from '@/stores/music'
import { useMyProfileStore } from '@/stores/myProfile'
import { saveAppToDB, saveMusicToDB, uploadAudioToPHP } from '@/js/contentApi'

export default defineComponent({
  name: 'AdminRegisterModal',
  props: {
    modelValue: {
      type: Boolean,
      default: false,
    },
    initialTab: {
      type: String,
      default: 'app', // 'app' | 'music'
    },
    editItem: {
      type: Object as () => any | null,
      default: null,
    },
  },
  emits: ['update:modelValue', 'registered', 'updated'],
  data() {
    return {
      isOpen: this.modelValue,
      currentTab: this.initialTab,
      appStore: useAppStore(),
      musicStore: useMusicStore(),
      myProfile: useMyProfileStore(),

      // アプリフォームデータ
      appData: {
        type: 'app' as 'app' | 'game',
        name: '',
        id: '',
        category: 'ツール',
        price: 0,
        summary: '',
        icon: '',
        thumbnail: '',
        platforms: ['Windows', 'Android', 'Web'] as string[],
        languages: ['日本語'] as string[],
        description: '',
        githubUrl: '',
        featured: false,
        isUnfinished: false,
      },
      appLinks: {
        googlePlay: '',
        appStore: '',
        webUrl: '',
      },
      availablePlatforms: [
        'Windows',
        'Android',
        'iOS',
        'Web',
        'Mac OS',
        'Linux',
        'その他',
      ],
      availableLanguages: ['日本語', 'English', '中文', '한국어', 'Magyar'],
      suggestedAppCategories: [
        'ツール',
        'ユーティリティ',
        'RPG',
        'アクション',
        'パズル',
        'シミュレーション',
        '音楽',
        '生産性',
        'エンタメ',
        'ソーシャル',
      ],

      // 音楽フォームデータ
      musicData: {
        title: '',
        id: '',
        artist: '',
        album: '',
        albumType: 'single' as 'single' | 'album' | 'ep',
        genre: '歌モノ',
        bpm: 120,
        price: 0,
        audioUrl: '',
        cover: '',
        duration: 180,
        durationFormatted: '3:00',
        lyricist: '',
        composer: '',
        description: '',
        lyrics: '',
        featured: false,
        isTrending: false,
        isUnfinished: false,
      },
      uploadedAudioName: '',
      uploadingAudio: false,

      // 試聴用プレイヤー
      previewAudioObj: null as HTMLAudioElement | null,
      previewPlaying: false,
      previewCurrentTime: 0,
      previewDuration: 0,

      // 処理フラグ
      submittingApp: false,
      submittingMusic: false,
      snackbar: {
        show: false,
        message: '',
        color: 'success',
      },
    }
  },
  watch: {
    modelValue(val) {
      this.isOpen = val
      if (val) {
        if (this.editItem) {
          this.loadEditItem(this.editItem)
        } else {
          this.currentTab = this.initialTab
          this.initDefaultValues()
        }
      } else {
        this.stopPreviewAudio()
      }
    },
    isOpen(val) {
      this.$emit('update:modelValue', val)
      if (!val) {
        this.stopPreviewAudio()
      }
    },
    initialTab(tab) {
      if (!this.isEditMode) {
        this.currentTab = tab
      }
    },
    editItem: {
      immediate: true,
      handler(val) {
        if (val) {
          this.loadEditItem(val)
        }
      },
    },
  },
  computed: {
    isMobile(): boolean {
      return Boolean(this.$vuetify?.display?.xs)
    },
    isEditMode(): boolean {
      return Boolean(this.editItem)
    },
  },
  mounted() {
    if (this.editItem) {
      this.loadEditItem(this.editItem)
    } else {
      this.initDefaultValues()
    }
  },
  beforeUnmount() {
    this.stopPreviewAudio()
  },
  methods: {
    loadEditItem(item: any) {
      if (!item) return
      const isMusic =
        item.type === 'music' ||
        'audioUrl' in item ||
        'composer' in item ||
        'lyricist' in item ||
        'album' in item

      if (isMusic) {
        this.currentTab = 'music'
        this.musicData.title = item.title || item.name || ''
        this.musicData.id = item.id || ''
        this.musicData.artist = item.artist || ''
        this.musicData.album = item.album || item.title || ''
        this.musicData.albumType = item.albumType || 'single'
        this.musicData.genre = item.genre || 'J-Pop'
        this.musicData.bpm = item.bpm ?? 120
        this.musicData.price = item.price ?? 0
        this.musicData.audioUrl = item.audioUrl || ''
        this.musicData.cover = item.cover || item.thumbnail || item.icon || ''
        this.musicData.duration = item.duration ?? 180
        this.musicData.durationFormatted = item.durationFormatted || '3:00'
        this.musicData.lyricist = item.lyricist || ''
        this.musicData.composer = item.composer || ''
        this.musicData.description = item.description || ''
        this.musicData.lyrics = item.lyrics || ''
        this.musicData.featured = Boolean(item.featured)
        this.musicData.isTrending = Boolean(item.isTrending)
        this.musicData.isUnfinished = Boolean(item.isUnfinished || (Array.isArray(item.tags) && item.tags.includes('未完成')))

        if (this.musicData.audioUrl) {
          this.initPreviewAudio(this.musicData.audioUrl)
        }
      } else {
        this.currentTab = 'app'
        this.appData.type = item.type === 'game' ? 'game' : 'app'
        this.appData.name = item.name || ''
        this.appData.id = item.id || ''
        this.appData.category = item.category || 'ツール'
        this.appData.price = item.price ?? 0
        this.appData.summary = item.summary || ''
        this.appData.icon = item.icon || ''
        this.appData.thumbnail =
          item.thumbnail || (item.images && item.images[0]) || ''
        this.appData.platforms =
          Array.isArray(item.platforms) && item.platforms.length > 0
            ? [...item.platforms]
            : ['Windows']
        this.appData.languages =
          Array.isArray(item.languages) && item.languages.length > 0
            ? [...item.languages]
            : ['日本語']
        this.appData.description = item.description || ''
        this.appData.githubUrl = item.githubUrl || ''
        this.appData.featured = Boolean(item.featured)
        this.appData.isUnfinished = Boolean(item.isUnfinished || (Array.isArray(item.tags) && item.tags.includes('未完成')))

        this.appLinks.googlePlay = ''
        this.appLinks.appStore = ''
        this.appLinks.webUrl = ''
        if (Array.isArray(item.links)) {
          for (const l of item.links) {
            const text = (l.text || '').toLowerCase()
            const url = l.url || ''
            if (text.includes('google') || text.includes('play'))
              this.appLinks.googlePlay = url
            else if (text.includes('apple') || text.includes('app store'))
              this.appLinks.appStore = url
            else if (text.includes('web')) this.appLinks.webUrl = url
          }
        }
      }
    },
    initDefaultValues() {
      // ログイン中の管理者名をアーティスト・作詞・作曲のデフォルトに反映
      const adminName = 'ときえのき' // ここは必要に応じて動的に取得することも可能
      if (!this.musicData.artist) this.musicData.artist = adminName
      if (!this.musicData.composer) this.musicData.composer = adminName
      if (!this.musicData.lyricist) this.musicData.lyricist = adminName
    },
    closeModal() {
      this.stopPreviewAudio()
      this.isOpen = false
    },
    showToast(
      message: string,
      color: 'success' | 'error' | 'info' = 'success',
    ) {
      this.snackbar.message = message
      this.snackbar.color = color
      this.snackbar.show = true
    },
    autoGenerateAppId() {
      if (this.isEditMode) return
      if (!this.appData.id || this.appData.id.startsWith('app-')) {
        const slug = this.appData.name
          .toLowerCase()
          .trim()
          .replace(/[\s\t\n]+/g, '-')
          .replace(/[^\w\u3040-\u30ff\u4e00-\u9faf\-]/g, '')
        if (slug) {
          this.appData.id = slug.substring(0, 30)
        }
      }
    },
    autoGenerateMusicId() {
      if (this.isEditMode) return
      if (!this.musicData.id || this.musicData.id.startsWith('music-')) {
        const slug = this.musicData.title
          .toLowerCase()
          .trim()
          .replace(/[\s\t\n]+/g, '-')
          .replace(/[^\w\u3040-\u30ff\u4e00-\u9faf\-]/g, '')
        if (slug) {
          this.musicData.id = slug.substring(0, 30)
        } else {
          this.musicData.id = `music-${Date.now().toString(36)}`
        }
      }
    },
    togglePlatform(p: string) {
      const idx = this.appData.platforms.indexOf(p)
      if (idx === -1) {
        this.appData.platforms.push(p)
      } else {
        if (this.appData.platforms.length > 1) {
          this.appData.platforms.splice(idx, 1)
        }
      }
    },
    toggleLanguage(lang: string) {
      const idx = this.appData.languages.indexOf(lang)
      if (idx === -1) {
        this.appData.languages.push(lang)
      } else {
        if (this.appData.languages.length > 1) {
          this.appData.languages.splice(idx, 1)
        }
      }
    },

    // ==================== 音声ファイルアップロード ====================
    async handleAudioFileSelect(event: Event) {
      const target = event.target as HTMLInputElement
      const file = target.files?.[0]
      if (!file) return

      this.uploadedAudioName = file.name
      this.uploadingAudio = true

      // 1. クライアント側で即座にdurationを解析
      try {
        const objectUrl = URL.createObjectURL(file)
        const tempAudio = new Audio(objectUrl)
        tempAudio.onloadedmetadata = () => {
          if (tempAudio.duration && !isNaN(tempAudio.duration)) {
            const sec = Math.floor(tempAudio.duration)
            this.musicData.duration = sec
            const m = Math.floor(sec / 60)
            const s = sec % 60
            this.musicData.durationFormatted = `${m}:${s < 10 ? '0' : ''}${s}`
            this.previewDuration = sec
          }
          URL.revokeObjectURL(objectUrl)
        }
      } catch (e) {
        console.warn('Audio metadata inspection failed:', e)
      }

      // 2. サーバー側へアップロード
      const formData = new FormData()
      formData.append('audio', file)

      try {
        let uploadSuccess = false
        let resultUrl = ''

        // (A) Nitro API へのアップロード試行
        try {
          const res = await fetch('/api/upload-audio', {
            method: 'POST',
            body: formData,
          })
          if (res.ok) {
            const data = await res.json()
            if (data.status === 'ok' && data.url) {
              resultUrl = data.url
              uploadSuccess = true
            }
          }
        } catch (nitroErr) {
          console.warn('Nitro upload failed, trying PHP fallback:', nitroErr)
        }

        // (B) Nitro がダメな場合の PHP フォールバック試行
        if (!uploadSuccess) {
          try {
            const data = await uploadAudioToPHP(formData)
            if (data.url) {
              resultUrl = data.url
              uploadSuccess = true
            }
          } catch (phpErr) {
            console.warn('PHP upload failed:', phpErr)
          }
        }

        if (uploadSuccess && resultUrl) {
          this.musicData.audioUrl = resultUrl
          this.showToast(
            '音声ファイルをサーバーにアップロードしました！',
            'success',
          )
          this.initPreviewAudio(resultUrl)
        } else {
          // フォールバック: Blob / Object URL でローカル保持
          const localUrl = URL.createObjectURL(file)
          this.musicData.audioUrl = localUrl
          this.initPreviewAudio(localUrl)
          this.showToast('ローカル音声として設定しました。', 'info')
        }
      } catch (err: any) {
        console.error('Upload failed:', err)
        this.showToast(
          'アップロード中にエラーが発生しました: ' + err.message,
          'error',
        )
      } finally {
        this.uploadingAudio = false
      }
    },

    clearAudioFile() {
      this.stopPreviewAudio()
      this.musicData.audioUrl = ''
      this.uploadedAudioName = ''
    },

    // 試聴用プレイヤー操作
    initPreviewAudio(url: string) {
      this.stopPreviewAudio()
      this.previewAudioObj = new Audio(url)
      this.previewAudioObj.ontimeupdate = () => {
        if (this.previewAudioObj) {
          this.previewCurrentTime = Math.floor(this.previewAudioObj.currentTime)
        }
      }
      this.previewAudioObj.onloadedmetadata = () => {
        if (this.previewAudioObj?.duration) {
          this.previewDuration = Math.floor(this.previewAudioObj.duration)
        }
      }
      this.previewAudioObj.onended = () => {
        this.previewPlaying = false
        this.previewCurrentTime = 0
      }
    },
    togglePreviewAudio() {
      if (!this.previewAudioObj && this.musicData.audioUrl) {
        this.initPreviewAudio(this.musicData.audioUrl)
      }
      if (!this.previewAudioObj) return

      if (this.previewPlaying) {
        this.previewAudioObj.pause()
        this.previewPlaying = false
      } else {
        this.previewAudioObj.play().catch((e) => console.warn(e))
        this.previewPlaying = true
      }
    },
    seekPreviewAudio(val: number) {
      if (this.previewAudioObj) {
        this.previewAudioObj.currentTime = val
      }
    },
    stopPreviewAudio() {
      if (this.previewAudioObj) {
        this.previewAudioObj.pause()
        this.previewAudioObj.currentTime = 0
        this.previewAudioObj = null
      }
      this.previewPlaying = false
      this.previewCurrentTime = 0
    },
    formatTime(sec: number): string {
      const m = Math.floor((sec || 0) / 60)
      const s = Math.floor((sec || 0) % 60)
      return `${m}:${s < 10 ? '0' : ''}${s}`
    },

    // ==================== 画像アップロード ====================
    async handleImageUpload(
      event: Event,
      targetField: 'app_icon' | 'app_thumbnail' | 'music_cover',
    ) {
      const target = event.target as HTMLInputElement
      const file = target.files?.[0]
      if (!file) return

      // まずBase64で即時プレビュー
      const reader = new FileReader()
      reader.onload = (e) => {
        const base64 = e.target?.result as string
        if (targetField === 'app_icon') this.appData.icon = base64
        else if (targetField === 'app_thumbnail')
          this.appData.thumbnail = base64
        else if (targetField === 'music_cover') this.musicData.cover = base64
      }
      reader.readAsDataURL(file)

      // サーバーへもアップロード
      const formData = new FormData()
      formData.append('image', file)
      try {
        const res = await fetch('/api/upload-image', {
          method: 'POST',
          body: formData,
        })
        if (res.ok) {
          const data = await res.json()
          if (data.status === 'ok' && data.url) {
            if (targetField === 'app_icon') this.appData.icon = data.url
            else if (targetField === 'app_thumbnail')
              this.appData.thumbnail = data.url
            else if (targetField === 'music_cover')
              this.musicData.cover = data.url
          }
        }
      } catch (err) {
        console.warn('Image upload to server error:', err)
      }
    },

    // ==================== アプリ登録送信 ====================
    async submitApp() {
      if (!this.appData.name || !this.appData.id) {
        this.showToast('アプリ名とアプリIDを入力してください', 'error')
        return
      }

      this.submittingApp = true

      // リンク組み立て
      const links = []
      if (this.appLinks.googlePlay) {
        links.push({
          text: 'Google Play',
          icon: 'mdi-google-play',
          url: this.appLinks.googlePlay,
        })
      }
      if (this.appLinks.appStore) {
        links.push({
          text: 'App Store',
          icon: 'mdi-apple',
          url: this.appLinks.appStore,
        })
      }
      if (this.appLinks.webUrl) {
        links.push({
          text: 'Web版で開く',
          icon: 'mdi-web',
          url: this.appLinks.webUrl,
        })
      }

      // デフォルト画像の用意
      const fallbackIcon =
        this.appData.icon ||
        `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256"><rect width="256" height="256" rx="56" fill="%236366F1"/><text x="128" y="145" font-size="80" text-anchor="middle" fill="white" font-weight="bold">${this.appData.name.charAt(
          0,
        )}</text></svg>`

      const fallbackThumbnail =
        this.appData.thumbnail ||
        `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="640" height="360" viewBox="0 0 640 360"><rect width="640" height="360" fill="%234338CA"/><text x="320" y="190" font-size="32" text-anchor="middle" fill="white" font-weight="bold">${encodeURIComponent(
          this.appData.name,
        )}</text></svg>`

      const isEdit = this.isEditMode
      const existing = isEdit ? this.editItem : null

      const newApp: AppInfo = {
        name: this.appData.name,
        id: this.appData.id,
        releaseDate: existing?.releaseDate || Date.now(),
        icon: fallbackIcon,
        thumbnail: fallbackThumbnail,
        description: this.appData.description || `${this.appData.name} の紹介`,
        price: Number(this.appData.price) || 0,
        platforms: [...this.appData.platforms],
        languages: [...this.appData.languages],
        links,
        githubUrl: this.appData.githubUrl || undefined,
        images:
          existing?.images && existing.images.length > 0
            ? existing.images
            : [fallbackThumbnail],
        type: this.appData.type,
        category: this.appData.category,
        rating: existing?.rating ?? 5.0,
        downloads: existing?.downloads || 'NEW',
        developer: existing?.developer || this.myProfile.name || 'エノキ電気',
        summary: this.appData.summary || `${this.appData.name} を体験しよう`,
        featured: this.appData.featured,
        isUnfinished: this.appData.isUnfinished,
        tags: this.appData.isUnfinished ? ['未完成'] : [],
      }

      try {
        // 1. PHP 経由で MySQL (app_list) へ登録・更新（失敗時は throw）
        await saveAppToDB(newApp)

        // 2. 保存に成功したらフロントエンドストアへ反映
        this.appStore.registerApp(newApp)

        if (isEdit) {
          this.showToast(
            `アプリ「${newApp.name}」の情報を更新しました！`,
            'success',
          )
          this.$emit('updated', { type: 'app', item: newApp })
        } else {
          this.showToast(`アプリ「${newApp.name}」を登録しました！`, 'success')
          this.$emit('registered', { type: 'app', item: newApp })
        }

        setTimeout(() => {
          this.closeModal()
          if (!isEdit) {
            this.$router.push(`/apps/${newApp.id}`)
          }
        }, 800)
      } catch (err: any) {
        console.error('App registration error:', err)
        this.showToast(
          `${isEdit ? 'アプリ更新' : 'アプリ登録'}に失敗しました: ${err?.message || err}`,
          'error',
        )
      } finally {
        this.submittingApp = false
      }
    },

    // ==================== 音楽登録送信 ====================
    async submitMusic() {
      if (!this.musicData.title || !this.musicData.id) {
        this.showToast('楽曲タイトルと楽曲IDを入力してください', 'error')
        return
      }

      this.submittingMusic = true

      const fallbackCover =
        this.musicData.cover ||
        `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300" viewBox="0 0 300 300"><rect width="300" height="300" rx="20" fill="%234F46E5"/><circle cx="150" cy="150" r="90" fill="%23111" stroke="%2338BDF8" stroke-width="3"/><circle cx="150" cy="150" r="28" fill="%234F46E5"/><circle cx="150" cy="150" r="8" fill="%23111"/><text x="150" y="270" text-anchor="middle" font-size="16" fill="white" font-weight="bold">${encodeURIComponent(
          this.musicData.title,
        )}</text></svg>`

      const now = new Date()
      const dateFormatted = `${now.getFullYear()}/${(now.getMonth() + 1)
        .toString()
        .padStart(2, '0')}/${now.getDate().toString().padStart(2, '0')}`

      const isEdit = this.isEditMode
      const existing = isEdit ? this.editItem : null

      const newTrack: MusicItem = {
        id: this.musicData.id,
        name: this.musicData.title,
        title: this.musicData.title,
        artist: this.musicData.artist || this.myProfile.name || 'エノキ電気',
        album: this.musicData.album || this.musicData.title,
        albumType: this.musicData.albumType,
        genre: this.musicData.genre,
        cover: fallbackCover,
        icon: fallbackCover,
        thumbnail: fallbackCover,
        duration: Number(this.musicData.duration) || 180,
        durationFormatted: this.musicData.durationFormatted || '3:00',
        releaseDate: existing?.releaseDate || Date.now(),
        releaseDateFormatted: existing?.releaseDateFormatted || dateFormatted,
        plays: existing?.plays || 'NEW',
        rating: existing?.rating ?? 5.0,
        featured: this.musicData.featured,
        isTrending: this.musicData.isTrending,
        isUnfinished: this.musicData.isUnfinished,
        tags: this.musicData.isUnfinished ? ['未完成'] : [],
        themeColor: existing?.themeColor || '#4F46E5',
        accentColor: existing?.accentColor || '#38BDF8',
        audioPreset: existing?.audioPreset || 'citypop',
        bpm: Number(this.musicData.bpm) || 120,
        description:
          this.musicData.description ||
          `${this.musicData.title} - ${this.musicData.artist}`,
        lyrics: this.musicData.lyrics || '',
        composer: this.musicData.composer || this.musicData.artist,
        lyricist: this.musicData.lyricist || this.musicData.artist,
        price: Number(this.musicData.price) || 0,
        type: 'music',
        // blob: のローカルURLは他の端末で再生できないためDBには保存しない
        audioUrl:
          this.musicData.audioUrl && !this.musicData.audioUrl.startsWith('blob:')
            ? this.musicData.audioUrl
            : existing?.audioUrl || undefined,
      }

      try {
        // 1. PHP 経由で MySQL (music_list) へ登録・更新（音声ファイルURL含む、失敗時は throw）
        await saveMusicToDB(newTrack)

        // 2. 保存に成功したらフロントエンドストアへ反映
        this.musicStore.updateTrack(newTrack)

        if (isEdit) {
          this.showToast(
            `楽曲「${newTrack.title}」の情報を更新しました！`,
            'success',
          )
          this.$emit('updated', { type: 'music', item: newTrack })
        } else {
          this.showToast(`楽曲「${newTrack.title}」を登録しました！`, 'success')
          this.$emit('registered', { type: 'music', item: newTrack })
        }

        setTimeout(() => {
          this.closeModal()
          if (!isEdit) {
            this.$router.push(`/music/${newTrack.id}`)
          }
        }, 800)
      } catch (err: any) {
        console.error('Music registration error:', err)
        this.showToast(
          `${isEdit ? '音楽更新' : '音楽登録'}に失敗しました: ${err?.message || err}`,
          'error',
        )
      } finally {
        this.submittingMusic = false
      }
    },
  },
})
</script>

<style lang="scss" scoped>
.register-modal-card {
  background-color: rgb(var(--v-theme-surface));
  border-radius: 16px;
  overflow: hidden;

  &.is-mobile {
    border-radius: 0;
    height: 100vh;
    height: 100dvh;
  }
}

.modal-header {
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}

.register-tabs {
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}

.form-section-title {
  font-size: 0.95rem;
  font-weight: 700;
  color: rgb(var(--v-theme-primary));
  margin-bottom: 8px;
  padding-bottom: 4px;
  border-bottom: 1px solid rgba(var(--v-theme-primary), 0.2);
}

.preview-box {
  background-color: rgba(var(--v-theme-on-surface), 0.04);
  border: 1px dashed rgba(var(--v-theme-on-surface), 0.2);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  &.square {
    width: 64px;
    height: 64px;
    flex-shrink: 0;
  }

  &.landscape {
    width: 100px;
    height: 56px;
    flex-shrink: 0;
  }
}

.audio-upload-card {
  border-color: rgba(var(--v-theme-primary), 0.3);
  background: linear-gradient(
    135deg,
    rgba(var(--v-theme-primary), 0.03),
    rgba(var(--v-theme-surface), 1)
  );
  transition: all 0.2s ease;

  &.has-file {
    border-color: rgba(var(--v-theme-success), 0.6);
    background: linear-gradient(
      135deg,
      rgba(var(--v-theme-success), 0.04),
      rgba(var(--v-theme-surface), 1)
    );
  }

  .audio-icon-box {
    width: 56px;
    height: 56px;
    border-radius: 12px;
    background-color: rgba(var(--v-theme-primary), 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.mini-preview-player {
  background-color: rgba(var(--v-theme-surface-variant), 0.35);
  border: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}

.gap-2 {
  gap: 8px;
}
.gap-3 {
  gap: 12px;
}
.app-type-toggle {
  :deep(.v-btn) {
    &.app-type-btn--selected,
    &.v-btn--active {
      background-color: var(--accent-color) !important;
      color: var(--accent-text-color, #ffffff) !important;

      .v-icon {
        color: var(--accent-text-color, #ffffff) !important;
      }
    }
  }
}
</style>
