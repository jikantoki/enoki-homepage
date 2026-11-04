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
  // ================= スポンサー =================
  {
    id: 'cyr',
    name: 'CYR MUSIC 合同会社',
    category: 'sponsor',
    tier: '楽曲委託配信',
    tierColor: 'primary',
    role: '音楽配信支援',
    organization: 'CYR MUSIC LLC',
    avatar: '/sponsor/cyr.png',
    description:
      'ときえのきの楽曲を委託配信してくださっている音楽レーベルです。楽曲の配信・販売・プロモーションをサポートしてくださっています。',
    since: '2024年〜',
    links: [
      {
        title: '企業サイト',
        url: 'https://cma.official.ec/',
        icon: 'mdi-web',
        color: '#3b82f6',
      },
    ],
  },
  {
    id: 'fascode-network',
    name: 'Fascode Network',
    category: 'sponsor',
    tier: '相互技術連携',
    tierColor: 'amber-darken-2',
    role: '学生プログラマー団体',
    organization: 'Fascode Network',
    avatar: '/sponsor/fascode.jpg',
    description:
      'ときえのきの個人開発活動を技術面・リソース面から支援してくださっている学生プログラマー団体です。個人開発者同士の交流や、技術的な相談・助言をいただいています。',
    since: '2020年〜',
    links: [
      {
        title: '公式サイト',
        url: 'https://fascode.net',
        icon: 'mdi-web',
        color: '#f59e0b',
      },
    ],
  },
  {
    id: 'naunau',
    name: 'Naunau',
    category: 'sponsor',
    tier: '公式アンバサダー',
    tierColor: 'teal',
    role: 'アンバサダー登用',
    organization: 'サポーター',
    avatar: '/sponsor/naunau.jpg',
    description:
      'ときえのきの活動を応援してくださっているサポーターです。Naunauの公式アンバサダーとして、相互的に認知を広める活動をしています。',
    since: '2024年〜',
    links: [],
  },
  {
    id: 'redbull',
    name: 'Red Bull Japan',
    category: 'sponsor',
    tier: 'エナジードリンク協賛',
    tierColor: 'red',
    role: 'エナジードリンク提供',
    organization: 'Red Bull Japan',
    avatar: '/sponsor/redbull.webp',
    description:
      'ときえのきの活動を応援してくださっているエナジードリンクブランドです。Red Bullのエナジードリンクを提供していただき、活動の活力源として活用しています。',
    since: '2023年〜',
    links: [],
  },

  // ================= 友人 =================
  {
    id: 'saisabo10',
    name: 'サイバーさぼてん',
    category: 'friend',
    tier: 'クリエイター仲間',
    tierColor: 'cyan',
    role: 'プロエンカラー',
    avatar: '/sponsor/saisabo10.jpg',
    description:
      '主に千葉県で活動しているエンカの狂人。ときえのきがクッソ初期から絡んでいる。口癖は「千葉来ません？」',
    since: '2020年〜',
    links: [
      {
        title: 'Homepage',
        url: 'https://saisabo10.com',
        icon: 'mdi-web',
        color: '#64748b',
      },
      {
        title: 'Twitter / X',
        url: 'https://twitter.com/saisabo10',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'mania',
    name: 'マニア',
    category: 'friend',
    tier: 'クリエイター仲間',
    tierColor: 'pink',
    role: 'プロエンカラー',
    avatar: '/sponsor/mania.jpg',
    description:
      '埼玉出身のエレベーターオタク。自称プログラミングは出来ないらしいが、ロブロックスで自作のゲームを配布している。',
    since: '2021年〜',
    links: [
      {
        title: 'Twitter / X',
        url: 'https://twitter.com/Man1a_Main',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
  {
    id: 'mackey',
    name: 'マッキー',
    category: 'friend',
    tier: '家主',
    tierColor: 'cyan-darken-1',
    role: 'ネットワークエンジニア',
    avatar: '/sponsor/mackey.jpg',
    description:
      'ときえのきが住んでいる家の大家さん。ネットワークエンジニアとしての知識を活かして、家のネットワーク環境を整備してくれている。',
    since: '2024年〜',
    links: [],
  },
  {
    id: 'strm_pixelrize',
    name: '優 / ねるる',
    category: 'friend',
    tier: 'ガジェット・工作仲間',
    tierColor: 'orange-darken-2',
    role: 'システムエンジニア',
    avatar: '/sponsor/neruru.jpg',
    description:
      'ソフトウェア開発の知識を持ちつつ、デザインに関するセンスも持っている珍しい人。ときえのきのソフトウェア開発や電子工作の相談に乗ってくれる頼れる友人。',
    since: '2022年〜',
    links: [
      {
        title: 'Homepage',
        url: 'https://architectural-n.net/',
        icon: 'mdi-web',
        color: '#64748b',
      },
      {
        title: 'Twitter / X',
        url: 'https://twitter.com/strm_pixelrize',
        icon: 'mdi-twitter',
        color: '#1da1f2',
      },
    ],
  },
]
