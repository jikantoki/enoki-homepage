<template lang="pug">
.login(v-if="isShow")
  v-card-actions
    p.ml-2(style="font-size: 1.3em") 管理者パスワード再設定
    v-spacer
    v-btn(
      text
      @click="$router.push('/')"
      icon="mdi-close"
      )
  v-form.center(@submit.prevent)
    img.ma-8(src="/icon.png")
    p.form-p.text-h6 {{ pageTitle }}
    p.form-sub.text-caption.text-center.mb-4.opacity-70(v-if="page === 0") 管理者アカウントのパスワード再設定用コードをメールに送信します
    v-container
      .error.pa-4.mb-4.relative(v-if="errorMessage")
        v-icon mdi-alert-circle-outline
        p.px-4 {{ errorMessage }}
        v-icon.v-ripple.absolute.close-error(
          v-ripple
          @click="errorMessage=''"
          ) mdi-close-circle-outline
      v-text-field(
        v-if="page === 0"
        v-model="userName"
        label="管理者ID"
        prepend-inner-icon="mdi-shield-account-outline"
        required
        clearable
        ref="userName"
        autocomplete="username"
        @keydown.enter="$refs.mailAddress.focus()"
        )
      v-text-field(
        v-if="page === 0"
        v-model="mailAddress"
        label="登録メールアドレス"
        placeholder="mail@example.com"
        :rules="mailRules"
        prepend-inner-icon="mdi-email-outline"
        type="email"
        clearable
        required
        ref="mailAddress"
        autocomplete="email"
        @keydown.enter="requestToken()"
        )
      a.forgot-password(v-if="page === 0" href="/login") パスワードを思い出した（ログインへ戻る）
      v-text-field(
        v-if="page === 1"
        v-model="token"
        label="管理者アクセストークン"
        prepend-inner-icon="mdi-key-outline"
        required
        clearable
        @keydown.enter="$refs.newPassword.focus()"
        )
      v-text-field(
        v-if="page === 1"
        v-model="newPassword"
        label="新しいパスワード"
        prepend-inner-icon="mdi-lock-outline"
        required
        clearable
        ref="newPassword"
        :type="showPassword ? 'text' : 'password'"
        :append-inner-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        @click:append-inner="showPassword = !showPassword"
        @keydown.enter="$refs.newRePassword.focus()"
        autocomplete="new-password"
        )
      v-text-field(
        v-if="page === 1"
        v-model="newRePassword"
        label="新しいパスワード（確認）"
        prepend-inner-icon="mdi-lock-outline"
        required
        clearable
        ref="newRePassword"
        :type="showRePassword ? 'text' : 'password'"
        :append-inner-icon="showRePassword ? 'mdi-eye' : 'mdi-eye-off'"
        @click:append-inner="showRePassword = !showRePassword"
        @keydown.enter="login()"
        autocomplete="new-password"
        )
      .btns.mt-4
        v-btn.round.submit(
          v-if="page === 0"
          @click="requestToken()"
          :disabled="!userName || !mailAddress"
          :loading="loading"
          ref="submit"
          ) 再設定コード送信
        v-btn.round.submit(
          v-if="page === 1"
          @click="login()"
          :disabled="!token || !newPassword || !newRePassword"
          :loading="loadingToken"
          ref="submitToken"
          ) パスワードを変更
        v-btn.round.submit(
          v-if="page === 2"
          @click="a('/login')"
          ref="jumpToLogin"
          ) 管理者ログインへ
</template>

<script lang="ts">
import mixins from '@/mixins/mixins'
import Setup from '@/js/setup'

