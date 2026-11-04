export interface SponsorLink {
  title: string
  url: string
  icon: string
  color?: string
}

export interface SponsorItem {
  id: string
  name: string
  category: 'sponsor' | 'friend'
  tier: string
  tierColor?: string
  role: string
  avatar: string
  description: string
  organization?: string
  since?: string
  links?: SponsorLink[]
}

export const SPONSORS_DATA: SponsorItem[] = [
  // ================= スポンサー (5名) =================
  {
    id: 'sponsor-neotech',
    name: '株式会社ネオテック・ソリューションズ',
    category: 'sponsor',
    tier: 'オフィシャルパートナー',
    tierColor: 'primary',
    role: 'ITインフラ・クラウド支援',
    organization: 'NeoTech Solutions Inc.',
    avatar: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=300&q=80',
    description: 'エノキ電気の各種WebサービスおよびAPIインフラの保守運用を全面サポートしていただいています。技術的な挑戦と自由なプロダクト開発を支えてくださる心強いパートナーです。',
    since: '2024年〜',
    links: [
      {
        title: '企業サイト',
        url: 'https://example.com/neotech',
        icon: 'mdi-web',
        color: '#3b82f6',
      },
    ],
  },
  {
    id: 'sponsor-soundfrontier',
    name: '合同会社サウンドフロンティア',
    category: 'sponsor',
    tier: 'ゴールドスポンサー',
    tierColor: 'amber-darken-2',
    role: '音楽機材・音源ライセンス支援',
    organization: 'SoundFrontier LLC',
    avatar: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=300&q=80',
    description: 'ボカロP・コンポーザー活動で使用するハイエンド音源・ハードウェア機材の提供支援や、レコーディング環境の協賛をいただいております。音楽制作の表現力を飛躍的に広げてくださっています。',
    since: '2024年〜',
    links: [
      {
        title: '公式サイト',
        url: 'https://example.com/soundfrontier',
        icon: 'mdi-web',
        color: '#f59e0b',
      },
      {
        title: 'Twitter',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'sponsor-kentaro',
    name: '山田 健太郎',
    category: 'sponsor',
    tier: '個人プレミアムサポーター',
    tierColor: 'teal',
    role: '個人開発サポーター / パトロン',
    organization: '個人サポーター',
    avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
    description: '初期の同人活動や個人開発プロジェクトの立ち上げ期から継続して手厚い個人支援をいただいております。いつも温かい応援メッセージと鋭いフィードバックをありがとうございます！',
    since: '2023年〜',
    links: [
      {
        title: 'Twitter / X',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
      {
        title: 'GitHub',
        url: 'https://github.com',
        icon: 'mdi-github',
        color: '#24292e',
      },
    ],
  },
  {
    id: 'sponsor-cloudnext',
    name: 'クラウドネクスト・テクノロジー',
    category: 'sponsor',
    tier: 'シルバースポンサー',
    tierColor: 'blue-grey',
    role: 'サーバー・ストレージ協賛',
    organization: 'CloudNext Tech',
    avatar: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?auto=format&fit=crop&w=300&q=80',
    description: '高負荷な配信サーバーや実証実験用環境のクラウドアセットをご提供いただいています。個人開発者による大規模展開と安定運用の基盤を技術面・リソース面から支えてくださっています。',
    since: '2025年〜',
    links: [
      {
        title: 'サービスページ',
        url: 'https://example.com/cloudnext',
        icon: 'mdi-web',
        color: '#64748b',
      },
    ],
  },
  {
    id: 'sponsor-creativeguild',
    name: 'クリエイティブ・ギルド・ジャパン',
    category: 'sponsor',
    tier: 'サポーティングパートナー',
    tierColor: 'deep-purple',
    role: 'デザイン・広報バックアップ',
    organization: 'Creative Guild Japan',
    avatar: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=300&q=80',
    description: 'UI/UXデザインのアドバイスや、各種展示会・イベント出展時のプロモーション活動をバックアップしていただいています。クリエイター同士の交流と創作を促進するコミュニティです。',
    since: '2025年〜',
    links: [
      {
        title: 'コミュニティ',
        url: 'https://example.com/creativeguild',
        icon: 'mdi-web',
        color: '#7c3aed',
      },
    ],
  },

  // ================= 友人 (5名) =================
  {
    id: 'friend-kazuki',
    name: 'カズキ (Kazuki)',
    category: 'friend',
    tier: 'クリエイター仲間',
    tierColor: 'indigo',
    role: 'ボカロP / コンポーザー',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    description: '音楽活動初期からの戦友。深夜に通話しながらDTMのミックス・マスタリングについて熱く議論したり、互いの楽曲をレビューし合ったりと、音楽面で最も刺激を受け合っている親友の一人です。',
    since: '2020年〜',
    links: [
      {
        title: 'YouTube',
        url: 'https://youtube.com',
        icon: 'mdi-youtube',
        color: '#ff0000',
      },
      {
        title: 'Twitter / X',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'friend-reina',
    name: 'れいな (Reina)',
    category: 'friend',
    tier: 'イラストパートナー',
    tierColor: 'pink',
    role: 'イラストレーター / キャラクターデザイナー',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
    description: 'オリジナル楽曲のジャケットやMV用キャラクターイラストを数多く手掛けてくれているイラストレーター。こちらの抽象的な世界観のオーダーを常に120%のクオリティで具現化してくれます。',
    since: '2021年〜',
    links: [
      {
        title: 'ポートフォリオ',
        url: 'https://example.com/reina',
        icon: 'mdi-palette',
        color: '#ec4899',
      },
      {
        title: 'Twitter / X',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'friend-takuya',
    name: 'たくや (Takuya)',
    category: 'friend',
    tier: '開発仲間',
    tierColor: 'cyan-darken-1',
    role: 'フルスタックエンジニア',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    description: '学生時代のハッカソンで意気投合して以来の開発仲間。休日に最新のWeb技術や自作アーキテクチャについて語り合ったり、個人開発プロジェクトのコードを突っつき合ったりしています。',
    since: '2021年〜',
    links: [
      {
        title: 'GitHub',
        url: 'https://github.com',
        icon: 'mdi-github',
        color: '#24292e',
      },
      {
        title: 'Blog',
        url: 'https://example.com/takuya-blog',
        icon: 'mdi-post',
        color: '#06b6d4',
      },
    ],
  },
  {
    id: 'friend-aoi',
    name: '葵 (Aoi)',
    category: 'friend',
    tier: 'クリエイター仲間',
    tierColor: 'purple',
    role: '映像クリエイター / 3Dモデラー',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80',
    description: '3DCGやAfter Effectsを用いたMV制作、イベント展示用映像で度々タッグを組んでいるクリエイター。細部まで妥協しない映像美と世界観の構築力にいつも背中を押されています。',
    since: '2022年〜',
    links: [
      {
        title: 'YouTube',
        url: 'https://youtube.com',
        icon: 'mdi-youtube',
        color: '#ff0000',
      },
      {
        title: 'Twitter / X',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'friend-kengo',
    name: 'ケンゴ (Kengo)',
    category: 'friend',
    tier: 'ガジェット・工作仲間',
    tierColor: 'orange-darken-2',
    role: 'ハードウェアエンジニア / モビリティ愛好家',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    description: '自作キーボードやRaspberry Pi、マイコン工作、そしてバイクやエンジンの整備までを語り合うハードウェア仲間。ソフトウェアにとどまらないモノ作りの情熱を共有できる大切な友人です。',
    since: '2022年〜',
    links: [
      {
        title: 'Twitter / X',
        url: 'https://twitter.com',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
      {
        title: 'Zenn / 技術記事',
        url: 'https://example.com/kengo',
        icon: 'mdi-book-open-variant',
        color: '#3ea8ff',
      },
    ],
  },
]
