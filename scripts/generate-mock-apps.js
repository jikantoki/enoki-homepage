import fs from 'fs';
import path from 'path';

const uploadsAppDir = path.resolve('public/uploads/images/apps');
if (!fs.existsSync(uploadsAppDir)) {
  fs.mkdirSync(uploadsAppDir, { recursive: true });
}

// アイコン生成関数 (256x256 SVG ファイル保存 & URL返却)
function createIconSvg(id, title, symbol, color1, color2, accent) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="grad_${id}" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${color1}"/>
      <stop offset="100%" stop-color="${color2}"/>
    </linearGradient>
    <filter id="shadow_${id}" x="-10%" y="-10%" width="130%" height="130%">
      <feDropShadow dx="0" dy="8" stdDeviation="12" flood-color="#000000" flood-opacity="0.35"/>
    </filter>
  </defs>
  <rect width="256" height="256" rx="56" fill="url(#grad_${id})"/>
  <circle cx="128" cy="128" r="90" fill="none" stroke="${accent}" stroke-width="3" opacity="0.25"/>
  <g filter="url(#shadow_${id})" fill="#ffffff" transform="translate(128 128) scale(1.1) translate(-128 -128)">
    ${symbol}
  </g>
</svg>`;
  const filename = `${id}_icon.svg`;
  fs.writeFileSync(path.join(uploadsAppDir, filename), svg, 'utf-8');
  return `/uploads/images/apps/${filename}`;
}

// サムネイル生成関数 (640x360 SVG ファイル保存 & URL返却)
function createThumbnailSvg(id, title, category, color1, color2, symbol) {
  const cleanTitle = title.replace(/[<>&"']/g, '');
  const cleanCat = category.replace(/[<>&"']/g, '');
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 360" width="640" height="360">
  <defs>
    <linearGradient id="bg_${id}" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${color1}"/>
      <stop offset="100%" stop-color="${color2}"/>
    </linearGradient>
    <linearGradient id="overlay_${id}" x1="0%" y1="100%" x2="0%" y2="0%">
      <stop offset="0%" stop-color="#000000" stop-opacity="0.8"/>
      <stop offset="60%" stop-color="#000000" stop-opacity="0.2"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect width="640" height="360" fill="url(#bg_${id})"/>
  <g opacity="0.12" fill="#ffffff" transform="translate(380, 40) scale(2.2)">
    ${symbol}
  </g>
  <circle cx="100" cy="80" r="140" fill="#ffffff" opacity="0.06"/>
  <circle cx="560" cy="280" r="180" fill="#ffffff" opacity="0.08"/>
  <rect width="640" height="360" fill="url(#overlay_${id})"/>
  <text x="36" y="270" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="28" fill="#ffffff">${cleanTitle}</text>
  <text x="36" y="305" font-family="system-ui, -apple-system, sans-serif" font-weight="500" font-size="16" fill="#e0e0e0">${cleanCat} • 公式ハイライト</text>
</svg>`;
  const filename = `${id}_thumb.svg`;
  fs.writeFileSync(path.join(uploadsAppDir, filename), svg, 'utf-8');
  return `/uploads/images/apps/${filename}`;
}