export default {
  mixins: [mixins],
  data() {
    return {
      /** 将来的にv-dialogとかでフォームを埋め込む用 */
      isShow: true,
      userName: '',
      mailAddress: '',
      token: '',
      loading: false,
      loadingToken: false,
      errorMessage: '',
      newPassword: '',
      newRePassword: '',
      showPassword: false,
      showRePassword: false,
      page: 0,
      pageTitle: '管理者パスワード再設定',
      /** メアド検証用 */
      mailRules: [
        (v: string) => !!v || 'メールアドレスを入力してください',
        (v: string) => /.+@.+\..+/.test(v) || 'メールアドレスの形式が正しくありません',
      ],
    }
  },
  setup() {
    //サーバーサイドで仮のタイトルを設定、mountedで言語ごとに再設定する
    Setup.setTitle('管理者パスワード再設定')
    Setup.setDescription(
      'エノキ電気 管理者パスワード再設定ページ',
    )
  },
  mounted() {
    this.setTitle('管理者パスワード再設定')
    if (localStorage.userIdForLogin) {
      this.userName = localStorage.userIdForLogin
    }
  },
  unmounted() {
    localStorage.userIdForLogin = this.userName ?? ''
  },
  methods: {
    /** ログイン前の二段階認証をリクエスト */
    async requestToken() {
      this.loading = true
      this.errorMessage = ''
      // @ts-ignore
      this.sendAjaxWithAuth('/requestTokenForgotAccount.php', {
        id: this.userName,
        mailAddress: this.mailAddress,
      })
        .then((e: any) => {
          if (e.body.status === 'ok') {
            this.page = 1
            this.errorMessage = ''
            this.pageTitle = 'メールに送信されたコードと新しいパスワードを入力'
          } else if (e.body.reason) {
            this.errorMessage = e.body.reason
          } else {
            this.errorMessage = 'ユーザー名またはメールアドレスが間違っています'
          }
          this.loading = false
        })
        .catch((error: any) => {
          console.error(error)
          this.errorMessage = '通信エラーが発生しました。接続を確認してください。'
          this.loading = false
        })
    },
    async login() {
      this.loadingToken = true
      this.errorMessage = ''
      if (this.newPassword !== this.newRePassword) {
        this.errorMessage = '新しいパスワードが一致しません'
        this.loadingToken = false
        return false
      }
      if (this.newPassword.length < 8 || this.newPassword.length > 64) {
        this.errorMessage = 'パスワードは8～64文字で入力してください'
        this.loadingToken = false
        return false
      }
      // @ts-ignore
      this.sendAjaxWithAuth('/resetPassword.php', {
        id: this.userName,
        mailAddress: this.mailAddress,
        token: this.token,
        newPassword: this.newPassword,
      })
        .then(async (e: any) => {
          if (e.body.status === 'ok') {
            this.pageTitle = 'パスワードを再設定しました！'
            this.page = 2
            this.errorMessage = ''
          } else if (e.body.reason) {
            this.errorMessage = e.body.reason
          } else {
            this.errorMessage =
              'ワンタイムトークンが違うか、無効なパスワードです'
          }
          this.loadingToken = false
        })
        .catch((error: any) => {
          console.error(error)
          this.errorMessage = '通信エラーが発生しました。接続を確認してください。'
          this.loadingToken = false
        })
    },
  },
}
</script>

<style lang="scss" scoped>
.center {
  width: 100%;
}

.login {
  position: relative;
  display: contents;
  .center {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    flex-direction: column;
    max-width: 32em;
    padding: 1em;
  }
}
.btns {
  display: flex;
  flex-direction: row-reverse;
  gap: 0.5em;
  .round {
    border-radius: 9999px;
  }
  .submit {
    background-color: var(--accent-color);
    color: var(--accent-text-color);
  }
}
img {
  height: 8em;
  object-fit: contain;
}
.form-p {
  text-align: center;
}
.form-sub {
  text-align: center;
}
.v-btn:disabled {
  opacity: 0.7;
}
.error {
  background-color: var(--color-error);
  color: white;
  display: flex;
  border-radius: 4px;
}
.v-ripple {
  border-radius: 9999px;
  cursor: pointer;
}
.close-error {
  right: 16px;
}
.forgot-password {
  color: inherit;
  opacity: 0.7;
}
</style>
