-- ========================================================
-- アプリカテゴリ刷新マイグレーションSQL
-- 新カテゴリ一覧: ゲーム, メディア, ポータルサイト, 便利ツール, ソーシャル, Mod・拡張機能, 開発, その他
-- 生成日時: 2026-11-09
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- 1. 既存 app_list レコードの旧カテゴリを新カテゴリに移行・更新
-- --------------------------------------------------------

-- 「ゲーム」への移行 (RPG, アクション, パズル, シミュレーション, 音楽ゲーム, レース, ストラテジー, アドベンチャー, カジュアル, テーブル, エンタメ等)
UPDATE `app_list` SET `category` = 'ゲーム'
  WHERE `category` IN ('RPG', 'アクション', 'パズル', 'シミュレーション', '音楽ゲーム', 'レース', 'ストラテジー', 'アドベンチャー', 'カジュアル', 'テーブル', 'エンタメ')
     OR (`type` = 'game' AND (`category` IS NULL OR `category` NOT IN ('ゲーム', 'メディア', 'ポータルサイト', '便利ツール', 'ソーシャル', 'Mod・拡張機能', '開発', 'その他')));

-- 「メディア」への移行 (写真, 動画再生＆編集, 音楽＆オーディオ, マンガ＆書籍, 音楽)
UPDATE `app_list` SET `category` = 'メディア'
  WHERE `category` IN ('写真', '動画再生＆編集', '音楽＆オーディオ', 'マンガ＆書籍', '音楽');

-- 「ポータルサイト」への移行 (天気, 防災, ポータル)
UPDATE `app_list` SET `category` = 'ポータルサイト'
  WHERE `category` IN ('ポータルサイト', 'ポータル', '天気');

-- 「便利ツール」への移行 (ツール, ユーティリティ, 仕事効率化, ファイナンス, ビジネス, 健康＆フィットネス)
UPDATE `app_list` SET `category` = '便利ツール'
  WHERE `category` IN ('ツール', 'ユーティリティ', '仕事効率化', 'ファイナンス', 'ビジネス', '生産性');

-- 「ソーシャル」への移行 (通信, ソーシャル)
UPDATE `app_list` SET `category` = 'ソーシャル'
  WHERE `category` IN ('ソーシャル', '通信');

-- 「開発」への移行 (教育, プログラミング, 開発)
UPDATE `app_list` SET `category` = '開発'
  WHERE `category` IN ('教育', 'プログラミング', '開発');

-- 「Mod・拡張機能」への移行
UPDATE `app_list` SET `category` = 'Mod・拡張機能'
  WHERE `category` IN ('Mod', '拡張機能', 'Mod・拡張機能');

-- 「その他」への移行 (ライフスタイル, 健康＆フィットネス, 未知カテゴリ, NULL)
UPDATE `app_list` SET `category` = 'その他'
  WHERE `category` IN ('ライフスタイル', '健康＆フィットネス', 'アート＆デザイン')
     OR `category` IS NULL
     OR `category` NOT IN ('ゲーム', 'メディア', 'ポータルサイト', '便利ツール', 'ソーシャル', 'Mod・拡張機能', '開発', 'その他');

