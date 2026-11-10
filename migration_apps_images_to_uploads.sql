-- ========================================================
-- アプリ画像 Base64 から /uploads/images/apps/ URLへの移行マイグレーションSQL
-- 対象テーブル: app_list
-- 生成日時: 2026-11-10
-- 説明: icon, thumbnail, images の Base64/SVG文字列を /uploads/images/apps/ のURLに更新
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/stella-chronicle_icon.svg',
  `thumbnail` = '/uploads/images/apps/stella-chronicle_thumb.svg',
  `images` = '["/uploads/images/apps/stella-chronicle_screen_1.svg","/uploads/images/apps/stella-chronicle_screen_2.svg","/uploads/images/apps/stella-chronicle_screen_3.svg"]'
WHERE `appId` = 'stella-chronicle';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/cyberblade-2088_icon.svg',
  `thumbnail` = '/uploads/images/apps/cyberblade-2088_thumb.svg',
  `images` = '["/uploads/images/apps/cyberblade-2088_screen_1.svg","/uploads/images/apps/cyberblade-2088_screen_2.svg","/uploads/images/apps/cyberblade-2088_screen_3.svg"]'
WHERE `appId` = 'cyberblade-2088';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/jewel-blast-pop_icon.svg',
  `thumbnail` = '/uploads/images/apps/jewel-blast-pop_thumb.svg',
  `images` = '["/uploads/images/apps/jewel-blast-pop_screen_1.svg","/uploads/images/apps/jewel-blast-pop_screen_2.svg","/uploads/images/apps/jewel-blast-pop_screen_3.svg"]'
WHERE `appId` = 'jewel-blast-pop';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/beat-wave-3d_icon.svg',
  `thumbnail` = '/uploads/images/apps/beat-wave-3d_thumb.svg',
  `images` = '["/uploads/images/apps/beat-wave-3d_screen_1.svg","/uploads/images/apps/beat-wave-3d_screen_2.svg","/uploads/images/apps/beat-wave-3d_screen_3.svg"]'
WHERE `appId` = 'beat-wave-3d';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/nitro-racers-overdrive_icon.svg',
  `thumbnail` = '/uploads/images/apps/nitro-racers-overdrive_thumb.svg',
  `images` = '["/uploads/images/apps/nitro-racers-overdrive_screen_1.svg","/uploads/images/apps/nitro-racers-overdrive_screen_2.svg","/uploads/images/apps/nitro-racers-overdrive_screen_3.svg"]'
WHERE `appId` = 'nitro-racers-overdrive';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/kingdom-tactics_icon.svg',
  `thumbnail` = '/uploads/images/apps/kingdom-tactics_thumb.svg',
  `images` = '["/uploads/images/apps/kingdom-tactics_screen_1.svg","/uploads/images/apps/kingdom-tactics_screen_2.svg","/uploads/images/apps/kingdom-tactics_screen_3.svg"]'
WHERE `appId` = 'kingdom-tactics';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/space-colony-2200_icon.svg',
  `thumbnail` = '/uploads/images/apps/space-colony-2200_thumb.svg',
  `images` = '["/uploads/images/apps/space-colony-2200_screen_1.svg","/uploads/images/apps/space-colony-2200_screen_2.svg","/uploads/images/apps/space-colony-2200_screen_3.svg"]'
WHERE `appId` = 'space-colony-2200';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/dungeon-diver-deep_icon.svg',
  `thumbnail` = '/uploads/images/apps/dungeon-diver-deep_thumb.svg',
  `images` = '["/uploads/images/apps/dungeon-diver-deep_screen_1.svg","/uploads/images/apps/dungeon-diver-deep_screen_2.svg","/uploads/images/apps/dungeon-diver-deep_screen_3.svg"]'
WHERE `appId` = 'dungeon-diver-deep';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/shadow-dash-ninja_icon.svg',
  `thumbnail` = '/uploads/images/apps/shadow-dash-ninja_thumb.svg',
  `images` = '["/uploads/images/apps/shadow-dash-ninja_screen_1.svg","/uploads/images/apps/shadow-dash-ninja_screen_2.svg","/uploads/images/apps/shadow-dash-ninja_screen_3.svg"]'
WHERE `appId` = 'shadow-dash-ninja';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/my-cafe-life_icon.svg',
  `thumbnail` = '/uploads/images/apps/my-cafe-life_thumb.svg',
  `images` = '["/uploads/images/apps/my-cafe-life_screen_1.svg","/uploads/images/apps/my-cafe-life_screen_2.svg","/uploads/images/apps/my-cafe-life_screen_3.svg"]'
WHERE `appId` = 'my-cafe-life';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/galaxy-wars-fleet_icon.svg',
  `thumbnail` = '/uploads/images/apps/galaxy-wars-fleet_thumb.svg',
  `images` = '["/uploads/images/apps/galaxy-wars-fleet_screen_1.svg","/uploads/images/apps/galaxy-wars-fleet_screen_2.svg","/uploads/images/apps/galaxy-wars-fleet_screen_3.svg"]'
WHERE `appId` = 'galaxy-wars-fleet';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/block-connect-brain_icon.svg',
  `thumbnail` = '/uploads/images/apps/block-connect-brain_thumb.svg',
  `images` = '["/uploads/images/apps/block-connect-brain_screen_1.svg","/uploads/images/apps/block-connect-brain_screen_2.svg","/uploads/images/apps/block-connect-brain_screen_3.svg"]'
