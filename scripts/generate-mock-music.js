import fs from 'fs';
import path from 'path';

// 正方形カバーアート (300x300 SVG Data URI) - Spotify / Apple Music風
function createCoverSvg(title, artist, color1, color2, symbolType, accent) {
  const cleanTitle = title.replace(/[<>&"']/g, '');
  const cleanArtist = artist.replace(/[<>&"']/g, '');

  let symbolSvg = '';
  if (symbolType === 'disc') {
    symbolSvg = `
      <circle cx="150" cy="150" r="90" fill="#111111" stroke="${accent}" stroke-width="2" opacity="0.85"/>
      <circle cx="150" cy="150" r="70" fill="none" stroke="#333333" stroke-width="1.5"/>
      <circle cx="150" cy="150" r="50" fill="none" stroke="#333333" stroke-width="1.5"/>
      <circle cx="150" cy="150" r="28" fill="${color1}"/>
      <circle cx="150" cy="150" r="8" fill="#111111"/>
    `;
  } else if (symbolType === 'wave') {
    symbolSvg = `
      <g stroke="${accent}" stroke-width="4" stroke-linecap="round" opacity="0.9">
        <line x1="70" y1="170" x2="70" y2="130"/>
        <line x1="90" y1="185" x2="90" y2="115"/>
        <line x1="110" y1="195" x2="110" y2="105"/>
        <line x1="130" y1="210" x2="130" y2="90"/>
        <line x1="150" y1="225" x2="150" y2="75"/>
        <line x1="170" y1="205" x2="170" y2="95"/>
        <line x1="190" y1="190" x2="190" y2="110"/>
        <line x1="210" y1="175" x2="210" y2="125"/>
        <line x1="230" y1="160" x2="230" y2="140"/>
      </g>
    `;
  } else if (symbolType === 'neon') {
    symbolSvg = `
      <polygon points="150,60 230,200 70,200" fill="none" stroke="${accent}" stroke-width="5" opacity="0.9"/>
      <circle cx="150" cy="150" r="45" fill="none" stroke="#ffffff" stroke-width="3" opacity="0.75"/>
      <line x1="70" y1="200" x2="230" y2="200" stroke="#ffffff" stroke-width="3" opacity="0.5"/>
    `;
  } else if (symbolType === 'notes') {
    symbolSvg = `
      <g fill="${accent}" opacity="0.9" transform="translate(100, 90) scale(1.6)">
        <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/>
      </g>
    `;
  } else if (symbolType === 'cassette') {
    symbolSvg = `
      <rect x="75" y="105" width="150" height="90" rx="10" fill="#1e1e24" stroke="${accent}" stroke-width="3"/>
      <rect x="100" y="125" width="100" height="45" rx="5" fill="#2d2d34"/>
      <circle cx="125" cy="147" r="12" fill="none" stroke="${accent}" stroke-width="3"/>
      <circle cx="175" cy="147" r="12" fill="none" stroke="${accent}" stroke-width="3"/>
      <line x1="125" y1="147" x2="175" y2="147" stroke="#ffffff" stroke-width="2" opacity="0.4"/>
    `;
  } else {
    // abstract rings
    symbolSvg = `
      <circle cx="150" cy="150" r="75" fill="none" stroke="${accent}" stroke-width="4" opacity="0.7"/>
      <circle cx="150" cy="150" r="50" fill="none" stroke="#ffffff" stroke-width="3" opacity="0.5"/>
      <circle cx="150" cy="150" r="25" fill="${accent}" opacity="0.8"/>
    `;
  }

  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300" width="300" height="300">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${color1}"/>
      <stop offset="100%" stop-color="${color2}"/>
    </linearGradient>
    <linearGradient id="shadow" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="40%" stop-color="#000000" stop-opacity="0"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0.85"/>
    </linearGradient>
  </defs>
  <rect width="300" height="300" rx="20" fill="url(#bg)"/>
  <circle cx="60" cy="60" r="90" fill="#ffffff" opacity="0.08"/>
  <circle cx="240" cy="240" r="110" fill="#000000" opacity="0.15"/>
  ${symbolSvg}
  <rect width="300" height="300" rx="20" fill="url(#shadow)"/>
  <text x="20" y="250" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="19" fill="#ffffff" letter-spacing="-0.5">${cleanTitle}</text>
  <text x="20" y="274" font-family="system-ui, -apple-system, sans-serif" font-weight="600" font-size="13" fill="${accent}">${cleanArtist}</text>
</svg>`;
  return `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`;
}

// 横長バナーサムネイル (640x360 SVG)
function createMusicBannerSvg(title, artist, category, color1, color2, accent) {
  const cleanTitle = title.replace(/[<>&"']/g, '');
  const cleanArtist = artist.replace(/[<>&"']/g, '');
  const cleanCat = category.replace(/[<>&"']/g, '');

  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 360" width="640" height="360">
  <defs>
    <linearGradient id="bbg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${color1}"/>
      <stop offset="100%" stop-color="${color2}"/>
    </linearGradient>
    <linearGradient id="bshadow" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#000000" stop-opacity="0.2"/>
      <stop offset="60%" stop-color="#000000" stop-opacity="0.5"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0.9"/>
    </linearGradient>
  </defs>
  <rect width="640" height="360" rx="16" fill="url(#bbg)"/>
  <g opacity="0.15" fill="#ffffff">
    <circle cx="480" cy="180" r="140"/>
    <circle cx="560" cy="90" r="90"/>
    <polygon points="400,60 520,240 340,240"/>
  </g>
  <rect width="640" height="360" rx="16" fill="url(#bshadow)"/>
  <rect x="36" y="32" width="120" height="26" rx="13" fill="${accent}" opacity="0.9"/>
  <text x="96" y="49" font-family="system-ui, sans-serif" font-weight="700" font-size="12" fill="#000000" text-anchor="middle">NEW RELEASE</text>
  <text x="36" y="270" font-family="system-ui, -apple-system, sans-serif" font-weight="800" font-size="32" fill="#ffffff">${cleanTitle}</text>
  <text x="36" y="308" font-family="system-ui, -apple-system, sans-serif" font-weight="600" font-size="18" fill="#e0e0e0">${cleanArtist} • ${cleanCat}</text>
</svg>`;
  return `data:image/svg+xml;utf8,${encodeURIComponent(svg)}`;
}

// 楽曲マスターリストの定義 (64曲)
const rawSongs = [
  // J-POP & City Pop
  {
    title: 'ミッドナイト・ブルー',
    artist: 'Toki & The Neon Nights',
    album: 'City Lights E.P.',
    genre: 'City Pop',
    color1: '#1E1B4B',
    color2: '#4338CA',
    accent: '#38BDF8',
    symbol: 'disc',
    duration: 232,
    audioPreset: 'citypop',
    bpm: 116,
    featured: true,
    plays: '1,420,580',
    description: '80年代の都会的なサウンドと洗練されたグルーヴが融合した極上のシティポップ。夜のハイウェイを駆け抜けるような心地よいベースラインが特徴。',
  },
  {
    title: 'サマー・カクテル',
    artist: '青空メロディックス',
    album: 'Breeze & Sunset',
    genre: 'J-POP',
    color1: '#F43F5E',
    color2: '#FB923C',
    accent: '#FEF08A',
    symbol: 'wave',
    duration: 215,
    audioPreset: 'citypop',
    bpm: 124,
    featured: true,
    plays: '982,100',
    description: 'きらめく夏の海辺を想起させる爽快なアップテンポJ-POP。軽やかなカッティングギターとキャッチーなサビが耳に残る。',
  },
  {
    title: '雨上がりのステーション',
    artist: '蓮見 カナタ',
    album: 'After the Rain',
    genre: 'J-POP',
    color1: '#0284C7',
    color2: '#0D9488',
    accent: '#7DD3FC',
    symbol: 'notes',
    duration: 254,
    audioPreset: 'piano',
    bpm: 92,
    featured: false,
    plays: '560,300',
    description: '澄み渡るアコースティックピアノと優しいストリングスで紡がれる切なくも温かいノスタルジックなバラード。',
  },
  {
    title: 'トワイライト・ハイウェイ',
    artist: 'Vapor Waveform',
    album: 'Midnight Cruising',
    genre: 'City Pop',
    color1: '#4C1D95',
    color2: '#BE185D',
    accent: '#F472B6',
    symbol: 'cassette',
    duration: 248,
    audioPreset: 'citypop',
    bpm: 110,
    featured: true,
    plays: '2,150,000',
    description: '夕暮れから夜へと移り変わる街並みをイメージしたグルーヴィなシティポップナンバー。アナログシンセの温かみが心地よい。',
  },
  {
    title: '夜風とサイダー',
    artist: 'ハルカミドリ',
    album: '微炭酸デイズ',
    genre: 'J-POP',
    color1: '#059669',
    color2: '#10B981',
    accent: '#A7F3D0',
    symbol: 'wave',
    duration: 198,
    audioPreset: 'acoustic',
    bpm: 104,
    featured: false,
    plays: '430,900',
    description: '青春の甘酸っぱさを爽やかなアコースティックサウンドに乗せて歌い上げた軽快なナンバー。',
  },
  {
    title: '星屑のダンスホール',
    artist: '星野ルカ & Nova Project',
    album: 'Stardust Ballroom',
    genre: 'J-POP',
    color1: '#7C3AED',
    color2: '#C026D3',
    accent: '#FBCFE8',
    symbol: 'rings',
    duration: 220,
    audioPreset: 'citypop',
    bpm: 120,
    featured: false,
    plays: '810,400',
    description: 'ファンキーなカッティングギターとディスコビートが絡み合う、誰もが踊りだしたくなるダンサブルなJ-POP。',
  },

  // Lo-Fi & Chill Beats
  {
    title: 'Late Night Coffee',
    artist: 'Chill Enoki Room',
    album: 'Midnight Study Session',
    genre: 'Lo-Fi',
    color1: '#78350F',
    color2: '#B45309',
    accent: '#FDE68A',
    symbol: 'cassette',
    duration: 165,
    audioPreset: 'lofi',
    bpm: 78,
    featured: true,
    plays: '3,890,200',
    description: '深夜の作業や読書に最適な、温かみのあるローファイビート。アナログテープの質感と心地よいピアノのループ。',
  },
  {
    title: 'Rainy Window Pane',
    artist: 'Sleepy Cat Beats',
    album: 'Drizzle in Shibuya',
    genre: 'Lo-Fi',
    color1: '#334155',
    color2: '#475569',
    accent: '#CBD5E1',
    symbol: 'wave',
    duration: 178,
    audioPreset: 'lofi',
    bpm: 72,
    featured: false,
    plays: '1,890,000',
    description: '雨音の環境音とやわらかなエレピが重なり合う極上のリラクゼーションチルビート。',
  },
  {
    title: 'Sunset Rooftop',
    artist: 'Lofi Toki Garden',
    album: 'Golden Hour Sketches',
    genre: 'Lo-Fi',
    color1: '#9A3412',
    color2: '#EA580C',
    accent: '#FED7AA',
    symbol: 'disc',
    duration: 154,
    audioPreset: 'lofi',
    bpm: 82,
    featured: false,
    plays: '1,120,400',
    description: '夕焼け空を眺めながら一息つきたい時にぴったりの、ゆったりとしたアコースティックギターのローファイインスト。',
  },
  {
    title: 'Old Library Books',
    artist: 'Study Companion',
    album: 'Paper & Ink Melodies',
    genre: 'Lo-Fi',
    color1: '#3F3F46',
    color2: '#71717A',
    accent: '#E4E4E7',
    symbol: 'rings',
    duration: 182,
    audioPreset: 'lofi',
    bpm: 75,
    featured: false,
    plays: '940,000',
    description: '静かな図書館の空気感を閉じ込めた、深い集中を促す落ち着いたチルホップ。',
  },
  {
    title: 'Sunday Morning Pancakes',
    artist: 'Cozy Corner Studio',
    album: 'Weekend Morning Vibes',
    genre: 'Lo-Fi',
    color1: '#D97706',
    color2: '#F59E0B',
    accent: '#FEF3C7',
    symbol: 'notes',
    duration: 160,
    audioPreset: 'lofi',
    bpm: 80,
    featured: false,
    plays: '780,200',
    description: '休日の穏やかな朝を彩る、甘く優しいメロディとソフトなスネアドラムの調和。',
  },

  // Synthwave & Cyberpunk
  {
    title: 'Cyberpunk Odyssey 2099',
    artist: 'Neon Samurai',
    album: 'Neo Shinjuku Protocol',
    genre: 'Synthwave',
    color1: '#831843',
    color2: '#BE185D',
    accent: '#06B6D4',
    symbol: 'neon',
    duration: 245,
    audioPreset: 'synthwave',
    bpm: 128,
    featured: true,
    plays: '2,940,100',
    description: '重厚なアナログシンセベースと疾走感あふれるアルペジオが炸裂する、サイバーパンク感満載のシンセウェイヴ。',
  },
  {
    title: 'Neon Grid Runner',
    artist: 'Retro Horizon',
    album: 'Outrun Highway',
    genre: 'Synthwave',
    color1: '#0F172A',
    color2: '#312E81',
    accent: '#EC4899',
    symbol: 'neon',
    duration: 218,
    audioPreset: 'synthwave',
    bpm: 132,
    featured: false,
    plays: '1,650,000',
    description: '80年代レトロフューチャーの美学を現代のサウンドデザインで蘇らせたハイエナジーなインストゥルメンタル。',
  },
  {
    title: 'Virtual Mirage',
    artist: 'Zero Vector',
    album: 'Data Streams & Memories',
    genre: 'Synthwave',
    color1: '#1E293B',
    color2: '#0F766E',
    accent: '#2DD4BF',
    symbol: 'disc',
    duration: 236,
    audioPreset: 'synthwave',
    bpm: 122,
    featured: false,
    plays: '890,300',
    description: '電脳空間を漂うようなドリーミーなシンセパッドと脈打つベースラインが特徴的なトラック。',
  },
  {
    title: 'Laser Heartbeat',
    artist: 'HyperDrive Alpha',
    album: 'Speed of Light',
    genre: 'Synthwave',
    color1: '#991B1B',
    color2: '#DC2626',
    accent: '#FCA5A5',
    symbol: 'wave',
    duration: 204,
    audioPreset: 'synthwave',
    bpm: 136,
    featured: false,
    plays: '1,230,000',
    description: '鼓動のように高鳴るキックとレーザーのように鋭いリードシンセがドライブを加速させる。',
  },

  // Anime & Game OST
  {
    title: '蒼天の境界線',
    artist: 'アルカディア幻想交響楽団',
    album: 'Skyward Chronicle OST',
    genre: 'Anime/Game',
    color1: '#1E3A8A',
    color2: '#2563EB',
    accent: '#93C5FD',
    symbol: 'notes',
    duration: 275,
    audioPreset: 'piano',
    bpm: 142,
    featured: true,
    plays: '3,450,800',
    description: '壮大なファンタジーRPGのメインテーマ。雄大なストリングスと力強いブラスセクションが冒険の始まりを高らかに告げる。',
  },
  {
    title: '運命のデュエル',
    artist: '神崎レイ & Sound Battalion',
    album: 'Blade of Destiny Theme',
    genre: 'Anime/Game',
    color1: '#7F1D1D',
    color2: '#B91C1C',
    accent: '#FDE047',
    symbol: 'neon',
    duration: 210,
    audioPreset: 'synthwave',
    bpm: 160,
    featured: false,
    plays: '2,100,500',
    description: '激しいバトルシーンを彩るシンフォニックロック。重厚なギターリフとドラマティックなバイオリンが交差する。',
  },
  {
    title: '星の降る夜に君と',
    artist: '月詠 ミク (Covered by Toki)',
    album: 'Virtual Starlight Songs',
    genre: 'Anime/Game',
    color1: '#581C87',
    color2: '#9333EA',
    accent: '#E9D5FF',
    symbol: 'rings',
    duration: 240,
    audioPreset: 'citypop',
    bpm: 130,
    featured: false,
    plays: '1,780,000',
    description: '情感あふれるボーカルと疾走するピアノが心揺さぶる、王道アニメ主題歌スタイルの名曲。',
  },
  {
    title: '憩いの宿屋〜タウンテーマ',
    artist: '8-Bit Enoki Heroes',
    album: 'Town & Tavern Themes Vol.1',
    genre: 'Anime/Game',
    color1: '#14532D',
    color2: '#16A34A',
    accent: '#BBF7D0',
    symbol: 'cassette',
    duration: 172,
    audioPreset: 'acoustic',
    bpm: 96,
    featured: false,
    plays: '670,400',
    description: '暖炉の温もりと仲間との談笑を思い起こさせる、どこか懐かしく温かいファンタジータウンBGM。',
  },

  // EDM & Club Dance
  {
    title: 'Infinity Drop',
    artist: 'DJ Enoki Pulse',
    album: 'Festival Anthems 2026',
    genre: 'EDM',
    color1: '#047857',
    color2: '#065F46',
    accent: '#34D399',
    symbol: 'wave',
    duration: 215,
    audioPreset: 'edm',
    bpm: 128,
    featured: true,
    plays: '4,520,000',
    description: '巨大フェスを揺らす圧倒的ビルドアップと爆発的ドロップ。ベースハウスとプログレッシブの極上のブレンド。',
  },
  {
    title: 'Tokyo Neon Lights',
    artist: 'Shibuya Electro Syndicate',
    album: 'Club Tokyo Afterhours',
    genre: 'EDM',
    color1: '#BE185D',
    color2: '#831843',
    accent: '#F472B6',
    symbol: 'disc',
    duration: 228,
    audioPreset: 'edm',
    bpm: 126,
    featured: false,
    plays: '2,340,000',
    description: '渋谷の夜を駆け抜けるフューチャーベースサウンド。キラキラしたシンセコードと力強いビート。',
  },
  {
    title: 'Bass Resonance',
    artist: 'SubZero Labs',
    album: 'Low End Theories',
    genre: 'EDM',
    color1: '#111827',
    color2: '#1F2937',
    accent: '#38BDF8',
    symbol: 'neon',
    duration: 195,
    audioPreset: 'edm',
    bpm: 130,
    featured: false,
    plays: '1,450,200',
    description: '腹の底まで響く重低音サブベースがフロアを直撃するミニマルかつ破壊力抜群のダブステップトラック。',
  },

  // Acoustic & Piano & Ambient
  {
    title: '月光のワルツ',
    artist: '森のピアニスト',
    album: 'Solo Piano Nocturnes',
    genre: 'Piano',
    color1: '#1E293B',
    color2: '#334155',
    accent: '#E2E8F0',
    symbol: 'notes',
    duration: 265,
    audioPreset: 'piano',
    bpm: 84,
    featured: true,
    plays: '1,890,300',
    description: '静寂の中に響くグランドピアノの美しい余韻。月明かりが差し込む夜に一人静かに浸りたい名演。',
  },
  {
    title: '木漏れ日のアコースティック',
    artist: '木陰カルテット',
    album: 'Forest Breeze',
    genre: 'Acoustic',
    color1: '#713F12',
    color2: '#854D0E',
    accent: '#FEF08A',
    symbol: 'disc',
    duration: 208,
    audioPreset: 'acoustic',
    bpm: 100,
    featured: false,
    plays: '740,000',
    description: '木漏れ日の中で聴くような温かいアコースティックギターとウクレレのデュエット。心地よいリラックス時間を提供。',
  },
  {
    title: 'Deep Ocean Waves',
    artist: 'Ambient Soundscape Lab',
    album: 'Hydro Harmony',
    genre: 'Ambient',
    color1: '#082F49',
    color2: '#0369A1',
    accent: '#38BDF8',
    symbol: 'rings',
    duration: 320,
    audioPreset: 'ambient',
    bpm: 60,
    featured: false,
    plays: '2,650,000',
    description: '深海の穏やかな静けさを再現したアンビエントドローン。睡眠前やマインドフルネス瞑想に最適。',
  },
  {
    title: '朝露のメロディ',
    artist: '朝比奈 ひより',
    album: 'Morning Awakening',
    genre: 'Piano',
    color1: '#064E3B',
    color2: '#047857',
    accent: '#6EE7B7',
    symbol: 'notes',
    duration: 195,
    audioPreset: 'piano',
    bpm: 90,
    featured: false,
    plays: '610,000',
    description: '新しい一日の始まりを優しく迎える爽やかなピアノソロ。清々しい朝の空気を運んでくれる一曲。',
  },

  // Rock & Alternative
  {
    title: 'Revolutionary Sparks',
    artist: 'The Black Enoki',
    album: 'Ignite the Night',
    genre: 'Rock',
    color1: '#881337',
    color2: '#E11D48',
    accent: '#FFE4E6',
    symbol: 'wave',
    duration: 226,
    audioPreset: 'synthwave',
    bpm: 148,
    featured: true,
    plays: '3,120,000',
    description: '歪んだギターリフとダイナミックなドラムビートが疾走するオルタナティブ・ロック・アンセム。',
  },
  {
    title: '錆びたフェンスの向こう側',
    artist: '午前3時のガレージ',
    album: 'Youth & Distortion',
    genre: 'Rock',
    color1: '#262626',
    color2: '#525252',
    accent: '#F59E0B',
    symbol: 'cassette',
    duration: 212,
    audioPreset: 'acoustic',
    bpm: 138,
    featured: false,
    plays: '890,100',
    description: '荒削りながら魂のこもったボーカルが胸を打つ、インディーガレージロックの真骨頂。',
  },

  // R&B & Soul
  {
    title: 'Velvet Midnight',
    artist: 'Sora & Soul Collective',
    album: 'Urban Sensations',
    genre: 'R&B',
    color1: '#312E81',
    color2: '#4C1D95',
    accent: '#A5B4FC',
    symbol: 'disc',
    duration: 242,
    audioPreset: 'citypop',
    bpm: 94,
    featured: true,
    plays: '2,780,000',
    description: 'シルクのように滑らかなボーカルとディープなネオソウルビートが夜の部屋を贅沢に満たす。',
  },
  {
    title: 'Slow Burn Candle',
    artist: 'Maya Jenkins',
    album: 'Intimate Grooves',
    genre: 'R&B',
    color1: '#701A75',
    color2: '#A21CAF',
    accent: '#F5D0FE',
    symbol: 'rings',
    duration: 230,
    audioPreset: 'lofi',
    bpm: 86,
    featured: false,
    plays: '1,420,000',
    description: 'アコースティックギターの爪弾きとメロウなシンセベースが心地よい大人なアーバンR&B。',
  },
];

// 歌詞生成ヘルパー
function generateSampleLyrics(title, artist) {
  return `[00:00.00]${title} - ${artist}
[00:12.50]街の灯りがひとつずつ消えてゆく
[00:24.00]静かな夜の帳に包まれて
[00:36.20]星が瞬く空を見上げながら
[00:48.00]胸の奥のメロディを口ずさむ
[01:00.10]
[01:02.00]光るハイウェイを駆け抜けて
[01:14.30]あの日の約束を迎えに行こう
[01:26.50]風が運ぶ未来の予感に
[01:38.20]心はいつでも自由になれるから
[01:50.00]
[02:02.50]夜が明ける前に届くように
[02:14.00]この歌をあなたへと響かせる
[02:26.40]果てしない空の彼方まで
[02:38.00]ずっと響き続けるよ
[02:50.00]（インストゥルメンタル・アウトロ）`;
}

// 60曲以上のデータを構築（バリエーション追加）
const fullMusicList = [];

let songCounter = 1;

// まず定義済み楽曲を追加
rawSongs.forEach((song, idx) => {
  const id = `music-${String(songCounter++).padStart(3, '0')}`;
  const minutes = Math.floor(song.duration / 60);
  const seconds = String(song.duration % 60).padStart(2, '0');
  const durationFormatted = `${minutes}:${seconds}`;

  const releaseTimestamp = Date.now() - (idx * 3.5 + 2) * 86400000;
  const d = new Date(releaseTimestamp);
  const releaseDateFormatted = `${d.getFullYear()}/${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}`;

  const coverSvg = createCoverSvg(song.title, song.artist, song.color1, song.color2, song.symbol, song.accent);
  const bannerSvg = createMusicBannerSvg(song.title, song.artist, song.genre, song.color1, song.color2, song.accent);

  fullMusicList.push({
    id,
    name: song.title,
    title: song.title,
    artist: song.artist,
    album: song.album,
    albumType: idx % 4 === 0 ? 'album' : (idx % 3 === 0 ? 'ep' : 'single'),
    genre: song.genre,
    cover: coverSvg,
    icon: coverSvg,
    thumbnail: bannerSvg,
    duration: song.duration,
    durationFormatted,
    releaseDate: releaseTimestamp,
    releaseDateFormatted,
    plays: song.plays,
    rating: Number((4.5 + (idx % 5) * 0.1).toFixed(1)),
    featured: song.featured || idx < 6,
    isTrending: idx % 3 === 0,
    themeColor: song.color2,
    accentColor: song.accent,
    audioPreset: song.audioPreset,
    bpm: song.bpm,
    description: song.description,
    lyrics: generateSampleLyrics(song.title, song.artist),
    composer: song.artist,
    lyricist: song.artist,
    price: 0,
    type: 'music',
  });
});

// バリエーション生成でさらに追加し、合計60曲にする
const extraThemes = [
  { prefix: 'Crystal', genre: 'Ambient', preset: 'ambient', c1: '#0E7490', c2: '#0891B2', acc: '#67E8F9', sym: 'rings', bpm: 68 },
  { prefix: 'Urban', genre: 'City Pop', preset: 'citypop', c1: '#3730A3', c2: '#4F46E5', acc: '#A5B4FC', sym: 'disc', bpm: 114 },
  { prefix: 'Midnight', genre: 'Lo-Fi', preset: 'lofi', c1: '#44403C', c2: '#57534E', acc: '#D6D3D1', sym: 'cassette', bpm: 80 },
  { prefix: 'Cyber', genre: 'Synthwave', preset: 'synthwave', c1: '#701A75', c2: '#86198F', acc: '#F472B6', sym: 'neon', bpm: 130 },
  { prefix: 'Acoustic', genre: 'Acoustic', preset: 'acoustic', c1: '#78350F', c2: '#92400E', acc: '#FDE68A', sym: 'wave', bpm: 98 },
  { prefix: 'Neo', genre: 'EDM', preset: 'edm', c1: '#1E1B4B', c2: '#312E81', acc: '#38BDF8', sym: 'wave', bpm: 128 },
  { prefix: 'Harmony', genre: 'Piano', preset: 'piano', c1: '#1E293B', c2: '#475569', acc: '#E2E8F0', sym: 'notes', bpm: 88 },
  { prefix: 'Sunset', genre: 'J-POP', preset: 'citypop', c1: '#991B1B', c2: '#C2410C', acc: '#FDBA74', sym: 'disc', bpm: 122 },
];

const artistsPool = [
  'Toki Beats', 'Enoki Soundworks', 'Miu Shizuki', 'Kaito Arata', 'Lumina Sound',
  'Yuki & The Stars', 'Chronos Quartet', 'Aoi Resonance', 'Cosmic Echoes', 'Rei Takamura'
];

const titlesPool = [
  'Memories in the Rain', 'Skyline Horizon', 'Coffee at 3AM', 'Retro Avenue',
  'Floating in Starlight', 'Echoes of Summer', 'Autumn Leaves Waltz', 'Neon Highway 99',
  'Quiet Forest Walk', 'Deep Dream State', 'First Light', 'Midnight Whisper',
  'Shinjuku Twilight', 'Golden Hour Reflections', 'Distance between Stars', 'Secret Garden BGM',
  'Velvet Waves', 'Electric Blossom', 'Lost in Translation', 'Parallel World Protocol',
  'Sakura Rain', 'Breeze from the Harbor', 'Clockwork Heart', 'Ocean Drive Groove',
  'Shooting Star Express', 'Virtual Paradise', 'Snowy City Lights', 'Moonlight Sonata 2026',
  'Starlight Train', 'Daybreak Radiance'
];

titlesPool.forEach((title, i) => {
  const theme = extraThemes[i % extraThemes.length];
  const artist = artistsPool[i % artistsPool.length];
  const id = `music-${String(songCounter++).padStart(3, '0')}`;
  const duration = 150 + ((i * 19) % 150);
  const minutes = Math.floor(duration / 60);
  const seconds = String(duration % 60).padStart(2, '0');
  const durationFormatted = `${minutes}:${seconds}`;

  const releaseTimestamp = Date.now() - (i * 2 + 15) * 86400000;
  const d = new Date(releaseTimestamp);
  const releaseDateFormatted = `${d.getFullYear()}/${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}`;

  const coverSvg = createCoverSvg(title, artist, theme.c1, theme.c2, theme.sym, theme.acc);
  const bannerSvg = createMusicBannerSvg(title, artist, theme.genre, theme.c1, theme.c2, theme.acc);

  fullMusicList.push({
    id,
    name: title,
    title,
    artist,
    album: `${theme.prefix} Collections Vol.${(i % 3) + 1}`,
    albumType: i % 3 === 0 ? 'album' : 'single',
    genre: theme.genre,
    cover: coverSvg,
    icon: coverSvg,
    thumbnail: bannerSvg,
    duration,
    durationFormatted,
    releaseDate: releaseTimestamp,
    releaseDateFormatted,
    plays: `${(350 + (i * 47) % 650).toLocaleString()},000`,
    rating: Number((4.6 + (i % 4) * 0.1).toFixed(1)),
    featured: i % 7 === 0,
    isTrending: i % 4 === 0,
    themeColor: theme.c2,
    accentColor: theme.acc,
    audioPreset: theme.preset,
    bpm: theme.bpm,
    description: `${theme.genre} の情緒あふれる美しいトラック。${artist} が紡ぎ出す繊細な音色をお楽しみください。`,
    lyrics: generateSampleLyrics(title, artist),
    composer: artist,
    lyricist: artist,
    price: 0,
    type: 'music',
  });
});

console.log(`Generated ${fullMusicList.length} music tracks.`);

// 保存先ディレクトリ確認
const appDataDir = path.resolve('app/data');
const publicDataDir = path.resolve('public/data');

if (!fs.existsSync(appDataDir)) fs.mkdirSync(appDataDir, { recursive: true });
if (!fs.existsSync(publicDataDir)) fs.mkdirSync(publicDataDir, { recursive: true });

// JSONファイル出力
const appMusicJsonPath = path.join(appDataDir, 'music.json');
const publicMusicJsonPath = path.join(publicDataDir, 'music.json');

fs.writeFileSync(appMusicJsonPath, JSON.stringify(fullMusicList, null, 2), 'utf-8');
fs.writeFileSync(publicMusicJsonPath, JSON.stringify(fullMusicList, null, 2), 'utf-8');

console.log(`Successfully saved music data to:\n- ${appMusicJsonPath}\n- ${publicMusicJsonPath}`);