-- --------------------------------------------------------
-- 2. 新カテゴリに合わせたモックデータ（100件）の投入 / 更新
-- --------------------------------------------------------
INSERT INTO `app_list` (
  `appId`, `name`, `type`, `category`, `price`, `icon`, `thumbnail`,
  `description`, `summary`, `platforms`, `languages`, `links`,
  `githubUrl`, `videoUrl`, `images`, `rating`, `downloads`, `developer`,
  `featured`, `isUnfinished`, `tags`, `createdAt`, `updatedAt`
) VALUES
  ('stella-chronicle', 'ステラクロニクル 救世の星', 'game', 'ゲーム', 0, '/uploads/images/apps/stella-chronicle_icon.svg', '/uploads/images/apps/stella-chronicle_thumb.svg', '### ステラクロニクル 救世の星 について

**ステラクロニクル 救世の星** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ステラクロニクル 救世の星で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.stella-chronicle"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000000"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/stella-chronicle"}]', 'https://github.com/jikantoki/stella-chronicle', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/stella-chronicle_screen_1.svg","/uploads/images/apps/stella-chronicle_screen_2.svg","/uploads/images/apps/stella-chronicle_screen_3.svg"]', 4.8, '500万+', 'Enoki Interactive', 1, 0, '[]', 1765563134, 1765563134),
  ('cyberblade-2088', 'サイバーブレード 2088', 'game', 'ゲーム', 480, '/uploads/images/apps/cyberblade-2088_icon.svg', '/uploads/images/apps/cyberblade-2088_thumb.svg', '### サイバーブレード 2088 について

**サイバーブレード 2088** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！サイバーブレード 2088で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.cyberblade-2088"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000001"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/cyberblade-2088"}]', NULL, NULL, '["/uploads/images/apps/cyberblade-2088_screen_1.svg","/uploads/images/apps/cyberblade-2088_screen_2.svg","/uploads/images/apps/cyberblade-2088_screen_3.svg"]', 4.7, '100万+', 'Pixel Forge Studio', 1, 0, '[]', 1781566305, 1781566305),
  ('jewel-blast-pop', 'ジュエルブラスト ポップ！', 'game', 'ゲーム', 0, '/uploads/images/apps/jewel-blast-pop_icon.svg', '/uploads/images/apps/jewel-blast-pop_thumb.svg', '### ジュエルブラスト ポップ！ について

**ジュエルブラスト ポップ！** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ジュエルブラスト ポップ！で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.jewel-blast-pop"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000002"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/jewel-blast-pop"}]', NULL, NULL, '["/uploads/images/apps/jewel-blast-pop_screen_1.svg","/uploads/images/apps/jewel-blast-pop_screen_2.svg","/uploads/images/apps/jewel-blast-pop_screen_3.svg"]', 4.6, '1000万+', 'Hypernova Lab', 1, 0, '[]', 1751004650, 1751004650),
  ('beat-wave-3d', 'ビートウェーブ 3D Rhythm', 'game', 'ゲーム', 0, '/uploads/images/apps/beat-wave-3d_icon.svg', '/uploads/images/apps/beat-wave-3d_thumb.svg', '### ビートウェーブ 3D Rhythm について

**ビートウェーブ 3D Rhythm** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ビートウェーブ 3D Rhythmで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.beat-wave-3d"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000003"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/beat-wave-3d"}]', 'https://github.com/jikantoki/beat-wave-3d', NULL, '["/uploads/images/apps/beat-wave-3d_screen_1.svg","/uploads/images/apps/beat-wave-3d_screen_2.svg","/uploads/images/apps/beat-wave-3d_screen_3.svg"]', 4.9, '200万+', 'Komorebi Soft', 1, 0, '[]', 1745569830, 1745569830),
  ('nitro-racers-overdrive', 'ニトロ・レーサーズ Overdrive', 'game', 'ゲーム', 0, '/uploads/images/apps/nitro-racers-overdrive_icon.svg', '/uploads/images/apps/nitro-racers-overdrive_thumb.svg', '### ニトロ・レーサーズ Overdrive について

**ニトロ・レーサーズ Overdrive** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ニトロ・レーサーズ Overdriveで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.nitro-racers-overdrive"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000004"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/nitro-racers-overdrive"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/nitro-racers-overdrive_screen_1.svg","/uploads/images/apps/nitro-racers-overdrive_screen_2.svg","/uploads/images/apps/nitro-racers-overdrive_screen_3.svg"]', 4.5, '500万+', 'Aether Works', 0, 0, '[]', 1759713210, 1759713210),
  ('kingdom-tactics', 'キングダム・タクティクス 王権', 'game', 'ゲーム', 0, '/uploads/images/apps/kingdom-tactics_icon.svg', '/uploads/images/apps/kingdom-tactics_thumb.svg', '### キングダム・タクティクス 王権 について

**キングダム・タクティクス 王権** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！キングダム・タクティクス 王権で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.kingdom-tactics"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000005"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/kingdom-tactics"}]', NULL, NULL, '["/uploads/images/apps/kingdom-tactics_screen_1.svg","/uploads/images/apps/kingdom-tactics_screen_2.svg","/uploads/images/apps/kingdom-tactics_screen_3.svg"]', 4.4, '300万+', 'Nexus Digital', 0, 0, '[]', 1754310104, 1754310104),
  ('space-colony-2200', 'スペースコロニー計画 2200', 'game', 'ゲーム', 650, '/uploads/images/apps/space-colony-2200_icon.svg', '/uploads/images/apps/space-colony-2200_thumb.svg', '### スペースコロニー計画 2200 について

**スペースコロニー計画 2200** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！スペースコロニー計画 2200で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.space-colony-2200"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000006"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/space-colony-2200"}]', 'https://github.com/jikantoki/space-colony-2200', NULL, '["/uploads/images/apps/space-colony-2200_screen_1.svg","/uploads/images/apps/space-colony-2200_screen_2.svg","/uploads/images/apps/space-colony-2200_screen_3.svg"]', 4.8, '50万+', 'Enoki Interactive', 0, 0, '[]', 1755881530, 1755881530),
  ('dungeon-diver-deep', 'ダンジョン・ダイバー 迷宮深層', 'game', 'ゲーム', 0, '/uploads/images/apps/dungeon-diver-deep_icon.svg', '/uploads/images/apps/dungeon-diver-deep_thumb.svg', '### ダンジョン・ダイバー 迷宮深層 について

**ダンジョン・ダイバー 迷宮深層** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ダンジョン・ダイバー 迷宮深層で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.dungeon-diver-deep"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000007"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/dungeon-diver-deep"}]', NULL, NULL, '["/uploads/images/apps/dungeon-diver-deep_screen_1.svg","/uploads/images/apps/dungeon-diver-deep_screen_2.svg","/uploads/images/apps/dungeon-diver-deep_screen_3.svg"]', 4.5, '150万+', 'Pixel Forge Studio', 0, 0, '[]', 1752200742, 1752200742),
  ('shadow-dash-ninja', 'シャドウダッシュ 忍道', 'game', 'ゲーム', 0, '/uploads/images/apps/shadow-dash-ninja_icon.svg', '/uploads/images/apps/shadow-dash-ninja_thumb.svg', '### シャドウダッシュ 忍道 について

**シャドウダッシュ 忍道** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！シャドウダッシュ 忍道で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.shadow-dash-ninja"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000008"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/shadow-dash-ninja"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/shadow-dash-ninja_screen_1.svg","/uploads/images/apps/shadow-dash-ninja_screen_2.svg","/uploads/images/apps/shadow-dash-ninja_screen_3.svg"]', 4.6, '400万+', 'Hypernova Lab', 0, 0, '[]', 1756874561, 1756874561),
  ('my-cafe-life', 'マイ・カフェ・ライフ 癒しの時間', 'game', 'ゲーム', 0, '/uploads/images/apps/my-cafe-life_icon.svg', '/uploads/images/apps/my-cafe-life_thumb.svg', '### マイ・カフェ・ライフ 癒しの時間 について

**マイ・カフェ・ライフ 癒しの時間** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！マイ・カフェ・ライフ 癒しの時間で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.my-cafe-life"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000009"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/my-cafe-life"}]', 'https://github.com/jikantoki/my-cafe-life', NULL, '["/uploads/images/apps/my-cafe-life_screen_1.svg","/uploads/images/apps/my-cafe-life_screen_2.svg","/uploads/images/apps/my-cafe-life_screen_3.svg"]', 4.7, '800万+', 'Komorebi Soft', 0, 0, '[]', 1773280803, 1773280803),
  ('galaxy-wars-fleet', 'ギャラクシー・ウォーズ 艦隊戦', 'game', 'ゲーム', 0, '/uploads/images/apps/galaxy-wars-fleet_icon.svg', '/uploads/images/apps/galaxy-wars-fleet_thumb.svg', '### ギャラクシー・ウォーズ 艦隊戦 について

**ギャラクシー・ウォーズ 艦隊戦** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ギャラクシー・ウォーズ 艦隊戦で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.galaxy-wars-fleet"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000010"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/galaxy-wars-fleet"}]', NULL, NULL, '["/uploads/images/apps/galaxy-wars-fleet_screen_1.svg","/uploads/images/apps/galaxy-wars-fleet_screen_2.svg","/uploads/images/apps/galaxy-wars-fleet_screen_3.svg"]', 4.3, '120万+', 'Aether Works', 0, 0, '[]', 1737896305, 1737896305),
  ('block-connect-brain', 'ブロックコネクト 脳トレパズル', 'game', 'ゲーム', 0, '/uploads/images/apps/block-connect-brain_icon.svg', '/uploads/images/apps/block-connect-brain_thumb.svg', '### ブロックコネクト 脳トレパズル について

**ブロックコネクト 脳トレパズル** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ブロックコネクト 脳トレパズルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.block-connect-brain"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000011"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/block-connect-brain"}]', NULL, NULL, '["/uploads/images/apps/block-connect-brain_screen_1.svg","/uploads/images/apps/block-connect-brain_screen_2.svg","/uploads/images/apps/block-connect-brain_screen_3.svg"]', 4.5, '600万+', 'Nexus Digital', 0, 0, '[]', 1761793039, 1761793039),
  ('rhythm-sinfonia', 'リズム・シンフォニア 古代の旋律', 'game', 'ゲーム', 320, '/uploads/images/apps/rhythm-sinfonia_icon.svg', '/uploads/images/apps/rhythm-sinfonia_thumb.svg', '### リズム・シンフォニア 古代の旋律 について

**リズム・シンフォニア 古代の旋律** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！リズム・シンフォニア 古代の旋律で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.rhythm-sinfonia"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000012"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/rhythm-sinfonia"}]', 'https://github.com/jikantoki/rhythm-sinfonia', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/rhythm-sinfonia_screen_1.svg","/uploads/images/apps/rhythm-sinfonia_screen_2.svg","/uploads/images/apps/rhythm-sinfonia_screen_3.svg"]', 4.9, '80万+', 'Enoki Interactive', 0, 0, '[]', 1767336351, 1767336351),
  ('drift-master-tokyo', 'ドリフト・マスター TOKYO', 'game', 'ゲーム', 0, '/uploads/images/apps/drift-master-tokyo_icon.svg', '/uploads/images/apps/drift-master-tokyo_thumb.svg', '### ドリフト・マスター TOKYO について

**ドリフト・マスター TOKYO** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ドリフト・マスター TOKYOで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.drift-master-tokyo"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000013"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/drift-master-tokyo"}]', NULL, NULL, '["/uploads/images/apps/drift-master-tokyo_screen_1.svg","/uploads/images/apps/drift-master-tokyo_screen_2.svg","/uploads/images/apps/drift-master-tokyo_screen_3.svg"]', 4.4, '250万+', 'Pixel Forge Studio', 0, 0, '[]', 1748447364, 1748447364),
  ('tower-defense-zero', 'タワーディフェンス Zero', 'game', 'ゲーム', 0, '/uploads/images/apps/tower-defense-zero_icon.svg', '/uploads/images/apps/tower-defense-zero_thumb.svg', '### タワーディフェンス Zero について

**タワーディフェンス Zero** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！タワーディフェンス Zeroで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.tower-defense-zero"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000014"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/tower-defense-zero"}]', NULL, NULL, '["/uploads/images/apps/tower-defense-zero_screen_1.svg","/uploads/images/apps/tower-defense-zero_screen_2.svg","/uploads/images/apps/tower-defense-zero_screen_3.svg"]', 4.6, '350万+', 'Hypernova Lab', 0, 0, '[]', 1748212611, 1748212611),
  ('dragons-legacy', 'ドラゴンズ・レガシー 竜血の絆', 'game', 'ゲーム', 0, '/uploads/images/apps/dragons-legacy_icon.svg', '/uploads/images/apps/dragons-legacy_thumb.svg', '### ドラゴンズ・レガシー 竜血の絆 について

**ドラゴンズ・レガシー 竜血の絆** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ドラゴンズ・レガシー 竜血の絆で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.dragons-legacy"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000015"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/dragons-legacy"}]', 'https://github.com/jikantoki/dragons-legacy', NULL, '["/uploads/images/apps/dragons-legacy_screen_1.svg","/uploads/images/apps/dragons-legacy_screen_2.svg","/uploads/images/apps/dragons-legacy_screen_3.svg"]', 4.7, '700万+', 'Komorebi Soft', 0, 0, '[]', 1782929525, 1782929525),
  ('mecha-battlers-arena', 'メカ・バトラーズ アリーナ', 'game', 'ゲーム', 0, '/uploads/images/apps/mecha-battlers-arena_icon.svg', '/uploads/images/apps/mecha-battlers-arena_thumb.svg', '### メカ・バトラーズ アリーナ について

**メカ・バトラーズ アリーナ** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！メカ・バトラーズ アリーナで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.mecha-battlers-arena"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000016"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/mecha-battlers-arena"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/mecha-battlers-arena_screen_1.svg","/uploads/images/apps/mecha-battlers-arena_screen_2.svg","/uploads/images/apps/mecha-battlers-arena_screen_3.svg"]', 4.4, '180万+', 'Aether Works', 0, 0, '[]', 1751678803, 1751678803),
  ('penguin-island-garden', 'ペンギン・アイランド 放置庭園', 'game', 'ゲーム', 0, '/uploads/images/apps/penguin-island-garden_icon.svg', '/uploads/images/apps/penguin-island-garden_thumb.svg', '### ペンギン・アイランド 放置庭園 について

**ペンギン・アイランド 放置庭園** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ペンギン・アイランド 放置庭園で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.penguin-island-garden"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000017"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/penguin-island-garden"}]', NULL, NULL, '["/uploads/images/apps/penguin-island-garden_screen_1.svg","/uploads/images/apps/penguin-island-garden_screen_2.svg","/uploads/images/apps/penguin-island-garden_screen_3.svg"]', 4.8, '900万+', 'Nexus Digital', 0, 0, '[]', 1790212113, 1790212113),
  ('number-puzzle-cross', '数字パズル クロス 1000問', 'game', 'ゲーム', 0, '/uploads/images/apps/number-puzzle-cross_icon.svg', '/uploads/images/apps/number-puzzle-cross_thumb.svg', '### 数字パズル クロス 1000問 について

**数字パズル クロス 1000問** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！数字パズル クロス 1000問で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.number-puzzle-cross"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000018"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/number-puzzle-cross"}]', 'https://github.com/jikantoki/number-puzzle-cross', NULL, '["/uploads/images/apps/number-puzzle-cross_screen_1.svg","/uploads/images/apps/number-puzzle-cross_screen_2.svg","/uploads/images/apps/number-puzzle-cross_screen_3.svg"]', 4.3, '300万+', 'Enoki Interactive', 0, 0, '[]', 1754738649, 1754738649),
  ('techno-step-arcade', 'テクノステップ アーケード', 'game', 'ゲーム', 0, '/uploads/images/apps/techno-step-arcade_icon.svg', '/uploads/images/apps/techno-step-arcade_thumb.svg', '### テクノステップ アーケード について

**テクノステップ アーケード** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！テクノステップ アーケードで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.techno-step-arcade"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000019"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/techno-step-arcade"}]', NULL, NULL, '["/uploads/images/apps/techno-step-arcade_screen_1.svg","/uploads/images/apps/techno-step-arcade_screen_2.svg","/uploads/images/apps/techno-step-arcade_screen_3.svg"]', 4.5, '100万+', 'Pixel Forge Studio', 0, 0, '[]', 1743722940, 1743722940),
  ('mini-kart-grand-prix', 'ミニカート・グランプリ DX', 'game', 'ゲーム', 250, '/uploads/images/apps/mini-kart-grand-prix_icon.svg', '/uploads/images/apps/mini-kart-grand-prix_thumb.svg', '### ミニカート・グランプリ DX について

**ミニカート・グランプリ DX** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ミニカート・グランプリ DXで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.mini-kart-grand-prix"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000020"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/mini-kart-grand-prix"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/mini-kart-grand-prix_screen_1.svg","/uploads/images/apps/mini-kart-grand-prix_screen_2.svg","/uploads/images/apps/mini-kart-grand-prix_screen_3.svg"]', 4.6, '60万+', 'Hypernova Lab', 0, 0, '[]', 1741853414, 1741853414),
  ('aether-fantasy-beast', 'エーテルファンタジー 幻獣契約', 'game', 'ゲーム', 0, '/uploads/images/apps/aether-fantasy-beast_icon.svg', '/uploads/images/apps/aether-fantasy-beast_thumb.svg', '### エーテルファンタジー 幻獣契約 について

**エーテルファンタジー 幻獣契約** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！エーテルファンタジー 幻獣契約で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.aether-fantasy-beast"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000021"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/aether-fantasy-beast"}]', 'https://github.com/jikantoki/aether-fantasy-beast', NULL, '["/uploads/images/apps/aether-fantasy-beast_screen_1.svg","/uploads/images/apps/aether-fantasy-beast_screen_2.svg","/uploads/images/apps/aether-fantasy-beast_screen_3.svg"]', 4.7, '450万+', 'Komorebi Soft', 0, 0, '[]', 1781380097, 1781380097),
  ('speed-storm-fist', 'スピードストーム 疾風の拳', 'game', 'ゲーム', 0, '/uploads/images/apps/speed-storm-fist_icon.svg', '/uploads/images/apps/speed-storm-fist_thumb.svg', '### スピードストーム 疾風の拳 について

**スピードストーム 疾風の拳** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！スピードストーム 疾風の拳で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.speed-storm-fist"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000022"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/speed-storm-fist"}]', NULL, NULL, '["/uploads/images/apps/speed-storm-fist_screen_1.svg","/uploads/images/apps/speed-storm-fist_screen_2.svg","/uploads/images/apps/speed-storm-fist_screen_3.svg"]', 4.3, '140万+', 'Aether Works', 0, 0, '[]', 1771679594, 1771679594),
  ('farm-harvest-seasons', 'ファーム・ハーベスト 四季の村', 'game', 'ゲーム', 0, '/uploads/images/apps/farm-harvest-seasons_icon.svg', '/uploads/images/apps/farm-harvest-seasons_thumb.svg', '### ファーム・ハーベスト 四季の村 について

**ファーム・ハーベスト 四季の村** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ファーム・ハーベスト 四季の村で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.farm-harvest-seasons"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000023"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/farm-harvest-seasons"}]', NULL, NULL, '["/uploads/images/apps/farm-harvest-seasons_screen_1.svg","/uploads/images/apps/farm-harvest-seasons_screen_2.svg","/uploads/images/apps/farm-harvest-seasons_screen_3.svg"]', 4.6, '550万+', 'Nexus Digital', 0, 0, '[]', 1749182758, 1749182758),
  ('war-of-empire-reign', 'ウォー・オブ・エンパイア 覇権', 'game', 'ゲーム', 0, '/uploads/images/apps/war-of-empire-reign_icon.svg', '/uploads/images/apps/war-of-empire-reign_thumb.svg', '### ウォー・オブ・エンパイア 覇権 について

**ウォー・オブ・エンパイア 覇権** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ウォー・オブ・エンパイア 覇権で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.war-of-empire-reign"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000024"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/war-of-empire-reign"}]', 'https://github.com/jikantoki/war-of-empire-reign', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/war-of-empire-reign_screen_1.svg","/uploads/images/apps/war-of-empire-reign_screen_2.svg","/uploads/images/apps/war-of-empire-reign_screen_3.svg"]', 4.2, '200万+', 'Enoki Interactive', 0, 0, '[]', 1786105589, 1786105589),
  ('physics-sandbox-play', '物理の箱庭 サンドボックス', 'game', 'ゲーム', 390, '/uploads/images/apps/physics-sandbox-play_icon.svg', '/uploads/images/apps/physics-sandbox-play_thumb.svg', '### 物理の箱庭 サンドボックス について

**物理の箱庭 サンドボックス** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！物理の箱庭 サンドボックスで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.physics-sandbox-play"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000025"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/physics-sandbox-play"}]', NULL, NULL, '["/uploads/images/apps/physics-sandbox-play_screen_1.svg","/uploads/images/apps/physics-sandbox-play_screen_2.svg","/uploads/images/apps/physics-sandbox-play_screen_3.svg"]', 4.8, '90万+', 'Pixel Forge Studio', 0, 0, '[]', 1788304084, 1788304084),
  ('piano-melody-tiles', 'ピアノ・メロディ・タイル', 'game', 'ゲーム', 0, '/uploads/images/apps/piano-melody-tiles_icon.svg', '/uploads/images/apps/piano-melody-tiles_thumb.svg', '### ピアノ・メロディ・タイル について

**ピアノ・メロディ・タイル** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ピアノ・メロディ・タイルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.piano-melody-tiles"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000026"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/piano-melody-tiles"}]', NULL, NULL, '["/uploads/images/apps/piano-melody-tiles_screen_1.svg","/uploads/images/apps/piano-melody-tiles_screen_2.svg","/uploads/images/apps/piano-melody-tiles_screen_3.svg"]', 4.4, '1500万+', 'Hypernova Lab', 0, 0, '[]', 1767156617, 1767156617),
  ('highway-chase-police', 'ハイウェイ・チェイス 警視庁', 'game', 'ゲーム', 0, '/uploads/images/apps/highway-chase-police_icon.svg', '/uploads/images/apps/highway-chase-police_thumb.svg', '### ハイウェイ・チェイス 警視庁 について

**ハイウェイ・チェイス 警視庁** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ハイウェイ・チェイス 警視庁で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.highway-chase-police"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000027"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/highway-chase-police"}]', 'https://github.com/jikantoki/highway-chase-police', NULL, '["/uploads/images/apps/highway-chase-police_screen_1.svg","/uploads/images/apps/highway-chase-police_screen_2.svg","/uploads/images/apps/highway-chase-police_screen_3.svg"]', 4.3, '110万+', 'Komorebi Soft', 0, 0, '[]', 1742451287, 1742451287),
  ('starfall-adventurers', '星降る夜の冒険者たち', 'game', 'ゲーム', 0, '/uploads/images/apps/starfall-adventurers_icon.svg', '/uploads/images/apps/starfall-adventurers_thumb.svg', '### 星降る夜の冒険者たち について

**星降る夜の冒険者たち** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！星降る夜の冒険者たちで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.starfall-adventurers"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000028"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/starfall-adventurers"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/starfall-adventurers_screen_1.svg","/uploads/images/apps/starfall-adventurers_screen_2.svg","/uploads/images/apps/starfall-adventurers_screen_3.svg"]', 4.8, '320万+', 'Aether Works', 0, 0, '[]', 1769131400, 1769131400),
  ('monster-hunter-soul', 'モンスターハンター ソウル', 'game', 'ゲーム', 0, '/uploads/images/apps/monster-hunter-soul_icon.svg', '/uploads/images/apps/monster-hunter-soul_thumb.svg', '### モンスターハンター ソウル について

**モンスターハンター ソウル** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！モンスターハンター ソウルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.monster-hunter-soul"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000029"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/monster-hunter-soul"}]', NULL, NULL, '["/uploads/images/apps/monster-hunter-soul_screen_1.svg","/uploads/images/apps/monster-hunter-soul_screen_2.svg","/uploads/images/apps/monster-hunter-soul_screen_3.svg"]', 4.6, '600万+', 'Nexus Digital', 0, 0, '[]', 1776709976, 1776709976),
  ('train-tycoon-railway', 'トレイン・タイクーン 鉄道王', 'game', 'ゲーム', 0, '/uploads/images/apps/train-tycoon-railway_icon.svg', '/uploads/images/apps/train-tycoon-railway_thumb.svg', '### トレイン・タイクーン 鉄道王 について

**トレイン・タイクーン 鉄道王** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！トレイン・タイクーン 鉄道王で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.train-tycoon-railway"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000030"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/train-tycoon-railway"}]', 'https://github.com/jikantoki/train-tycoon-railway', NULL, '["/uploads/images/apps/train-tycoon-railway_screen_1.svg","/uploads/images/apps/train-tycoon-railway_screen_2.svg","/uploads/images/apps/train-tycoon-railway_screen_3.svg"]', 4.5, '170万+', 'Enoki Interactive', 0, 0, '[]', 1748127688, 1748127688),
  ('craft-survival-island', 'クラフト・サバイバル 孤島', 'game', 'ゲーム', 540, '/uploads/images/apps/craft-survival-island_icon.svg', '/uploads/images/apps/craft-survival-island_thumb.svg', '### クラフト・サバイバル 孤島 について

**クラフト・サバイバル 孤島** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！クラフト・サバイバル 孤島で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.craft-survival-island"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000031"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/craft-survival-island"}]', NULL, NULL, '["/uploads/images/apps/craft-survival-island_screen_1.svg","/uploads/images/apps/craft-survival-island_screen_2.svg","/uploads/images/apps/craft-survival-island_screen_3.svg"]', 4.7, '120万+', 'Pixel Forge Studio', 0, 0, '[]', 1791187724, 1791187724),
  ('color-sort-ball-puzzle', 'カラーソート ボールパズル', 'game', 'ゲーム', 0, '/uploads/images/apps/color-sort-ball-puzzle_icon.svg', '/uploads/images/apps/color-sort-ball-puzzle_thumb.svg', '### カラーソート ボールパズル について

**カラーソート ボールパズル** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！カラーソート ボールパズルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.color-sort-ball-puzzle"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000032"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/color-sort-ball-puzzle"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/color-sort-ball-puzzle_screen_1.svg","/uploads/images/apps/color-sort-ball-puzzle_screen_2.svg","/uploads/images/apps/color-sort-ball-puzzle_screen_3.svg"]', 4.5, '800万+', 'Hypernova Lab', 0, 0, '[]', 1784077596, 1784077596),
  ('electro-groove-dj', 'エレクトロ・グルーヴ DJ', 'game', 'ゲーム', 0, '/uploads/images/apps/electro-groove-dj_icon.svg', '/uploads/images/apps/electro-groove-dj_thumb.svg', '### エレクトロ・グルーヴ DJ について

**エレクトロ・グルーヴ DJ** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！エレクトロ・グルーヴ DJで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.electro-groove-dj"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000033"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/electro-groove-dj"}]', 'https://github.com/jikantoki/electro-groove-dj', NULL, '["/uploads/images/apps/electro-groove-dj_screen_1.svg","/uploads/images/apps/electro-groove-dj_screen_2.svg","/uploads/images/apps/electro-groove-dj_screen_3.svg"]', 4.4, '70万+', 'Komorebi Soft', 0, 0, '[]', 1751669382, 1751669382),
  ('offroad-climber-4x4', 'オフロード・クライマー 4x4', 'game', 'ゲーム', 0, '/uploads/images/apps/offroad-climber-4x4_icon.svg', '/uploads/images/apps/offroad-climber-4x4_thumb.svg', '### オフロード・クライマー 4x4 について

**オフロード・クライマー 4x4** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！オフロード・クライマー 4x4で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.offroad-climber-4x4"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000034"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/offroad-climber-4x4"}]', NULL, NULL, '["/uploads/images/apps/offroad-climber-4x4_screen_1.svg","/uploads/images/apps/offroad-climber-4x4_screen_2.svg","/uploads/images/apps/offroad-climber-4x4_screen_3.svg"]', 4.2, '220万+', 'Aether Works', 0, 0, '[]', 1766776586, 1766776586),
  ('abyss-knights-order', 'アビス・ナイツ 深淵の騎士', 'game', 'ゲーム', 0, '/uploads/images/apps/abyss-knights-order_icon.svg', '/uploads/images/apps/abyss-knights-order_thumb.svg', '### アビス・ナイツ 深淵の騎士 について

**アビス・ナイツ 深淵の騎士** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！アビス・ナイツ 深淵の騎士で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.abyss-knights-order"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000035"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/abyss-knights-order"}]', NULL, NULL, '["/uploads/images/apps/abyss-knights-order_screen_1.svg","/uploads/images/apps/abyss-knights-order_screen_2.svg","/uploads/images/apps/abyss-knights-order_screen_3.svg"]', 4.7, '280万+', 'Nexus Digital', 0, 0, '[]', 1771680149, 1771680149),
  ('archery-king-3d', 'アーチェリー・キング 3D', 'game', 'ゲーム', 0, '/uploads/images/apps/archery-king-3d_icon.svg', '/uploads/images/apps/archery-king-3d_thumb.svg', '### アーチェリー・キング 3D について

**アーチェリー・キング 3D** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！アーチェリー・キング 3Dで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.archery-king-3d"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000036"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/archery-king-3d"}]', 'https://github.com/jikantoki/archery-king-3d', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/archery-king-3d_screen_1.svg","/uploads/images/apps/archery-king-3d_screen_2.svg","/uploads/images/apps/archery-king-3d_screen_3.svg"]', 4.3, '400万+', 'Enoki Interactive', 0, 0, '[]', 1791638723, 1791638723),
  ('aquarium-dream-world', 'アクアリウム・ドリーム 水族館', 'game', 'ゲーム', 0, '/uploads/images/apps/aquarium-dream-world_icon.svg', '/uploads/images/apps/aquarium-dream-world_thumb.svg', '### アクアリウム・ドリーム 水族館 について

**アクアリウム・ドリーム 水族館** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！アクアリウム・ドリーム 水族館で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.aquarium-dream-world"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000037"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/aquarium-dream-world"}]', NULL, NULL, '["/uploads/images/apps/aquarium-dream-world_screen_1.svg","/uploads/images/apps/aquarium-dream-world_screen_2.svg","/uploads/images/apps/aquarium-dream-world_screen_3.svg"]', 4.6, '330万+', 'Pixel Forge Studio', 0, 0, '[]', 1753462020, 1753462020),
  ('commander-in-chief', 'コマンダー・イン・チーフ 戦線', 'game', 'ゲーム', 0, '/uploads/images/apps/commander-in-chief_icon.svg', '/uploads/images/apps/commander-in-chief_thumb.svg', '### コマンダー・イン・チーフ 戦線 について

**コマンダー・イン・チーフ 戦線** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！コマンダー・イン・チーフ 戦線で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.commander-in-chief"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000038"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/commander-in-chief"}]', NULL, NULL, '["/uploads/images/apps/commander-in-chief_screen_1.svg","/uploads/images/apps/commander-in-chief_screen_2.svg","/uploads/images/apps/commander-in-chief_screen_3.svg"]', 4.1, '90万+', 'Hypernova Lab', 0, 0, '[]', 1762783313, 1762783313),
  ('tangram-geom-puzzle', 'タングラム 幾何学パズル', 'game', 'ゲーム', 0, '/uploads/images/apps/tangram-geom-puzzle_icon.svg', '/uploads/images/apps/tangram-geom-puzzle_thumb.svg', '### タングラム 幾何学パズル について

**タングラム 幾何学パズル** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！タングラム 幾何学パズルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.tangram-geom-puzzle"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000039"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/tangram-geom-puzzle"}]', 'https://github.com/jikantoki/tangram-geom-puzzle', NULL, '["/uploads/images/apps/tangram-geom-puzzle_screen_1.svg","/uploads/images/apps/tangram-geom-puzzle_screen_2.svg","/uploads/images/apps/tangram-geom-puzzle_screen_3.svg"]', 4.4, '190万+', 'Komorebi Soft', 0, 0, '[]', 1778935767, 1778935767),
  ('eight-bit-heroes-retro', '8ビット・ヒーローズ レトロ', 'game', 'ゲーム', 180, '/uploads/images/apps/eight-bit-heroes-retro_icon.svg', '/uploads/images/apps/eight-bit-heroes-retro_thumb.svg', '### 8ビット・ヒーローズ レトロ について

**8ビット・ヒーローズ レトロ** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！8ビット・ヒーローズ レトロで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.eight-bit-heroes-retro"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000040"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/eight-bit-heroes-retro"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/eight-bit-heroes-retro_screen_1.svg","/uploads/images/apps/eight-bit-heroes-retro_screen_2.svg","/uploads/images/apps/eight-bit-heroes-retro_screen_3.svg"]', 4.7, '40万+', 'Aether Works', 0, 0, '[]', 1739992550, 1739992550),
  ('sniper-elite-ghost', 'スナイパー・エリート ゴースト', 'game', 'ゲーム', 0, '/uploads/images/apps/sniper-elite-ghost_icon.svg', '/uploads/images/apps/sniper-elite-ghost_thumb.svg', '### スナイパー・エリート ゴースト について

**スナイパー・エリート ゴースト** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！スナイパー・エリート ゴーストで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.sniper-elite-ghost"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000041"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/sniper-elite-ghost"}]', NULL, NULL, '["/uploads/images/apps/sniper-elite-ghost_screen_1.svg","/uploads/images/apps/sniper-elite-ghost_screen_2.svg","/uploads/images/apps/sniper-elite-ghost_screen_3.svg"]', 4.5, '650万+', 'Nexus Digital', 0, 0, '[]', 1743729808, 1743729808),
  ('city-builder-metro', 'シティ・ビルダー 大都市創造', 'game', 'ゲーム', 0, '/uploads/images/apps/city-builder-metro_icon.svg', '/uploads/images/apps/city-builder-metro_thumb.svg', '### シティ・ビルダー 大都市創造 について

**シティ・ビルダー 大都市創造** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！シティ・ビルダー 大都市創造で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.city-builder-metro"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000042"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/city-builder-metro"}]', 'https://github.com/jikantoki/city-builder-metro', NULL, '["/uploads/images/apps/city-builder-metro_screen_1.svg","/uploads/images/apps/city-builder-metro_screen_2.svg","/uploads/images/apps/city-builder-metro_screen_3.svg"]', 4.6, '420万+', 'Enoki Interactive', 0, 0, '[]', 1787851861, 1787851861),
  ('word-master-sea', 'ワード・マスター ことばの海', 'game', 'ゲーム', 0, '/uploads/images/apps/word-master-sea_icon.svg', '/uploads/images/apps/word-master-sea_thumb.svg', '### ワード・マスター ことばの海 について

**ワード・マスター ことばの海** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ワード・マスター ことばの海で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.word-master-sea"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000043"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/word-master-sea"}]', NULL, NULL, '["/uploads/images/apps/word-master-sea_screen_1.svg","/uploads/images/apps/word-master-sea_screen_2.svg","/uploads/images/apps/word-master-sea_screen_3.svg"]', 4.5, '290万+', 'Pixel Forge Studio', 0, 0, '[]', 1784020485, 1784020485),
  ('airplane-flight-sim', 'エアプレーン・フライト シム', 'game', 'ゲーム', 780, '/uploads/images/apps/airplane-flight-sim_icon.svg', '/uploads/images/apps/airplane-flight-sim_thumb.svg', '### エアプレーン・フライト シム について

**エアプレーン・フライト シム** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！エアプレーン・フライト シムで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.airplane-flight-sim"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000044"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/airplane-flight-sim"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/airplane-flight-sim_screen_1.svg","/uploads/images/apps/airplane-flight-sim_screen_2.svg","/uploads/images/apps/airplane-flight-sim_screen_3.svg"]', 4.8, '85万+', 'Hypernova Lab', 0, 0, '[]', 1740360248, 1740360248),
  ('rally-champion-wrc', 'ラリー・チャンピオン WRC', 'game', 'ゲーム', 0, '/uploads/images/apps/rally-champion-wrc_icon.svg', '/uploads/images/apps/rally-champion-wrc_thumb.svg', '### ラリー・チャンピオン WRC について

**ラリー・チャンピオン WRC** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ラリー・チャンピオン WRCで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.rally-champion-wrc"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000045"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/rally-champion-wrc"}]', 'https://github.com/jikantoki/rally-champion-wrc', NULL, '["/uploads/images/apps/rally-champion-wrc_screen_1.svg","/uploads/images/apps/rally-champion-wrc_screen_2.svg","/uploads/images/apps/rally-champion-wrc_screen_3.svg"]', 4.3, '160万+', 'Komorebi Soft', 0, 0, '[]', 1776348603, 1776348603),
  ('valkyrie-crisis', 'ヴァルキリー・クライシス', 'game', 'ゲーム', 0, '/uploads/images/apps/valkyrie-crisis_icon.svg', '/uploads/images/apps/valkyrie-crisis_thumb.svg', '### ヴァルキリー・クライシス について

**ヴァルキリー・クライシス** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！ヴァルキリー・クライシスで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.valkyrie-crisis"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000046"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/valkyrie-crisis"}]', NULL, NULL, '["/uploads/images/apps/valkyrie-crisis_screen_1.svg","/uploads/images/apps/valkyrie-crisis_screen_2.svg","/uploads/images/apps/valkyrie-crisis_screen_3.svg"]', 4.6, '380万+', 'Aether Works', 0, 0, '[]', 1750505003, 1750505003),
  ('crane-game-online', 'クレーンゲーム オンライン 直送', 'game', 'ゲーム', 0, '/uploads/images/apps/crane-game-online_icon.svg', '/uploads/images/apps/crane-game-online_thumb.svg', '### クレーンゲーム オンライン 直送 について

**クレーンゲーム オンライン 直送** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！クレーンゲーム オンライン 直送で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.crane-game-online"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000047"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/crane-game-online"}]', NULL, NULL, '["/uploads/images/apps/crane-game-online_screen_1.svg","/uploads/images/apps/crane-game-online_screen_2.svg","/uploads/images/apps/crane-game-online_screen_3.svg"]', 4.1, '210万+', 'Nexus Digital', 0, 0, '[]', 1738494353, 1738494353),
  ('chess-masters-ai', 'チェス・マスターズ AI対局', 'game', 'ゲーム', 0, '/uploads/images/apps/chess-masters-ai_icon.svg', '/uploads/images/apps/chess-masters-ai_thumb.svg', '### チェス・マスターズ AI対局 について

**チェス・マスターズ AI対局** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！チェス・マスターズ AI対局で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.chess-masters-ai"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000048"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/chess-masters-ai"}]', 'https://github.com/jikantoki/chess-masters-ai', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/chess-masters-ai_screen_1.svg","/uploads/images/apps/chess-masters-ai_screen_2.svg","/uploads/images/apps/chess-masters-ai_screen_3.svg"]', 4.7, '500万+', 'Enoki Interactive', 0, 0, '[]', 1769476952, 1769476952),
  ('bubble-shooter-pop', 'バブル・シューター・ポップ', 'game', 'ゲーム', 0, '/uploads/images/apps/bubble-shooter-pop_icon.svg', '/uploads/images/apps/bubble-shooter-pop_thumb.svg', '### バブル・シューター・ポップ について

**バブル・シューター・ポップ** は、洗練されたデザインと快適な操作性を追求したゲームです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ゲームの決定版！バブル・シューター・ポップで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.bubble-shooter-pop"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000049"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/bubble-shooter-pop"}]', NULL, NULL, '["/uploads/images/apps/bubble-shooter-pop_screen_1.svg","/uploads/images/apps/bubble-shooter-pop_screen_2.svg","/uploads/images/apps/bubble-shooter-pop_screen_3.svg"]', 4.4, '1200万+', 'Pixel Forge Studio', 0, 0, '[]', 1790315937, 1790315937),
  ('enoki-file-manager', 'Enoki ファイルマネージャー Pro', 'app', '便利ツール', 0, '/uploads/images/apps/enoki-file-manager_icon.svg', '/uploads/images/apps/enoki-file-manager_thumb.svg', '### Enoki ファイルマネージャー Pro について

**Enoki ファイルマネージャー Pro** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！Enoki ファイルマネージャー Proで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.enoki-file-manager"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000050"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/enoki-file-manager"}]', NULL, NULL, '["/uploads/images/apps/enoki-file-manager_screen_1.svg","/uploads/images/apps/enoki-file-manager_screen_2.svg","/uploads/images/apps/enoki-file-manager_screen_3.svg"]', 4.9, '100万+', 'Hypernova Lab', 1, 0, '[]', 1736641175, 1736641175),
  ('focus-pomodoro-timer', 'Focus ポモドーロ 集中タイマー', 'app', '便利ツール', 0, '/uploads/images/apps/focus-pomodoro-timer_icon.svg', '/uploads/images/apps/focus-pomodoro-timer_thumb.svg', '### Focus ポモドーロ 集中タイマー について

**Focus ポモドーロ 集中タイマー** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！Focus ポモドーロ 集中タイマーで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.focus-pomodoro-timer"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000051"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/focus-pomodoro-timer"}]', 'https://github.com/jikantoki/focus-pomodoro-timer', NULL, '["/uploads/images/apps/focus-pomodoro-timer_screen_1.svg","/uploads/images/apps/focus-pomodoro-timer_screen_2.svg","/uploads/images/apps/focus-pomodoro-timer_screen_3.svg"]', 4.8, '250万+', 'Komorebi Soft', 1, 0, '[]', 1762271609, 1762271609),
  ('retro-camera-1998', 'レトロカメラ 1998 フィルムFX', 'app', 'メディア', 0, '/uploads/images/apps/retro-camera-1998_icon.svg', '/uploads/images/apps/retro-camera-1998_thumb.svg', '### レトロカメラ 1998 フィルムFX について

**レトロカメラ 1998 フィルムFX** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！レトロカメラ 1998 フィルムFXで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.retro-camera-1998"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000052"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/retro-camera-1998"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/retro-camera-1998_screen_1.svg","/uploads/images/apps/retro-camera-1998_screen_2.svg","/uploads/images/apps/retro-camera-1998_screen_3.svg"]', 4.7, '800万+', 'Aether Works', 1, 0, '[]', 1754823548, 1754823548),
  ('enoki-chat-secure', 'Enoki チャット＆セキュア通話', 'app', 'ソーシャル', 0, '/uploads/images/apps/enoki-chat-secure_icon.svg', '/uploads/images/apps/enoki-chat-secure_thumb.svg', '### Enoki チャット＆セキュア通話 について

**Enoki チャット＆セキュア通話** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！Enoki チャット＆セキュア通話で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.enoki-chat-secure"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000053"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/enoki-chat-secure"}]', NULL, NULL, '["/uploads/images/apps/enoki-chat-secure_screen_1.svg","/uploads/images/apps/enoki-chat-secure_screen_2.svg","/uploads/images/apps/enoki-chat-secure_screen_3.svg"]', 4.6, '300万+', 'Nexus Digital', 1, 0, '[]', 1774625824, 1774625824),
  ('simple-household-book', 'シンプル家計簿 3秒で記録', 'app', '便利ツール', 0, '/uploads/images/apps/simple-household-book_icon.svg', '/uploads/images/apps/simple-household-book_thumb.svg', '### シンプル家計簿 3秒で記録 について

**シンプル家計簿 3秒で記録** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！シンプル家計簿 3秒で記録で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.simple-household-book"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000054"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/simple-household-book"}]', 'https://github.com/jikantoki/simple-household-book', NULL, '["/uploads/images/apps/simple-household-book_screen_1.svg","/uploads/images/apps/simple-household-book_screen_2.svg","/uploads/images/apps/simple-household-book_screen_3.svg"]', 4.8, '400万+', 'Enoki Interactive', 0, 0, '[]', 1754487401, 1754487401),
  ('rain-radar-weather', '雨雲レーダー 高精度天気予報', 'app', 'ポータルサイト', 0, '/uploads/images/apps/rain-radar-weather_icon.svg', '/uploads/images/apps/rain-radar-weather_thumb.svg', '### 雨雲レーダー 高精度天気予報 について

**雨雲レーダー 高精度天気予報** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！雨雲レーダー 高精度天気予報で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.rain-radar-weather"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000055"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/rain-radar-weather"}]', NULL, NULL, '["/uploads/images/apps/rain-radar-weather_screen_1.svg","/uploads/images/apps/rain-radar-weather_screen_2.svg","/uploads/images/apps/rain-radar-weather_screen_3.svg"]', 4.6, '600万+', 'Pixel Forge Studio', 0, 0, '[]', 1769073132, 1769073132),
  ('markdown-notes-sync', 'Markdown ノート 瞬速同期', 'app', '開発', 380, '/uploads/images/apps/markdown-notes-sync_icon.svg', '/uploads/images/apps/markdown-notes-sync_thumb.svg', '### Markdown ノート 瞬速同期 について

**Markdown ノート 瞬速同期** は、洗練されたデザインと快適な操作性を追求した開発です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '開発の決定版！Markdown ノート 瞬速同期で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.markdown-notes-sync"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000056"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/markdown-notes-sync"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/markdown-notes-sync_screen_1.svg","/uploads/images/apps/markdown-notes-sync_screen_2.svg","/uploads/images/apps/markdown-notes-sync_screen_3.svg"]', 4.9, '50万+', 'Hypernova Lab', 0, 0, '[]', 1756373950, 1756373950),
  ('ai-portrait-retouch-hd', 'AI ポートレート レタッチ HD', 'app', 'メディア', 0, '/uploads/images/apps/ai-portrait-retouch-hd_icon.svg', '/uploads/images/apps/ai-portrait-retouch-hd_thumb.svg', '### AI ポートレート レタッチ HD について

**AI ポートレート レタッチ HD** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！AI ポートレート レタッチ HDで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.ai-portrait-retouch-hd"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000057"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/ai-portrait-retouch-hd"}]', 'https://github.com/jikantoki/ai-portrait-retouch-hd', NULL, '["/uploads/images/apps/ai-portrait-retouch-hd_screen_1.svg","/uploads/images/apps/ai-portrait-retouch-hd_screen_2.svg","/uploads/images/apps/ai-portrait-retouch-hd_screen_3.svg"]', 4.5, '500万+', 'Komorebi Soft', 0, 0, '[]', 1780761793, 1780761793),
  ('smart-qr-barcode-reader', 'スマートQR＆バーコード リーダー', 'app', '便利ツール', 0, '/uploads/images/apps/smart-qr-barcode-reader_icon.svg', '/uploads/images/apps/smart-qr-barcode-reader_thumb.svg', '### スマートQR＆バーコード リーダー について

**スマートQR＆バーコード リーダー** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！スマートQR＆バーコード リーダーで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.smart-qr-barcode-reader"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000058"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/smart-qr-barcode-reader"}]', NULL, NULL, '["/uploads/images/apps/smart-qr-barcode-reader_screen_1.svg","/uploads/images/apps/smart-qr-barcode-reader_screen_2.svg","/uploads/images/apps/smart-qr-barcode-reader_screen_3.svg"]', 4.7, '900万+', 'Aether Works', 0, 0, '[]', 1745729856, 1745729856),
  ('ambient-sleep-whitenoise', 'Ambient 睡眠サウンド＆白雑音', 'app', 'メディア', 0, '/uploads/images/apps/ambient-sleep-whitenoise_icon.svg', '/uploads/images/apps/ambient-sleep-whitenoise_thumb.svg', '### Ambient 睡眠サウンド＆白雑音 について

**Ambient 睡眠サウンド＆白雑音** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！Ambient 睡眠サウンド＆白雑音で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.ambient-sleep-whitenoise"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000059"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/ambient-sleep-whitenoise"}]', NULL, NULL, '["/uploads/images/apps/ambient-sleep-whitenoise_screen_1.svg","/uploads/images/apps/ambient-sleep-whitenoise_screen_2.svg","/uploads/images/apps/ambient-sleep-whitenoise_screen_3.svg"]', 4.8, '350万+', 'Nexus Digital', 0, 0, '[]', 1737486957, 1737486957),
  ('task-kanban-board', 'タスク・カンバン ボード共有', 'app', 'ソーシャル', 0, '/uploads/images/apps/task-kanban-board_icon.svg', '/uploads/images/apps/task-kanban-board_thumb.svg', '### タスク・カンバン ボード共有 について

**タスク・カンバン ボード共有** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！タスク・カンバン ボード共有で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.task-kanban-board"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000060"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/task-kanban-board"}]', 'https://github.com/jikantoki/task-kanban-board', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/task-kanban-board_screen_1.svg","/uploads/images/apps/task-kanban-board_screen_2.svg","/uploads/images/apps/task-kanban-board_screen_3.svg"]', 4.6, '120万+', 'Enoki Interactive', 0, 0, '[]', 1773132416, 1773132416),
  ('asset-tracker-crypto', '資産トラッカー 株＆暗号資産', 'app', 'ポータルサイト', 0, '/uploads/images/apps/asset-tracker-crypto_icon.svg', '/uploads/images/apps/asset-tracker-crypto_thumb.svg', '### 資産トラッカー 株＆暗号資産 について

**資産トラッカー 株＆暗号資産** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！資産トラッカー 株＆暗号資産で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.asset-tracker-crypto"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000061"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/asset-tracker-crypto"}]', NULL, NULL, '["/uploads/images/apps/asset-tracker-crypto_screen_1.svg","/uploads/images/apps/asset-tracker-crypto_screen_2.svg","/uploads/images/apps/asset-tracker-crypto_screen_3.svg"]', 4.7, '180万+', 'Pixel Forge Studio', 0, 0, '[]', 1787713913, 1787713913),
  ('daily-english-memory', 'デイリー英単語 忘却曲線メソッド', 'app', '開発', 0, '/uploads/images/apps/daily-english-memory_icon.svg', '/uploads/images/apps/daily-english-memory_thumb.svg', '### デイリー英単語 忘却曲線メソッド について

**デイリー英単語 忘却曲線メソッド** は、洗練されたデザインと快適な操作性を追求した開発です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '開発の決定版！デイリー英単語 忘却曲線メソッドで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.daily-english-memory"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000062"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/daily-english-memory"}]', NULL, NULL, '["/uploads/images/apps/daily-english-memory_screen_1.svg","/uploads/images/apps/daily-english-memory_screen_2.svg","/uploads/images/apps/daily-english-memory_screen_3.svg"]', 4.8, '270万+', 'Hypernova Lab', 0, 0, '[]', 1744693598, 1744693598),
  ('sleep-assist-tracker', '快眠アシスト 睡眠トラッカー', 'app', 'その他', 0, '/uploads/images/apps/sleep-assist-tracker_icon.svg', '/uploads/images/apps/sleep-assist-tracker_thumb.svg', '### 快眠アシスト 睡眠トラッカー について

**快眠アシスト 睡眠トラッカー** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！快眠アシスト 睡眠トラッカーで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.sleep-assist-tracker"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000063"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/sleep-assist-tracker"}]', 'https://github.com/jikantoki/sleep-assist-tracker', NULL, '["/uploads/images/apps/sleep-assist-tracker_screen_1.svg","/uploads/images/apps/sleep-assist-tracker_screen_2.svg","/uploads/images/apps/sleep-assist-tracker_screen_3.svg"]', 4.5, '310万+', 'Komorebi Soft', 0, 0, '[]', 1751157872, 1751157872),
  ('pdf-scanner-signature', 'PDF スキャナー＆電子署名', 'app', 'Mod・拡張機能', 490, '/uploads/images/apps/pdf-scanner-signature_icon.svg', '/uploads/images/apps/pdf-scanner-signature_thumb.svg', '### PDF スキャナー＆電子署名 について

**PDF スキャナー＆電子署名** は、洗練されたデザインと快適な操作性を追求したMod・拡張機能です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'Mod・拡張機能の決定版！PDF スキャナー＆電子署名で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.pdf-scanner-signature"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000064"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/pdf-scanner-signature"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/pdf-scanner-signature_screen_1.svg","/uploads/images/apps/pdf-scanner-signature_screen_2.svg","/uploads/images/apps/pdf-scanner-signature_screen_3.svg"]', 4.7, '150万+', 'Aether Works', 0, 0, '[]', 1784514321, 1784514321),
  ('equalizer-fx-pro', 'イコライザー FX 音質強化 Pro', 'app', 'メディア', 0, '/uploads/images/apps/equalizer-fx-pro_icon.svg', '/uploads/images/apps/equalizer-fx-pro_thumb.svg', '### イコライザー FX 音質強化 Pro について

**イコライザー FX 音質強化 Pro** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！イコライザー FX 音質強化 Proで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.equalizer-fx-pro"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000065"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/equalizer-fx-pro"}]', NULL, NULL, '["/uploads/images/apps/equalizer-fx-pro_screen_1.svg","/uploads/images/apps/equalizer-fx-pro_screen_2.svg","/uploads/images/apps/equalizer-fx-pro_screen_3.svg"]', 4.6, '430万+', 'Nexus Digital', 0, 0, '[]', 1772754305, 1772754305),
  ('quick-calc-converter', 'クイック電卓 Pro 単位換算付き', 'app', '便利ツール', 0, '/uploads/images/apps/quick-calc-converter_icon.svg', '/uploads/images/apps/quick-calc-converter_thumb.svg', '### クイック電卓 Pro 単位換算付き について

**クイック電卓 Pro 単位換算付き** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！クイック電卓 Pro 単位換算付きで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.quick-calc-converter"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000066"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/quick-calc-converter"}]', 'https://github.com/jikantoki/quick-calc-converter', NULL, '["/uploads/images/apps/quick-calc-converter_screen_1.svg","/uploads/images/apps/quick-calc-converter_screen_2.svg","/uploads/images/apps/quick-calc-converter_screen_3.svg"]', 4.8, '700万+', 'Enoki Interactive', 0, 0, '[]', 1736300056, 1736300056),
  ('stargazer-3d-astronomy', 'スターゲイザー 3D天体観測', 'app', 'ポータルサイト', 420, '/uploads/images/apps/stargazer-3d-astronomy_icon.svg', '/uploads/images/apps/stargazer-3d-astronomy_thumb.svg', '### スターゲイザー 3D天体観測 について

**スターゲイザー 3D天体観測** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！スターゲイザー 3D天体観測で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.stargazer-3d-astronomy"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000067"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/stargazer-3d-astronomy"}]', NULL, NULL, '["/uploads/images/apps/stargazer-3d-astronomy_screen_1.svg","/uploads/images/apps/stargazer-3d-astronomy_screen_2.svg","/uploads/images/apps/stargazer-3d-astronomy_screen_3.svg"]', 4.9, '90万+', 'Pixel Forge Studio', 0, 0, '[]', 1776944683, 1776944683),
  ('smart-meditation-5min', 'スマート瞑想 1日5分マインドフル', 'app', 'その他', 0, '/uploads/images/apps/smart-meditation-5min_icon.svg', '/uploads/images/apps/smart-meditation-5min_thumb.svg', '### スマート瞑想 1日5分マインドフル について

**スマート瞑想 1日5分マインドフル** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！スマート瞑想 1日5分マインドフルで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.smart-meditation-5min"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000068"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/smart-meditation-5min"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/smart-meditation-5min_screen_1.svg","/uploads/images/apps/smart-meditation-5min_screen_2.svg","/uploads/images/apps/smart-meditation-5min_screen_3.svg"]', 4.7, '220万+', 'Hypernova Lab', 0, 0, '[]', 1760229027, 1760229027),
  ('short-video-vlog-editor', 'ショート動画スタジオ 編集Vlog', 'app', 'メディア', 0, '/uploads/images/apps/short-video-vlog-editor_icon.svg', '/uploads/images/apps/short-video-vlog-editor_thumb.svg', '### ショート動画スタジオ 編集Vlog について

**ショート動画スタジオ 編集Vlog** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！ショート動画スタジオ 編集Vlogで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.short-video-vlog-editor"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000069"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/short-video-vlog-editor"}]', 'https://github.com/jikantoki/short-video-vlog-editor', NULL, '["/uploads/images/apps/short-video-vlog-editor_screen_1.svg","/uploads/images/apps/short-video-vlog-editor_screen_2.svg","/uploads/images/apps/short-video-vlog-editor_screen_3.svg"]', 4.4, '650万+', 'Komorebi Soft', 0, 0, '[]', 1748472229, 1748472229),
  ('battery-doctor-saver', 'バッテリー・ドクター 節電ガード', 'app', '便利ツール', 0, '/uploads/images/apps/battery-doctor-saver_icon.svg', '/uploads/images/apps/battery-doctor-saver_thumb.svg', '### バッテリー・ドクター 節電ガード について

**バッテリー・ドクター 節電ガード** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！バッテリー・ドクター 節電ガードで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.battery-doctor-saver"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000070"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/battery-doctor-saver"}]', NULL, NULL, '["/uploads/images/apps/battery-doctor-saver_screen_1.svg","/uploads/images/apps/battery-doctor-saver_screen_2.svg","/uploads/images/apps/battery-doctor-saver_screen_3.svg"]', 4.3, '850万+', 'Aether Works', 0, 0, '[]', 1743540129, 1743540129),
  ('voiceroom-social-audio', 'VoiceRoom 音声ルーム・ラジオ', 'app', 'ソーシャル', 0, '/uploads/images/apps/voiceroom-social-audio_icon.svg', '/uploads/images/apps/voiceroom-social-audio_thumb.svg', '### VoiceRoom 音声ルーム・ラジオ について

**VoiceRoom 音声ルーム・ラジオ** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！VoiceRoom 音声ルーム・ラジオで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.voiceroom-social-audio"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000071"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/voiceroom-social-audio"}]', NULL, NULL, '["/uploads/images/apps/voiceroom-social-audio_screen_1.svg","/uploads/images/apps/voiceroom-social-audio_screen_2.svg","/uploads/images/apps/voiceroom-social-audio_screen_3.svg"]', 4.5, '160万+', 'Nexus Digital', 0, 0, '[]', 1749930483, 1749930483),
  ('receipt-household-ai', 'レシート家計簿 AI自動読取', 'app', '便利ツール', 0, '/uploads/images/apps/receipt-household-ai_icon.svg', '/uploads/images/apps/receipt-household-ai_thumb.svg', '### レシート家計簿 AI自動読取 について

**レシート家計簿 AI自動読取** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！レシート家計簿 AI自動読取で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.receipt-household-ai"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000072"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/receipt-household-ai"}]', 'https://github.com/jikantoki/receipt-household-ai', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/receipt-household-ai_screen_1.svg","/uploads/images/apps/receipt-household-ai_screen_2.svg","/uploads/images/apps/receipt-household-ai_screen_3.svg"]', 4.6, '340万+', 'Enoki Interactive', 0, 0, '[]', 1764178862, 1764178862),
  ('comic-reader-pro', 'コミックリーダー Pro 縦スクロール', 'app', 'メディア', 300, '/uploads/images/apps/comic-reader-pro_icon.svg', '/uploads/images/apps/comic-reader-pro_thumb.svg', '### コミックリーダー Pro 縦スクロール について

**コミックリーダー Pro 縦スクロール** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！コミックリーダー Pro 縦スクロールで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.comic-reader-pro"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000073"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/comic-reader-pro"}]', NULL, NULL, '["/uploads/images/apps/comic-reader-pro_screen_1.svg","/uploads/images/apps/comic-reader-pro_screen_2.svg","/uploads/images/apps/comic-reader-pro_screen_3.svg"]', 4.8, '110万+', 'Pixel Forge Studio', 0, 0, '[]', 1769517156, 1769517156),
  ('programming-python-learn', 'プログラミング入門 Python学習', 'app', '開発', 0, '/uploads/images/apps/programming-python-learn_icon.svg', '/uploads/images/apps/programming-python-learn_thumb.svg', '### プログラミング入門 Python学習 について

**プログラミング入門 Python学習** は、洗練されたデザインと快適な操作性を追求した開発です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '開発の決定版！プログラミング入門 Python学習で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.programming-python-learn"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000074"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/programming-python-learn"}]', NULL, NULL, '["/uploads/images/apps/programming-python-learn_screen_1.svg","/uploads/images/apps/programming-python-learn_screen_2.svg","/uploads/images/apps/programming-python-learn_screen_3.svg"]', 4.7, '190万+', 'Hypernova Lab', 0, 0, '[]', 1769581973, 1769581973),
  ('daily-water-hydration', 'デイリー・ウォーター 水分記録', 'app', 'その他', 0, '/uploads/images/apps/daily-water-hydration_icon.svg', '/uploads/images/apps/daily-water-hydration_thumb.svg', '### デイリー・ウォーター 水分記録 について

**デイリー・ウォーター 水分記録** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！デイリー・ウォーター 水分記録で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.daily-water-hydration"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000075"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/daily-water-hydration"}]', 'https://github.com/jikantoki/daily-water-hydration', NULL, '["/uploads/images/apps/daily-water-hydration_screen_1.svg","/uploads/images/apps/daily-water-hydration_screen_2.svg","/uploads/images/apps/daily-water-hydration_screen_3.svg"]', 4.6, '240万+', 'Komorebi Soft', 0, 0, '[]', 1769343761, 1769343761),
  ('podcast-cast-hd', 'ポッドキャスト・キャスト 高音質', 'app', 'メディア', 0, '/uploads/images/apps/podcast-cast-hd_icon.svg', '/uploads/images/apps/podcast-cast-hd_thumb.svg', '### ポッドキャスト・キャスト 高音質 について

**ポッドキャスト・キャスト 高音質** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！ポッドキャスト・キャスト 高音質で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.podcast-cast-hd"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000076"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/podcast-cast-hd"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/podcast-cast-hd_screen_1.svg","/uploads/images/apps/podcast-cast-hd_screen_2.svg","/uploads/images/apps/podcast-cast-hd_screen_3.svg"]', 4.5, '170万+', 'Aether Works', 0, 0, '[]', 1742333185, 1742333185),
  ('exchange-rate-alert', '為替レート 計算＆アラート', 'app', 'ポータルサイト', 0, '/uploads/images/apps/exchange-rate-alert_icon.svg', '/uploads/images/apps/exchange-rate-alert_thumb.svg', '### 為替レート 計算＆アラート について

**為替レート 計算＆アラート** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！為替レート 計算＆アラートで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.exchange-rate-alert"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000077"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/exchange-rate-alert"}]', NULL, NULL, '["/uploads/images/apps/exchange-rate-alert_screen_1.svg","/uploads/images/apps/exchange-rate-alert_screen_2.svg","/uploads/images/apps/exchange-rate-alert_screen_3.svg"]', 4.4, '130万+', 'Nexus Digital', 0, 0, '[]', 1785537772, 1785537772),
  ('wifi-speedtest-analyzer', 'WiFi スピードテスト＆解析', 'app', '便利ツール', 0, '/uploads/images/apps/wifi-speedtest-analyzer_icon.svg', '/uploads/images/apps/wifi-speedtest-analyzer_thumb.svg', '### WiFi スピードテスト＆解析 について

**WiFi スピードテスト＆解析** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！WiFi スピードテスト＆解析で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.wifi-speedtest-analyzer"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000078"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/wifi-speedtest-analyzer"}]', 'https://github.com/jikantoki/wifi-speedtest-analyzer', NULL, '["/uploads/images/apps/wifi-speedtest-analyzer_screen_1.svg","/uploads/images/apps/wifi-speedtest-analyzer_screen_2.svg","/uploads/images/apps/wifi-speedtest-analyzer_screen_3.svg"]', 4.7, '780万+', 'Enoki Interactive', 0, 0, '[]', 1780873839, 1780873839),
  ('short-novel-paradise', '短編小説パラダイス 毎日更新', 'app', 'ポータルサイト', 0, '/uploads/images/apps/short-novel-paradise_icon.svg', '/uploads/images/apps/short-novel-paradise_thumb.svg', '### 短編小説パラダイス 毎日更新 について

**短編小説パラダイス 毎日更新** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！短編小説パラダイス 毎日更新で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.short-novel-paradise"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000079"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/short-novel-paradise"}]', NULL, NULL, '["/uploads/images/apps/short-novel-paradise_screen_1.svg","/uploads/images/apps/short-novel-paradise_screen_2.svg","/uploads/images/apps/short-novel-paradise_screen_3.svg"]', 4.5, '85万+', 'Pixel Forge Studio', 0, 0, '[]', 1759027744, 1759027744),
  ('voice-recorder-hd-pro', 'ボイスレコーダー HD 高音質録音', 'app', 'ソーシャル', 0, '/uploads/images/apps/voice-recorder-hd-pro_icon.svg', '/uploads/images/apps/voice-recorder-hd-pro_thumb.svg', '### ボイスレコーダー HD 高音質録音 について

**ボイスレコーダー HD 高音質録音** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！ボイスレコーダー HD 高音質録音で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.voice-recorder-hd-pro"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000080"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/voice-recorder-hd-pro"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/voice-recorder-hd-pro_screen_1.svg","/uploads/images/apps/voice-recorder-hd-pro_screen_2.svg","/uploads/images/apps/voice-recorder-hd-pro_screen_3.svg"]', 4.6, '390万+', 'Hypernova Lab', 0, 0, '[]', 1740296453, 1740296453),
  ('timezone-world-clock', 'タイムゾーン 世界時計＆会議調整', 'app', '便利ツール', 160, '/uploads/images/apps/timezone-world-clock_icon.svg', '/uploads/images/apps/timezone-world-clock_thumb.svg', '### タイムゾーン 世界時計＆会議調整 について

**タイムゾーン 世界時計＆会議調整** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！タイムゾーン 世界時計＆会議調整で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.timezone-world-clock"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000081"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/timezone-world-clock"}]', 'https://github.com/jikantoki/timezone-world-clock', NULL, '["/uploads/images/apps/timezone-world-clock_screen_1.svg","/uploads/images/apps/timezone-world-clock_screen_2.svg","/uploads/images/apps/timezone-world-clock_screen_3.svg"]', 4.8, '60万+', 'Komorebi Soft', 0, 0, '[]', 1785937170, 1785937170),
  ('running-tracker-gps', 'ランニング・トラッカー GPS計測', 'app', 'その他', 0, '/uploads/images/apps/running-tracker-gps_icon.svg', '/uploads/images/apps/running-tracker-gps_thumb.svg', '### ランニング・トラッカー GPS計測 について

**ランニング・トラッカー GPS計測** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！ランニング・トラッカー GPS計測で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.running-tracker-gps"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000082"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/running-tracker-gps"}]', NULL, NULL, '["/uploads/images/apps/running-tracker-gps_screen_1.svg","/uploads/images/apps/running-tracker-gps_screen_2.svg","/uploads/images/apps/running-tracker-gps_screen_3.svg"]', 4.6, '470万+', 'Aether Works', 0, 0, '[]', 1745707500, 1745707500),
  ('collage-maker-photo-fx', 'コラージュ メーカー 写真加工', 'app', 'メディア', 0, '/uploads/images/apps/collage-maker-photo-fx_icon.svg', '/uploads/images/apps/collage-maker-photo-fx_thumb.svg', '### コラージュ メーカー 写真加工 について

**コラージュ メーカー 写真加工** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！コラージュ メーカー 写真加工で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.collage-maker-photo-fx"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000083"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/collage-maker-photo-fx"}]', NULL, NULL, '["/uploads/images/apps/collage-maker-photo-fx_screen_1.svg","/uploads/images/apps/collage-maker-photo-fx_screen_2.svg","/uploads/images/apps/collage-maker-photo-fx_screen_3.svg"]', 4.4, '520万+', 'Nexus Digital', 0, 0, '[]', 1758159930, 1758159930),
  ('clipboard-manager-history', 'クリップボード マネージャー 履歴', 'app', 'Mod・拡張機能', 0, '/uploads/images/apps/clipboard-manager-history_icon.svg', '/uploads/images/apps/clipboard-manager-history_thumb.svg', '### クリップボード マネージャー 履歴 について

**クリップボード マネージャー 履歴** は、洗練されたデザインと快適な操作性を追求したMod・拡張機能です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'Mod・拡張機能の決定版！クリップボード マネージャー 履歴で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.clipboard-manager-history"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000084"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/clipboard-manager-history"}]', 'https://github.com/jikantoki/clipboard-manager-history', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/clipboard-manager-history_screen_1.svg","/uploads/images/apps/clipboard-manager-history_screen_2.svg","/uploads/images/apps/clipboard-manager-history_screen_3.svg"]', 4.7, '140万+', 'Enoki Interactive', 0, 0, '[]', 1738051361, 1738051361),
  ('habit-tracker-30days', '習慣トラッカー 30日チャレンジ', 'app', 'その他', 0, '/uploads/images/apps/habit-tracker-30days_icon.svg', '/uploads/images/apps/habit-tracker-30days_thumb.svg', '### 習慣トラッカー 30日チャレンジ について

**習慣トラッカー 30日チャレンジ** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！習慣トラッカー 30日チャレンジで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.habit-tracker-30days"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000085"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/habit-tracker-30days"}]', NULL, NULL, '["/uploads/images/apps/habit-tracker-30days_screen_1.svg","/uploads/images/apps/habit-tracker-30days_screen_2.svg","/uploads/images/apps/habit-tracker-30days_screen_3.svg"]', 4.8, '260万+', 'Pixel Forge Studio', 0, 0, '[]', 1774414579, 1774414579),
  ('earthquake-warning-map', '3D 地震速報＆防災マップ', 'app', 'ポータルサイト', 0, '/uploads/images/apps/earthquake-warning-map_icon.svg', '/uploads/images/apps/earthquake-warning-map_thumb.svg', '### 3D 地震速報＆防災マップ について

**3D 地震速報＆防災マップ** は、洗練されたデザインと快適な操作性を追求したポータルサイトです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ポータルサイトの決定版！3D 地震速報＆防災マップで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.earthquake-warning-map"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000086"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/earthquake-warning-map"}]', NULL, NULL, '["/uploads/images/apps/earthquake-warning-map_screen_1.svg","/uploads/images/apps/earthquake-warning-map_screen_2.svg","/uploads/images/apps/earthquake-warning-map_screen_3.svg"]', 4.7, '580万+', 'Hypernova Lab', 0, 0, '[]', 1765882306, 1765882306),
  ('minimalist-secret-diary', 'ミニマリスト日記 秘密の鍵付き', 'app', 'その他', 0, '/uploads/images/apps/minimalist-secret-diary_icon.svg', '/uploads/images/apps/minimalist-secret-diary_thumb.svg', '### ミニマリスト日記 秘密の鍵付き について

**ミニマリスト日記 秘密の鍵付き** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！ミニマリスト日記 秘密の鍵付きで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.minimalist-secret-diary"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000087"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/minimalist-secret-diary"}]', 'https://github.com/jikantoki/minimalist-secret-diary', NULL, '["/uploads/images/apps/minimalist-secret-diary_screen_1.svg","/uploads/images/apps/minimalist-secret-diary_screen_2.svg","/uploads/images/apps/minimalist-secret-diary_screen_3.svg"]', 4.7, '180万+', 'Komorebi Soft', 0, 0, '[]', 1788647456, 1788647456),
  ('guitar-tuner-metronome', 'ギターチューナー＆メトロノーム', 'app', 'メディア', 0, '/uploads/images/apps/guitar-tuner-metronome_icon.svg', '/uploads/images/apps/guitar-tuner-metronome_thumb.svg', '### ギターチューナー＆メトロノーム について

**ギターチューナー＆メトロノーム** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！ギターチューナー＆メトロノームで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.guitar-tuner-metronome"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000088"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/guitar-tuner-metronome"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/guitar-tuner-metronome_screen_1.svg","/uploads/images/apps/guitar-tuner-metronome_screen_2.svg","/uploads/images/apps/guitar-tuner-metronome_screen_3.svg"]', 4.8, '620万+', 'Aether Works', 0, 0, '[]', 1773062614, 1773062614),
  ('password-vault-safe', 'パスワード管理キー Vault', 'app', '便利ツール', 580, '/uploads/images/apps/password-vault-safe_icon.svg', '/uploads/images/apps/password-vault-safe_thumb.svg', '### パスワード管理キー Vault について

**パスワード管理キー Vault** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！パスワード管理キー Vaultで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.password-vault-safe"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000089"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/password-vault-safe"}]', NULL, NULL, '["/uploads/images/apps/password-vault-safe_screen_1.svg","/uploads/images/apps/password-vault-safe_screen_2.svg","/uploads/images/apps/password-vault-safe_screen_3.svg"]', 4.9, '80万+', 'Nexus Digital', 0, 0, '[]', 1779768942, 1779768942),
  ('calorie-management-ai', 'カロリー管理 AI食事撮影', 'app', 'その他', 0, '/uploads/images/apps/calorie-management-ai_icon.svg', '/uploads/images/apps/calorie-management-ai_thumb.svg', '### カロリー管理 AI食事撮影 について

**カロリー管理 AI食事撮影** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！カロリー管理 AI食事撮影で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.calorie-management-ai"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000090"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/calorie-management-ai"}]', 'https://github.com/jikantoki/calorie-management-ai', NULL, '["/uploads/images/apps/calorie-management-ai_screen_1.svg","/uploads/images/apps/calorie-management-ai_screen_2.svg","/uploads/images/apps/calorie-management-ai_screen_3.svg"]', 4.5, '330万+', 'Enoki Interactive', 0, 0, '[]', 1770592618, 1770592618),
  ('illustration-sketch-draw', 'イラスト・スケッチ キャンバス', 'app', 'Mod・拡張機能', 0, '/uploads/images/apps/illustration-sketch-draw_icon.svg', '/uploads/images/apps/illustration-sketch-draw_thumb.svg', '### イラスト・スケッチ キャンバス について

**イラスト・スケッチ キャンバス** は、洗練されたデザインと快適な操作性を追求したMod・拡張機能です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'Mod・拡張機能の決定版！イラスト・スケッチ キャンバスで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.illustration-sketch-draw"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000091"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/illustration-sketch-draw"}]', NULL, NULL, '["/uploads/images/apps/illustration-sketch-draw_screen_1.svg","/uploads/images/apps/illustration-sketch-draw_screen_2.svg","/uploads/images/apps/illustration-sketch-draw_screen_3.svg"]', 4.6, '210万+', 'Pixel Forge Studio', 0, 0, '[]', 1764064713, 1764064713),
  ('business-card-scanner', '名刺管理 スキャナー＆連絡先', 'app', 'ソーシャル', 0, '/uploads/images/apps/business-card-scanner_icon.svg', '/uploads/images/apps/business-card-scanner_thumb.svg', '### 名刺管理 スキャナー＆連絡先 について

**名刺管理 スキャナー＆連絡先** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！名刺管理 スキャナー＆連絡先で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.business-card-scanner"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000092"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/business-card-scanner"}]', NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/business-card-scanner_screen_1.svg","/uploads/images/apps/business-card-scanner_screen_2.svg","/uploads/images/apps/business-card-scanner_screen_3.svg"]', 4.4, '150万+', 'Hypernova Lab', 0, 0, '[]', 1762428049, 1762428049),
  ('world-radio-fm-am', '世界ラジオ FM/AM ストリーミング', 'app', 'メディア', 0, '/uploads/images/apps/world-radio-fm-am_icon.svg', '/uploads/images/apps/world-radio-fm-am_thumb.svg', '### 世界ラジオ FM/AM ストリーミング について

**世界ラジオ FM/AM ストリーミング** は、洗練されたデザインと快適な操作性を追求したメディアです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'メディアの決定版！世界ラジオ FM/AM ストリーミングで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.world-radio-fm-am"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000093"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/world-radio-fm-am"}]', 'https://github.com/jikantoki/world-radio-fm-am', NULL, '["/uploads/images/apps/world-radio-fm-am_screen_1.svg","/uploads/images/apps/world-radio-fm-am_screen_2.svg","/uploads/images/apps/world-radio-fm-am_screen_3.svg"]', 4.5, '410万+', 'Komorebi Soft', 0, 0, '[]', 1768917057, 1768917057),
  ('bluelight-filter-care', 'ブルーライト カット 目の保護フィルター', 'app', 'Mod・拡張機能', 0, '/uploads/images/apps/bluelight-filter-care_icon.svg', '/uploads/images/apps/bluelight-filter-care_thumb.svg', '### ブルーライト カット 目の保護フィルター について

**ブルーライト カット 目の保護フィルター** は、洗練されたデザインと快適な操作性を追求したMod・拡張機能です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'Mod・拡張機能の決定版！ブルーライト カット 目の保護フィルターで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.bluelight-filter-care"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000094"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/bluelight-filter-care"}]', NULL, NULL, '["/uploads/images/apps/bluelight-filter-care_screen_1.svg","/uploads/images/apps/bluelight-filter-care_screen_2.svg","/uploads/images/apps/bluelight-filter-care_screen_3.svg"]', 4.6, '880万+', 'Aether Works', 0, 0, '[]', 1762790649, 1762790649),
  ('flick-typing-practice', 'タイピング練習 フリック向上', 'app', '開発', 0, '/uploads/images/apps/flick-typing-practice_icon.svg', '/uploads/images/apps/flick-typing-practice_thumb.svg', '### タイピング練習 フリック向上 について

**タイピング練習 フリック向上** は、洗練されたデザインと快適な操作性を追求した開発です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '開発の決定版！タイピング練習 フリック向上で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.flick-typing-practice"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000095"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/flick-typing-practice"}]', NULL, NULL, '["/uploads/images/apps/flick-typing-practice_screen_1.svg","/uploads/images/apps/flick-typing-practice_screen_2.svg","/uploads/images/apps/flick-typing-practice_screen_3.svg"]', 4.5, '120万+', 'Nexus Digital', 0, 0, '[]', 1777018889, 1777018889),
  ('shopping-list-share', 'お買い物メモ 家族と共有リスト', 'app', 'ソーシャル', 0, '/uploads/images/apps/shopping-list-share_icon.svg', '/uploads/images/apps/shopping-list-share_thumb.svg', '### お買い物メモ 家族と共有リスト について

**お買い物メモ 家族と共有リスト** は、洗練されたデザインと快適な操作性を追求したソーシャルです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'ソーシャルの決定版！お買い物メモ 家族と共有リストで新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.shopping-list-share"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000096"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/shopping-list-share"}]', 'https://github.com/jikantoki/shopping-list-share', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '["/uploads/images/apps/shopping-list-share_screen_1.svg","/uploads/images/apps/shopping-list-share_screen_2.svg","/uploads/images/apps/shopping-list-share_screen_3.svg"]', 4.7, '290万+', 'Enoki Interactive', 0, 0, '[]', 1776104384, 1776104384),
  ('compass-level-altimeter', 'コンパス 3D 水準器＆高度計', 'app', '便利ツール', 0, '/uploads/images/apps/compass-level-altimeter_icon.svg', '/uploads/images/apps/compass-level-altimeter_thumb.svg', '### コンパス 3D 水準器＆高度計 について

**コンパス 3D 水準器＆高度計** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！コンパス 3D 水準器＆高度計で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.compass-level-altimeter"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000097"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/compass-level-altimeter"}]', NULL, NULL, '["/uploads/images/apps/compass-level-altimeter_screen_1.svg","/uploads/images/apps/compass-level-altimeter_screen_2.svg","/uploads/images/apps/compass-level-altimeter_screen_3.svg"]', 4.6, '490万+', 'Pixel Forge Studio', 0, 0, '[]', 1757262165, 1757262165),
  ('stretch-refresh-alarm', 'ストレッチ リフレッシュ通知', 'app', 'その他', 0, '/uploads/images/apps/stretch-refresh-alarm_icon.svg', '/uploads/images/apps/stretch-refresh-alarm_thumb.svg', '### ストレッチ リフレッシュ通知 について

**ストレッチ リフレッシュ通知** は、洗練されたデザインと快適な操作性を追求したその他です。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', 'その他の決定版！ストレッチ リフレッシュ通知で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.stretch-refresh-alarm"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000098"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/stretch-refresh-alarm"}]', NULL, NULL, '["/uploads/images/apps/stretch-refresh-alarm_screen_1.svg","/uploads/images/apps/stretch-refresh-alarm_screen_2.svg","/uploads/images/apps/stretch-refresh-alarm_screen_3.svg"]', 4.5, '140万+', 'Hypernova Lab', 0, 0, '[]', 1760359967, 1760359967),
  ('smart-alarm-clock-wake', 'シンプル目覚まし時計 爽快起床', 'app', '便利ツール', 0, '/uploads/images/apps/smart-alarm-clock-wake_icon.svg', '/uploads/images/apps/smart-alarm-clock-wake_thumb.svg', '### シンプル目覚まし時計 爽快起床 について

**シンプル目覚まし時計 爽快起床** は、洗練されたデザインと快適な操作性を追求した便利ツールです。

#### 🌟 主な特徴
- **直感的なユーザーインターフェイス**: 誰でもすぐに使いこなせる美しいマテリアルデザイン。
- **高速＆軽量動作**: バッテリー消費を抑え、あらゆる端末でスムーズに動作。
- **安心のプライバシー設計**: 最小限の権限で動作し、データは安全に保護されます。
- **オフライン対応**: 通信環境がない場所でも主要機能を利用可能。

#### 📱 対応環境
Android 10以上、iOS 16以上、モダンWebブラウザに対応しています。定期的なアップデートにより新機能の追加とパフォーマンス改善が行われています。

#### 🔄 最新アップデート情報 (Ver 2.4.0)
- パフォーマンスの最適化と起動速度の向上
- 一部UIの視認性改善
- 細かな不具合の修正と安定性の向上
', '便利ツールの決定版！シンプル目覚まし時計 爽快起床で新しい体験を。', '["Android","iOS","Web"]', '["日本語","English"]', '[{"text":"Google Play","icon":"mdi-google-play","url":"https://play.google.com/store/apps/details?id=com.enoki.smart-alarm-clock-wake"},{"text":"App Store","icon":"mdi-apple","url":"https://apps.apple.com/app/id1000099"},{"text":"Web版で開く","icon":"mdi-web","url":"https://enoki.xyz/apps/smart-alarm-clock-wake"}]', 'https://github.com/jikantoki/smart-alarm-clock-wake', NULL, '["/uploads/images/apps/smart-alarm-clock-wake_screen_1.svg","/uploads/images/apps/smart-alarm-clock-wake_screen_2.svg","/uploads/images/apps/smart-alarm-clock-wake_screen_3.svg"]', 4.6, '360万+', 'Komorebi Soft', 0, 0, '[]', 1750782067, 1750782067)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `type` = VALUES(`type`),
  `category` = VALUES(`category`),
  `price` = VALUES(`price`),
  `icon` = VALUES(`icon`),
  `thumbnail` = VALUES(`thumbnail`),
  `description` = VALUES(`description`),
  `summary` = VALUES(`summary`),
  `platforms` = VALUES(`platforms`),
  `languages` = VALUES(`languages`),
  `links` = VALUES(`links`),
  `githubUrl` = VALUES(`githubUrl`),
  `videoUrl` = VALUES(`videoUrl`),
  `images` = VALUES(`images`),
  `rating` = VALUES(`rating`),
  `downloads` = VALUES(`downloads`),
  `developer` = VALUES(`developer`),
  `featured` = VALUES(`featured`),
  `isUnfinished` = VALUES(`isUnfinished`),
  `tags` = VALUES(`tags`);

COMMIT;