WHERE `appId` = 'block-connect-brain';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/rhythm-sinfonia_icon.svg',
  `thumbnail` = '/uploads/images/apps/rhythm-sinfonia_thumb.svg',
  `images` = '["/uploads/images/apps/rhythm-sinfonia_screen_1.svg","/uploads/images/apps/rhythm-sinfonia_screen_2.svg","/uploads/images/apps/rhythm-sinfonia_screen_3.svg"]'
WHERE `appId` = 'rhythm-sinfonia';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/drift-master-tokyo_icon.svg',
  `thumbnail` = '/uploads/images/apps/drift-master-tokyo_thumb.svg',
  `images` = '["/uploads/images/apps/drift-master-tokyo_screen_1.svg","/uploads/images/apps/drift-master-tokyo_screen_2.svg","/uploads/images/apps/drift-master-tokyo_screen_3.svg"]'
WHERE `appId` = 'drift-master-tokyo';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/tower-defense-zero_icon.svg',
  `thumbnail` = '/uploads/images/apps/tower-defense-zero_thumb.svg',
  `images` = '["/uploads/images/apps/tower-defense-zero_screen_1.svg","/uploads/images/apps/tower-defense-zero_screen_2.svg","/uploads/images/apps/tower-defense-zero_screen_3.svg"]'
WHERE `appId` = 'tower-defense-zero';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/dragons-legacy_icon.svg',
  `thumbnail` = '/uploads/images/apps/dragons-legacy_thumb.svg',
  `images` = '["/uploads/images/apps/dragons-legacy_screen_1.svg","/uploads/images/apps/dragons-legacy_screen_2.svg","/uploads/images/apps/dragons-legacy_screen_3.svg"]'
WHERE `appId` = 'dragons-legacy';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/mecha-battlers-arena_icon.svg',
  `thumbnail` = '/uploads/images/apps/mecha-battlers-arena_thumb.svg',
  `images` = '["/uploads/images/apps/mecha-battlers-arena_screen_1.svg","/uploads/images/apps/mecha-battlers-arena_screen_2.svg","/uploads/images/apps/mecha-battlers-arena_screen_3.svg"]'
WHERE `appId` = 'mecha-battlers-arena';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/penguin-island-garden_icon.svg',
  `thumbnail` = '/uploads/images/apps/penguin-island-garden_thumb.svg',
  `images` = '["/uploads/images/apps/penguin-island-garden_screen_1.svg","/uploads/images/apps/penguin-island-garden_screen_2.svg","/uploads/images/apps/penguin-island-garden_screen_3.svg"]'
WHERE `appId` = 'penguin-island-garden';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/number-puzzle-cross_icon.svg',
  `thumbnail` = '/uploads/images/apps/number-puzzle-cross_thumb.svg',
  `images` = '["/uploads/images/apps/number-puzzle-cross_screen_1.svg","/uploads/images/apps/number-puzzle-cross_screen_2.svg","/uploads/images/apps/number-puzzle-cross_screen_3.svg"]'
WHERE `appId` = 'number-puzzle-cross';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/techno-step-arcade_icon.svg',
  `thumbnail` = '/uploads/images/apps/techno-step-arcade_thumb.svg',
  `images` = '["/uploads/images/apps/techno-step-arcade_screen_1.svg","/uploads/images/apps/techno-step-arcade_screen_2.svg","/uploads/images/apps/techno-step-arcade_screen_3.svg"]'
WHERE `appId` = 'techno-step-arcade';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/mini-kart-grand-prix_icon.svg',
  `thumbnail` = '/uploads/images/apps/mini-kart-grand-prix_thumb.svg',
  `images` = '["/uploads/images/apps/mini-kart-grand-prix_screen_1.svg","/uploads/images/apps/mini-kart-grand-prix_screen_2.svg","/uploads/images/apps/mini-kart-grand-prix_screen_3.svg"]'
WHERE `appId` = 'mini-kart-grand-prix';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/aether-fantasy-beast_icon.svg',
  `thumbnail` = '/uploads/images/apps/aether-fantasy-beast_thumb.svg',
  `images` = '["/uploads/images/apps/aether-fantasy-beast_screen_1.svg","/uploads/images/apps/aether-fantasy-beast_screen_2.svg","/uploads/images/apps/aether-fantasy-beast_screen_3.svg"]'
WHERE `appId` = 'aether-fantasy-beast';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/speed-storm-fist_icon.svg',
  `thumbnail` = '/uploads/images/apps/speed-storm-fist_thumb.svg',
  `images` = '["/uploads/images/apps/speed-storm-fist_screen_1.svg","/uploads/images/apps/speed-storm-fist_screen_2.svg","/uploads/images/apps/speed-storm-fist_screen_3.svg"]'
WHERE `appId` = 'speed-storm-fist';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/farm-harvest-seasons_icon.svg',
  `thumbnail` = '/uploads/images/apps/farm-harvest-seasons_thumb.svg',
  `images` = '["/uploads/images/apps/farm-harvest-seasons_screen_1.svg","/uploads/images/apps/farm-harvest-seasons_screen_2.svg","/uploads/images/apps/farm-harvest-seasons_screen_3.svg"]'
WHERE `appId` = 'farm-harvest-seasons';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/war-of-empire-reign_icon.svg',
  `thumbnail` = '/uploads/images/apps/war-of-empire-reign_thumb.svg',
  `images` = '["/uploads/images/apps/war-of-empire-reign_screen_1.svg","/uploads/images/apps/war-of-empire-reign_screen_2.svg","/uploads/images/apps/war-of-empire-reign_screen_3.svg"]'
