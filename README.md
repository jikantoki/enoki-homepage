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
  <img src="https://img.shields.io/badge/PWA-Enabled-5A0FC8?logo=pwa&logoColor=white" alt="PWA">
  <img src="https://img.shields.io/badge/PHP-7.4%20%7C%208.x-777BB4?logo=php&logoColor=white" alt="PHP">
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
   - [3. バックエンド設定 (env.php)](#3-バックエンド設定-envphp)
   - [4. データベースの用意 (MySQL)](#4-データベースの用意-mysql)
   - [5. 初回管理者 API トークンの発行](#5-初回管理者-api-トークンの発行)
9. [開発・コマンドリファレンス](#開発コマンドリファレンス)
10. [モバイルアプリ開発 (Capacitor 8)](#モバイルアプリ開発-capacitor-8)
11. [PWA (Progressive Web Apps)](#pwa-progressive-web-apps)
12. [バックエンド API エンドポイント一覧](#バックエンド-api-エンドポイント一覧)
13. [主要な設定箇所](#主要な設定箇所)
14. [デプロイガイド](#デプロイガイド)
15. [参考リンク・クレジット](#参考リンククレジット)

---

## 概要

**エノキ電気 公式ホームページ** は、ときえのき（エノキ電気）が運営するエノキ電気のホームページです。  
ユーザー登録・プロフィール管理・友達申請・QR コードによる友達追加・リアルタイムプッシュ通知（WebPush）などの多彩なソーシャル機能を備えています。

**Nuxt 4**（`compatibilityVersion: 4`）と **Capacitor 8** を採用したワンソース・マルチプラットフォーム構成となっており、同一のコードベースから **Web ブラウザ**、**PWA (Progressive Web Apps)**、および **Android / iOS ネイティブアプリ** を展開できます。

---

## 主な機能・特徴

- 📱 **マルチプラットフォーム展開**: Web、PWA、Android、iOS（Capacitor 8）に対応
- 👥 **ユーザー & ソーシャル機能**: アカウント登録、ログイン、パスワードリセット、プロフィール編集、友達申請・一覧管理
- 📷 **QR コード連携**:
  - `vue-qrcode-reader` によるカメラからの QR コード読み取り（対面での友達登録）
  - `qrcode` による自分専用 QR コードのリアルタイム生成
- 🔔 **WebPush プッシュ通知**:
  - Service Worker と WebPush API によるバックグラウンド通知の送受信
  - PHP バックエンド（`minishlink/web-push`）による通知配信基盤
- 🎨 **モダンかつ親しみやすい UI**:
  - Vuetify 3 + Pug + SCSS (`sass-embedded`)
  - Google Fonts「Zen Maru Gothic」を採用
  - ダークテーマ / ライトテーマ / システム連動の動的切り替え
  - **Android 15+ のエッジ・トゥ・エッジ (Edge-to-Edge) 対応**: ステータスバーやノッチ切り欠きに応じたパディング制御
- 🌐 **多言語対応 (i18n)**: `@nuxtjs/i18n` による日本語・英語のローカライズ対応
- 📚 **コンテンツ管理**: `@nuxt/content` (v3) による Markdown ページのコレクション管理
- 🔒 **セキュアな独自 API 認証**: API ID / Token / AccessKey によるリクエスト署名・認証機構

---

## アクセス

- **公式サイト**: <https://app.enoki.xyz>
- **エノキ電気（運営）**: <https://enoki.xyz>

---

## 技術スタック

| 分類                        | 技術 / ライブラリ                                             | バージョン / 補足                                                 |
| :-------------------------- | :------------------------------------------------------------ | :---------------------------------------------------------------- |
| **フレームワーク**          | [Nuxt 4](https://nuxt.com/)                                   | `^4.3.1`（`compatibilityVersion: 4`, SSR / SSG）                  |
| **フロントエンド基盤**      | [Vue.js](https://vuejs.org/)                                  | `^3.5` (Composition API & Options API)                            |
| **言語**                    | [TypeScript](https://www.typescriptlang.org/)                 | 完全型定義対応                                                    |
| **UI コンポーネント**       | [Vuetify 3](https://vuetifyjs.com/)                           | `vuetify-nuxt-module: ^0.19.5`, `@mdi/font`                       |
| **テンプレート**            | [Pug](https://pugjs.org/)                                     | `^3.0.3`                                                          |
| **スタイル**                | [SCSS (sass-embedded)](https://sass-lang.com/)                | `^1.97.3`（Dart Sass 高速版）                                     |
| **状態管理**                | [Pinia](https://pinia.vuejs.org/)                             | `^3.0.4` + `@pinia-plugin-persistedstate/nuxt`（永続化）          |
| **国際化**                  | [@nuxtjs/i18n](https://i18n.nuxtjs.org/)                      | `^10.2.3`（日本語 / 英語）                                        |
| **コンテンツ管理**          | [@nuxt/content](https://content.nuxt.com/)                    | `^3.11.2` (Content v3) + `better-sqlite3`                         |
| **モバイル / ネイティブ**   | [Capacitor](https://capacitorjs.com/)                         | `^8.1.0` (Core, CLI, App, Camera, Device, StatusBar, Toast, etc.) |
| **PWA**                     | Service Worker / Web App Manifest                             | オフライン対応、ホーム画面追加、プッシュ通知                      |
| **QR コード**               | `vue-qrcode-reader`, `qrcode`                                 | カメラ認識 (`^5.7.3`) & コード生成 (`^1.5.4`)                     |
| **リンター / フォーマッタ** | [@nuxt/eslint](https://eslint.nuxt.com/)                      | `^1.15.1` (Flat Config: `eslint.config.mjs`)                      |
| **バックエンド言語**        | [PHP](https://www.php.net/)                                   | 7.4 / 8.x + Composer                                              |
| **データベース**            | [MySQL](https://www.mysql.com/) / MariaDB                     | PDO 接続、文字コード `utf8mb4`                                    |
| **メール送信**              | [PHPMailer](https://github.com/PHPMailer/PHPMailer)           | `^6.8` (SMTP 認証メール送信)                                      |
| **プッシュ通知送信**        | [web-push-php](https://github.com/web-push-libs/web-push-php) | `^8.0` (VAPID 認証 WebPush 送信)                                  |

---

## ページ・ルーティング一覧

| パス                          | ファイルパス                               | 内容・概要                                              |
| :---------------------------- | :----------------------------------------- | :------------------------------------------------------ |
| `/`                           | `app/pages/index.vue`                      | トップページ（タイムライン・アプリ紹介・各種導線）      |
| `/login`                      | `app/pages/login.vue`                      | ログイン画面                                            |
| `/registar`                   | `app/pages/registar.vue`                   | 新規アカウント登録画面（ワンタイム認証）                |
| `/password_reset`             | `app/pages/password_reset.vue`             | パスワード再設定画面                                    |
| `/user/[userId]`              | `app/pages/user/[userId].vue`              | ユーザープロフィール画面（動的ルーティング）            |
| `/friendlist`                 | `app/pages/friendlist.vue`                 | 友達リスト（申請中・承認済み一覧）                      |
| `/qrcode`                     | `app/pages/qrcode.vue`                     | QR コード友達検索 & 自分の QR コード表示                |
| `/settings`                   | `app/pages/settings/index.vue`             | 設定トップメニュー                                      |
| `/settings/profile`           | `app/pages/settings/profile.vue`           | プロフィール編集画面（名前・自己紹介・アイコン等）      |
| `/settings/display`           | `app/pages/settings/display.vue`           | 表示・言語設定（テーマ切替・言語選択）                  |
| `/settings/developer-options` | `app/pages/settings/developer-options.vue` | 開発者向けオプション（Android 15 ノッチ切り欠き検証等） |
| `/terms`                      | `app/pages/terms.vue`                      | 利用規約                                                |
| `/about`                      | `app/pages/about.vue`                      | 運営情報・エノキ電気について                            |
| `/tutorial`                   | `app/pages/tutorial.vue`                   | アプリの使い方チュートリアル                            |
| `/[ready]`                    | `app/pages/[ready].vue`                    | 準備中画面（フォールバック用動的ルート）                |

---

## ファイル・ディレクトリ構成

Nuxt 4 の標準構造（`future: { compatibilityVersion: 4 }`）に基づき、Nuxt アプリケーション本体は `app/` 配下に集約されています。

```
enoki-homepage/
├── app/                                # Nuxt 4 アプリケーションルート
│   ├── app.vue                         # ルートコンポーネント（テーマ・スプラッシュ・OS別パディング制御）
│   ├── components/                     # Vue コンポーネント群
│   │   └── common/
│   │       └── commonSplash.vue        # アプリ起動時スプラッシュ画面
│   ├── pages/                          # ルーティング対応ページコンポーネント
│   │   ├── index.vue                   # トップページ
│   │   ├── login.vue                   # ログイン
│   │   ├── registar.vue                # アカウント登録
│   │   ├── password_reset.vue          # パスワードリセット
│   │   ├── friendlist.vue              # 友達リスト
│   │   ├── qrcode.vue                  # QR コード（スキャン・生成）
│   │   ├── terms.vue                   # 利用規約
│   │   ├── about.vue                   # 運営情報
│   │   ├── tutorial.vue                # チュートリアル
│   │   ├── [ready].vue                 # 準備中フォールバック
│   │   ├── settings/                   # 設定サブルート
│   │   │   ├── index.vue               # 設定トップ
│   │   │   ├── profile.vue             # プロフィール編集
│   │   │   ├── display.vue             # 表示・テーマ設定
│   │   │   └── developer-options.vue   # 開発者オプション
│   │   └── user/
│   │       └── [userId].vue            # ユーザープロフィール詳細
│   ├── stores/                         # Pinia 状態管理
│   │   ├── app.ts                      # アプリ全体状態・アプリ一覧データ
│   │   ├── meta.ts                     # メタ情報
│   │   ├── myProfile.ts                # ログイン中ユーザー情報
│   │   └── settings.ts                 # 設定（テーマ・言語・開発者オプション、LocalStorage永続化）
│   ├── js/                             # ユーティリティモジュール
│   │   ├── Functions.ts                # 汎用ヘルパー（外部リンク・クリップボード等）
│   │   ├── ajaxFunctions.ts            # API 通信ラッパー（GET/POST・署名ヘッダー処理）
│   │   ├── metaFunctions.ts            # クライアント側メタタグ動的更新
│   │   ├── setup.ts                    # サーバーサイド SEO メタ設定（useServerHead / useServerSeoMeta）
│   │   └── webpush.ts                  # WebPush 購読・トークン登録・Service Worker 連携
│   └── mixins/
│       └── mixins.ts                   # Vue Options API 用共通ミックスイン
├── assets/                             # アプリアイコン原画（Capacitor Assets 生成用）
│   ├── icon-background.png             # アイコン背景
│   ├── icon-foreground.png             # アイコン前景
│   └── icon-only.png                   # アイコン単体
├── php/                                # PHP API バックエンド
│   ├── functions/                      # 共通処理・関数群
│   │   ├── database.php                # DB 接続・CRUD・OTP生成などのコア関数
│   │   ├── authAPI.php / authAPIforUse.php       # API アクセス認証
│   │   ├── authAccount.php / authAccountforUse.php # ユーザーアカウント認証
│   │   ├── mailFunctions.php           # PHPMailer メール送信処理
│   │   └── push.php                    # WebPush 送信処理
│   ├── acceptFriend.php                # 友達申請承認
│   ├── authAccount.php                 # アカウント認証チェック
│   ├── createAccount.php               # 新規アカウント作成
│   ├── createTable.php                 # テーブル自動生成スクリプト
│   ├── deletePushToken.php             # プッシュ通知トークン削除
│   ├── friendRequest.php               # 友達申請送信
│   ├── getMyFriendList.php             # 友達リスト取得
│   ├── getProfile.php                  # プロフィール情報取得
│   ├── insertPushToken.php             # プッシュ通知トークン登録
│   ├── loginAccount.php                # ログイン処理
│   ├── logoutAccount.php               # ログアウト処理
│   ├── makeApiForAdmin.php             # 管理者用デフォルト API トークン初期発行
│   ├── myAutoLoad.php                  # Composer オートローダー読み込み
│   ├── requestToken.php                # メール認証用ワンタイムトークン発行
│   ├── requestTokenForgotAccount.php   # パスワード忘れ認証トークン発行
│   ├── resetPassword.php               # パスワード再設定
│   ├── sendPushForAccount.php          # 指定ユーザーへのプッシュ通知送信
│   ├── sendPushForMe.php               # テスト用プッシュ通知送信
│   ├── settings.php                    # CORS・共通ヘッダー設定
│   ├── updateGeoLocation.php           # 位置情報更新
│   └── updateProfile.php               # プロフィール更新
├── public/                             # 静的アセット（Web公開ディレクトリ）
│   ├── icons/                          # PWA 用アプリアイコン群 (WebP: 48~512px)
│   ├── img/                            # サムネイル・画像素材
│   ├── manifest.json                   # PWA Web App Manifest
│   ├── sw.js                           # PWA / WebPush 用 Service Worker
│   ├── favicon.ico                     # ファビコン
│   └── icon.png                        # メインアプリアイコン
├── server/                             # Nitro サーバーエンドポイント用ディレクトリ（拡張用）
├── capacitor.config.ts                 # Capacitor 8 設定ファイル
├── content.config.ts                   # @nuxt/content (v3) コレクション定義
├── eslint.config.mjs                   # ESLint Flat Config 設定
├── nuxt.config.ts                      # Nuxt 4 設定ファイル
├── database.sql                        # MySQL スキーマ定義
├── env.example.php                     # PHP 側環境変数サンプル
├── .env.example                        # Nuxt 側環境変数サンプル
├── composer.json                       # PHP 依存関係定義
├── package.json                        # Node.js 依存関係・スクリプト定義
├── vercel.json                         # Vercel SPA リライト設定
└── yarn.lock                           # Yarn ロックファイル
```

---

## 前提条件

- **Node.js**: `20.x` 以上（LTS 推奨）
- **パッケージマネージャー**: `yarn`（v1.x Classic 推奨）
- **バックエンド API 実行時**:
  - **PHP**: `7.4` または `8.x`（PDO, cURL, OpenSSL, mbstring 拡張が必要）
  - **Composer**: `2.x`
  - **MySQL**: `5.7` 以上 または MariaDB `10.x` 以上
- **モバイルアプリ開発時**:
  - Android: **Android Studio**, JDK 17+
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

> [!NOTE] > `yarn install` 完了時に `nuxt prepare`（postinstall スクリプト）が自動実行され、`.nuxt` 内部の型定義が初期化されます。

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
NUXT_API_HOST=https://api.yourdomain.com
```

> [!TIP] > **WebPush 用の鍵ペアの生成方法**  
> 公開鍵・秘密鍵（VAPID キー）は [Web Push Codelab (Glitch)](https://web-push-codelab.glitch.me/) などのツールで即座に生成できます。

---

### 3. バックエンド設定 (env.php)

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
define('WebPush_URL', 'https://app.enoki.xyz');
define('WebPush_icon', 'https://app.enoki.xyz/icon.png');
define('Default_user_icon', 'https://app.enoki.xyz/account_default.jpg');

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

// メールヘッダー・フッター
$mailHeader = "<p>いつも エノキ電気 公式ホームページ をご利用いただきありがとうございます。<hr></p>";
$mailFooter = "<p><hr>このメールに返信することはできません。<br><a href=\"https://app.enoki.xyz\">エノキ電気</a></p>";
```

#### PHP サーバーの Apache / .htaccess 設定例:

API 用サブドメインのドキュメントルートを `php/` ディレクトリに向けるか、以下の `.htaccess` でルーティングと CORS を許可します。

```htaccess
<IfModule mod_rewrite.c>
  RewriteEngine on
  RewriteBase /
  RewriteRule ^$ php/ [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule ^(.+)$ php/$1 [L]
</IfModule>

# CORS 許可
Header append Access-Control-Allow-Origin: "*"
Header append Access-Control-Allow-Headers: "*"
```

---

### 4. データベースの用意 (MySQL)

リポジトリルートにある `database.sql` を MySQL データベースにインポートします。

```bash
mysql -u your_user -p your_database_name < database.sql
```

> [!NOTE]
> phpMyAdmin をご利用の場合は、作成したデータベースを選択して「インポート」タブから `database.sql` をアップロードするだけで完了します。
>
> **作成される主要テーブル:**
>
> - `accounts` / `user_list` / `user_profile_list`: ユーザー基本情報・プロフィール
> - `follow_list`: 友達申請・登録ステータス
> - `push_token_list`: プッシュ通知送信用トークン一覧
> - `location_list`: ユーザー位置情報
> - `api_list`: API 認証キー（ID・トークン・ハッシュ化アクセスキー）

---

### 5. 初回管理者 API トークンの発行

本アプリの API 通信は独自の署名・認証機構を持っています。初回セットアップ時に管理者用デフォルト API を発行します。

1. セットアップした API サーバーの `/makeApiForAdmin.php`（例: `https://api.yourdomain.com/makeApiForAdmin.php`）にブラウザでアクセスします。
2. 初回アクセス時のみ MySQL の `api_list` テーブルにレコードが自動生成され、画面上に **API Token** と **AccessKey** が表示されます。
3. 表示された内容をコピーし、フロントエンドの `.env` の `NUXT_API_TOKEN` および `NUXT_API_ACCESSKEY` に貼り付けます。

> [!WARNING]
> AccessKey はハッシュ化されて保存されるため、画面を閉じると後から再確認できません。必ずメモを残してください。  
> 紛失した場合は、MySQL の `api_list` および `api_listForView` から `secretId='default'` の行を削除し、再度 `/makeApiForAdmin.php` にアクセスして再生成してください。

---

## 開発・コマンドリファレンス

`package.json` に定義されている開発・ビルドコマンド一覧です。

| コマンド                | 説明                                                                         |
| :---------------------- | :--------------------------------------------------------------------------- |
| `yarn dev`              | ローカル開発サーバーを起動（`http://localhost:10000`）                       |
| `yarn build`            | 本番用 Nuxt アプリケーションをビルド（SSR モード）                           |
| `yarn generate`         | 静的プリレンダリングを行い、`dist/` ディレクトリを生成（SPA / SSG）          |
| `yarn preview`          | `yarn build` または `yarn generate` で生成した成果物をローカルでプレビュー   |
| `yarn lint`             | ESLint によるコード静的解析・構文チェックを実行                              |
| `yarn typecheck`        | `nuxt typecheck` による TypeScript 型整合性チェックを実行                    |
| `yarn cap:sync`         | `nuxt generate` を実行後、成果物を Capacitor ネイティブプロジェクトに同期    |
| `yarn cap:open:android` | Android Studio を起動してネイティブプロジェクトを開く                        |
| `yarn cap:open:ios`     | Xcode を起動してネイティブプロジェクトを開く                                 |
| `yarn postinstall`      | `nuxt prepare` を実行し、Nuxt の型マッピングを生成（インストール時自動実行） |

---

## モバイルアプリ開発 (Capacitor 8)

Capacitor 8 を使用して、Web の資産を Android / iOS アプリとしてビルドできます。

### 1. ネイティブプラットフォームの初回追加

リポジトリクローン直後など、ネイティブフォルダ（`android/`, `ios/`）が存在しない場合は初回のみ追加コマンドを実行します。

```bash
# Android プラットフォームを追加
npx cap add android

# iOS プラットフォームを追加 (macOS のみ)
npx cap add ios
```

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

IDE が起動したら、エミュレータまたは実機を選択して実行・デバッグを行います。

### 4. アプリアイコン・スプラッシュ画面の生成

`assets/` ディレクトリ内の画像素材を元に、各プラットフォーム向けのアプリアイコンとスプラッシュ画面を自動生成できます。

```bash
npx @capacitor/assets generate
```

---

## PWA (Progressive Web Apps)

本プロジェクトは PWA（Progressive Web App）に対応しています。

- **Service Worker (`public/sw.js`)**:
  - 静的アセットのキャッシュ
  - WebPush プッシュ通知のバックグラウンド受信・通知バナーのタップハンドリング
- **Web App Manifest (`public/manifest.json`)**:
  - ホーム画面への追加（Standalone 起動対応）
  - 各種解像度（48px〜512px）の WebP アプリアイコン対応
- **Vercel リライト (`vercel.json`)**:
  - クライアントサイドルーティング（SPA / PWA）のための `index.html` フォールバックリライト設定済み

ブラウザでアクセスした際、アドレスバーやメニューから「ホーム画面に追加」または「アプリをインストール」を選択することで、ネイティブアプリ感覚で利用できます。

---

## バックエンド API エンドポイント一覧

PHP バックエンド（`php/`）に用意されている主なエンドポイントです。フロントエンドからは `app/js/ajaxFunctions.ts` を経由してリクエストが行われます。

| カテゴリ             | エンドポイント                  | 説明                                       |
| :------------------- | :------------------------------ | :----------------------------------------- |
| **認証・アカウント** | `loginAccount.php`              | ユーザーログイン認証（トークン発行）       |
|                      | `logoutAccount.php`             | ログアウト処理                             |
|                      | `authAccount.php`               | アクセストークンの妥当性検証               |
|                      | `createAccount.php`             | 新規アカウントの本登録                     |
|                      | `requestToken.php`              | 新規登録時のメール認証コード送信           |
| **パスワード**       | `requestTokenForgotAccount.php` | パスワードリセット用認証コード送信         |
|                      | `resetPassword.php`             | パスワードの再設定実行                     |
| **プロフィール**     | `getProfile.php`                | ユーザープロフィールの取得                 |
|                      | `updateProfile.php`             | プロフィール情報の更新（名前・自己紹介等） |
| **ソーシャル・友達** | `friendRequest.php`             | 友達申請の送信                             |
|                      | `acceptFriend.php`              | 友達申請の承認                             |
|                      | `getMyFriendList.php`           | 友達一覧・申請中リストの取得               |
| **プッシュ通知**     | `insertPushToken.php`           | WebPush 購読トークンの登録・更新           |
|                      | `deletePushToken.php`           | WebPush 購読トークンの解除                 |
|                      | `sendPushForAccount.php`        | 特定のユーザーへのプッシュ通知送信         |
|                      | `sendPushForMe.php`             | 自分宛てのテスト通知送信                   |
| **位置情報**         | `updateGeoLocation.php`         | ユーザーの位置情報（緯度・経度）更新       |
| **システム・管理**   | `makeApiForAdmin.php`           | 管理者用 API トークンの初期生成            |
|                      | `createTable.php`               | DB テーブル自動初期化                      |

---

## 主要な設定箇所

| 設定項目                    | 設定対象ファイル          | 内容                                                          |
| :-------------------------- | :------------------------ | :------------------------------------------------------------ |
| **Nuxt 全般・モジュール**   | `nuxt.config.ts`          | Nuxt 4 モード設定、i18n 言語設定、Vuetify 設定、OGP・メタタグ |
| **Capacitor モバイル設定**  | `capacitor.config.ts`     | App ID (`xyz.enoki.home`)、アプリ表示名、Web 出力先 (`dist`)  |
| **コンテンツ管理設定**      | `content.config.ts`       | `@nuxt/content` (v3) のコレクション定義                       |
| **コード規約・ESLint**      | `eslint.config.mjs`       | `@nuxt/eslint` のフラットコンフィグ設定                       |
| **テーマカラー・フォント**  | `app/app.vue`             | `--v-theme-primary: 225, 35, 120`、Zen Maru Gothic            |
| **環境変数 (フロント)**     | `.env` / `nuxt.config.ts` | WebPush キー、API ホスト、API トークン                        |
| **環境変数 (バックエンド)** | `env.php`                 | DB 接続情報、SMTP メールサーバー情報、WebPush 秘密鍵          |
| **PWA マニフェスト**        | `public/manifest.json`    | アプリ名称、テーマカラー、アイコン定義                        |

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
   - `NUXT_API_HOST`
4. ビルドコマンドは `yarn generate`（SPA/PWA 静的ホスティング）または `yarn build`（SSR ホスティング）を指定します。
   - 本リポジトリには `vercel.json` が含まれており、SPA / PWA 形式で安全に全ルートを `index.html` にフォールバックします。

### バックエンド (PHP / Apache / Nginx)

1. レンタルサーバーや VPS の任意のドメイン / サブドメインに `php/` 配下のファイル一式を配置します。
2. ルートディレクトリに `env.php` を配置し、DB・SMTP 接続情報を正しく設定します。
3. `database.sql` を MySQL にインポートします。
4. `/makeApiForAdmin.php` にアクセスし、生成されたトークンをフロントエンドの `.env` に反映します。

---

## 参考リンク・クレジット

- **運営・開発**: [エノキ電気 (ときえのき)](https://enoki.xyz)
- **公式ドキュメント**:
  - [Nuxt Documentation](https://nuxt.com/docs)
  - [Capacitor Documentation](https://capacitorjs.com/docs)
  - [Vuetify 3 Documentation](https://vuetifyjs.com/)
  - [Nuxt Content Documentation](https://content.nuxt.com/)
  - [Web Push Libs PHP](https://github.com/web-push-libs/web-push-php)
