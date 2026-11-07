-- ========================================================
-- アプリ・音楽の画像カラム拡張マイグレーションSQL
-- データベース名: qr4el_appcenter_9842 (MySQL)
-- 生成日時: 2026-11-08
-- 説明: アイコン・サムネイル・カバー画像を Base64 で保存した場合に
--       text 型 (最大64KB) を超えて登録に失敗するため mediumtext (最大16MB) へ拡張
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

ALTER TABLE `app_list`
  MODIFY `icon` mediumtext DEFAULT NULL COMMENT 'アプリアイコンURLまたはBase64',
  MODIFY `thumbnail` mediumtext DEFAULT NULL COMMENT 'サムネイル画像URLまたはBase64',
  MODIFY `images` mediumtext DEFAULT NULL COMMENT '紹介スクリーンショット画像URL一覧 (JSON配列)';

ALTER TABLE `music_list`
  MODIFY `cover` mediumtext DEFAULT NULL COMMENT 'カバーアート・ジャケット画像URLまたはBase64',
  MODIFY `icon` mediumtext DEFAULT NULL COMMENT '楽曲アイコンURL',
  MODIFY `thumbnail` mediumtext DEFAULT NULL COMMENT '楽曲サムネイル画像URL';

COMMIT;