WHERE `appId` = 'war-of-empire-reign';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/physics-sandbox-play_icon.svg',
  `thumbnail` = '/uploads/images/apps/physics-sandbox-play_thumb.svg',
  `images` = '["/uploads/images/apps/physics-sandbox-play_screen_1.svg","/uploads/images/apps/physics-sandbox-play_screen_2.svg","/uploads/images/apps/physics-sandbox-play_screen_3.svg"]'
WHERE `appId` = 'physics-sandbox-play';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/piano-melody-tiles_icon.svg',
  `thumbnail` = '/uploads/images/apps/piano-melody-tiles_thumb.svg',
  `images` = '["/uploads/images/apps/piano-melody-tiles_screen_1.svg","/uploads/images/apps/piano-melody-tiles_screen_2.svg","/uploads/images/apps/piano-melody-tiles_screen_3.svg"]'
WHERE `appId` = 'piano-melody-tiles';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/highway-chase-police_icon.svg',
  `thumbnail` = '/uploads/images/apps/highway-chase-police_thumb.svg',
  `images` = '["/uploads/images/apps/highway-chase-police_screen_1.svg","/uploads/images/apps/highway-chase-police_screen_2.svg","/uploads/images/apps/highway-chase-police_screen_3.svg"]'
WHERE `appId` = 'highway-chase-police';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/starfall-adventurers_icon.svg',
  `thumbnail` = '/uploads/images/apps/starfall-adventurers_thumb.svg',
  `images` = '["/uploads/images/apps/starfall-adventurers_screen_1.svg","/uploads/images/apps/starfall-adventurers_screen_2.svg","/uploads/images/apps/starfall-adventurers_screen_3.svg"]'
WHERE `appId` = 'starfall-adventurers';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/monster-hunter-soul_icon.svg',
  `thumbnail` = '/uploads/images/apps/monster-hunter-soul_thumb.svg',
  `images` = '["/uploads/images/apps/monster-hunter-soul_screen_1.svg","/uploads/images/apps/monster-hunter-soul_screen_2.svg","/uploads/images/apps/monster-hunter-soul_screen_3.svg"]'
WHERE `appId` = 'monster-hunter-soul';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/train-tycoon-railway_icon.svg',
  `thumbnail` = '/uploads/images/apps/train-tycoon-railway_thumb.svg',
  `images` = '["/uploads/images/apps/train-tycoon-railway_screen_1.svg","/uploads/images/apps/train-tycoon-railway_screen_2.svg","/uploads/images/apps/train-tycoon-railway_screen_3.svg"]'
WHERE `appId` = 'train-tycoon-railway';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/craft-survival-island_icon.svg',
  `thumbnail` = '/uploads/images/apps/craft-survival-island_thumb.svg',
  `images` = '["/uploads/images/apps/craft-survival-island_screen_1.svg","/uploads/images/apps/craft-survival-island_screen_2.svg","/uploads/images/apps/craft-survival-island_screen_3.svg"]'
WHERE `appId` = 'craft-survival-island';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/color-sort-ball-puzzle_icon.svg',
  `thumbnail` = '/uploads/images/apps/color-sort-ball-puzzle_thumb.svg',
  `images` = '["/uploads/images/apps/color-sort-ball-puzzle_screen_1.svg","/uploads/images/apps/color-sort-ball-puzzle_screen_2.svg","/uploads/images/apps/color-sort-ball-puzzle_screen_3.svg"]'
WHERE `appId` = 'color-sort-ball-puzzle';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/electro-groove-dj_icon.svg',
  `thumbnail` = '/uploads/images/apps/electro-groove-dj_thumb.svg',
  `images` = '["/uploads/images/apps/electro-groove-dj_screen_1.svg","/uploads/images/apps/electro-groove-dj_screen_2.svg","/uploads/images/apps/electro-groove-dj_screen_3.svg"]'
WHERE `appId` = 'electro-groove-dj';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/offroad-climber-4x4_icon.svg',
  `thumbnail` = '/uploads/images/apps/offroad-climber-4x4_thumb.svg',
  `images` = '["/uploads/images/apps/offroad-climber-4x4_screen_1.svg","/uploads/images/apps/offroad-climber-4x4_screen_2.svg","/uploads/images/apps/offroad-climber-4x4_screen_3.svg"]'
WHERE `appId` = 'offroad-climber-4x4';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/abyss-knights-order_icon.svg',
  `thumbnail` = '/uploads/images/apps/abyss-knights-order_thumb.svg',
  `images` = '["/uploads/images/apps/abyss-knights-order_screen_1.svg","/uploads/images/apps/abyss-knights-order_screen_2.svg","/uploads/images/apps/abyss-knights-order_screen_3.svg"]'
WHERE `appId` = 'abyss-knights-order';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/archery-king-3d_icon.svg',
  `thumbnail` = '/uploads/images/apps/archery-king-3d_thumb.svg',
  `images` = '["/uploads/images/apps/archery-king-3d_screen_1.svg","/uploads/images/apps/archery-king-3d_screen_2.svg","/uploads/images/apps/archery-king-3d_screen_3.svg"]'