// スクリーンショット生成関数 (360x640 SVG ファイル保存 & URL返却)
function createScreenshotSvg(id, title, step, color1, color2) {
  const cleanTitle = title.replace(/[<>&"']/g, '');
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 360 640" width="360" height="640">
  <defs>
    <linearGradient id="sbg_${id}_${step}" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${color1}"/>
      <stop offset="100%" stop-color="${color2}"/>
    </linearGradient>
  </defs>
  <rect width="360" height="640" fill="#121212"/>
  <rect x="16" y="24" width="328" height="592" rx="28" fill="url(#sbg_${id}_${step})"/>
  <rect x="36" y="60" width="288" height="180" rx="16" fill="#ffffff" opacity="0.15"/>
  <text x="180" y="155" text-anchor="middle" font-family="system-ui, sans-serif" font-weight="700" font-size="22" fill="#ffffff">Preview ${step}</text>
  <text x="180" y="320" text-anchor="middle" font-family="system-ui, sans-serif" font-weight="600" font-size="18" fill="#ffffff">${cleanTitle}</text>
  <rect x="40" y="380" width="280" height="24" rx="8" fill="#ffffff" opacity="0.25"/>
  <rect x="40" y="420" width="220" height="18" rx="6" fill="#ffffff" opacity="0.2"/>
  <rect x="40" y="450" width="250" height="18" rx="6" fill="#ffffff" opacity="0.2"/>
  <rect x="40" y="520" width="280" height="54" rx="27" fill="#ffffff" opacity="0.9"/>
  <text x="180" y="554" text-anchor="middle" font-family="system-ui, sans-serif" font-weight="700" font-size="16" fill="#000000">今すぐ体験</text>
</svg>`;
  const filename = `${id}_screen_${step}.svg`;
  fs.writeFileSync(path.join(uploadsAppDir, filename), svg, 'utf-8');
  return `/uploads/images/apps/${filename}`;
}

// アイコンシンボル定義
const SYMBOLS = {
  gamepad: '<path d="M185 80H71a47 47 0 0 0-47 47v28a47 47 0 0 0 80 33l14-14h18l14 14a47 47 0 0 0 80-33v-28a47 47 0 0 0-45-47zm-105 56h-16v16h-16v-16H32v-16h16v-16h16v16h16v16zm92 12a12 12 0 1 1 12-12 12 12 0 0 1-12 12zm24-24a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>',
  sword: '<path d="M197 45a10 10 0 0 0-14 0l-57 57 14 14 57-57a10 10 0 0 0 0-14zM86 112L72 98 45 125l14 14-27 27a10 10 0 0 0 0 14l14 14a10 10 0 0 0 14 0l27-27 14 14 27-27-14-14 14-14-41-41z"/>',
  rocket: '<path d="M131 43c-39 0-70 26-80 62l24 24c8-3 17-5 26-5 27 0 50 16 60 40l24 24c36-10 62-41 62-80 0-36-51-65-116-65zm-61 97l-32 32 15 15 32-32-15-15zm102 47l-32 32 15 15 32-32-15-15z"/>',
  star: '<path d="M128 36l28 58 64 9-46 45 11 64-57-30-57 30 11-64-46-45 64-9z"/>',
  music: '<path d="M180 48v96a36 36 0 1 1-24-34V76l-72 16v84a36 36 0 1 1-24-34V64l120-16z"/>',
  camera: '<path d="M128 92a36 36 0 1 0 36 36 36 36 0 0 0-36-36zm76-32h-32l-12-16H96L84 60H52a28 28 0 0 0-28 28v96a28 28 0 0 0 28 28h152a28 28 0 0 0 28-28V88a28 28 0 0 0-28-28z"/>',
  chat: '<path d="M128 44C75 44 32 80 32 124c0 24 13 46 34 61l-10 35 41-18c10 4 20 6 31 6 53 0 96-36 96-80s-43-84-96-84z"/>',
  code: '<path d="M94 166L48 128l46-38-16-18-68 56 68 56 16-18zm68-76l46 38-46 38 16 18 68-56-68-56-16 18zm-44 100l48-124-18-6-48 124 18 6z"/>',
  check: '<path d="M72 128l40 40 88-88-18-18-70 70-22-22-18 18zm140-72H44a20 20 0 0 0-20 20v140a20 20 0 0 0 20 20h168a20 20 0 0 0 20-20V76a20 20 0 0 0-20-20z"/>',
  weather: '<path d="M192 128a48 48 0 0 0-44-47 56 56 0 0 0-104 23 44 44 0 0 0 12 88h136a44 44 0 0 0 0-88z"/>',
  wallet: '<path d="M208 80H48a24 24 0 0 0-24 24v88a24 24 0 0 0 24 24h160a24 24 0 0 0 24-24v-88a24 24 0 0 0-24-24zm0 68h-40a16 16 0 0 1 0-32h40v32zm-24-88H64V48a16 16 0 0 1 16-16h104v28z"/>',
  heart: '<path d="M128 212l-18-16C54 146 20 114 20 74a54 54 0 0 1 90-41 54 54 0 0 1 90 41c0 40-34 72-90 122l-18 16z"/>',
  car: '<path d="M189 68l18 36H49l18-36h122zM48 128h160a16 16 0 0 1 16 16v40h-20a24 24 0 0 1-48 0h-56a24 24 0 0 1-48 0H32v-40a16 16 0 0 1 16-16z"/>',
  puzzle: '<path d="M168 116a24 24 0 0 0-20-24V64a16 16 0 0 0-16-16h-28a24 24 0 0 0-48 0H28a16 16 0 0 0-16 16v28a24 24 0 0 0 0 48v28a16 16 0 0 0 16 16h28a24 24 0 0 0 48 0h28a16 16 0 0 0 16-16v-28a24 24 0 0 0 20-24z"/>',
  book: '<path d="M192 48H64a24 24 0 0 0-24 24v128a24 24 0 0 0 24 24h128a16 16 0 0 0 16-16V64a16 16 0 0 0-16-16zm-8 144H64a8 8 0 0 1 0-16h120v16zm0-32H64a8 8 0 0 1 0-16h120v16zm0-32H64a8 8 0 0 1 0-16h120v16z"/>',
  bolt: '<path d="M140 28L48 140h64l-20 88 100-116h-64l24-84z"/>',
  shield: '<path d="M128 32L44 68v64c0 52 36 100 84 112 48-12 84-60 84-112V68l-84-36zm0 136l-36-36 14-14 22 22 50-50 14 14-64 64z"/>',
  compass: '<path d="M128 32a96 96 0 1 0 96 96 96 96 0 0 0-96-96zm36 60l-20 64-64 20 20-64 64-20z"/>',
  clock: '<path d="M128 32a96 96 0 1 0 96 96 96 96 0 0 0-96-96zm12 100h-36V76h16v40h20v16z"/>',
  flame: '<path d="M136 28c-4 36-28 60-44 84-24 36-8 84 36 84 48 0 80-40 68-88-8-32-36-56-44-80h-16zm-8 148c-16 0-24-12-16-28 8-16 24-28 28-44 4 16 16 28 20 44 4 16-8 28-32 28z"/>'
};

const PALETTES = [
  ['#4F46E5', '#06B6D4'], // Indigo -> Cyan
  ['#EC4899', '#8B5CF6'], // Pink -> Purple
  ['#10B981', '#3B82F6'], // Emerald -> Blue
  ['#F59E0B', '#EF4444'], // Amber -> Red
  ['#8B5CF6', '#3B82F6'], // Purple -> Blue
  ['#059669', '#10B981'], // Teal -> Emerald
  ['#DC2626', '#F97316'], // Red -> Orange
  ['#2563EB', '#60A5FA'], // Blue -> Sky
  ['#7C3AED', '#C084FC'], // Violet -> Light Violet
  ['#0D9488', '#2DD4BF'], // Dark Teal -> Cyan
  ['#D97706', '#FBBF24'], // Dark Amber -> Yellow
  ['#4338CA', '#818CF8'], // Indigo -> Iris
];

const RAW_APPS = [
  // 50 GAMES (すべてカテゴリ: ゲーム)
  { id: 'stella-chronicle', name: 'ステラクロニクル 救世の星', cat: 'ゲーム', sym: 'sword', free: true, rate: 4.8, dl: '500万+', feat: true },
  { id: 'cyberblade-2088', name: 'サイバーブレード 2088', cat: 'ゲーム', sym: 'bolt', free: false, price: 480, rate: 4.7, dl: '100万+', feat: true },
  { id: 'jewel-blast-pop', name: 'ジュエルブラスト ポップ！', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.6, dl: '1000万+', feat: true },
  { id: 'beat-wave-3d', name: 'ビートウェーブ 3D Rhythm', cat: 'ゲーム', sym: 'music', free: true, rate: 4.9, dl: '200万+', feat: true },
  { id: 'nitro-racers-overdrive', name: 'ニトロ・レーサーズ Overdrive', cat: 'ゲーム', sym: 'car', free: true, rate: 4.5, dl: '500万+' },
  { id: 'kingdom-tactics', name: 'キングダム・タクティクス 王権', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.4, dl: '300万+' },
  { id: 'space-colony-2200', name: 'スペースコロニー計画 2200', cat: 'ゲーム', sym: 'rocket', free: false, price: 650, rate: 4.8, dl: '50万+' },
  { id: 'dungeon-diver-deep', name: 'ダンジョン・ダイバー 迷宮深層', cat: 'ゲーム', sym: 'sword', free: true, rate: 4.5, dl: '150万+' },
  { id: 'shadow-dash-ninja', name: 'シャドウダッシュ 忍道', cat: 'ゲーム', sym: 'flame', free: true, rate: 4.6, dl: '400万+' },
  { id: 'my-cafe-life', name: 'マイ・カフェ・ライフ 癒しの時間', cat: 'ゲーム', sym: 'heart', free: true, rate: 4.7, dl: '800万+' },
  { id: 'galaxy-wars-fleet', name: 'ギャラクシー・ウォーズ 艦隊戦', cat: 'ゲーム', sym: 'rocket', free: true, rate: 4.3, dl: '120万+' },
  { id: 'block-connect-brain', name: 'ブロックコネクト 脳トレパズル', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.5, dl: '600万+' },
  { id: 'rhythm-sinfonia', name: 'リズム・シンフォニア 古代の旋律', cat: 'ゲーム', sym: 'music', free: false, price: 320, rate: 4.9, dl: '80万+' },
  { id: 'drift-master-tokyo', name: 'ドリフト・マスター TOKYO', cat: 'ゲーム', sym: 'car', free: true, rate: 4.4, dl: '250万+' },
  { id: 'tower-defense-zero', name: 'タワーディフェンス Zero', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.6, dl: '350万+' },
  { id: 'dragons-legacy', name: 'ドラゴンズ・レガシー 竜血の絆', cat: 'ゲーム', sym: 'flame', free: true, rate: 4.7, dl: '700万+' },
  { id: 'mecha-battlers-arena', name: 'メカ・バトラーズ アリーナ', cat: 'ゲーム', sym: 'bolt', free: true, rate: 4.4, dl: '180万+' },
  { id: 'penguin-island-garden', name: 'ペンギン・アイランド 放置庭園', cat: 'ゲーム', sym: 'heart', free: true, rate: 4.8, dl: '900万+' },
  { id: 'number-puzzle-cross', name: '数字パズル クロス 1000問', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.3, dl: '300万+' },
  { id: 'techno-step-arcade', name: 'テクノステップ アーケード', cat: 'ゲーム', sym: 'music', free: true, rate: 4.5, dl: '100万+' },
  { id: 'mini-kart-grand-prix', name: 'ミニカート・グランプリ DX', cat: 'ゲーム', sym: 'car', free: false, price: 250, rate: 4.6, dl: '60万+' },
  { id: 'aether-fantasy-beast', name: 'エーテルファンタジー 幻獣契約', cat: 'ゲーム', sym: 'star', free: true, rate: 4.7, dl: '450万+' },
  { id: 'speed-storm-fist', name: 'スピードストーム 疾風の拳', cat: 'ゲーム', sym: 'flame', free: true, rate: 4.3, dl: '140万+' },
  { id: 'farm-harvest-seasons', name: 'ファーム・ハーベスト 四季の村', cat: 'ゲーム', sym: 'heart', free: true, rate: 4.6, dl: '550万+' },
  { id: 'war-of-empire-reign', name: 'ウォー・オブ・エンパイア 覇権', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.2, dl: '200万+' },
  { id: 'physics-sandbox-play', name: '物理の箱庭 サンドボックス', cat: 'ゲーム', sym: 'puzzle', free: false, price: 390, rate: 4.8, dl: '90万+' },
  { id: 'piano-melody-tiles', name: 'ピアノ・メロディ・タイル', cat: 'ゲーム', sym: 'music', free: true, rate: 4.4, dl: '1500万+' },
  { id: 'highway-chase-police', name: 'ハイウェイ・チェイス 警視庁', cat: 'ゲーム', sym: 'car', free: true, rate: 4.3, dl: '110万+' },
  { id: 'starfall-adventurers', name: '星降る夜の冒険者たち', cat: 'ゲーム', sym: 'star', free: true, rate: 4.8, dl: '320万+' },
  { id: 'monster-hunter-soul', name: 'モンスターハンター ソウル', cat: 'ゲーム', sym: 'sword', free: true, rate: 4.6, dl: '600万+' },
  { id: 'train-tycoon-railway', name: 'トレイン・タイクーン 鉄道王', cat: 'ゲーム', sym: 'compass', free: true, rate: 4.5, dl: '170万+' },
  { id: 'craft-survival-island', name: 'クラフト・サバイバル 孤島', cat: 'ゲーム', sym: 'compass', free: false, price: 540, rate: 4.7, dl: '120万+' },
  { id: 'color-sort-ball-puzzle', name: 'カラーソート ボールパズル', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.5, dl: '800万+' },
  { id: 'electro-groove-dj', name: 'エレクトロ・グルーヴ DJ', cat: 'ゲーム', sym: 'music', free: true, rate: 4.4, dl: '70万+' },
  { id: 'offroad-climber-4x4', name: 'オフロード・クライマー 4x4', cat: 'ゲーム', sym: 'car', free: true, rate: 4.2, dl: '220万+' },
  { id: 'abyss-knights-order', name: 'アビス・ナイツ 深淵の騎士', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.7, dl: '280万+' },
  { id: 'archery-king-3d', name: 'アーチェリー・キング 3D', cat: 'ゲーム', sym: 'bolt', free: true, rate: 4.3, dl: '400万+' },
  { id: 'aquarium-dream-world', name: 'アクアリウム・ドリーム 水族館', cat: 'ゲーム', sym: 'heart', free: true, rate: 4.6, dl: '330万+' },
  { id: 'commander-in-chief', name: 'コマンダー・イン・チーフ 戦線', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.1, dl: '90万+' },
  { id: 'tangram-geom-puzzle', name: 'タングラム 幾何学パズル', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.4, dl: '190万+' },
  { id: 'eight-bit-heroes-retro', name: '8ビット・ヒーローズ レトロ', cat: 'ゲーム', sym: 'gamepad', free: false, price: 180, rate: 4.7, dl: '40万+' },
  { id: 'sniper-elite-ghost', name: 'スナイパー・エリート ゴースト', cat: 'ゲーム', sym: 'bolt', free: true, rate: 4.5, dl: '650万+' },
  { id: 'city-builder-metro', name: 'シティ・ビルダー 大都市創造', cat: 'ゲーム', sym: 'compass', free: true, rate: 4.6, dl: '420万+' },
  { id: 'word-master-sea', name: 'ワード・マスター ことばの海', cat: 'ゲーム', sym: 'book', free: true, rate: 4.5, dl: '290万+' },
  { id: 'airplane-flight-sim', name: 'エアプレーン・フライト シム', cat: 'ゲーム', sym: 'rocket', free: false, price: 780, rate: 4.8, dl: '85万+' },
  { id: 'rally-champion-wrc', name: 'ラリー・チャンピオン WRC', cat: 'ゲーム', sym: 'car', free: true, rate: 4.3, dl: '160万+' },
  { id: 'valkyrie-crisis', name: 'ヴァルキリー・クライシス', cat: 'ゲーム', sym: 'star', free: true, rate: 4.6, dl: '380万+' },
  { id: 'crane-game-online', name: 'クレーンゲーム オンライン 直送', cat: 'ゲーム', sym: 'gamepad', free: true, rate: 4.1, dl: '210万+' },
  { id: 'chess-masters-ai', name: 'チェス・マスターズ AI対局', cat: 'ゲーム', sym: 'shield', free: true, rate: 4.7, dl: '500万+' },
  { id: 'bubble-shooter-pop', name: 'バブル・シューター・ポップ', cat: 'ゲーム', sym: 'puzzle', free: true, rate: 4.4, dl: '1200万+' },

  // 50 APPS (新カテゴリ: メディア, ポータルサイト, 便利ツール, ソーシャル, Mod・拡張機能, 開発, その他)
  { id: 'enoki-file-manager', name: 'Enoki ファイルマネージャー Pro', cat: '便利ツール', sym: 'code', free: true, rate: 4.9, dl: '100万+', feat: true },
  { id: 'focus-pomodoro-timer', name: 'Focus ポモドーロ 集中タイマー', cat: '便利ツール', sym: 'clock', free: true, rate: 4.8, dl: '250万+', feat: true },
  { id: 'retro-camera-1998', name: 'レトロカメラ 1998 フィルムFX', cat: 'メディア', sym: 'camera', free: true, rate: 4.7, dl: '800万+', feat: true },
  { id: 'enoki-chat-secure', name: 'Enoki チャット＆セキュア通話', cat: 'ソーシャル', sym: 'chat', free: true, rate: 4.6, dl: '300万+', feat: true },
  { id: 'simple-household-book', name: 'シンプル家計簿 3秒で記録', cat: '便利ツール', sym: 'wallet', free: true, rate: 4.8, dl: '400万+' },
  { id: 'rain-radar-weather', name: '雨雲レーダー 高精度天気予報', cat: 'ポータルサイト', sym: 'weather', free: true, rate: 4.6, dl: '600万+' },
  { id: 'markdown-notes-sync', name: 'Markdown ノート 瞬速同期', cat: '開発', sym: 'book', free: false, price: 380, rate: 4.9, dl: '50万+' },
  { id: 'ai-portrait-retouch-hd', name: 'AI ポートレート レタッチ HD', cat: 'メディア', sym: 'camera', free: true, rate: 4.5, dl: '500万+' },
  { id: 'smart-qr-barcode-reader', name: 'スマートQR＆バーコード リーダー', cat: '便利ツール', sym: 'code', free: true, rate: 4.7, dl: '900万+' },
  { id: 'ambient-sleep-whitenoise', name: 'Ambient 睡眠サウンド＆白雑音', cat: 'メディア', sym: 'music', free: true, rate: 4.8, dl: '350万+' },
  { id: 'task-kanban-board', name: 'タスク・カンバン ボード共有', cat: 'ソーシャル', sym: 'check', free: true, rate: 4.6, dl: '120万+' },
  { id: 'asset-tracker-crypto', name: '資産トラッカー 株＆暗号資産', cat: 'ポータルサイト', sym: 'wallet', free: true, rate: 4.7, dl: '180万+' },
  { id: 'daily-english-memory', name: 'デイリー英単語 忘却曲線メソッド', cat: '開発', sym: 'book', free: true, rate: 4.8, dl: '270万+' },
  { id: 'sleep-assist-tracker', name: '快眠アシスト 睡眠トラッカー', cat: 'その他', sym: 'heart', free: true, rate: 4.5, dl: '310万+' },
  { id: 'pdf-scanner-signature', name: 'PDF スキャナー＆電子署名', cat: 'Mod・拡張機能', sym: 'check', free: false, price: 490, rate: 4.7, dl: '150万+' },
  { id: 'equalizer-fx-pro', name: 'イコライザー FX 音質強化 Pro', cat: 'メディア', sym: 'music', free: true, rate: 4.6, dl: '430万+' },
  { id: 'quick-calc-converter', name: 'クイック電卓 Pro 単位換算付き', cat: '便利ツール', sym: 'code', free: true, rate: 4.8, dl: '700万+' },
  { id: 'stargazer-3d-astronomy', name: 'スターゲイザー 3D天体観測', cat: 'ポータルサイト', sym: 'star', free: false, price: 420, rate: 4.9, dl: '90万+' },
  { id: 'smart-meditation-5min', name: 'スマート瞑想 1日5分マインドフル', cat: 'その他', sym: 'heart', free: true, rate: 4.7, dl: '220万+' },
  { id: 'short-video-vlog-editor', name: 'ショート動画スタジオ 編集Vlog', cat: 'メディア', sym: 'camera', free: true, rate: 4.4, dl: '650万+' },
  { id: 'battery-doctor-saver', name: 'バッテリー・ドクター 節電ガード', cat: '便利ツール', sym: 'bolt', free: true, rate: 4.3, dl: '850万+' },
  { id: 'voiceroom-social-audio', name: 'VoiceRoom 音声ルーム・ラジオ', cat: 'ソーシャル', sym: 'chat', free: true, rate: 4.5, dl: '160万+' },
  { id: 'receipt-household-ai', name: 'レシート家計簿 AI自動読取', cat: '便利ツール', sym: 'wallet', free: true, rate: 4.6, dl: '340万+' },
  { id: 'comic-reader-pro', name: 'コミックリーダー Pro 縦スクロール', cat: 'メディア', sym: 'book', free: false, price: 300, rate: 4.8, dl: '110万+' },
  { id: 'programming-python-learn', name: 'プログラミング入門 Python学習', cat: '開発', sym: 'code', free: true, rate: 4.7, dl: '190万+' },
  { id: 'daily-water-hydration', name: 'デイリー・ウォーター 水分記録', cat: 'その他', sym: 'heart', free: true, rate: 4.6, dl: '240万+' },
  { id: 'podcast-cast-hd', name: 'ポッドキャスト・キャスト 高音質', cat: 'メディア', sym: 'music', free: true, rate: 4.5, dl: '170万+' },
  { id: 'exchange-rate-alert', name: '為替レート 計算＆アラート', cat: 'ポータルサイト', sym: 'wallet', free: true, rate: 4.4, dl: '130万+' },
  { id: 'wifi-speedtest-analyzer', name: 'WiFi スピードテスト＆解析', cat: '便利ツール', sym: 'bolt', free: true, rate: 4.7, dl: '780万+' },
  { id: 'short-novel-paradise', name: '短編小説パラダイス 毎日更新', cat: 'ポータルサイト', sym: 'book', free: true, rate: 4.5, dl: '85万+' },
  { id: 'voice-recorder-hd-pro', name: 'ボイスレコーダー HD 高音質録音', cat: 'ソーシャル', sym: 'music', free: true, rate: 4.6, dl: '390万+' },
  { id: 'timezone-world-clock', name: 'タイムゾーン 世界時計＆会議調整', cat: '便利ツール', sym: 'clock', free: false, price: 160, rate: 4.8, dl: '60万+' },
  { id: 'running-tracker-gps', name: 'ランニング・トラッカー GPS計測', cat: 'その他', sym: 'flame', free: true, rate: 4.6, dl: '470万+' },
  { id: 'collage-maker-photo-fx', name: 'コラージュ メーカー 写真加工', cat: 'メディア', sym: 'camera', free: true, rate: 4.4, dl: '520万+' },
  { id: 'clipboard-manager-history', name: 'クリップボード マネージャー 履歴', cat: 'Mod・拡張機能', sym: 'check', free: true, rate: 4.7, dl: '140万+' },
  { id: 'habit-tracker-30days', name: '習慣トラッカー 30日チャレンジ', cat: 'その他', sym: 'check', free: true, rate: 4.8, dl: '260万+' },
  { id: 'earthquake-warning-map', name: '3D 地震速報＆防災マップ', cat: 'ポータルサイト', sym: 'shield', free: true, rate: 4.7, dl: '580万+' },
  { id: 'minimalist-secret-diary', name: 'ミニマリスト日記 秘密の鍵付き', cat: 'その他', sym: 'book', free: true, rate: 4.7, dl: '180万+' },
  { id: 'guitar-tuner-metronome', name: 'ギターチューナー＆メトロノーム', cat: 'メディア', sym: 'music', free: true, rate: 4.8, dl: '620万+' },
  { id: 'password-vault-safe', name: 'パスワード管理キー Vault', cat: '便利ツール', sym: 'shield', free: false, price: 580, rate: 4.9, dl: '80万+' },
  { id: 'calorie-management-ai', name: 'カロリー管理 AI食事撮影', cat: 'その他', sym: 'heart', free: true, rate: 4.5, dl: '330万+' },
  { id: 'illustration-sketch-draw', name: 'イラスト・スケッチ キャンバス', cat: 'Mod・拡張機能', sym: 'star', free: true, rate: 4.6, dl: '210万+' },
  { id: 'business-card-scanner', name: '名刺管理 スキャナー＆連絡先', cat: 'ソーシャル', sym: 'check', free: true, rate: 4.4, dl: '150万+' },
  { id: 'world-radio-fm-am', name: '世界ラジオ FM/AM ストリーミング', cat: 'メディア', sym: 'music', free: true, rate: 4.5, dl: '410万+' },
  { id: 'bluelight-filter-care', name: 'ブルーライト カット 目の保護フィルター', cat: 'Mod・拡張機能', sym: 'weather', free: true, rate: 4.6, dl: '880万+' },
  { id: 'flick-typing-practice', name: 'タイピング練習 フリック向上', cat: '開発', sym: 'code', free: true, rate: 4.5, dl: '120万+' },
  { id: 'shopping-list-share', name: 'お買い物メモ 家族と共有リスト', cat: 'ソーシャル', sym: 'check', free: true, rate: 4.7, dl: '290万+' },
  { id: 'compass-level-altimeter', name: 'コンパス 3D 水準器＆高度計', cat: '便利ツール', sym: 'compass', free: true, rate: 4.6, dl: '490万+' },
  { id: 'stretch-refresh-alarm', name: 'ストレッチ リフレッシュ通知', cat: 'その他', sym: 'heart', free: true, rate: 4.5, dl: '140万+' },
  { id: 'smart-alarm-clock-wake', name: 'シンプル目覚まし時計 爽快起床', cat: '便利ツール', sym: 'clock', free: true, rate: 4.6, dl: '360万+' },
];

const mockList = RAW_APPS.map((item, index) => {
  const isGame = index < 50;
  const id = item.id;
  const palette = PALETTES[index % PALETTES.length];
  const symbolSvg = SYMBOLS[item.sym] || SYMBOLS.star;

  const iconUrl = createIconSvg(id, item.name, symbolSvg, palette[0], palette[1], '#ffffff');
  const thumbUrl = createThumbnailSvg(id, item.name, item.cat, palette[0], palette[1], symbolSvg);
  const screenshots = [
    createScreenshotSvg(id, item.name, 1, palette[0], palette[1]),
    createScreenshotSvg(id, item.name, 2, palette[1], palette[0]),
    createScreenshotSvg(id, item.name, 3, palette[0], '#111827'),
  ];

  // リリース日: 2025年1月〜2026年10月のランダムUnixtime(ミリ秒)
  const baseTime = new Date('2025-01-01').getTime();
  const maxTime = new Date('2026-10-31').getTime();
  const releaseDate = Math.floor(baseTime + Math.random() * (maxTime - baseTime));

  const developers = ['Enoki Interactive', 'Pixel Forge Studio', 'Hypernova Lab', 'Komorebi Soft', 'Aether Works', 'Nexus Digital'];
  const dev = developers[index % developers.length];

  const description = `### ${item.name} について

**${item.name}** は、洗練されたデザインと快適な操作性を追求した${item.cat}です。

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
`;

  return {
    name: item.name,
    id: id,
    releaseDate: releaseDate,
    icon: iconUrl,
    thumbnail: thumbUrl,
    description: description,
    price: item.free ? 0 : (item.price || 300),
    platforms: ['Android', 'iOS', 'Web'],
    languages: ['日本語', 'English'],
    links: [
      { text: 'Google Play', icon: 'mdi-google-play', url: `https://play.google.com/store/apps/details?id=com.enoki.${id}` },
      { text: 'App Store', icon: 'mdi-apple', url: `https://apps.apple.com/app/id${1000000 + index}` },
      { text: 'Web版で開く', icon: 'mdi-web', url: `https://enoki.xyz/apps/${id}` },
    ],
    githubUrl: index % 3 === 0 ? `https://github.com/jikantoki/${id}` : undefined,
    videoUrl: index % 4 === 0 ? 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' : undefined,
    images: screenshots,
    type: isGame ? 'game' : 'app',
    category: item.cat,
    rating: item.rate,
    downloads: item.dl,
    developer: dev,
    summary: `${item.cat}の決定版！${item.name}で新しい体験を。`,
    featured: !!item.feat,
  };
});

// app/data ディレクトリと public/data ディレクトリに保存
const appDataDir = path.resolve('app/data');
const publicDataDir = path.resolve('public/data');

if (!fs.existsSync(appDataDir)) {
  fs.mkdirSync(appDataDir, { recursive: true });
}
if (!fs.existsSync(publicDataDir)) {
  fs.mkdirSync(publicDataDir, { recursive: true });
}

fs.writeFileSync(path.join(appDataDir, 'apps.json'), JSON.stringify(mockList, null, 2), 'utf-8');
fs.writeFileSync(path.join(publicDataDir, 'apps.json'), JSON.stringify(mockList, null, 2), 'utf-8');

console.log(`Successfully generated ${mockList.length} mock apps to:`);
console.log(` - ${path.join(appDataDir, 'apps.json')}`);
console.log(` - ${path.join(publicDataDir, 'apps.json')}`);
