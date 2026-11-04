<template lang="pug">
v-card.admin-register-page(
  style="width: 100%; height: 100%;"
  :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
)
  //- トップバー
  v-card-actions.page-header
    v-btn(
      icon="mdi-arrow-left"
      variant="text"
      @click="handleBack"
    )
    p.header-title.ml-2.font-weight-bold アプリ・音楽の新規登録
    v-spacer
    v-chip(color="primary" size="small" variant="flat")
      v-icon.mr-1(size="14") mdi-shield-check
      | 管理者モード

  //- メインコンテンツ
  v-card-text.page-content.pa-0
    AdminRegisterModal(
      v-model="modalOpen"
      :initialTab="initialTab"
      @registered="onRegistered"
    )

  //- ボトムナビ
  BottomNav
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import AdminRegisterModal from '@/components/admin/AdminRegisterModal.vue'
import BottomNav from '@/components/common/BottomNav.vue'
import { useMyProfileStore } from '@/stores/myProfile'
import { useSettingsStore } from '@/stores/settings'
import Setup from '@/js/setup'
import mixins from '@/mixins/mixins'

export default defineComponent({
  name: 'AdminRegisterPage',
  components: {
    AdminRegisterModal,
    BottomNav,
  },
  mixins: [mixins],
  data() {
    return {
      modalOpen: true,
      initialTab: 'app',
      myProfile: useMyProfileStore(),
      settings: useSettingsStore(),
    }
  },
  setup() {
    Setup.setTitle('コンテンツ登録 - 管理者')
    Setup.setDescription('エノキ電気 管理者専用アプリ・音楽登録フォーム')
  },
  mounted() {
    this.setTitle('コンテンツ登録')

    // 管理者ログイン判定
    const isAdmin =
      this.myProfile.isAdmin ||
      this.myProfile.role === 'admin' ||
      (!this.myProfile.guest && this.myProfile.canRegisterApp)

    if (!isAdmin) {
      // 未ログインの場合はログインページへリダイレクト
      this.$router.replace('/login?redirect=/admin/register')
      return
    }

    // URLクエリで初期タブ指定可能 (?tab=music または ?tab=app)
    const tabParam = this.$route.query.tab as string
    if (tabParam === 'music' || tabParam === 'app') {
      this.initialTab = tabParam
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
    onRegistered(payload: { type: string; item: any }) {
      if (payload.type === 'app') {
        this.$router.push(`/apps/${payload.item.id}`)
      } else {
        this.$router.push(`/music/${payload.item.id}`)
      }
    },
  },
})
</script>

<style lang="scss" scoped>
.admin-register-page {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  overflow: hidden;
  position: relative;
  background-color: rgb(var(--v-theme-surface));

  .page-header {
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
  }

  .header-title {
    font-size: 1.15rem;
    margin: 0;
  }

  .page-content {
    flex: 1;
    overflow-y: auto;
  }
}
</style>