WHERE `appId` = 'archery-king-3d';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/aquarium-dream-world_icon.svg',
  `thumbnail` = '/uploads/images/apps/aquarium-dream-world_thumb.svg',
  `images` = '["/uploads/images/apps/aquarium-dream-world_screen_1.svg","/uploads/images/apps/aquarium-dream-world_screen_2.svg","/uploads/images/apps/aquarium-dream-world_screen_3.svg"]'
WHERE `appId` = 'aquarium-dream-world';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/commander-in-chief_icon.svg',
  `thumbnail` = '/uploads/images/apps/commander-in-chief_thumb.svg',
  `images` = '["/uploads/images/apps/commander-in-chief_screen_1.svg","/uploads/images/apps/commander-in-chief_screen_2.svg","/uploads/images/apps/commander-in-chief_screen_3.svg"]'
WHERE `appId` = 'commander-in-chief';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/tangram-geom-puzzle_icon.svg',
  `thumbnail` = '/uploads/images/apps/tangram-geom-puzzle_thumb.svg',
  `images` = '["/uploads/images/apps/tangram-geom-puzzle_screen_1.svg","/uploads/images/apps/tangram-geom-puzzle_screen_2.svg","/uploads/images/apps/tangram-geom-puzzle_screen_3.svg"]'
WHERE `appId` = 'tangram-geom-puzzle';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/eight-bit-heroes-retro_icon.svg',
  `thumbnail` = '/uploads/images/apps/eight-bit-heroes-retro_thumb.svg',
  `images` = '["/uploads/images/apps/eight-bit-heroes-retro_screen_1.svg","/uploads/images/apps/eight-bit-heroes-retro_screen_2.svg","/uploads/images/apps/eight-bit-heroes-retro_screen_3.svg"]'
WHERE `appId` = 'eight-bit-heroes-retro';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/sniper-elite-ghost_icon.svg',
  `thumbnail` = '/uploads/images/apps/sniper-elite-ghost_thumb.svg',
  `images` = '["/uploads/images/apps/sniper-elite-ghost_screen_1.svg","/uploads/images/apps/sniper-elite-ghost_screen_2.svg","/uploads/images/apps/sniper-elite-ghost_screen_3.svg"]'
WHERE `appId` = 'sniper-elite-ghost';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/city-builder-metro_icon.svg',
  `thumbnail` = '/uploads/images/apps/city-builder-metro_thumb.svg',
  `images` = '["/uploads/images/apps/city-builder-metro_screen_1.svg","/uploads/images/apps/city-builder-metro_screen_2.svg","/uploads/images/apps/city-builder-metro_screen_3.svg"]'
WHERE `appId` = 'city-builder-metro';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/word-master-sea_icon.svg',
  `thumbnail` = '/uploads/images/apps/word-master-sea_thumb.svg',
  `images` = '["/uploads/images/apps/word-master-sea_screen_1.svg","/uploads/images/apps/word-master-sea_screen_2.svg","/uploads/images/apps/word-master-sea_screen_3.svg"]'
WHERE `appId` = 'word-master-sea';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/airplane-flight-sim_icon.svg',
  `thumbnail` = '/uploads/images/apps/airplane-flight-sim_thumb.svg',
  `images` = '["/uploads/images/apps/airplane-flight-sim_screen_1.svg","/uploads/images/apps/airplane-flight-sim_screen_2.svg","/uploads/images/apps/airplane-flight-sim_screen_3.svg"]'
WHERE `appId` = 'airplane-flight-sim';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/rally-champion-wrc_icon.svg',
  `thumbnail` = '/uploads/images/apps/rally-champion-wrc_thumb.svg',
  `images` = '["/uploads/images/apps/rally-champion-wrc_screen_1.svg","/uploads/images/apps/rally-champion-wrc_screen_2.svg","/uploads/images/apps/rally-champion-wrc_screen_3.svg"]'
WHERE `appId` = 'rally-champion-wrc';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/valkyrie-crisis_icon.svg',
  `thumbnail` = '/uploads/images/apps/valkyrie-crisis_thumb.svg',
  `images` = '["/uploads/images/apps/valkyrie-crisis_screen_1.svg","/uploads/images/apps/valkyrie-crisis_screen_2.svg","/uploads/images/apps/valkyrie-crisis_screen_3.svg"]'
WHERE `appId` = 'valkyrie-crisis';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/crane-game-online_icon.svg',
  `thumbnail` = '/uploads/images/apps/crane-game-online_thumb.svg',
  `images` = '["/uploads/images/apps/crane-game-online_screen_1.svg","/uploads/images/apps/crane-game-online_screen_2.svg","/uploads/images/apps/crane-game-online_screen_3.svg"]'
WHERE `appId` = 'crane-game-online';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/chess-masters-ai_icon.svg',
  `thumbnail` = '/uploads/images/apps/chess-masters-ai_thumb.svg',
  `images` = '["/uploads/images/apps/chess-masters-ai_screen_1.svg","/uploads/images/apps/chess-masters-ai_screen_2.svg","/uploads/images/apps/chess-masters-ai_screen_3.svg"]'
WHERE `appId` = 'chess-masters-ai';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/bubble-shooter-pop_icon.svg',
  `thumbnail` = '/uploads/images/apps/bubble-shooter-pop_thumb.svg',
  `images` = '["/uploads/images/apps/bubble-shooter-pop_screen_1.svg","/uploads/images/apps/bubble-shooter-pop_screen_2.svg","/uploads/images/apps/bubble-shooter-pop_screen_3.svg"]'
