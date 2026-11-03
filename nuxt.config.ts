// https://nuxt.com/docs/api/configuration/nuxt-config
import { defineNuxtConfig } from 'nuxt/config'

export default defineNuxtConfig({
  // Nuxt 4 モードの有効化（app/ ディレクトリ構造などの新仕様を適用）
  future: {
    compatibilityVersion: 4,
  },

  modules: [
    '@nuxt/content',
    '@nuxt/eslint',
    '@nuxtjs/i18n',
    '@pinia/nuxt',
    '@pinia-plugin-persistedstate/nuxt',
    'vuetify-nuxt-module',
  ],

  devtools: { enabled: true },

  // 最新の日付に更新
  compatibilityDate: '2026-11-03',

  // i18n の警告解消設定
  i18n: {
    defaultLocale: 'ja',
    strategy: 'prefix_except_default',
    locales: [
      { code: 'ja', name: '日本語' },
      { code: 'en', name: 'English' },
    ],
  },

  // Vuetify の設定
  vuetify: {
    moduleOptions: {
      // useLayout 等の衝突を防ぐためコンポーザブルにプレフィックス (vUseLayout) を付与
      prefixComposables: true,
      ssrClientHints: {
        reloadOnFirstRequest: false,
        prefersColorScheme: true,
        prefersColorSchemeOptions: {
          useBrowserThemeOnly: false,
        },
      },
    },
    vuetifyOptions: {
      theme: {
        defaultTheme: 'light',
        themes: {
          light: {
            dark: false,
          },
          dark: {
            dark: true,
          },
        },
      },
    },
  },

  runtimeConfig: {
    // サーバーサイド専用
    webpushPrivatekey: process.env.NUXT_WEBPUSH_PRIVATEKEY || '',
    public: {
      // クライアント参照可能
      webpushPublickey: process.env.NUXT_WEBPUSH_PUBLICKEY || '',
      apiId: process.env.NUXT_API_ID || 'default',
      apiToken: process.env.NUXT_API_TOKEN || '',
      apiAccesskey: process.env.NUXT_API_ACCESSKEY || '',
      apiHost: process.env.NUXT_API_HOST || '',
    },
  },

  ssr: true,

  app: {
    head: {
      htmlAttrs: {
        lang: 'ja',
        prefix: 'og: http://ogp.me/ns#',
      },
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        {
          property: 'og:image',
          content: 'https://enoki.xyz/img/thumbnail.jpg',
        },
        { name: 'format-detection', content: 'telephone=no' },
        { name: 'mobile-web-app-capable', content: 'yes' },
        { name: 'apple-mobile-web-app-capable', content: 'yes' },
        { name: 'apple-mobile-web-app-status-bar-style', content: 'black' },
        { name: 'apple-mobile-web-app-title', content: 'APP_TITLE' },
        { name: 'theme-color', content: '#000000' },
        { name: 'twitter:card', content: 'summary' },
        { name: 'twitter:creator', content: '@jikantoki' },
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
        { rel: 'manifest', href: '/manifest.json' },
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'stylesheet', href: '/style.css' },
        {
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          crossorigin: 'anonymous',
        },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700;900&display=swap',
        },
      ],
    },
  },

  vite: {
    define: {
      'process.env.DEBUG': false,
    },
  },
})
