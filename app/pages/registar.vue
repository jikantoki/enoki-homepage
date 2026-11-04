<template lang="pug">
.login(v-if="isShow")
  v-card-actions
    p.ml-2(style="font-size: 1.3em") 管理者アカウント作成
    v-spacer
    v-btn(
      text
      @click="$router.push('/')"
      icon="mdi-close"
      )
  v-form.center(@submit.prevent)
    img.ma-8(src="/icon.png")
    p.form-p.text-h6 管理者アカウント新規登録
    p.form-sub.text-caption.text-center.mb-4.opacity-70 管理者専用画面です。登録には管理者登録キーが必要です。
    v-container
      .success.pa-4.ma-4.relative(v-if="page === 1")
        v-icon mdi-check
        p.px-4 管理者アカウントの登録が完了しました！
      .error.pa-4.mb-4.relative(v-if="errorMessage && page === 0")
        v-icon mdi-alert-circle-outline
        p.px-4 {{ errorMessage }}
        v-icon.v-ripple.absolute.close-error(
          v-ripple
          @click="errorMessage=''"
          ) mdi-close-circle-outline
      v-text-field(
        v-if="page === 0"
        v-model="userName"
        name="id"
        label="管理者ID"
        counter="32"
        prepend-inner-icon="mdi-account-outline"
        type="text"
        :rules="[rules.required]"
        hint="3～32文字、半角英数字アンダーバーのみ"
        ref="formId"
        autocomplete="username"
        @keydown.enter="$refs.formMail.focus()"
        clearable
        )
      v-text-field(
        v-if="page === 0"
        v-model="mailAddress"
        name="mail"
        label="管理者メールアドレス"
        prepend-inner-icon="mdi-email-outline"
        type="email"
        :rules="[rules.required]"
        ref="formMail"
        autocomplete="email"
        @keydown.enter="$refs.formAdminKey.focus()"
        clearable
        )
      v-text-field(
        v-if="page === 0"
        v-model="adminKey"
        name="adminKey"
        label="管理者登録キー（Admin Secret Key）"
        prepend-inner-icon="mdi-shield-key-outline"
        :type="showAdminKey ? 'text' : 'password'"
        :append-inner-icon="showAdminKey ? 'mdi-eye' : 'mdi-eye-off'"
        @click:append-inner="showAdminKey = !showAdminKey"
        ref="formAdminKey"
        hint="サーバー環境で設定された秘密キーを入力してください"
        persistent-hint
        autocomplete="off"
        @keydown.enter="$refs.formPass.focus()"
        :rules="[rules.required]"
        )
      v-text-field(
        v-if="page === 0"
        v-model="password"
        name="password"
        label="パスワード"
        prepend-inner-icon="mdi-lock-outline"
        :type="showPassword ? 'text' : 'password'"
        :append-inner-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        @click:append-inner="showPassword = !showPassword"
        ref="formPass"
        autocomplete="new-password"
        @keydown.enter="$refs.formRePass.focus()"
        :rules="[rules.required]"
        )
      v-text-field(
        v-if="page === 0"
        v-model="confirmPassword"
        name="confirmPassword"
        label="パスワード（確認用）"
        prepend-inner-icon="mdi-lock-outline"
        :type="showConfirmPassword ? 'text' : 'password'"
        :append-inner-icon="showConfirmPassword ? 'mdi-eye' : 'mdi-eye-off'"
        @click:append-inner="showConfirmPassword = !showConfirmPassword"
        ref="formRePass"
        autocomplete="new-password"
        @keydown.enter="agreement = true;$refs.formRegistar.$el.focus();"
        :rules="[rules.required]"
        )
      v-checkbox(
        v-if="page === 0"
        v-model="agreement"
        label="利用規約に同意します"
        ref="formAgree"
        )
      .btns
        v-btn.round.submit(
          v-if="page === 0"
          @click="registar"
          :disabled="!userName || !mailAddress || !adminKey || !password || !confirmPassword"
          :loading="loading"
          ref="formRegistar"
          ) 管理者登録
        v-btn.round(
          v-if="page === 0"
          @click="a('/login')"
          ) 既に管理者アカウントを持っています
        v-btn.round.submit(
          v-if="page === 1"
          @click="a('/login')"
          ) 管理者ログインへ
</template>

<script lang="ts">
import mixins from '@/mixins/mixins'
import Setup from '@/js/setup'
export default {
  mixins: [mixins],
  data() {
    return {
      /** 将来的にdivの一つとしてフォームを埋め込む用 */
      isShow: true,
      userName: '',
      mailAddress: '',
      adminKey: '',
      password: '',
      confirmPassword: '',
      showAdminKey: false,
      showPassword: false,
      showConfirmPassword: false,
      agreement: false,
      errorMessage: '',
      loading: false,
      page: 0,
      rules: {
        required: (value: string) => !!value || '必須項目です',
      },
    }
  },
  watch: {
    password() {
      this.errorMessage = ''
    },
    confirmPassword() {
      this.errorMessage = ''
    },
    adminKey() {
      this.errorMessage = ''
    },
    userName() {
      this.errorMessage = ''
    },
    mailAddress() {
      this.errorMessage = ''
    },
    agreement() {
      this.errorMessage = ''
    },
  },
  setup() {
    //サーバーサイドで仮のタイトルを設定、mountedで言語ごとに再設定する
    Setup.setTitle('管理者アカウント作成')
    Setup.setDescription('エノキ電気 管理者用アカウント登録ページです')
  },
  mounted() {
    this.setTitle('管理者アカウント作成')
    if (localStorage.userIdForLogin) {
      this.userName = localStorage.userIdForLogin
    }
  },
  unmounted() {
    localStorage.userIdForLogin = this.userName ?? ''
  },
  methods: {
    registar() {
      if (
        !this.userName ||
        !this.mailAddress ||
        !this.adminKey ||
        !this.password ||
        !this.confirmPassword
      ) {
        this.errorMessage = '入力されていない項目があります'
        return false
      }
      if (
        this.userName.length < 3 ||
        this.userName.length > 32 ||
        !/^[0-9a-zA-z_]+$/.test(this.userName)
      ) {
        this.errorMessage = 'IDは半角英数字アンダーバー3～32文字で入力してください'
        return false
      }
      if (!/.+@.+\..+/.test(this.mailAddress)) {
        this.errorMessage = 'メールアドレスの形式が正しくありません'
        return false
      }
      if (this.password.length < 4 || this.password.length > 64) {
        this.errorMessage = 'パスワードは4～64文字で入力してください'
        return false
      }
      if (this.password !== this.confirmPassword) {
        this.errorMessage = '確認用パスワードが一致しません'
        return false
      }
      if (!this.agreement) {
        this.errorMessage = '利用規約に同意してください'
        return false
      }
      this.loading = true
      // @ts-ignore
      this.sendAjaxWithAuth('/createAccount.php', {
        username: this.userName,
        password: this.password,
        mailaddress: this.mailAddress,
        adminkey: this.adminKey,
      })
        .then((e: any) => {
          this.loading = false
          if (e.body.status === 'ok') {
            this.page = 1
            this.errorMessage = ''
          } else if (e.body.reason) {
            this.errorMessage = e.body.reason
          } else {
            this.errorMessage = 'アカウントの作成に失敗しました'
          }
        })
        .catch((error: any) => {
          this.loading = false
          console.error(error)
          this.errorMessage = '通信エラーが発生しました。ネットワーク接続を確認してください。'
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
.error {
  background-color: var(--color-error);
  color: white;
  display: flex;
  border-radius: 4px;
}
.success {
  background-color: var(--color-success);
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
</style>