WHERE `appId` = 'bubble-shooter-pop';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/enoki-file-manager_icon.svg',
  `thumbnail` = '/uploads/images/apps/enoki-file-manager_thumb.svg',
  `images` = '["/uploads/images/apps/enoki-file-manager_screen_1.svg","/uploads/images/apps/enoki-file-manager_screen_2.svg","/uploads/images/apps/enoki-file-manager_screen_3.svg"]'
WHERE `appId` = 'enoki-file-manager';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/focus-pomodoro-timer_icon.svg',
  `thumbnail` = '/uploads/images/apps/focus-pomodoro-timer_thumb.svg',
  `images` = '["/uploads/images/apps/focus-pomodoro-timer_screen_1.svg","/uploads/images/apps/focus-pomodoro-timer_screen_2.svg","/uploads/images/apps/focus-pomodoro-timer_screen_3.svg"]'
WHERE `appId` = 'focus-pomodoro-timer';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/retro-camera-1998_icon.svg',
  `thumbnail` = '/uploads/images/apps/retro-camera-1998_thumb.svg',
  `images` = '["/uploads/images/apps/retro-camera-1998_screen_1.svg","/uploads/images/apps/retro-camera-1998_screen_2.svg","/uploads/images/apps/retro-camera-1998_screen_3.svg"]'
WHERE `appId` = 'retro-camera-1998';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/enoki-chat-secure_icon.svg',
  `thumbnail` = '/uploads/images/apps/enoki-chat-secure_thumb.svg',
  `images` = '["/uploads/images/apps/enoki-chat-secure_screen_1.svg","/uploads/images/apps/enoki-chat-secure_screen_2.svg","/uploads/images/apps/enoki-chat-secure_screen_3.svg"]'
WHERE `appId` = 'enoki-chat-secure';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/simple-household-book_icon.svg',
  `thumbnail` = '/uploads/images/apps/simple-household-book_thumb.svg',
  `images` = '["/uploads/images/apps/simple-household-book_screen_1.svg","/uploads/images/apps/simple-household-book_screen_2.svg","/uploads/images/apps/simple-household-book_screen_3.svg"]'
WHERE `appId` = 'simple-household-book';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/rain-radar-weather_icon.svg',
  `thumbnail` = '/uploads/images/apps/rain-radar-weather_thumb.svg',
  `images` = '["/uploads/images/apps/rain-radar-weather_screen_1.svg","/uploads/images/apps/rain-radar-weather_screen_2.svg","/uploads/images/apps/rain-radar-weather_screen_3.svg"]'
WHERE `appId` = 'rain-radar-weather';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/markdown-notes-sync_icon.svg',
  `thumbnail` = '/uploads/images/apps/markdown-notes-sync_thumb.svg',
  `images` = '["/uploads/images/apps/markdown-notes-sync_screen_1.svg","/uploads/images/apps/markdown-notes-sync_screen_2.svg","/uploads/images/apps/markdown-notes-sync_screen_3.svg"]'
WHERE `appId` = 'markdown-notes-sync';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/ai-portrait-retouch-hd_icon.svg',
  `thumbnail` = '/uploads/images/apps/ai-portrait-retouch-hd_thumb.svg',
  `images` = '["/uploads/images/apps/ai-portrait-retouch-hd_screen_1.svg","/uploads/images/apps/ai-portrait-retouch-hd_screen_2.svg","/uploads/images/apps/ai-portrait-retouch-hd_screen_3.svg"]'
WHERE `appId` = 'ai-portrait-retouch-hd';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/smart-qr-barcode-reader_icon.svg',
  `thumbnail` = '/uploads/images/apps/smart-qr-barcode-reader_thumb.svg',
  `images` = '["/uploads/images/apps/smart-qr-barcode-reader_screen_1.svg","/uploads/images/apps/smart-qr-barcode-reader_screen_2.svg","/uploads/images/apps/smart-qr-barcode-reader_screen_3.svg"]'
WHERE `appId` = 'smart-qr-barcode-reader';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/ambient-sleep-whitenoise_icon.svg',
  `thumbnail` = '/uploads/images/apps/ambient-sleep-whitenoise_thumb.svg',
  `images` = '["/uploads/images/apps/ambient-sleep-whitenoise_screen_1.svg","/uploads/images/apps/ambient-sleep-whitenoise_screen_2.svg","/uploads/images/apps/ambient-sleep-whitenoise_screen_3.svg"]'
WHERE `appId` = 'ambient-sleep-whitenoise';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/task-kanban-board_icon.svg',
  `thumbnail` = '/uploads/images/apps/task-kanban-board_thumb.svg',
  `images` = '["/uploads/images/apps/task-kanban-board_screen_1.svg","/uploads/images/apps/task-kanban-board_screen_2.svg","/uploads/images/apps/task-kanban-board_screen_3.svg"]'
WHERE `appId` = 'task-kanban-board';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/asset-tracker-crypto_icon.svg',
  `thumbnail` = '/uploads/images/apps/asset-tracker-crypto_thumb.svg',
  `images` = '["/uploads/images/apps/asset-tracker-crypto_screen_1.svg","/uploads/images/apps/asset-tracker-crypto_screen_2.svg","/uploads/images/apps/asset-tracker-crypto_screen_3.svg"]'
WHERE `appId` = 'asset-tracker-crypto';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/daily-english-memory_icon.svg',
  `thumbnail` = '/uploads/images/apps/daily-english-memory_thumb.svg',
  `images` = '["/uploads/images/apps/daily-english-memory_screen_1.svg","/uploads/images/apps/daily-english-memory_screen_2.svg","/uploads/images/apps/daily-english-memory_screen_3.svg"]'
