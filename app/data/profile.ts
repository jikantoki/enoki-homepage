export interface SocialLink {
  title: string
  url: string
  icon: string
  color?: string
  bg?: string
}

export interface AchievementItem {
  id: string
  date: string
  title: string
  badge: string
  badgeColor?: string
  icon: string
  description?: string
  link?: string
}

export interface CareerItem {
  id: string
  date: string
  year: number
  title: string
  description?: string
  icon: string
  highlight?: boolean
  tag?: string
}

export interface LicenseItem {
  name: string
  date: string
  icon: string
  category: string
}

export interface SkillCategory {
  title: string
  icon: string
  color: string
  summary: string
  items: string[]
}

export const PROFILE_DATA = {
  name: 'ときえのき',
  englishName: 'jikantoki',
  title: 'エノキ電気 代表 / マルチクリエイター',
  birthDate: '2003年1月6日',
  birthPlace: '埼玉県さいたま市',
  avatar: '/jikantoki.jpg',
  cover: '/img/default_cover.jpg',
  motto: '「今年は法人化します」とかれこれ5年以上言い続けている',
  bio: `エノキ電気グループを作った人。
音楽活動（ボカロP）から始まり、Linuxディストリビューション自作、Webサービスやスマホアプリ開発、弱電・バイクのエンジン載せ替え、現場責任者・営業まで、多岐にわたるプロジェクトを実質1人で統括・開発しています。`,

  socials: [
    {
      title: 'YouTube',
      url: 'https://www.youtube.com/@jikantoki',
      icon: 'mdi-youtube',
      color: '#FFFFFF',
      bg: '#FF0000',
    },
    {
      title: 'Twitter / X',
      url: 'https://twitter.com/jikantoki',
      icon: 'mdi-twitter',
      color: '#FFFFFF',
      bg: '#1DA1F2',
    },
    {
      title: 'GitHub',
      url: 'https://github.com/jikantoki',
      icon: 'mdi-github',
      color: '#FFFFFF',
      bg: '#24292e',
    },
    {
      title: 'エノキ電気 公式',
      url: 'https://enoki.xyz',
      icon: 'mdi-web',
      color: '#FFFFFF',
      bg: '#4CAF50',
    },
  ] as SocialLink[],

  licenses: [
    {
      name: '第一種普通自動車免許 (AT)',
      date: '2024/05/13',
      icon: 'mdi-car',
      category: '免許',
    },
    {
      name: '普通二輪自動車免許',
      date: '2022/11/08',
      icon: 'mdi-motorbike',
      category: '免許',
    },
    {
      name: '原動機付自転車免許',
      date: '2022/06/07',
      icon: 'mdi-moped',
      category: '免許',
    },
    {
      name: '基本情報技術者 (午前免除)',
      date: '2021/08/26',
      icon: 'mdi-certificate',
      category: '国家資格',
    },
    {
      name: 'ITパスポート',
      date: '2020/06/18',
      icon: 'mdi-shield-check',
      category: '国家資格',
    },
  ] as LicenseItem[],

  skills: [
    {
      title: '音楽・ボカロP',
      icon: 'mdi-music-clef-treble',
      color: '#9C27B0',
      summary: '作詞・作曲・編曲・アルバム制作・配信',
      items: [
        'ボカロP「ときえのき（刻夏P）」として楽曲制作',
        'Spotify / Apple Music / LINE MUSIC等でサブスク配信',
        'JOYSOUNDでのカラオケ音源全国配信',
        'Steam Workshop [Cities: Skylines] への楽曲配信',
        'コミックマーケット等での自主制作CD販売',
      ],
    },
    {
      title: 'IT・ソフトウェア開発',
      icon: 'mdi-laptop-code',
      color: '#1976D2',
      summary: '自作OS・Web開発・モバイルアプリ・OSS',
      items: [
        '自作Linux「Caramel OS / Upper Linux」（Xubuntu公式掲載）',
        'Nuxt 4 / Vue 3 / Capacitor によるクロスプラットフォーム開発',
        'TypeScript / JavaScript / PHP / Python / C++',
        'GitHubでのオープンソースソフトウェア公開・保守',
        '某企業 CTO就任（2026年〜）',
      ],
    },
    {
      title: '弱電・ハードウェア・モビリティ',
      icon: 'mdi-wrench-cog',
      color: '#F57C00',
      summary: 'バイク自力整備・電光掲示板・電子工作',
      items: [
        'スズキ ジクサー150 エンジン載せ替えを自力完遂',
        '自作電光掲示板の制作＆レッドブル公式キャンペーン宣伝',
        '各種バイク・車のメンテナンス・カスタム',
        '車歴: ディオ → ジクサー150 → セルボ → Ninja250R → パレットSW',
      ],
    },
    {
      title: 'メディア・ビジネス',
      icon: 'mdi-bullhorn-outline',
      color: '#43A047',
      summary: 'ブログ運営・YouTube・個人事業主',
      items: [
        '高校生でのブログ開設・アフィリエイト収益化',
        '2021年 開業届提出、個人事業主（エノキ電気）',
        'YouTubeチャンネル運営（解説動画・音楽MV）',
        '位置情報SNS「Naunau」公式アンバサダー',
      ],
    },
  ] as SkillCategory[],

  achievements: [
    {
      id: 'cto',
      date: '2026/01/10',
      title: '某企業にて CTO（最高技術責任者）に就任',
      badge: 'キャリア',
      badgeColor: 'primary',
      icon: 'mdi-tie',
      description: 'これまでのIT・ソフトウェア開発実績と技術力を評価され就任。',
    },
    {
      id: 'c105',
      date: '2024/12/30',
      title: 'コミックマーケットにてCD販売',
      badge: 'イベント',
      badgeColor: 'deep-orange',
      icon: 'mdi-disc',
      description: '知り合いのツテでコミケにサークル参加しオリジナルCDを頒布！',
    },
    {
      id: 'cyr',
      date: '2023/03/24',
      title: 'CYR MUSIC合同会社に楽曲配信を委託',
      badge: '音楽',
      badgeColor: 'purple',
      icon: 'mdi-music-box-multiple',
      description: '制作楽曲のさらなる世界配信拡大に向け委託契約を締結（当時）。',
    },
    {
      id: 'redbull',
      date: '2023/03/09',
      title: 'Red Bull パープルエディションを自作電光掲示板で宣伝',
      badge: '制作・広告',
      badgeColor: 'amber',
      icon: 'mdi-bullhorn',
      description: '自作の屋外電光掲示板を活用し、レッドブル公式の大型宣伝を展開！',
    },
    {
      id: 'naunau',
      date: '2022/12/25',
      title: '位置情報SNS「Naunau」公式アンバサダ就任',
      badge: 'アンバサダー',
      badgeColor: 'teal',
      icon: 'mdi-account-star',
      description: '急速にユーザーを増やしたSNS「Naunau」の公式アンバサダに抜擢。',
    },
    {
      id: 'cities-skylines',
      date: '2021/07/23',
      title: 'Steam Workshop [Cities: Skylines] にて楽曲配信',
      badge: 'ゲーム・音楽',
      badgeColor: 'indigo',
      icon: 'mdi-steam',
      description: '世界的人気都市開発シミュレーションゲームのSteamワークショップで楽曲を公開。',
    },
    {
      id: 'fascode-music',
      date: '2021/06/28',
      title: 'Fascode Network への楽曲提供を正式開始',
      badge: '楽曲提供',
      badgeColor: 'pink',
      icon: 'mdi-handshake',
      description: 'プログラマ団体 Fascode Network の公式コンテンツ向けに楽曲を提供。',
    },
    {
      id: 'joysound',
      date: '2021/04/23',
      title: 'JOYSOUND にてカラオケ音源全国配信開始',
      badge: '音楽配信',
      badgeColor: 'red',
      icon: 'mdi-microphone-variant',
      description: '全国のJOYSOUND設置店舗にて、オリジナル楽曲がカラオケ歌唱可能に！',
    },
    {
      id: 'xubuntu',
      date: '2020/08/01',
      title: 'Xubuntu公式HPにて自作「Caramel OS」が紹介',
      badge: '自作OS・OSS',
      badgeColor: 'blue',
      icon: 'mdi-linux',
      description: 'Ubuntu派生の公式トップページにて、公式派生ディストリビューションとして紹介される快挙。',
    },
    {
      id: 'fascode-partner',
      date: '2020/04/01',
      title: '学生プログラマ団体「Fascode Network」と技術提携',
      badge: '提携',
      badgeColor: 'cyan',
      icon: 'mdi-transit-connection-variant',
      description: '技術コミュニティとのパートナーシップを締結し、ソフトウェア開発を加速。',
    },
  ] as AchievementItem[],

  career: [
    {
      id: '2026-03',
      date: '2026/03/24',
      year: 2026,
      title: 'スズキ パレットSWを納車！',
      icon: 'mdi-car',
      tag: 'モビリティ',
    },
    {
      id: '2026-01',
      date: '2026/01/10',
      year: 2026,
      title: '某企業にてCTOに就任',
      icon: 'mdi-tie',
      highlight: true,
      tag: 'キャリア',
    },
    {
      id: '2025-09',
      date: '2025/09/29',
      year: 2025,
      title: '東京にてシェアハウス居住開始',
      icon: 'mdi-home-city',
      tag: 'ライフ',
    },
    {
      id: '2025-07',
      date: '2025/07/23',
      year: 2025,
      title: 'カワサキ Ninja250Rを納車！',
      icon: 'mdi-motorbike',
      tag: 'モビリティ',
    },
    {
      id: '2024-12',
      date: '2024/12/30',
      year: 2024,
      title: '知り合いのツテでコミケでCD販売！',
      icon: 'mdi-disc',
      highlight: true,
      tag: '音楽',
    },
    {
      id: '2024-08',
      date: '2024/08/23',
      year: 2024,
      title: 'またまた別の企業に所属（個人事業主は変わらず継続）',
      icon: 'mdi-domain',
      tag: 'キャリア',
    },
    {
      id: '2024-05-30',
      date: '2024/05/30',
      year: 2024,
      title: 'スズキ セルボを納車！',
      icon: 'mdi-car',
      tag: 'モビリティ',
    },
    {
      id: '2024-05-13',
      date: '2024/05/13',
      year: 2024,
      title: '第一種普通自動車免許 (AT) を取得',
      icon: 'mdi-card-account-details',
      tag: '資格',
    },
    {
      id: '2024-03',
      date: '2024/03/30',
      year: 2024,
      title: '日本工学院専門学校を留年して卒業、就活をしておらずギグワーカーを開始',
      icon: 'mdi-school',
      tag: '学歴',
    },
    {
      id: '2023-12',
      date: '2023/12/31',
      year: 2023,
      title: '求められているものより作りたいものを作りたくてIT企業を退職',
      icon: 'mdi-door-open',
      tag: 'キャリア',
    },
    {
      id: '2023-08',
      date: '2023/08/01',
      year: 2023,
      title: '某ベンチャーIT企業に在籍、Web開発をじっくり実践学習',
      icon: 'mdi-laptop',
      tag: 'キャリア',
    },
    {
      id: '2023-03-24',
      date: '2023/03/24',
      year: 2023,
      title: 'CYR MUSIC合同会社に楽曲配信を委託（当時）',
      icon: 'mdi-music-box-multiple',
      tag: '音楽',
    },
    {
      id: '2023-03-09',
      date: '2023/03/09',
      year: 2023,
      title: 'Red Bull パープルエディションを自分の電光掲示板にて宣伝',
      icon: 'mdi-bullhorn',
      highlight: true,
      tag: '制作',
    },
    {
      id: '2023-02',
      date: '2023/02/10頃',
      year: 2023,
      title: 'ジクサーのエンジンが故障したので自力で載せ替え完遂',
      icon: 'mdi-wrench',
      tag: 'モビリティ',
    },
    {
      id: '2023-01-28',
      date: '2023/01/28',
      year: 2023,
      title: '「エノキ電気」名義で新しい屋号を取得',
      icon: 'mdi-office-building',
      highlight: true,
      tag: 'ビジネス',
    },
    {
      id: '2023-01-06',
      date: '2023/01/06',
      year: 2023,
      title: '20歳になる！',
      icon: 'mdi-cake-variant',
      tag: 'ライフ',
    },
    {
      id: '2022-12',
      date: '2022/12/25',
      year: 2022,
      title: '位置情報SNS「Naunau」公式アンバサダに就任',
      icon: 'mdi-star-face',
      highlight: true,
      tag: '実績',
    },
    {
      id: '2022-11-20',
      date: '2022/11/20',
      year: 2022,
      title: 'スズキ ジクサー150を納車！',
      icon: 'mdi-motorbike',
      tag: 'モビリティ',
    },
    {
      id: '2022-11-08',
      date: '2022/11/08',
      year: 2022,
      title: '普通二輪自動車免許を取得',
      icon: 'mdi-card-account-details',
      tag: '資格',
    },
    {
      id: '2022-06-11',
      date: '2022/06/11',
      year: 2022,
      title: 'ホンダ ディオを納車！',
      icon: 'mdi-moped',
      tag: 'モビリティ',
    },
    {
      id: '2022-06-07',
      date: '2022/06/07',
      year: 2022,
      title: '原付免許を取得',
      icon: 'mdi-card-account-details',
      tag: '資格',
    },
    {
      id: '2022-05',
      date: '2022/05/15',
      year: 2022,
      title: 'ときえのき名義から「エノキ電気グループ」に名義変更（所属は自分のみ）',
      icon: 'mdi-account-group',
      highlight: true,
      tag: 'ビジネス',
    },
    {
      id: '2022-04-21',
      date: '2022/04/21',
      year: 2022,
      title: 'タイピング速度 5.3文字/秒を達成！',
      icon: 'mdi-keyboard',
      tag: 'スキル',
    },
    {
      id: '2022-04-01',
      date: '2022/04/01',
      year: 2022,
      title: '民法改正により19歳で新成人に！',
      icon: 'mdi-account-check',
      tag: 'ライフ',
    },
    {
      id: '2022-02',
      date: '2022/02/20',
      year: 2022,
      title: '人生初の確定申告を達成',
      icon: 'mdi-file-document-outline',
      tag: 'ビジネス',
    },
    {
      id: '2021-10-31',
      date: '2021/10/31',
      year: 2021,
      title: 'アルバイトを退職、フリーランス一本へ',
      icon: 'mdi-logout',
      tag: 'キャリア',
    },
    {
      id: '2021-10-18',
      date: '2021/10/18',
      year: 2021,
      title: 'LINEスタンプ「意識が高くて低いスタンプ」を販売開始',
      icon: 'mdi-sticker-emoji',
      tag: 'クリエイティブ',
    },
    {
      id: '2021-09-30',
      date: '2021/09/30',
      year: 2021,
      title: '学生にして高い月収20万を偶然達成（毎月維持は無理）',
      icon: 'mdi-currency-jpy',
      tag: 'ビジネス',
    },
    {
      id: '2021-09-21',
      date: '2021/09/21',
      year: 2021,
      title: '開業届と青色申告承認申請書を提出、ときえのき名義を取得（自営業者へ）',
      icon: 'mdi-briefcase-check',
      highlight: true,
      tag: 'ビジネス',
    },
    {
      id: '2021-08',
      date: '2021/08/26',
      year: 2021,
      title: 'オリジナルCD販売開始＆基本情報技術者（午前免除）を取得',
      icon: 'mdi-certificate',
      highlight: true,
      tag: '音楽・資格',
    },
    {
      id: '2021-07',
      date: '2021/07/23',
      year: 2021,
      title: 'Steam Workshop [Cities: Skylines] にて楽曲を配信',
      icon: 'mdi-steam',
      tag: '音楽',
    },
    {
      id: '2021-06',
      date: '2021/06/28',
      year: 2021,
      title: 'Fascode Network への楽曲提供を正式に開始',
      icon: 'mdi-handshake',
      tag: '音楽',
    },
    {
      id: '2021-04',
      date: '2021/04/23',
      year: 2021,
      title: 'JOYSOUND でのカラオケ音源全国配信を開始',
      icon: 'mdi-microphone',
      highlight: true,
      tag: '音楽',
    },
    {
      id: '2021-03',
      date: '2021/03/31',
      year: 2021,
      title: '高校を卒業、日本工学院専門学校へ進学',
      icon: 'mdi-school',
      tag: '学歴',
    },
    {
      id: '2020-08',
      date: '2020/08/01頃',
      year: 2020,
      title: 'Xubuntu公式HPにて自作Linux「Caramel OS」が公式派生として紹介！',
      icon: 'mdi-linux',
      highlight: true,
      tag: 'OSS',
    },
    {
      id: '2020-06',
      date: '2020/06/18頃',
      year: 2020,
      title: 'ITパスポートを取得',
      icon: 'mdi-certificate',
      tag: '資格',
    },
    {
      id: '2020-05',
      date: '2020/05/01頃',
      year: 2020,
      title: 'Spotify、Apple Music、LINE MUSIC等でストリーミング配信開始',
      icon: 'mdi-music',
      highlight: true,
      tag: '音楽',
    },
    {
      id: '2020-04',
      date: '2020/04/01',
      year: 2020,
      title: '学生プログラマ団体「Fascode Network」と技術提携',
      icon: 'mdi-transit-connection',
      tag: '提携',
    },
    {
      id: '2020-03',
      date: '2020/03/03',
      year: 2020,
      title: 'Linuxディストリビューションを自作・公開（caramelos.xyz）、同時にブログ開設',
      icon: 'mdi-laptop',
      highlight: true,
      tag: 'OSS・Web',
    },
    {
      id: '2019-03',
      date: '2019/03/25',
      year: 2019,
      title: 'まともに曲と呼べる初めてのオリジナル楽曲を公開',
      icon: 'mdi-music-circle',
      highlight: true,
      tag: '音楽',
    },
    {
      id: '2018-02',
      date: '2018/02/05',
      year: 2018,
      title: 'YouTubeチャンネル開設、自己紹介動画を投稿（当時中学3年生）',
      icon: 'mdi-youtube',
      tag: 'メディア',
    },
    {
      id: '2003-01',
      date: '2003/01/06',
      year: 2003,
      title: '埼玉県さいたま市に爆誕！',
      icon: 'mdi-baby-carriage',
      highlight: true,
      tag: '誕生',
    },
  ] as CareerItem[],
}
