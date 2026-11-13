# エノキ電気 公式ホームページ

<p align="center">
  <img src="./public/icon.png" alt="エノキ電気 アイコン" width="128" height="128">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Nuxt-4.3+-00DC82?logo=nuxtdotjs&logoColor=white" alt="Nuxt 4">
  <img src="https://img.shields.io/badge/Vue.js-3.5+-4FC08D?logo=vuedotjs&logoColor=white" alt="Vue 3">
  <img src="https://img.shields.io/badge/TypeScript-5.x-3178C6?logo=typescript&logoColor=white" alt="TypeScript">
  <img src="https://img.shields.io/badge/Vuetify-3.x-1867C0?logo=vuetify&logoColor=white" alt="Vuetify 3">
  <img src="https://img.shields.io/badge/Capacitor-8.x-119EFF?logo=capacitor&logoColor=white" alt="Capacitor 8">
  <img src="https://img.shields.io/badge/Gradle-8.14.5-02303A?logo=gradle&logoColor=white" alt="Gradle 8.14.5">
  <img src="https://img.shields.io/badge/PWA-Enabled-5A0FC8?logo=pwa&logoColor=white" alt="PWA">
  <img src="https://img.shields.io/badge/IndexedDB-Cache-FF6F00?logo=databricks&logoColor=white" alt="IndexedDB">
  <img src="https://img.shields.io/badge/PHP-7.4%20%7C%208.x-777BB4?logo=php&logoColor=white" alt="PHP">
  <img src="https://img.shields.io/badge/MySQL-5.7+-4479A1?logo=mysql&logoColor=white" alt="MySQL">
</p>

---

## 目次