WHERE `appId` = 'daily-english-memory';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/sleep-assist-tracker_icon.svg',
  `thumbnail` = '/uploads/images/apps/sleep-assist-tracker_thumb.svg',
  `images` = '["/uploads/images/apps/sleep-assist-tracker_screen_1.svg","/uploads/images/apps/sleep-assist-tracker_screen_2.svg","/uploads/images/apps/sleep-assist-tracker_screen_3.svg"]'
WHERE `appId` = 'sleep-assist-tracker';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/pdf-scanner-signature_icon.svg',
  `thumbnail` = '/uploads/images/apps/pdf-scanner-signature_thumb.svg',
  `images` = '["/uploads/images/apps/pdf-scanner-signature_screen_1.svg","/uploads/images/apps/pdf-scanner-signature_screen_2.svg","/uploads/images/apps/pdf-scanner-signature_screen_3.svg"]'
WHERE `appId` = 'pdf-scanner-signature';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/equalizer-fx-pro_icon.svg',
  `thumbnail` = '/uploads/images/apps/equalizer-fx-pro_thumb.svg',
  `images` = '["/uploads/images/apps/equalizer-fx-pro_screen_1.svg","/uploads/images/apps/equalizer-fx-pro_screen_2.svg","/uploads/images/apps/equalizer-fx-pro_screen_3.svg"]'
WHERE `appId` = 'equalizer-fx-pro';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/quick-calc-converter_icon.svg',
  `thumbnail` = '/uploads/images/apps/quick-calc-converter_thumb.svg',
  `images` = '["/uploads/images/apps/quick-calc-converter_screen_1.svg","/uploads/images/apps/quick-calc-converter_screen_2.svg","/uploads/images/apps/quick-calc-converter_screen_3.svg"]'
WHERE `appId` = 'quick-calc-converter';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/stargazer-3d-astronomy_icon.svg',
  `thumbnail` = '/uploads/images/apps/stargazer-3d-astronomy_thumb.svg',
  `images` = '["/uploads/images/apps/stargazer-3d-astronomy_screen_1.svg","/uploads/images/apps/stargazer-3d-astronomy_screen_2.svg","/uploads/images/apps/stargazer-3d-astronomy_screen_3.svg"]'
WHERE `appId` = 'stargazer-3d-astronomy';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/smart-meditation-5min_icon.svg',
  `thumbnail` = '/uploads/images/apps/smart-meditation-5min_thumb.svg',
  `images` = '["/uploads/images/apps/smart-meditation-5min_screen_1.svg","/uploads/images/apps/smart-meditation-5min_screen_2.svg","/uploads/images/apps/smart-meditation-5min_screen_3.svg"]'
WHERE `appId` = 'smart-meditation-5min';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/short-video-vlog-editor_icon.svg',
  `thumbnail` = '/uploads/images/apps/short-video-vlog-editor_thumb.svg',
  `images` = '["/uploads/images/apps/short-video-vlog-editor_screen_1.svg","/uploads/images/apps/short-video-vlog-editor_screen_2.svg","/uploads/images/apps/short-video-vlog-editor_screen_3.svg"]'
WHERE `appId` = 'short-video-vlog-editor';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/battery-doctor-saver_icon.svg',
  `thumbnail` = '/uploads/images/apps/battery-doctor-saver_thumb.svg',
  `images` = '["/uploads/images/apps/battery-doctor-saver_screen_1.svg","/uploads/images/apps/battery-doctor-saver_screen_2.svg","/uploads/images/apps/battery-doctor-saver_screen_3.svg"]'
WHERE `appId` = 'battery-doctor-saver';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/voiceroom-social-audio_icon.svg',
  `thumbnail` = '/uploads/images/apps/voiceroom-social-audio_thumb.svg',
  `images` = '["/uploads/images/apps/voiceroom-social-audio_screen_1.svg","/uploads/images/apps/voiceroom-social-audio_screen_2.svg","/uploads/images/apps/voiceroom-social-audio_screen_3.svg"]'
WHERE `appId` = 'voiceroom-social-audio';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/receipt-household-ai_icon.svg',
  `thumbnail` = '/uploads/images/apps/receipt-household-ai_thumb.svg',
  `images` = '["/uploads/images/apps/receipt-household-ai_screen_1.svg","/uploads/images/apps/receipt-household-ai_screen_2.svg","/uploads/images/apps/receipt-household-ai_screen_3.svg"]'
WHERE `appId` = 'receipt-household-ai';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/comic-reader-pro_icon.svg',
  `thumbnail` = '/uploads/images/apps/comic-reader-pro_thumb.svg',
  `images` = '["/uploads/images/apps/comic-reader-pro_screen_1.svg","/uploads/images/apps/comic-reader-pro_screen_2.svg","/uploads/images/apps/comic-reader-pro_screen_3.svg"]'
WHERE `appId` = 'comic-reader-pro';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/programming-python-learn_icon.svg',
  `thumbnail` = '/uploads/images/apps/programming-python-learn_thumb.svg',
  `images` = '["/uploads/images/apps/programming-python-learn_screen_1.svg","/uploads/images/apps/programming-python-learn_screen_2.svg","/uploads/images/apps/programming-python-learn_screen_3.svg"]'
