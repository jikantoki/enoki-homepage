-- ========================================================
-- 管理者機能追加のための差分マイグレーションSQL
-- データベース名: qr4el_appcenter_9842 (MySQL)
-- 生成日時: 2026-11-05
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- 1. user_list テーブルに role カラムを追加
-- --------------------------------------------------------
ALTER TABLE `user_list`
  ADD COLUMN `role` varchar(32) NOT NULL DEFAULT 'user' COMMENT 'ユーザー権限 (admin / user)'
  AFTER `status`;

-- --------------------------------------------------------
-- 2. 各種 VIEW の再作成（role カラムをビューに含める）
-- --------------------------------------------------------

-- プロフィール表示用ビューの更新
CREATE OR REPLACE VIEW `USER_PROFILE_VIEW` AS
SELECT
  `user_list`.`secretId` AS `secretId`,
  `user_list`.`userId` AS `userId`,
  `user_list`.`createdAt` AS `createdAt`,
  `user_list`.`status` AS `status`,
  `user_list`.`role` AS `role`,
  `user_profile_list`.`icon` AS `icon`,
  `user_profile_list`.`coverImg` AS `coverImg`,
  `user_profile_list`.`name` AS `name`,
  `user_profile_list`.`message` AS `message`
FROM (`user_list` JOIN `user_profile_list`)
WHERE (`user_list`.`secretId` = `user_profile_list`.`secretId`);

-- トークン認証用ビューの更新
CREATE OR REPLACE VIEW `USER_TOKEN_VIEW` AS
SELECT
  `user_list`.`secretId` AS `secretId`,
  `user_list`.`userId` AS `userId`,
  `user_list`.`createdAt` AS `userCreatedAt`,
  `user_list`.`status` AS `status`,
  `user_list`.`role` AS `role`,
  `user_accesstoken_list`.`token` AS `token`,
  `user_accesstoken_list`.`createdAt` AS `tokenCreatedAt`
FROM (`user_list` JOIN `user_accesstoken_list`)
WHERE (`user_list`.`secretId` = `user_accesstoken_list`.`secretId`);

-- メールアドレス確認用ビューの更新
CREATE OR REPLACE VIEW `USER_MAIL_VIEW` AS
SELECT
  `user_list`.`secretId` AS `secretId`,
  `user_list`.`userId` AS `userId`,
  `user_list`.`createdAt` AS `createdAt`,
  `user_list`.`status` AS `status`,
  `user_list`.`role` AS `role`,
  `user_mail_list`.`mailAddress` AS `mailAddress`,
  `user_mail_list`.`status` AS `mailStatus`,
  `user_mail_list`.`token` AS `mailToken`
FROM (`user_mail_list` JOIN `user_list`)
WHERE (`user_mail_list`.`secretId` = `user_list`.`secretId`);

-- --------------------------------------------------------
-- 3. (参考) 既存のユーザーを管理者に昇格させる場合
-- --------------------------------------------------------
-- もし既に存在する特定アカウントを管理者にする場合は下記コメントを解除して実行してください:
-- UPDATE `user_list` SET `role` = 'admin', `status` = 'admin' WHERE `userId` = '対象のユーザーID';

COMMIT;