1. [概要](#概要)
2. [主な機能・特徴](#主な機能特徴)
3. [アクセス](#アクセス)
4. [技術スタック](#技術スタック)
5. [ページ・ルーティング一覧](#ページルーティング一覧)
6. [ファイル・ディレクトリ構成](#ファイルディレクトリ構成)
7. [前提条件](#前提条件)
8. [環境構築・セットアップ](#環境構築セットアップ)
   - [1. リポジトリのクローンと依存解決](#1-リポジトリのクローンと依存解決)
   - [2. フロントエンド環境変数の設定 (.env)](#2-フロントエンド環境変数の設定-env)
   - [3. バックエンド設定 (env.php / .user.ini / .htaccess)](#3-バックエンド設定-envphp--userini--htaccess)
   - [4. データベースの用意 (MySQL)](#4-データベースの用意-mysql)
   - [5. 初回管理者 API トークンの発行](#5-初回管理者-api-トークンの発行)
9. [コンテンツ管理機能 (CMS: アプリ・音楽の一覧・編集・削除・ログアウト)](#コンテンツ管理機能-cms-アプリ音楽の一覧編集削除ログアウト)
10. [ダウンロードセンター (Download Center)](#ダウンロードセンター-download-center)
11. [開発・コマンドリファレンス](#開発コマンドリファレンス)
    - [npm / yarn スクリプト](#npm--yarn-スクリプト)
    - [ユーティリティスクリプト (scripts/)](#ユーティリティスクリプト-scripts)
12. [モバイルアプリ開発 (Capacitor 8 & Android)](#モバイルアプリ開発-capacitor-8--android)
    - [1. ネイティブプラットフォーム環境](#1-ネイティブプラットフォーム環境)
    - [2. Web アセットの生成と同期](#2-web-アセットの生成と同期)
    - [3. IDE でのビルド・実行](#3-ide-でのビルド実行)
    - [4. リリース向けパッケージ生成 (APK / AAB / キーストア署名)](#4-リリース向けパッケージ生成-apk--aab--キーストア署名)
    - [5. アプリアイコン・スプラッシュ画面の生成](#5-アプリアイコンスプラッシュ画面の生成)
13. [PWA & オフラインキャッシュ (Progressive Web Apps & IndexedDB)](#pwa--オフラインキャッシュ-progressive-web-apps--indexeddb)
14. [バックエンド API エンドポイント一覧](#バックエンド-api-エンドポイント一覧)
    - [PHP バックエンド (php/)](#php-バックエンド-php)
    - [Nitro サーバーエンドポイント (server/api/)](#nitro-サーバーエンドポイント-serverapi)
15. [主要な設定箇所](#主要な設定箇所)
16. [デプロイガイド](#デプロイガイド)
17. [参考リンク・クレジット](#参考リンククレジット)

---

## 概要

**エノキ電気 公式ホームページ** は、ときえのき（エノキ電気）が運営する公式ポータルサイト＆Webアプリケーションです。  
自作ソフトウェア・Webツールのカタログ配信、オリジナル楽曲のストリーミング試聴、各種デジタル制作物（自作Linux OS、妄想鉄道路線図Excel、OuDia2ダイヤデータ、電光掲示板制御ファイルなど）のダウンロードセンター、ユーザー登録・プロフィール管理・友達申請・QRコードによる友達追加・リアルタイムWebPush通知などの多彩なソーシャル機能を備えています。

**Nuxt 4**（`future: { compatibilityVersion: 4 }`）と **Capacitor 8** を採用したワンソース・マルチプラットフォーム構成となっており、同一のコードベースから **Webブラウザ**、**PWA (Progressive Web Apps)**、および **Android / iOS ネイティブアプリ** をシームレスに展開・運用できます。

---

## 主な機能・特徴

- 📱 **マルチプラットフォーム展開**:
  - Webブラウザ、PWA、Android、iOS（Capacitor 8）に対応
  - `@capacitor/android` (`^8.6.0`)、`capacitor-native-settings` (`^8.0.0`) による端末設定連携
  - `@ionic/pwa-elements` によるネイティブカメラ等のPWA対応UI補完
- 📦 **ダウンロードセンター (`/download`)**:
  - オリジナル楽曲データ（「人生のタイムカプセル」オフボーカル音源＆歌詞ZIP）
  - 自作Linux OS（Toki Linux, Caramel OS などの ISO アーカイブ）
  - 妄想鉄道路線図・ダイヤデータ（Excel / OuDia2 形式）
  - 電子工作・LED電光掲示板制御ファイル、マイコンコンパイラ配布パッケージ
  - 高速ミラーサーバー（`https://山d.com`）連携
- 👥 **ユーザー & ソーシャル機能**:
  - アカウント登録、ログイン、パスワードリセット、プロフィール編集
  - 友達申請・承認・一覧管理
- 📷 **QRコード連携**:
  - `vue-qrcode-reader` によるカメラからのQRコードリアルタイム読み取り（対面での友達登録）
  - `qrcode` による自分専用QRコードの動的生成
- 🔔 **WebPush プッシュ通知**:
  - Service Worker と WebPush API によるバックグラウンド通知の送受信
  - PHP バックエンド（`minishlink/web-push`）による VAPID 署名通知配信基盤
- ⚡ **IndexedDB による高速オフラインキャッシュ**:
  - `app/js/indexedDb.ts` によるアプリ一覧・楽曲一覧のローカル永続化（`enoki_homepage_cache`）
  - 通信状況によらず高速な初期レンダリングを実現
- 🌐 **アセット完全解決 & 外部サーバーホスティング最適化**:
  - `app/utils/assetUrl.ts` および `php/functions/urlHelper.php` による静的アセット完全URL自動解決
  - アセット配信サーバー（`https://api.home.enoki.xyz` 等）とフロントエンド（Vercel 等）が分離された環境でも、`/public/uploads/`、`/public/download/`、`/public/customfiles/` へのアクセスを確実に正規化
- 🎨 **モダンかつ親しみやすい UI**:
  - Vuetify 3 + Pug + SCSS (`sass-embedded`)
  - Google Fonts「Zen Maru Gothic」を採用
  - ダークテーマ / ライトテーマ / システム連動の動的切り替え
  - **スムーズスクロール & 洗練されたヘッダーレイアウト**: 快適なナビゲーション体験
  - **Android 15+ のエッジ・トゥ・エッジ (Edge-to-Edge) 対応**: ステータスバーやノッチ切り欠きに応じたパディング制御
- 🎮 **リッチなカスタム 404 / エラーページ (`app/error.vue`)**:
  - Canvas によるサイバーパーティクルアニメーション & CRTスキャンライン演出
  - Web Audio API によるサイバー効果音（トグル機能付き）
  - 404 ページ内でのサイバーミニゲーム搭載
- 🌐 **多言語対応 (i18n)**:
  - `@nuxtjs/i18n` による日本語（`ja`）・英語（`en`）のローカライズ対応（`prefix_except_default` 戦略）
- 🔍 **SEO & クロール・購読最適化**:
  - `robots.txt` による検索エンジンクローラーの全ページ巡回許可およびサイトマップ指定
  - 動的 XML サイトマップ（`/sitemap.xml`）+ 人間用ブラウザ表示スタイルシート（`sitemap.xsl`）
  - 動的 RSS 2.0 フィード（`/rssfeed.xml`, `/feed.xml`, `/rss.xml`）による最新情報の自動配信
- 📚 **コンテンツ管理 (CMS) & 管理者機能**:
  - 管理者ログイン時（`/login`）のアプリ登録・音楽登録・編集・削除機能（FAB・設定・メニュー連動）
  - **ファイルストレージ最適化**: 画像 Base64 を廃止し、すべて公開ファイルストレージ（`/uploads/images/`）へ移行・高速化
  - **画像アップロード基盤**: アプリアイコン・サムネイル、楽曲カバーアートのアップロード（`uploadImage.php` / `/api/upload-image`）
  - **大容量音声アップロード基盤 (最大 100MB)**: 音声ファイル（mp3 / wav / m4a等）のサーバー保存 & クライアント側 ID3 メタデータ自動抽出（タイトル・アーティスト・アルバム・歌詞・カバーアート・duration）
  - **新カテゴリ体系**: 8大カテゴリ（ゲーム, メディア, ポータルサイト, 便利ツール, ソーシャル, Mod・拡張機能, 開発, その他）
  - **未完成フラグ (`isUnfinished`) & タグ (`tags`) 管理**: 開発中・制作途中のコンテンツの可視化と分類
  - **セキュアな管理者ログアウト**: PHP バックエンド（`logoutAccount.php`）と連携したアクセストークンの完全破棄
- 🔒 **多層認証セキュリティ**:
  - API ID / Token / AccessKey によるリクエスト署名・API認証機構
  - ユーザーアクセストークン検証および管理者ロール判定（`isUserAdmin`）

---

## アクセス

- **公式サイト**: <https://enoki.xyz>
- **API サーバー / メディア配信**: <https://api.home.enoki.xyz>

---

## 技術スタック

| 分類                        | 技術 / ライブラリ                                             | バージョン / 補足                                                 |
| :-------------------------- | :------------------------------------------------------------ | :---------------------------------------------------------------- |
| **フレームワーク**          | [Nuxt 4](https://nuxt.com/)                                   | `^4.3.1` (`future: { compatibilityVersion: 4 }`, SSR / SSG）       |
| **フロントエンド基盤**      | [Vue.js](https://vuejs.org/)                                  | `^3.5` (Composition API & Options API)                            |
| **言語**                    | [TypeScript](https://www.typescriptlang.org/)                 | 完全型定義対応                                                    |
| **UI コンポーネント**       | [Vuetify 3](https://vuetifyjs.com/)                           | `vuetify-nuxt-module: ^0.19.5`, `@mdi/font: ^7.4.47`              |
| **テンプレート**            | [Pug](https://pugjs.org/)                                     | `^3.0.3`                                                          |
| **スタイル**                | [SCSS (sass-embedded)](https://sass-lang.com/)                | `^1.97.3`（Dart Sass 高速版）                                     |
| **状態管理**                | [Pinia](https://pinia.vuejs.org/)                             | `^3.0.4` + `@pinia-plugin-persistedstate/nuxt: ^1.2.1`（永続化）   |
| **ローカルキャッシュ**      | [IndexedDB](https://developer.mozilla.org/ja/docs/Web/API/IndexedDB_API) | `enoki_homepage_cache`（アプリ・楽曲データのオフライン永続化）   |
| **国際化**                  | [@nuxtjs/i18n](https://i18n.nuxtjs.org/)                      | `^10.2.3`（日本語 / 英語）                                        |
| **コンテンツ管理**          | [@nuxt/content](https://content.nuxt.com/)                    | `^3.11.2` (Content v3) + `better-sqlite3: ^12.6.2`                |
| **Markdown パーサー**       | [Marked](https://marked.js.org/)                              | `^18.1.3` (アプリ紹介文・お知らせなどのパース)                     |
| **モバイル / ネイティブ**   | [Capacitor](https://capacitorjs.com/)                         | `^8.1.0` (Core, CLI, App, Camera, Device, StatusBar, Toast, Browser, Clipboard, Share) |
| **モバイル拡張**            | `@capacitor/android`, `capacitor-native-settings`             | `@capacitor/android: ^8.6.0`, `capacitor-native-settings: ^8.0.0` |
| **Android ビルド環境**      | Gradle & Java Toolchain                                       | `Gradle 8.14.5`, `Java (JDK) 21`                                  |
| **PWA UI 補完**             | [@ionic/pwa-elements](https://github.com/ionic-team/pwa-elements) | `^3.4.0` (PWA 実行時のカメラUI等のポリフィル)                     |
| **PWA**                     | Service Worker / Web App Manifest                             | オフライン対応、ホーム画面追加、WebPush プッシュ通知              |
| **QR コード**               | `vue-qrcode-reader`, `qrcode`                                 | カメラ認識 (`^5.7.3`) & コード生成 (`^1.5.4`)                     |
| **リンター / フォーマッタ** | [@nuxt/eslint](https://eslint.nuxt.com/)                      | `^1.15.1` (Flat Config: `eslint.config.mjs`)                      |
| **バックエンド言語**        | [PHP](https://www.php.net/)                                   | 7.4 / 8.x + Composer (FastCGI / mod_php / PHP-FPM)                |
| **データベース**            | [MySQL](https://www.mysql.com/) / MariaDB                     | PDO 接続、文字コード `utf8mb4`                                    |
| **メール送信**              | [PHPMailer](https://github.com/PHPMailer/PHPMailer)           | `^6.8` (SMTP 認証メール送信)                                      |
| **プッシュ通知送信**        | [web-push-php](https://github.com/web-push-libs/web-push-php) | `^8.0` (VAPID 認証 WebPush 送信)                                  |

---

## ページ・ルーティング一覧

| パス                          | ファイルパス                               | 内容・概要                                              |
| :---------------------------- | :----------------------------------------- | :------------------------------------------------------ |
| `/`                           | `app/pages/index.vue`                      | トップページ（ヒーローセクション、ピックアップ、最新コンテンツ等） |
| `/apps`                       | `app/pages/apps/index.vue`                 | ソフトウェア一覧ページ（新カテゴリ別棚、ランキング、全アプリ検索） |
| `/apps/[appId]`               | `app/pages/apps/[appId].vue`               | ソフトウェア詳細画面（動的ルーティング・スクリーンショット・外部リンク） |
| `/music`                      | `app/pages/music/index.vue`                | 音楽一覧ページ（楽曲・アルバム・ジャンル探索・試聴）     |
| `/music/[musicId]`            | `app/pages/music/[musicId].vue`            | 音楽詳細画面（動的ルーティング・シンセ/音声試聴・歌詞・メタデータ） |
| `/download`                   | `app/pages/download.vue`                   | **ダウンロードセンター**（オリジナル曲ZIP・自作OS・妄想路線図Excel・LED制御ファイル等） |
| `/profile`                    | `app/pages/profile/index.vue`              | プロフィールページ（ときえのき経歴・実績・運営情報）    |
| `/sponsors`                   | `app/pages/sponsors.vue`                   | スポンサー・友人紹介ページ（支援者およびクリエイター仲間） |
| `/product`                    | `app/pages/product/index.vue`              | 事業一覧（`/profile` への 301 リダイレクト）            |
| `/product/it`                 | `app/pages/product/it.vue`                 | IT事業（`/apps` への 301 リダイレクト）                 |
| `/product/music`              | `app/pages/product/music.vue`              | 音楽事業（`/music` への 301 リダイレクト）              |
| `/info`                       | `app/pages/info.vue`                       | プロフィール（`/profile` への 301 リダイレクト）         |
| `/login`                      | `app/pages/login.vue`                      | 管理者ログイン画面（二段階メール認証）                  |
| `/registar`                   | `app/pages/registar.vue`                   | 管理者新規登録画面（管理者秘密キー・ワンタイム認証）    |
| `/password_reset`             | `app/pages/password_reset.vue`             | パスワード再設定画面                                    |
| `/user/[userId]`              | `app/pages/user/[userId].vue`              | ユーザープロフィール画面（動的ルーティング）            |
| `/friendlist`                 | `app/pages/friendlist.vue`                 | 友達リスト（申請中・承認済み一覧）                      |
| `/qrcode`                     | `app/pages/qrcode.vue`                     | QR コード友達検索 & 自分の QR コード表示                |
| `/settings`                   | `app/pages/settings/index.vue`             | 設定トップメニュー（管理者ログアウト対応）              |
| `/settings/profile`           | `app/pages/settings/profile.vue`           | プロフィール編集画面（名前・自己紹介・アイコン等）      |
| `/settings/display`           | `app/pages/settings/display.vue`           | 表示・言語設定（テーマ切替・言語選択）                  |
| `/settings/developer-options` | `app/pages/settings/developer-options.vue` | 開発者向けオプション（Android 15 ノッチ切り欠き検証等） |
| `/admin/manage`               | `app/pages/admin/manage.vue`               | コンテンツ管理（アプリ・音楽の一覧・試聴・編集・削除）  |
| `/admin/register`             | `app/pages/admin/register.vue`             | コンテンツ新規登録（アプリ・音楽・音声/画像アップロード）|
| `/terms`                      | `app/pages/terms.vue`                      | 利用規約                                                |
| `/privacy`                    | `app/pages/privacy.vue`                    | プライバシーポリシー                                    |
| `/about`                      | `app/pages/about.vue`                      | 運営情報・プロフィール                                  |
| `/twitter`                    | `app/pages/twitter.vue`                    | 公式Twitter / Xへの 301 リダイレクト (`https://twitter.com/jikantoki`) |
| `/youtube`                    | `app/pages/youtube.vue`                    | 公式YouTubeへの 301 リダイレクト (`https://www.youtube.com/@jikantoki`) |
| `/blog`                       | `app/pages/blog.vue`                       | 公式ブログへの 301 リダイレクト (`https://blog.caramelos.xyz`)       |
| `/tutorial`                   | `app/pages/tutorial.vue`                   | アプリの使い方チュートリアル                            |
| `/[...slug]`                  | `app/pages/[...slug].vue`                  | 存在しないパスへのフォールバック（準備中画面）          |
| *(エラー / 404)*              | `app/error.vue`                            | **カスタムエラー画面**（サイバーパーティクル・ミニゲーム・効果音） |

---

## ファイル・ディレクトリ構成

Nuxt 4 の標準構造（`future: { compatibilityVersion: 4 }`）に基づき、Nuxt アプリケーション本体は `app/` 配下に集約されています。

```
enoki-homepage/
├── android/                            # Capacitor Android ネイティブプロジェクト
│   ├── app/                            # Android アプリモジュール (build.gradle, AndroidManifest.xml 等)
│   ├── gradle/                         # Gradle ラッパー & JVM ツールチェーン設定
│   │   ├── gradle-daemon-jvm.properties# Java 21 Toolchain 定義
│   │   └── wrapper/
│   │       └── gradle-wrapper.properties# Gradle 8.14.5 指定
│   ├── build.gradle                    # プロジェクトルート Gradle スクリプト
│   ├── capacitor.settings.gradle       # プラグイン自動読み込み設定
│   └── gradlew / gradlew.bat           # Gradle ラッパー実行ファイル
├── app/                                # Nuxt 4 アプリケーションルート
│   ├── app.vue                         # ルートコンポーネント（テーマ・スプラッシュ・OS別パディング制御）
│   ├── error.vue                       # カスタム404・エラー画面（パーティクル・CRT・ミニゲーム・効果音）
│   ├── components/                     # Vue コンポーネント群
│   │   ├── common/
│   │   │   ├── BottomNav.vue           # ボトムナビゲーション & ようこそダイアログ（管理者ログアウト対応）
│   │   │   ├── commonSplash.vue        # アプリ起動時スプラッシュ画面
│   │   │   └── HeroProfile.vue         # ヒーロープロフィール表示
│   │   ├── store/                      # ソフトウェアストア向けコンポーネント群
│   │   │   ├── AppCard.vue             # アプリカード
│   │   │   ├── AppDetailModal.vue      # アプリ詳細モーダル
│   │   │   ├── AppRankItem.vue         # ランキング表示アイテム
│   │   │   ├── AppShelf.vue            # アプリシェルフ（新カテゴリ別横スクロール棚）
│   │   │   └── HeroBanner.vue          # おすすめヒーローバナー
│   │   ├── music/                      # 音楽プレイヤー向けコンポーネント群
│   │   │   ├── MiniPlayer.vue          # 画面下部ミニプレイヤー
│   │   │   ├── MusicCard.vue           # 楽曲カード
│   │   │   ├── MusicHeroBanner.vue     # 音楽おすすめバナー
│   │   │   ├── MusicShelf.vue          # 楽曲シェルフ（横スクロール棚）
│   │   │   ├── MusicTrackRow.vue       # トラック行（インライン試聴・再生対応）
│   │   │   ├── MusicView.vue           # 音楽トップ表示ビュー
│   │   │   └── NowPlayingModal.vue     # 全画面再生中モーダル
│   │   ├── admin/                      # 管理者専用コンポーネント群
│   │   │   └── AdminRegisterModal.vue  # アプリ・楽曲新規登録・編集モーダル（音声・画像アップロード対応）
│   │   └── about/
│   │       └── AboutView.vue           # 運営情報ビュー
│   ├── data/                           # 初期モック・静的データ定義
│   │   ├── apps.json                   # アプリ・ゲーム初期データ
│   │   ├── downloads.ts                # ダウンロードセンター配布アイテム定義
│   │   ├── music.json                  # 楽曲初期データ
│   │   ├── profile.ts                  # プロフィール初期データ（経歴・SNS等）
│   │   └── sponsors.ts                 # スポンサー・友人紹介データ
│   ├── js/                             # ユーティリティモジュール
│   │   ├── ajaxFunctions.ts            # API 通信ラッパー（GET/POST・署名ヘッダー処理）
│   │   ├── audioMetadata.ts            # 音声ファイル（MP3/M4A/FLAC）ID3タグ・ジャケット抽出
│   │   ├── contentApi.ts               # アプリ・音楽・音声/画像アップロード・ログアウト PHP/Nitro 連携
│   │   ├── Functions.ts                # 汎用ヘルパー（外部リンク・クリップボード・トースト等）
│   │   ├── indexedDb.ts                # IndexedDB 永続化ストレージ（オフラインキャッシュ）
│   │   ├── metaFunctions.ts            # クライアント側メタタグ動的更新
│   │   ├── setup.ts                    # サーバーサイド SEO メタ設定（useServerHead / useServerSeoMeta）
│   │   └── webpush.ts                  # WebPush 購読・トークン登録・Service Worker 連携
│   ├── mixins/
│   │   └── mixins.ts                   # Vue Options API 用共通ミックスイン
│   ├── pages/                          # ルーティング対応ページコンポーネント群
│   ├── plugins/
│   │   └── pwa-elements.client.ts      # @ionic/pwa-elements カスタム要素登録プラグイン
│   ├── stores/                         # Pinia 状態管理
│   │   ├── app.ts                      # アプリ全体状態・アプリ一覧・カテゴリ定義・IndexedDB連携
│   │   ├── meta.ts                     # メタ情報
│   │   ├── music.ts                    # 音楽プレイヤー状態・楽曲一覧・再生キュー・IndexedDB連携
│   │   ├── myProfile.ts                # ログイン中ユーザー情報・管理者ロール判定
│   │   ├── navigation.ts               # ボトムナビ・ダイアログ表示制御状態
│   │   └── settings.ts                 # 設定（テーマ・言語・開発者オプション、LocalStorage永続化）
│   └── utils/
│       └── assetUrl.ts                 # 静的アセット完全URL解決・正規化ヘルパー (APIホスト/public補正)
├── assets/                             # アプリアイコン原画（Capacitor Assets 生成用）
│   ├── icon-background.png             # アイコン背景
│   ├── icon-foreground.png             # アイコン前景
│   └── icon-only.png                   # アイコン単体
├── icons/                              # 高品質 WebP アプリアイコン群 (48px〜512px)
├── php/                                # PHP API バックエンド（APIサーバー別端末ホスト対応）
│   ├── .htaccess                       # Apache 用リライトルール・CORS ヘッダー設定
│   ├── .user.ini                       # FastCGI / PHP-FPM 用アップロード上限設定 (100MB)
│   ├── public/                         # APIサーバー配下の大容量静的アセット（Vercel成果物外へ分離）
│   │   ├── customfiles/                # ダウンロードセンター配布用ファイル（ZIP, XLSX, OUD2 等）
│   │   ├── download/images/            # ダウンロードセンターアイテム紹介画像群
│   │   └── uploads/                    # ユーザー・管理者アップロードファイル
│   │       ├── audio/                  # アップロードされた音声ファイル群 (mp3/wav/m4a等)
│   │       └── images/                 # アップロードされた画像ファイル群 (apps/, music/ 等)
│   ├── functions/                      # 共通処理・関数群
│   │   ├── database.php                # DB 接続・CRUD・OTP生成などのコア関数
│   │   ├── authAPI.php / authAPIforUse.php         # API アクセス認証
│   │   ├── authAccount.php / authAccountforUse.php # ユーザーアカウント認証・管理者チェック
│   │   ├── functions.php               # 共通ユーティリティ
│   │   ├── id3Parser.php               # 音声ファイルメタデータ・ジャケット抽出
│   │   ├── imageStorage.php            # 画像ファイル保存・URLパス変換
│   │   ├── mailFunctions.php           # PHPMailer メール送信処理
│   │   ├── push.php                    # WebPush 送信処理
│   │   └── urlHelper.php               # APIサーバー完全URL解決ヘルパー
│   ├── acceptFriend.php                # 友達申請承認
│   ├── authAccount.php                 # アカウント認証チェック
│   ├── createAccount.php               # 新規アカウント作成
│   ├── createTable.php                 # テーブル自動生成スクリプト
│   ├── deleteApp.php                   # アプリ情報 MySQL & JSON 削除 API
│   ├── deleteMusic.php                 # 音楽情報 MySQL & JSON 削除 API
│   ├── deletePushToken.php             # プッシュ通知トークン削除
│   ├── friendRequest.php               # 友達申請送信
│   ├── getApps.php                     # アプリ一覧 MySQL 取得 API (メモリ上限256M・URL正規化)
│   ├── getMusic.php                    # 楽曲一覧 MySQL 取得 API (メモリ上限256M・URL正規化)
│   ├── getMyFriendList.php             # 友達リスト取得
│   ├── getProfile.php                  # プロフィール情報取得
│   ├── insertPushToken.php             # プッシュ通知トークン登録
│   ├── loginAccount.php                # 管理者ログイン処理（二段階認証・トークン発行）
│   ├── logoutAccount.php               # 管理者ログアウト処理（アクセストークン削除）
│   ├── makeApiForAdmin.php             # 管理者用デフォルト API トークン初期発行
│   ├── migrateAppImagesApi.php         # アプリ画像 Base64 -> 実ファイル＆URL 一括マイグレーション API (管理者)
│   ├── myAutoLoad.php                  # Composer オートローダー読み込み
│   ├── registerApp.php                 # アプリ情報 MySQL 登録・更新 API
│   ├── registerMusic.php               # 楽曲情報 MySQL 登録・更新 API
│   ├── requestToken.php                # メール認証用ワンタイムトークン発行
│   ├── requestTokenForgotAccount.php   # パスワード忘れ認証トークン発行
│   ├── resetPassword.php               # パスワード再設定
│   ├── sendPushForAccount.php          # 指定ユーザーへのプッシュ通知送信
│   ├── sendPushForMe.php               # テスト用プッシュ通知送信
│   ├── settings.php                    # CORS・共通ヘッダー設定
│   ├── updateGeoLocation.php           # 位置情報更新
│   ├── updateProfile.php               # プロフィール更新
│   ├── uploadAudio.php                 # 音声ファイル (mp3/wav/m4a) アップロード API (/php/public/uploads/audio/)
│   └── uploadImage.php                 # 画像ファイル (png/jpg/webp/svg/gif) アップロード API (/php/public/uploads/images/)
├── public/                             # Nuxt 静的アセット（Web公開ディレクトリ・軽量ファイルのみ）
│   ├── backgrounds/                    # トップページスライドショー用背景画像群
│   ├── data/                           # 公開データ（apps.json, music.json）
│   ├── icons/                          # PWA 用アプリアイコン群 (WebP: 48~512px)
│   ├── img/                            # サムネイル・画像素材
│   ├── sponsor/                        # スポンサー・友人ロゴ画像群
│   ├── .htaccess                       # SPA ルーティング ＆ php/public/ アセットリライト
│   ├── manifest.json                   # PWA Web App Manifest
│   ├── robots.txt                      # クローラー許可・サイトマップ参照設定
│   ├── sitemap.xsl                     # 動的 XML サイトマップ用 XSL スタイルシート
│   ├── style.css                       # サイト共通スタイルシート
│   ├── sw.js                           # PWA / WebPush 用 Service Worker
│   ├── favicon.ico                     # ファビコン
│   └── icon.png                        # メインアプリアイコン
├── scripts/                            # 開発・運用サポートスクリプト
│   ├── generate-mock-apps.js           # アプリモックデータ生成スクリプト
│   ├── generate-mock-music.js          # 楽曲モックデータ生成スクリプト
│   ├── migrate-apps-images.js          # アプリモックBase64画像を実ファイルへ抽出・移行するスクリプト (Node.js)
│   └── migrate_app_images.php          # 本番DB(app_list)の画像Base64を一括で画像ファイル化・URL置換するスクリプト (PHP/CLI)
├── server/                             # Nitro サーバーエンドポイント
│   ├── api/
│   │   ├── upload-audio.post.ts        # 音声ファイル (mp3/wav) アップロード API
│   │   ├── upload-image.post.ts        # 画像ファイル (png/jpg/webp/svg/gif) アップロード API
│   │   ├── register-app.post.ts        # アプリ登録 API (ローカル JSON 反映)
│   │   ├── register-music.post.ts      # 音楽登録 API (ローカル JSON 反映)
│   │   ├── delete-app.post.ts          # アプリ削除 API (ローカル JSON 反映)
│   │   └── delete-music.post.ts        # 音楽削除 API (ローカル JSON 反映)
│   ├── routes/
│   │   ├── sitemap.xml.ts              # 動的サイトマップ XML 生成エンドポイント
│   │   ├── rssfeed.xml.ts              # 動的 RSS 2.0 フィード生成エンドポイント
│   │   ├── feed.xml.ts                 # RSS フィード エイリアス
│   │   └── rss.xml.ts                  # RSS フィード エイリアス
│   └── utils/
│       ├── audioMetadata.ts            # 音声メタデータ抽出ユーティリティ
│       └── siteData.ts                 # サイトコンテンツ・日付・XML生成ユーティリティ
├── .htaccess                           # ルート用 Apache 設定 (リライト、静的アセット転送、mod_php上限設定)
├── android-keystore.keystore           # Android アプリ署名用キーストア
├── app-release.aab                     # Google Play 配信用リリースパッケージ (AAB)
├── app-release.apk                     # Android インストール用署名済みリリースパッケージ (APK)
├── capacitor.config.ts                 # Capacitor 8 設定ファイル
├── content.config.ts                   # @nuxt/content (v3) コレクション定義
├── database.sql                        # MySQL 完全スキーマ定義（全テーブル・ビュー・インデックス）
├── eslint.config.mjs                   # ESLint Flat Config 設定
├── migration_admin.sql                 # 管理者権限追加用差分マイグレーション
├── migration_app_categories.sql        # アプリ新カテゴリ体系への刷新マイグレーション
├── migration_app_images_applied.sql    # アプリ画像 Base64 -> 公開URL 移行適用済み SQL (40件)
├── migration_app_music.sql             # アプリ・音楽管理差分マイグレーション
├── migration_apps_images_to_uploads.sql# アプリ画像 Base64 から実ファイルURLへの移行マイグレーション
├── migration_content_mediumtext.sql    # Base64画像保存対応のためのカラム拡張 (`mediumtext`) 差分マイグレーション
├── migration_unfinished_tag.sql        # 未完成フラグ (`isUnfinished`)・タグ (`tags`) 追加差分マイグレーション
├── nuxt.config.ts                      # Nuxt 4 設定ファイル
├── package.json                        # Node.js 依存関係・スクリプト定義
├── thumbnail.jpg                       # プロジェクト紹介サムネイル画像
├── thumbnail.pdn                       # サムネイル原画ファイル (Paint.NET)
├── vercel.json                         # Vercel SPA リライト設定
└── yarn.lock                           # Yarn ロックファイル
```

---

## 前提条件

- **Node.js**: `20.x` 以上（LTS 推奨）
- **パッケージマネージャー**: `yarn`（v1.x Classic 推奨）または `npm`
- **バックエンド API 実行時**:
  - **PHP**: `7.4` または `8.x`（PDO, cURL, OpenSSL, mbstring 拡張が必要）
  - **Composer**: `2.x`
  - **MySQL**: `5.7` 以上 または MariaDB `10.x` 以上
- **モバイルアプリ開発時**:
  - Android: **Android Studio**, JDK 17 または JDK 21 (Gradle 8.14.5)
  - iOS: **macOS**, **Xcode**, CocoaPods

---

## 環境構築・セットアップ

### 1. リポジトリのクローンと依存解決

```bash
# リポジトリのクローン
git clone https://github.com/jikantoki/enoki-homepage.git
cd enoki-homepage

# Node パッケージのインストール
yarn install

# PHP パッケージのインストール（API を利用する場合）
composer install
```

> [!NOTE]
> `yarn install` 完了時に `nuxt prepare`（postinstall スクリプト）が自動実行され、`.nuxt` 内部の型定義が初期化されます。

---

### 2. フロントエンド環境変数の設定 (.env)

`.env.example` をコピーしてプロジェクトルートに `.env` を作成し、必要な値を設定します。

```bash
cp .env.example .env
```

#### `.env` の記述例:

```env
# WebPush 秘密鍵（サーバーサイド専用・クライアントには露出されません）
NUXT_WEBPUSH_PRIVATEKEY=your_webpush_private_key

# WebPush 公開鍵（クライアントで購読時に使用）
NUXT_WEBPUSH_PUBLICKEY=your_webpush_public_key

# API 設定（PHPバックエンドと通信するための認証情報）
NUXT_API_ID=default
NUXT_API_TOKEN=後述の手順5で生成されたトークン
NUXT_API_ACCESSKEY=後述の手順5で生成されたアクセスキー

# API サーバーのホスト URL（末尾スラッシュなし）
NUXT_API_HOST=https://api.home.enoki.xyz
```

> [!TIP]
> **WebPush 用の鍵ペアの生成方法**  
> 公開鍵・秘密鍵（VAPID キー）は [Web Push Codelab (Glitch)](https://web-push-codelab.glitch.me/) などのツールで即座に生成できます。

---

### 3. バックエンド設定 (env.php / .user.ini / .htaccess)

PHP バックエンドを使用する場合、リポジトリルート直下に `env.php` を作成します。  
`env.example.php` をコピーして作成し、データベースや SMTP メール送信設定、WebPush 設定を記入してください。

```bash
cp env.example.php env.php
```

#### `env.php` の主要な設定項目:

```php
<?php
// プロジェクトルートのディレクトリ名
define('DIRECTORY_NAME', '/');

// WebPush 設定（フロントエンドの .env と同じ鍵を指定）
define('NUXT_WebPush_PublicKey', 'パブリックキー');
define('NUXT_WebPush_PrivateKey', 'プライベートキー');
define('WebPush_URL', 'https://enoki.xyz');
define('WebPush_icon', 'https://enoki.xyz/icon.png');
define('Default_user_icon', 'https://enoki.xyz/account_default.jpg');

// MySQL データベース接続情報
define('MySQL_Host', 'localhost');
define('MySQL_DBName', 'your_database_name');
define('MySQL_User', 'your_database_user');
define('MySQL_Password', 'your_database_password');

// SMTP 送信設定（アカウント認証メール・パスワード再設定で使用）
define('SMTP_Name', 'エノキ電気');
define('SMTP_Username', 'smtp_user');
define('SMTP_Mailaddress', 'info@example.com');
define('SMTP_Password', 'smtp_password');
define('SMTP_Server', 'smtp.example.com');
define('SMTP_Port', 587);

// 管理者登録設定（管理者専用アカウント作成用セキュリティ）
define('Admin_Register_Key', '管理者登録用の秘密キー（半角英数記号）');
define('Admin_Register_Max', 1); // 登録可能な管理者アカウントの最大数（1で管理者本人のみ）
define('Admin_Allowed_Email', ''); // 特定のメールアドレスのみ許可する場合は指定（空欄ならキー検証のみ）

// メールヘッダー・フッター
$mailHeader = "<p>いつも エノキ電気 公式ホームページ をご利用いただきありがとうございます。<hr></p>";
$mailFooter = "<p><hr>このメールに返信することはできません。<br><a href=\"https://enoki.xyz\">エノキ電気</a></p>";
```

#### 大容量音声ファイルアップロード用設定 (`php/.user.ini` / `.htaccess`):

本システムでは、高品質なオリジナル楽曲音声ファイル（最大 100MB 程度）の直接アップロードに対応しています。

- **FastCGI / PHP-FPM 環境 (`php/.user.ini`)**:
  ```ini
  upload_max_filesize = 100M
  post_max_size = 110M
  max_execution_time = 300
  max_input_time = 300
  memory_limit = 256M
  ```

- **Apache mod_php 環境 (`.htaccess`)**:
  ルートの `.htaccess` にて以下が自動適用されます。
  ```htaccess
  <IfModule mod_php.c>
    php_value upload_max_filesize 100M
    php_value post_max_size 110M
    php_value max_execution_time 300
    php_value max_input_time 300
  </IfModule>
  ```

---

### 4. データベースの用意 (MySQL)

新規環境の場合は、リポジトリルートにある `database.sql` を MySQL データベースにインポートします。

```bash
mysql -u your_user -p your_database_name < database.sql
```

> [!NOTE]
> phpMyAdmin をご利用の場合は、作成したデータベースを選択して「インポート」タブから `database.sql` をアップロードするだけで完了します。
>
> **作成される主要テーブル:**
>
> - `accounts` / `user_list` / `user_profile_list`: ユーザー基本情報・プロフィール・管理者権限ロール (`role`)
> - `user_accesstoken_list`: ログイン中アクセストークン管理
> - `follow_list`: 友達申請・登録ステータス
> - `push_token_list`: プッシュ通知送信用トークン一覧
> - `location_list`: ユーザー位置情報
> - `api_list`: API 認証キー（ID・トークン・ハッシュ化アクセスキー）
> - `app_list`: アプリ・ゲーム情報（カテゴリ、価格、実ファイル画像URL、未完成フラグ、タグ、外部リンク等）
> - `music_list`: 楽曲情報（サーバー上音声ファイルURL、歌詞、ジャケット画像、未完成フラグ、タグ等）

#### 既存データベースからの差分更新 (マイグレーション)

すでに既存のデータベースを運用中の場合は、必要に応じて以下の差分マイグレーション SQL を順番に実行してください。

1. **管理者権限の追加 (`user_list` への `role` カラム追加)**:
   ```bash
   mysql -u your_user -p your_database_name < migration_admin.sql
   ```
2. **アプリ・音楽管理テーブルの追加**:
   ```bash
   mysql -u your_user -p your_database_name < migration_app_music.sql
   ```
3. **未完成フラグ (`isUnfinished`) & タグ (`tags`) カラムの追加**:
   ```bash
   mysql -u your_user -p your_database_name < migration_unfinished_tag.sql
   ```
4. **画像カラムの拡張 (`mediumtext` による一時的な Base64 対応)**:
   ```bash
   mysql -u your_user -p your_database_name < migration_content_mediumtext.sql
   ```
5. **アプリ画像の Base64 から実ファイルURL (`/uploads/images/apps/`) への移行定義**:
   ```bash
   mysql -u your_user -p your_database_name < migration_apps_images_to_uploads.sql
   ```
6. **アプリカテゴリ体系の刷新・正規化 (新8大カテゴリ)**:
   ```bash
   mysql -u your_user -p your_database_name < migration_app_categories.sql
   ```
7. **アプリ画像実ファイルURL一括置換 (本番適用済みクエリ 40件)**:
   ```bash
   mysql -u your_user -p your_database_name < migration_app_images_applied.sql
   ```

---

### 5. 初回管理者 API トークンの発行

本アプリの API 通信は独自の署名・認証機構を持っています。初回セットアップ時に管理者用デフォルト API を発行します。

1. セットアップした API サーバーの `/makeApiForAdmin.php`（例: `https://api.home.enoki.xyz/makeApiForAdmin.php`）にブラウザでアクセスします。
2. 初回アクセス時のみ MySQL の `api_list` テーブルにレコードが自動生成され、画面上に **API Token** と **AccessKey** が表示されます。
3. 表示された内容をコピーし、フロントエンドの `.env` の `NUXT_API_TOKEN` および `NUXT_API_ACCESSKEY` に貼り付けます。

> [!WARNING]
> AccessKey はハッシュ化されて保存されるため、画面を閉じると後から再確認できません。必ずメモを残してください。  
> 紛失した場合は、MySQL の `api_list` および `api_listForView` から `secretId='default'` の行を削除し、再度 `/makeApiForAdmin.php` にアクセスして再生成してください。

---

## コンテンツ管理機能 (CMS: アプリ・音楽の一覧・編集・削除・ログアウト)

管理者アカウント（`role === 'admin'` または `canRegisterApp === true`）でログインしている場合、専用のコンテンツ管理機能が利用可能です。

### 1. 管理ページ (`/admin/manage`)
- **一覧表示**: 登録済みアプリ・ゲームおよび楽曲をタブ形式で素早く閲覧・検索・カテゴリ/ジャンル絞り込み。
- **インライン試聴**: 音楽一覧では、サーバーにアップロードされた音声ファイルの有無をバッジ表示し、その場ですぐに試聴可能。
- **クイックアクション**: 各アイテムの「詳細ページを開く」「編集」「削除」をワンクリックで実行可能。
- **新規登録への導線**: ヘッダーおよびリスト上部からワンクリックで登録モーダルを開くことが可能。

### 2. 編集・登録機能
- 管理ページ（`/admin/manage`）の「編集」ボタン、ボトムナビ「アプリ・音楽を登録」、または各詳細画面（`/apps/[appId]`, `/music/[musicId]`）の管理者バーからモーダルを呼び出せます。
- **ファイルアップロード & アセット管理**:
  - 音声ファイル（mp3 / wav / m4a等）をアップロードすると、クライアント側で自動的に ID3 タグ（曲名、アーティスト、アルバム、歌詞、ジャケット画像、再生時間）を解析してフォームに入力補完。
  - 画像ファイル（アプリアイコン、サムネイル、ジャケット）をアップロードすると、APIサーバーの `php/public/uploads/images/` に安全に保存され、完全URLが自動設定されます（Base64によるDB肥大化を完全防止）。
- 名前、ID、価格、画像、外部リンク、音声URL、作詞・作曲、歌詞、**未完成フラグ (`isUnfinished`)**、**タグ一覧 (`tags`)** などをフォームから編集・保存可能。
- 保存を実行すると、MySQL データベースのレコードが `ON DUPLICATE KEY UPDATE` により更新され、サーバー側 JSON ファイルおよび Pinia ストア、IndexedDB キャッシュへ即座に反映されます。

### 3. 安全な削除機能
- 管理ページ（`/admin/manage`）または詳細画面（`/apps/[appId]`, `/music/[musicId]`）の「削除」ボタンをクリックすると、確認ダイアログが表示されます。
- 削除を確定すると、以下の処理が安全に実行されます:
  1. **MySQL データベース**: `app_list` / `music_list` テーブルから該当レコードを物理削除 (`deleteApp.php` / `deleteMusic.php`)
  2. **サーバー JSON ファイル**: `app/data/apps.json`、`app/data/music.json`（および `public/data/`）から除外して保存 (`/api/delete-app` / `/api/delete-music`)
  3. **Pinia 状態管理 & IndexedDB**: クライアントキャッシュおよび永続ストレージから即座に削除（再生中楽曲の場合は安全に再生停止）

### 4. 管理者ログアウト機能
- **「ようこそ」画面（ボトムナビの「その他」）**: 管理者でログインしている場合、管理者アイコンや表示名、バッジと共に**「管理者ログアウト」**ボタンが表示されます。
- **設定画面 (`/settings`)**: 設定一覧の中にも「管理者ログアウト」ボタンが常時表示されます。
- ログアウトを実行すると、確認ダイアログが表示された上で、**PHP バックエンド（`logoutAccount.php`）を呼び出して MySQL の `user_accesstoken_list` からアクセストークンを完全に破棄**し、クライアント側のセッション（Pinia ストア）をリセットして安全にゲスト状態へ戻ります。

---

## ダウンロードセンター (Download Center)

`/download` ページでは、ときえのきが製作・公開している多彩なデジタルコンテンツを無料で直接ダウンロードできます。

- **オリジナル曲データ**:
  - 「人生のタイムカプセル」オフボーカルカラオケ音源 ＆ 歌詞テキスト（ZIPアーカイブ）
- **自作 Linux OS**:
  - Toki Linux（TokiLinux 24.04 等の ISO イメージ）
  - Caramel OS（Caramel OS 10 等の ISO イメージ）
- **妄想鉄道路線図・ダイヤデータ**:
  - 関東高速鉄道、日本第三鉄道、定期快速路線図、合理化路線図などの高解像度 Excel 路線図ファイル（`.xlsx`）
  - OuDia2 ダイヤデータ（羽田空港大宮線 `.oud2`）
- **電子工作・制御ファイル**:
  - 電光掲示板制御ファイル各種（`.zip`）
  - マイコンコンパイラ配布パッケージ（`.zip`）
- **ミラーサーバー連携**:
  - 一部の大容量ファイルは高速配信サーバー `https://山d.com` と連携して快適なダウンロードを提供

---

## 開発・コマンドリファレンス

### npm / yarn スクリプト

`package.json` に定義されている開発・ビルドコマンド一覧です。

| コマンド                | 説明                                                                         |
| :---------------------- | :--------------------------------------------------------------------------- |
| `yarn dev`              | ローカル開発サーバーをポート 10000 で起動（`http://localhost:10000`）         |
| `yarn build`            | 本番用 Nuxt アプリケーションをビルド（SSR モード）                           |
| `yarn generate`         | 静的プリレンダリングを行い、`dist/` ディレクトリを生成（SPA / SSG）          |
| `yarn preview`          | `yarn build` または `yarn generate` で生成した成果物をローカルでプレビュー   |
| `yarn lint`             | ESLint によるコード静的解析・構文チェックを実行                              |
| `yarn typecheck`        | `nuxt typecheck` による TypeScript 型整合性チェックを実行                    |
| `yarn cap:sync`         | `nuxt generate` を実行後、成果物を Capacitor ネイティブプロジェクトに同期    |
| `yarn cap:open:android` | Android Studio を起動してネイティブプロジェクトを開く                        |
| `yarn cap:open:ios`     | Xcode を起動してネイティブプロジェクトを開く                                 |
| `yarn postinstall`      | `nuxt prepare` を実行し、Nuxt の型マッピングを生成（インストール時自動実行） |

### ユーティリティスクリプト (scripts/)

`scripts/` ディレクトリ配下にある運用・データ移行スクリプトです。

| スクリプト                         | 実行例                                       | 説明                                                                  |
| :--------------------------------- | :------------------------------------------- | :-------------------------------------------------------------------- |
| `scripts/migrate_app_images.php`   | `php scripts/migrate_app_images.php`         | 本番DB(app_list)の画像Base64を一括でファイル保存しURLに置換更新するスクリプト (PHP/CLI) |
|                                    | `php scripts/migrate_app_images.php --dry-run` | DB・ファイルを変更せず事前に対象をシミュレーション                   |
|                                    | `php scripts/migrate_app_images.php --export-sql` | UPDATE クエリを SQL ファイル (`migration_app_images_applied.sql`) に出力 |
| `scripts/migrate-apps-images.js`   | `node scripts/migrate-apps-images.js`        | アプリモック用Base64画像を抽出し`/uploads/images/apps/`へ保存するNodeスクリプト |
| `scripts/generate-mock-apps.js`    | `node scripts/generate-mock-apps.js`         | 開発・検証用アプリモックデータの生成                                  |
| `scripts/generate-mock-music.js`   | `node scripts/generate-mock-music.js`        | 開発・検証用楽曲モックデータの生成                                    |

---

## モバイルアプリ開発 (Capacitor 8 & Android)

Capacitor 8 を使用して、Web の資産を Android / iOS アプリとしてビルドできます。

### 1. ネイティブプラットフォーム環境

- **Gradle バージョン**: `8.14.5` (`android/gradle/wrapper/gradle-wrapper.properties`)
- **Java Toolchain**: `JDK 21` (`android/gradle/gradle-daemon-jvm.properties`)
- **パッケージ名 (App ID)**: `xyz.enoki.home`
- **対象 SDK**: `compileSdkVersion 34+`, `targetSdkVersion 34+`, `minSdkVersion 22+`

### 2. Web アセットの生成と同期

コードの変更をネイティブプロジェクトに反映するには `yarn cap:sync` を実行します。

```bash
yarn cap:sync
```

このコマンドは内部で `nuxt generate`（`dist/` への静的出力）を行い、Capacitor がそのファイルをネイティブプロジェクトへコピーします。

### 3. IDE でのビルド・実行

```bash
# Android Studio で開く
yarn cap:open:android

# Xcode で開く (macOS のみ)
yarn cap:open:ios
```

### 4. リリース向けパッケージ生成 (APK / AAB / キーストア署名)

プロジェクトルートの `android-keystore.keystore` を使用して、Google Play 公開用の **AAB (`app-release.aab`)** や直接インストール用の **APK (`app-release.apk`)** をビルド・署名できます。

```bash
cd android
./gradlew bundleRelease  # app/build/outputs/bundle/release/app-release.aab
./gradlew assembleRelease # app/build/outputs/apk/release/app-release.apk
```

### 5. アプリアイコン・スプラッシュ画面の生成

`assets/` ディレクトリ内の画像素材を元に、各プラットフォーム向けのアプリアイコンとスプラッシュ画面を自動生成できます。

```bash
npx @capacitor/assets generate
```

---

## PWA & オフラインキャッシュ (Progressive Web Apps & IndexedDB)

本プロジェクトは PWA（Progressive Web App）およびクライアント側キャッシュに対応しています。

- **Service Worker (`public/sw.js`)**:
  - 静的アセットのキャッシュ
  - WebPush プッシュ通知のバックグラウンド受信・通知バナーのタップハンドリング
- **IndexedDB 永続化ストレージ (`app/js/indexedDb.ts`)**:
  - データベース名: `enoki_homepage_cache`
  - アプリ一覧（`enoki_apps_list`）および楽曲一覧（`enoki_music_list`）をローカルにキャッシュ
  - 初回読み込み以降、オフライン時や低速ネットワーク下でも瞬時にコンテンツ一覧を表示可能
- **PWA UI 補完 (`@ionic/pwa-elements`)**:
  - `app/plugins/pwa-elements.client.ts` により、ブラウザ/PWA環境でも Capacitor Camera などのネイティブUIをエミュレート
- **Web App Manifest (`public/manifest.json`)**:
  - ホーム画面への追加（Standalone 起動対応）
  - 各種解像度（48px〜512px）の WebP アプリアイコン対応
- **Vercel リライト (`vercel.json`) & Apache リライト (`public/.htaccess`)**:
  - クライアントサイドルーティング（SPA / PWA）のための `index.html` フォールバックリライト設定済み

---

## バックエンド API エンドポイント一覧

### PHP バックエンド (php/)

フロントエンドからは `app/js/contentApi.ts` または `app/js/ajaxFunctions.ts` を経由してリクエストが行われます。

| カテゴリ             | エンドポイント                  | 説明                                                 |
| :------------------- | :------------------------------ | :--------------------------------------------------- |
| **認証・アカウント** | `loginAccount.php`              | 管理者ログイン認証（メール二段階認証・トークン発行） |
|                      | `logoutAccount.php`             | 管理者/ユーザーログアウト処理（アクセストークンの削除） |
|                      | `authAccount.php`               | アクセストークンの妥当性検証                         |
|                      | `createAccount.php`             | 新規アカウントの本登録                               |
|                      | `requestToken.php`              | 新規登録・ログイン時のメール認証コード送信           |
| **パスワード**       | `requestTokenForgotAccount.php` | パスワードリセット用認証コード送信                   |
|                      | `resetPassword.php`             | パスワードの再設定実行                               |
| **プロフィール**     | `getProfile.php`                | ユーザープロフィールの取得                           |
|                      | `updateProfile.php`             | プロフィール情報の更新（名前・自己紹介等）           |
| **ソーシャル・友達** | `friendRequest.php`             | 友達申請の送信                                       |
|                      | `acceptFriend.php`              | 友達申請の承認                                       |
|                      | `getMyFriendList.php`           | 友達一覧・申請中リストの取得                         |
| **プッシュ通知**     | `insertPushToken.php`           | WebPush 購読トークンの登録・更新                     |
|                      | `deletePushToken.php`           | WebPush 購読トークンの解除                           |
|                      | `sendPushForAccount.php`        | 特定のユーザーへのプッシュ通知送信                   |
|                      | `sendPushForMe.php`             | 自分宛てのテスト通知送信                             |
| **位置情報**         | `updateGeoLocation.php`         | ユーザーの位置情報（緯度・経度）更新                 |
| **システム・管理**   | `makeApiForAdmin.php`           | 管理者用 API トークンの初期生成                      |
|                      | `createTable.php`               | DB テーブル自動初期化                                |
| **コンテンツ管理**   | `uploadAudio.php`               | 音声ファイル (mp3/wav/m4a等) サーバー側アップロード API (最大100MB) |
|                      | `uploadImage.php`               | 画像ファイル (png/jpg/webp/svg/gif等) アップロード API |
|                      | `registerApp.php`               | アプリ情報 MySQL 登録・更新 API                      |
|                      | `registerMusic.php`             | 楽曲・音声ファイルURL MySQL 登録・更新 API           |
|                      | `deleteApp.php`                 | アプリ情報 MySQL & JSON 物理削除 API                 |
|                      | `deleteMusic.php`               | 楽曲情報 MySQL & JSON 物理削除 API                   |
|                      | `getApps.php`                   | アプリ一覧 MySQL 取得 API (memory_limit: 256M, URL正規化) |
|                      | `getMusic.php`                  | 楽曲一覧 MySQL 取得 API (memory_limit: 256M, URL正規化) |
|                      | `migrateAppImagesApi.php`       | 本番DB画像Base64 -> ファイルURL一括移行 API (管理者) |

### Nitro サーバーエンドポイント (server/api/)

ローカル開発環境や Nuxt サーバー稼働時にローカルデータと同期する Nitro API です。

| エンドポイント                    | メソッド | 説明                                                           |
| :-------------------------------- | :------- | :------------------------------------------------------------- |
| `/api/upload-audio`               | POST     | 音声ファイル (mp3/wav/m4a) を PHP API サーバー (`php/public/uploads/audio/`) に転送・保存 |
| `/api/upload-image`               | POST     | 画像ファイル (png/jpg/webp/svg/gif) を PHP API サーバー (`php/public/uploads/images/`) に転送・保存 |
| `/api/register-app`               | POST     | アプリ情報をローカル `apps.json` に登録・更新                  |
| `/api/register-music`             | POST     | 楽曲情報をローカル `music.json` に登録・更新                   |
| `/api/delete-app`                 | POST     | アプリ情報をローカル `apps.json` から削除                      |
| `/api/delete-music`               | POST     | 楽曲情報をローカル `music.json` から削除                      |

---

## 主要な設定箇所

| 設定項目                    | 設定対象ファイル              | 内容                                                          |
| :-------------------------- | :---------------------------- | :------------------------------------------------------------ |
| **Nuxt 全般・モジュール**   | `nuxt.config.ts`              | Nuxt 4 モード設定、i18n 言語設定、Vuetify 設定、OGP・メタタグ |
| **Capacitor モバイル設定**  | `capacitor.config.ts`         | App ID (`xyz.enoki.home`)、アプリ表示名、Web 出力先 (`dist`)  |
| **Android ビルド設定**      | `android/gradle/`             | Gradle 8.14.5、Java 21 Toolchain (`gradle-daemon-jvm.properties`) |
| **コンテンツ管理設定**      | `content.config.ts`           | `@nuxt/content` (v3) のコレクション定義                       |
| **コード規約・ESLint**      | `eslint.config.mjs`           | `@nuxt/eslint` のフラットコンフィグ設定                       |
| **テーマカラー・フォント**  | `app/app.vue`                 | `--v-theme-primary: 225, 35, 120`、Zen Maru Gothic            |
| **カスタムエラー・404**     | `app/error.vue`               | サイバーパーティクル描画、効果音トグル、ミニゲーム            |
| **ダウンロードセンター**    | `app/data/downloads.ts`       | ダウンロードセンターのカテゴリ・アイテム・画像・配布URL定義   |
| **アプリカテゴリ体系**      | `app/stores/app.ts`           | `APP_CATEGORIES`（ゲーム, メディア, 便利ツール等8カテゴリ）   |
| **アセットURL解決**         | `app/utils/assetUrl.ts`       | APIサーバー側静的アセット（uploads, download等）完全URL解決   |
| **オフラインキャッシュ**    | `app/js/indexedDb.ts`         | `enoki_homepage_cache` によるアプリ・楽曲データ保存           |
| **環境変数 (フロント)**     | `.env` / `nuxt.config.ts`     | WebPush キー、API ホスト、API トークン                        |
| **環境変数 (バックエンド)** | `env.php`                     | DB 接続情報、SMTP メールサーバー情報、WebPush 秘密鍵          |
| **アップロード制限設定**    | `php/.user.ini`, `.htaccess`  | FastCGI / Apache 用アップロードサイズ 100MB 緩和設定          |
| **PWA マニフェスト**        | `public/manifest.json`        | アプリ名称、テーマカラー、アイコン定義                        |
| **サイトマップ用スタイル**  | `public/sitemap.xsl`          | XMLサイトマップのブラウザ閲覧用スタイル定義                   |

---

## デプロイガイド

### フロントエンド (Vercel)

1. Vercel にリポジトリを連携します。
2. Framework Preset として **Nuxt** または **Other** を選択します。
3. **Environment Variables** に `.env` に記載した環境変数を設定します。
   - `NUXT_WEBPUSH_PUBLICKEY`
   - `NUXT_WEBPUSH_PRIVATEKEY`
   - `NUXT_API_ID`
   - `NUXT_API_TOKEN`
   - `NUXT_API_ACCESSKEY`
   - `NUXT_API_HOST` (例: `https://api.home.enoki.xyz`)
4. ビルドコマンドは `yarn generate`（SPA/PWA 静的ホスティング）または `yarn build`（SSR ホスティング）を指定します。
   - 本リポジトリには `vercel.json` および `public/.htaccess` が含まれており、SPA / PWA 形式で安全に全ルートを `index.html` にフォールバックします。

### バックエンド (PHP / Apache / Nginx)

1. レンタルサーバーや VPS の任意のドメイン / サブドメインに `php/` 配下のファイル一式を配置します。
2. ルートディレクトリに `env.php` を配置し、DB・SMTP 接続情報を正しく設定します。
3. `php/.user.ini` および `.htaccess` が有効であることを確認します（100MB 級の音声ファイルアップロードを許可するため）。
4. `database.sql` を MySQL にインポートします（既存DBの場合は差分マイグレーション SQL を順番に実行）。
5. `/makeApiForAdmin.php` にアクセスし、生成されたトークンをフロントエンドの `.env` に反映します。

---

## 参考リンク・クレジット

- **運営・開発**: [エノキ電気 (ときえのき)](https://enoki.xyz)
- **公式ドキュメント**:
  - [Nuxt Documentation](https://nuxt.com/docs)
  - [Capacitor Documentation](https://capacitorjs.com/docs)
  - [Vuetify 3 Documentation](https://vuetifyjs.com/)
  - [Nuxt Content Documentation](https://content.nuxt.com/)
  - [Web Push Libs PHP](https://github.com/web-push-libs/web-push-php)