WHERE `appId` = 'programming-python-learn';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/daily-water-hydration_icon.svg',
  `thumbnail` = '/uploads/images/apps/daily-water-hydration_thumb.svg',
  `images` = '["/uploads/images/apps/daily-water-hydration_screen_1.svg","/uploads/images/apps/daily-water-hydration_screen_2.svg","/uploads/images/apps/daily-water-hydration_screen_3.svg"]'
WHERE `appId` = 'daily-water-hydration';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/podcast-cast-hd_icon.svg',
  `thumbnail` = '/uploads/images/apps/podcast-cast-hd_thumb.svg',
  `images` = '["/uploads/images/apps/podcast-cast-hd_screen_1.svg","/uploads/images/apps/podcast-cast-hd_screen_2.svg","/uploads/images/apps/podcast-cast-hd_screen_3.svg"]'
WHERE `appId` = 'podcast-cast-hd';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/exchange-rate-alert_icon.svg',
  `thumbnail` = '/uploads/images/apps/exchange-rate-alert_thumb.svg',
  `images` = '["/uploads/images/apps/exchange-rate-alert_screen_1.svg","/uploads/images/apps/exchange-rate-alert_screen_2.svg","/uploads/images/apps/exchange-rate-alert_screen_3.svg"]'
WHERE `appId` = 'exchange-rate-alert';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/wifi-speedtest-analyzer_icon.svg',
  `thumbnail` = '/uploads/images/apps/wifi-speedtest-analyzer_thumb.svg',
  `images` = '["/uploads/images/apps/wifi-speedtest-analyzer_screen_1.svg","/uploads/images/apps/wifi-speedtest-analyzer_screen_2.svg","/uploads/images/apps/wifi-speedtest-analyzer_screen_3.svg"]'
WHERE `appId` = 'wifi-speedtest-analyzer';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/short-novel-paradise_icon.svg',
  `thumbnail` = '/uploads/images/apps/short-novel-paradise_thumb.svg',
  `images` = '["/uploads/images/apps/short-novel-paradise_screen_1.svg","/uploads/images/apps/short-novel-paradise_screen_2.svg","/uploads/images/apps/short-novel-paradise_screen_3.svg"]'
WHERE `appId` = 'short-novel-paradise';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/voice-recorder-hd-pro_icon.svg',
  `thumbnail` = '/uploads/images/apps/voice-recorder-hd-pro_thumb.svg',
  `images` = '["/uploads/images/apps/voice-recorder-hd-pro_screen_1.svg","/uploads/images/apps/voice-recorder-hd-pro_screen_2.svg","/uploads/images/apps/voice-recorder-hd-pro_screen_3.svg"]'
WHERE `appId` = 'voice-recorder-hd-pro';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/timezone-world-clock_icon.svg',
  `thumbnail` = '/uploads/images/apps/timezone-world-clock_thumb.svg',
  `images` = '["/uploads/images/apps/timezone-world-clock_screen_1.svg","/uploads/images/apps/timezone-world-clock_screen_2.svg","/uploads/images/apps/timezone-world-clock_screen_3.svg"]'
WHERE `appId` = 'timezone-world-clock';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/running-tracker-gps_icon.svg',
  `thumbnail` = '/uploads/images/apps/running-tracker-gps_thumb.svg',
  `images` = '["/uploads/images/apps/running-tracker-gps_screen_1.svg","/uploads/images/apps/running-tracker-gps_screen_2.svg","/uploads/images/apps/running-tracker-gps_screen_3.svg"]'
WHERE `appId` = 'running-tracker-gps';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/collage-maker-photo-fx_icon.svg',
  `thumbnail` = '/uploads/images/apps/collage-maker-photo-fx_thumb.svg',
  `images` = '["/uploads/images/apps/collage-maker-photo-fx_screen_1.svg","/uploads/images/apps/collage-maker-photo-fx_screen_2.svg","/uploads/images/apps/collage-maker-photo-fx_screen_3.svg"]'
WHERE `appId` = 'collage-maker-photo-fx';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/clipboard-manager-history_icon.svg',
  `thumbnail` = '/uploads/images/apps/clipboard-manager-history_thumb.svg',
  `images` = '["/uploads/images/apps/clipboard-manager-history_screen_1.svg","/uploads/images/apps/clipboard-manager-history_screen_2.svg","/uploads/images/apps/clipboard-manager-history_screen_3.svg"]'
WHERE `appId` = 'clipboard-manager-history';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/habit-tracker-30days_icon.svg',
  `thumbnail` = '/uploads/images/apps/habit-tracker-30days_thumb.svg',
  `images` = '["/uploads/images/apps/habit-tracker-30days_screen_1.svg","/uploads/images/apps/habit-tracker-30days_screen_2.svg","/uploads/images/apps/habit-tracker-30days_screen_3.svg"]'
WHERE `appId` = 'habit-tracker-30days';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/earthquake-warning-map_icon.svg',
  `thumbnail` = '/uploads/images/apps/earthquake-warning-map_thumb.svg',
  `images` = '["/uploads/images/apps/earthquake-warning-map_screen_1.svg","/uploads/images/apps/earthquake-warning-map_screen_2.svg","/uploads/images/apps/earthquake-warning-map_screen_3.svg"]'
WHERE `appId` = 'earthquake-warning-map';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/minimalist-secret-diary_icon.svg',
  `thumbnail` = '/uploads/images/apps/minimalist-secret-diary_thumb.svg',
  `images` = '["/uploads/images/apps/minimalist-secret-diary_screen_1.svg","/uploads/images/apps/minimalist-secret-diary_screen_2.svg","/uploads/images/apps/minimalist-secret-diary_screen_3.svg"]'
