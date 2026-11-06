-- ========================================================
-- アプリ・音楽への未完成タグ・フラグ追加のための差分マイグレーションSQL
-- データベース名: qr4el_appcenter_9842 (MySQL)
-- 生成日時: 2026-11-06
-- 説明: アプリ・ゲームおよび音楽テーブルに未完成フラグ(isUnfinished)およびタグ(tags)カラムを追加
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- 1. app_list テーブルへのカラム追加
-- --------------------------------------------------------
ALTER TABLE `app_list`
  ADD `isUnfinished` tinyint(1) NOT NULL DEFAULT 0 COMMENT '未完成フラグ (1: 未完成, 0: 完成)' AFTER `featured`,
  ADD `tags` text DEFAULT NULL COMMENT 'タグ一覧 (JSON配列)' AFTER `isUnfinished`,
  ADD KEY `isUnfinished` (`isUnfinished`);

-- --------------------------------------------------------
-- 2. music_list テーブルへのカラム追加
-- --------------------------------------------------------
ALTER TABLE `music_list`
  ADD `isUnfinished` tinyint(1) NOT NULL DEFAULT 0 COMMENT '未完成フラグ (1: 未完成, 0: 完成)' AFTER `isTrending`,
  ADD `tags` text DEFAULT NULL COMMENT 'タグ一覧 (JSON配列)' AFTER `isUnfinished`,
  ADD KEY `isUnfinished` (`isUnfinished`);

COMMIT;
