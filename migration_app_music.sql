-- ========================================================
-- アプリ・音楽管理機能追加のための差分マイグレーションSQL
-- データベース名: qr4el_appcenter_9842 (MySQL)
-- 生成日時: 2026-11-05
-- 説明: 管理者によるアプリ登録・音楽登録（音声ファイルURL管理含む）用のテーブルを追加
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- 1. アプリ・ゲーム管理テーブル `app_list` の作成
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_list` (
  `appId` varchar(64) NOT NULL COMMENT 'アプリの一意な識別ID (URLスラッグ)',
  `name` varchar(255) NOT NULL COMMENT 'アプリ名',
  `type` varchar(32) NOT NULL DEFAULT 'app' COMMENT '種別 (app / game)',
  `category` varchar(64) DEFAULT NULL COMMENT 'カテゴリ・ジャンル',
  `price` int(11) NOT NULL DEFAULT 0 COMMENT '価格 (0は無料)',
  `icon` text DEFAULT NULL COMMENT 'アプリアイコンURLまたはBase64',
  `thumbnail` text DEFAULT NULL COMMENT 'サムネイル画像URLまたはBase64',
  `description` longtext DEFAULT NULL COMMENT '紹介文 (Markdown形式)',
  `summary` text DEFAULT NULL COMMENT '概要・キャッチコピー',
  `platforms` text DEFAULT NULL COMMENT '対応プラットフォーム (JSON配列)',
  `languages` text DEFAULT NULL COMMENT '使用言語 (JSON配列)',
  `links` text DEFAULT NULL COMMENT '外部リンク一覧 (JSON配列: text, icon, url)',
  `githubUrl` text DEFAULT NULL COMMENT 'GitHub リポジトリURL',
  `videoUrl` text DEFAULT NULL COMMENT '紹介動画 YouTube URL',
  `images` text DEFAULT NULL COMMENT '紹介スクリーンショット画像URL一覧 (JSON配列)',
  `rating` double NOT NULL DEFAULT 5.0 COMMENT '評価レーティング (1.0 - 5.0)',
  `downloads` varchar(32) NOT NULL DEFAULT 'NEW' COMMENT 'ダウンロード数表示用テキスト',
  `developer` varchar(255) DEFAULT 'エノキ電気' COMMENT '開発者・開発元名称',
  `featured` tinyint(1) NOT NULL DEFAULT 0 COMMENT '注目・ピックアップフラグ (1: 注目, 0: 通常)',
  `createdAt` int(11) NOT NULL COMMENT '登録日時 (unixtime秒)',
  `updatedAt` int(11) NOT NULL COMMENT '更新日時 (unixtime秒)',
  PRIMARY KEY (`appId`),
  KEY `type` (`type`),
  KEY `featured` (`featured`),
  KEY `createdAt` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='アプリ・ゲーム情報リスト';

-- --------------------------------------------------------
-- 2. 楽曲・音楽管理テーブル `music_list` の作成
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `music_list` (
  `musicId` varchar(64) NOT NULL COMMENT '楽曲の一意な識別ID (URLスラッグ)',
  `title` varchar(255) NOT NULL COMMENT '楽曲タイトル',
  `name` varchar(255) DEFAULT NULL COMMENT '楽曲表示名',
  `artist` varchar(255) NOT NULL COMMENT 'アーティスト名',
  `album` varchar(255) DEFAULT NULL COMMENT 'アルバム名',
  `albumType` varchar(32) NOT NULL DEFAULT 'single' COMMENT '作品種別 (single / album / ep)',
  `genre` varchar(64) NOT NULL DEFAULT '歌モノ' COMMENT 'ジャンル (歌モノ / インスト / AI楽曲等)',
  `bpm` int(11) NOT NULL DEFAULT 120 COMMENT 'テンポ (BPM)',
  `price` int(11) NOT NULL DEFAULT 0 COMMENT '価格 (0は無料)',
  `audioUrl` text DEFAULT NULL COMMENT 'サーバー上の音声ファイルURL (mp3 / wav / m4a等)',
  `cover` text DEFAULT NULL COMMENT 'カバーアート・ジャケット画像URLまたはBase64',
  `icon` text DEFAULT NULL COMMENT '楽曲アイコンURL',
  `thumbnail` text DEFAULT NULL COMMENT 'サムネイル画像URL',
  `duration` int(11) NOT NULL DEFAULT 180 COMMENT '楽曲の長さ (秒)',
  `durationFormatted` varchar(16) NOT NULL DEFAULT '3:00' COMMENT '楽曲の長さ (分:秒形式)',
  `releaseDate` bigint(20) NOT NULL COMMENT 'リリース日時 (ミリ秒unixtime)',
  `releaseDateFormatted` varchar(32) DEFAULT NULL COMMENT 'リリース日表示用文字列 (YYYY/MM/DD)',
  `plays` varchar(32) NOT NULL DEFAULT 'NEW' COMMENT '再生回数表示テキスト',
  `rating` double NOT NULL DEFAULT 5.0 COMMENT '評価レーティング (1.0 - 5.0)',
  `featured` tinyint(1) NOT NULL DEFAULT 0 COMMENT '注目・ピックアップ曲フラグ (1: 注目, 0: 通常)',
  `isTrending` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'トレンド曲フラグ (1: トレンド, 0: 通常)',
  `themeColor` varchar(32) NOT NULL DEFAULT '#4F46E5' COMMENT 'テーマカラーHEX',
  `accentColor` varchar(32) NOT NULL DEFAULT '#38BDF8' COMMENT 'アクセントカラーHEX',
  `audioPreset` varchar(32) NOT NULL DEFAULT 'citypop' COMMENT 'シンセプリセット名 (citypop, lofi, synthwave, piano等)',
  `description` text DEFAULT NULL COMMENT '楽曲解説・紹介文',
  `lyrics` longtext DEFAULT NULL COMMENT '歌詞 (LRCタイムタグまたはテキスト)',
  `composer` varchar(255) DEFAULT NULL COMMENT '作曲者名',
  `lyricist` varchar(255) DEFAULT NULL COMMENT '作詞者名',
  `createdAt` int(11) NOT NULL COMMENT '登録日時 (unixtime秒)',
  `updatedAt` int(11) NOT NULL COMMENT '更新日時 (unixtime秒)',
  PRIMARY KEY (`musicId`),
  KEY `genre` (`genre`),
  KEY `featured` (`featured`),
  KEY `isTrending` (`isTrending`),
  KEY `createdAt` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='楽曲・音楽情報リスト（音声ファイルURL含む）';

COMMIT;