WHERE `appId` = 'minimalist-secret-diary';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/guitar-tuner-metronome_icon.svg',
  `thumbnail` = '/uploads/images/apps/guitar-tuner-metronome_thumb.svg',
  `images` = '["/uploads/images/apps/guitar-tuner-metronome_screen_1.svg","/uploads/images/apps/guitar-tuner-metronome_screen_2.svg","/uploads/images/apps/guitar-tuner-metronome_screen_3.svg"]'
WHERE `appId` = 'guitar-tuner-metronome';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/password-vault-safe_icon.svg',
  `thumbnail` = '/uploads/images/apps/password-vault-safe_thumb.svg',
  `images` = '["/uploads/images/apps/password-vault-safe_screen_1.svg","/uploads/images/apps/password-vault-safe_screen_2.svg","/uploads/images/apps/password-vault-safe_screen_3.svg"]'
WHERE `appId` = 'password-vault-safe';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/calorie-management-ai_icon.svg',
  `thumbnail` = '/uploads/images/apps/calorie-management-ai_thumb.svg',
  `images` = '["/uploads/images/apps/calorie-management-ai_screen_1.svg","/uploads/images/apps/calorie-management-ai_screen_2.svg","/uploads/images/apps/calorie-management-ai_screen_3.svg"]'
WHERE `appId` = 'calorie-management-ai';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/illustration-sketch-draw_icon.svg',
  `thumbnail` = '/uploads/images/apps/illustration-sketch-draw_thumb.svg',
  `images` = '["/uploads/images/apps/illustration-sketch-draw_screen_1.svg","/uploads/images/apps/illustration-sketch-draw_screen_2.svg","/uploads/images/apps/illustration-sketch-draw_screen_3.svg"]'
WHERE `appId` = 'illustration-sketch-draw';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/business-card-scanner_icon.svg',
  `thumbnail` = '/uploads/images/apps/business-card-scanner_thumb.svg',
  `images` = '["/uploads/images/apps/business-card-scanner_screen_1.svg","/uploads/images/apps/business-card-scanner_screen_2.svg","/uploads/images/apps/business-card-scanner_screen_3.svg"]'
WHERE `appId` = 'business-card-scanner';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/world-radio-fm-am_icon.svg',
  `thumbnail` = '/uploads/images/apps/world-radio-fm-am_thumb.svg',
  `images` = '["/uploads/images/apps/world-radio-fm-am_screen_1.svg","/uploads/images/apps/world-radio-fm-am_screen_2.svg","/uploads/images/apps/world-radio-fm-am_screen_3.svg"]'
WHERE `appId` = 'world-radio-fm-am';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/bluelight-filter-care_icon.svg',
  `thumbnail` = '/uploads/images/apps/bluelight-filter-care_thumb.svg',
  `images` = '["/uploads/images/apps/bluelight-filter-care_screen_1.svg","/uploads/images/apps/bluelight-filter-care_screen_2.svg","/uploads/images/apps/bluelight-filter-care_screen_3.svg"]'
WHERE `appId` = 'bluelight-filter-care';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/flick-typing-practice_icon.svg',
  `thumbnail` = '/uploads/images/apps/flick-typing-practice_thumb.svg',
  `images` = '["/uploads/images/apps/flick-typing-practice_screen_1.svg","/uploads/images/apps/flick-typing-practice_screen_2.svg","/uploads/images/apps/flick-typing-practice_screen_3.svg"]'
WHERE `appId` = 'flick-typing-practice';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/shopping-list-share_icon.svg',
  `thumbnail` = '/uploads/images/apps/shopping-list-share_thumb.svg',
  `images` = '["/uploads/images/apps/shopping-list-share_screen_1.svg","/uploads/images/apps/shopping-list-share_screen_2.svg","/uploads/images/apps/shopping-list-share_screen_3.svg"]'
WHERE `appId` = 'shopping-list-share';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/compass-level-altimeter_icon.svg',
  `thumbnail` = '/uploads/images/apps/compass-level-altimeter_thumb.svg',
  `images` = '["/uploads/images/apps/compass-level-altimeter_screen_1.svg","/uploads/images/apps/compass-level-altimeter_screen_2.svg","/uploads/images/apps/compass-level-altimeter_screen_3.svg"]'
WHERE `appId` = 'compass-level-altimeter';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/stretch-refresh-alarm_icon.svg',
  `thumbnail` = '/uploads/images/apps/stretch-refresh-alarm_thumb.svg',
  `images` = '["/uploads/images/apps/stretch-refresh-alarm_screen_1.svg","/uploads/images/apps/stretch-refresh-alarm_screen_2.svg","/uploads/images/apps/stretch-refresh-alarm_screen_3.svg"]'
WHERE `appId` = 'stretch-refresh-alarm';

UPDATE `app_list` SET 
  `icon` = '/uploads/images/apps/smart-alarm-clock-wake_icon.svg',
  `thumbnail` = '/uploads/images/apps/smart-alarm-clock-wake_thumb.svg',
  `images` = '["/uploads/images/apps/smart-alarm-clock-wake_screen_1.svg","/uploads/images/apps/smart-alarm-clock-wake_screen_2.svg","/uploads/images/apps/smart-alarm-clock-wake_screen_3.svg"]'
WHERE `appId` = 'smart-alarm-clock-wake';

COMMIT;
