export interface DownloadItem {
  id: string
  title: string
  subtitle?: string
  category: 'music' | 'os' | 'railway' | 'led' | 'other'
  categoryLabel: string
  description: string
  format: 'ZIP' | 'XLSX' | 'OUD2' | 'ISO' | 'WEB' | 'LINK'
  formatColor: string
  downloadUrl?: string
  externalUrl?: string
  images: {
    url: string
    caption?: string
  }[]
  youtubeId?: string
  youtubeTitle?: string
  blogUrl?: string
  blogTitle?: string
  blogImage?: string
  badge?: string
  note?: string
}

export interface ExternalResource {
  title: string
  description: string
  url: string
  icon: string
  color: string
  badge?: string
}

export const DOWNLOAD_ITEMS: DownloadItem[] = [
  // ================= 1. オリジナル曲関連データ =================
  {
    id: 'song-jinseitimec',
    title: '人生のタイムカプセル',
    subtitle: 'オフボーカル音源 ＆ 歌詞データ',
    category: 'music',
    categoryLabel: 'オリジナル曲データ',
    description:
      'ときえのきオリジナル楽曲「人生のタイムカプセル」のオフボーカル音源（カラオケ）と歌詞テキストファイルです。歌ってみた、BGM利用、二次創作等にご活用いただけます。',
    format: 'ZIP',
    formatColor: 'amber-darken-2',
    downloadUrl: 'https://enoki.xyz/customfiles/jinseitimec.zip',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/12/download-g10a15c0c8_640.png?fit=150%2C150&ssl=1',
        caption: '人生のタイムカプセル 配布パッケージ',
      },
    ],
    youtubeId: '1nR3UbWrTFE',
    youtubeTitle: '【オリジナル曲】人生のタイムカプセル',
  },
  {
    id: 'song-compiler',
    title: 'コンパイラ',
    subtitle: 'オフボーカル音源 ＆ 歌詞データ',
    category: 'music',
    categoryLabel: 'オリジナル曲データ',
    description:
      'ときえのきオリジナル楽曲「コンパイラ」のオフボーカル音源（カラオケ）と歌詞テキストファイルです。歌ってみた、BGM利用、二次創作等にご活用いただけます。',
    format: 'ZIP',
    formatColor: 'amber-darken-2',
    downloadUrl: 'https://enoki.xyz/customfiles/compiler_haihu.zip',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/12/download-g10a15c0c8_640.png?fit=150%2C150&ssl=1',
        caption: 'コンパイラ 配布パッケージ',
      },
    ],
    youtubeId: '_1KrfT5xOD4',
    youtubeTitle: '【オリジナル曲】コンパイラ',
  },

  // ================= 2. Linux OSイメージ =================
  {
    id: 'os-caramel',
    title: 'Caramel OS 1.0',
    subtitle: '美味しくて可愛いLinux OS',
    category: 'os',
    categoryLabel: 'Linux OSイメージ',
    description:
      'これまでにない過去最高の経験造りに貢献する最高のOS。Ubuntuに変わる新しい選択肢。公式ホームページからOSイメージや詳細ドキュメントをご覧いただけます。',
    format: 'WEB',
    formatColor: 'deep-purple-accent-3',
    externalUrl: 'https://caramelos.xyz',
    images: [
      {
        url: 'https://i0.wp.com/caramelos.xyz/wp-content/uploads/2020/04/0d0a9afc666678b2a5278fd1eaa7734c.jpg?w=3840&ssl=1',
        caption: 'Caramel OS 1.0 デスクトップ',
      },
    ],
    badge: '公式OS',
  },
  {
    id: 'os-upper-1804',
    title: 'Upper Linux 18.04',
    subtitle: 'Upper Linuxへようこそ',
    category: 'os',
    categoryLabel: 'Linux OSイメージ',
    description:
      'ときえのきが開発を手掛けたLinuxディストリビューションです。公式ポータルにて詳細仕様や各種リソースを案内しています。',
    format: 'WEB',
    formatColor: 'indigo-accent-3',
    externalUrl: 'https://caramelos.xyz/other/upper',
    images: [
      {
        url: 'https://i0.wp.com/caramelos.xyz/wp-content/uploads/2020/04/d01c48c33b0aadc7e165d3131848b24d.jpg?w=3840&ssl=1',
        caption: 'Upper Linux 18.04 概要',
      },
    ],
  },
  {
    id: 'os-upper-xfce',
    title: 'Upper Linux Xfce 18.04',
    subtitle: '軽量デスクトップ Xfce 採用モデル',
    category: 'os',
    categoryLabel: 'Linux OSイメージ',
    description:
      '.isoファイル、.md5ファイル、.sha256ファイルを配布しています。ダウンロードリンクは公式配布ページにあります。ダウンロードがうまくいかない場合はミラーリンクをご利用ください。',
    format: 'ISO',
    formatColor: 'cyan-darken-2',
    externalUrl: 'https://caramelos.xyz/download/',
    images: [
      {
        url: 'https://i0.wp.com/caramelos.xyz/wp-content/uploads/2020/04/0d0a9afc666678b2a5278fd1eaa7734c.jpg?w=3840&ssl=1',
        caption: 'Upper Linux Xfce 18.04',
      },
    ],
  },

  // ================= 3. 鉄道路線図 =================
  {
    id: 'rail-jr-east-mousou',
    title: 'JR東日本 妄想路線図',
    subtitle: 'JR東日本首都圏の路線図に勝手に脚色を加えたもの',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      'JR東日本首都圏の路線図に勝手な妄想・脚色を加えた夢の路線図です。Excelファイル（.xlsx）としてダウンロードできます。',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E5%A6%84%E6%83%B3%E8%B7%AF%E7%B7%9A%E5%9B%B3.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image.png?resize=1024%2C576&ssl=1',
        caption: 'JR東日本 妄想路線図 プレビュー',
      },
    ],
  },
  {
    id: 'rail-jr-east-futsu',
    title: 'JR東日本 絶対普通路線図',
    subtitle: '支線と快速を省いた普通列車重視路線図',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      'JR東日本首都圏の路線図から支線と快速を省き、純粋な各駅停車・普通列車の運行系統に焦点を当てた路線図です。',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E7%B5%B6%E5%AF%BE%E6%99%AE%E9%80%9A%E8%B7%AF%E7%B7%9A%E5%9B%B3.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-1.png?resize=1024%2C576&ssl=1',
        caption: '絶対普通路線図 プレビュー',
      },
    ],
  },
  {
    id: 'rail-jr-east-kaisoku',
    title: 'JR東日本 定期快速路線図',
    subtitle: '1時間に1本以上の快速運転エリアを抽出',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      'JR東日本首都圏の路線図から、1時間に1本以上の快速運転がある範囲のみを分かりやすく切り取った路線図です。',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E5%AE%9A%E6%9C%9F%E5%BF%AB%E9%80%9F%E8%B7%AF%E7%B7%9A%E5%9B%B3.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-2.png?resize=1024%2C576&ssl=1',
        caption: '定期快速路線図 プレビュー',
      },
    ],
  },
  {
    id: 'rail-jr-east-gourika',
    title: 'JR東日本 合理化された路線図',
    subtitle: '首都圏路線網をより合理的・機能的に再構成',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      'JR東日本首都圏の路線図をより合理的に再設計した路線図です。Excelファイル（.xlsx）でお届けします。',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E5%90%88%E7%90%86%E5%8C%96%E3%81%95%E3%82%8C%E3%81%9F%E8%B7%AF%E7%B7%9A%E5%9B%B3.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/12/download-g10a15c0c8_640.png?fit=150%2C150&ssl=1',
        caption: '合理化された路線図',
      },
    ],
  },
  {
    id: 'rail-japan-tyokutou',
    title: '東北本線・東海道本線・山陽本線 直通路線図',
    subtitle: '日本の主要路線はすべて直通（半分妄想）',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      '東海道本線が函南に停車！全駅の乗り換え案内付き。現在は青森から姫路まで完成しており、いつか博多まで延伸予定の壮大な直通路線図です。',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl:
      'https://enoki.xyz/customfiles/%E6%9D%B1%E5%8C%97%E6%9C%AC%E7%B7%9A%E3%83%BB%E6%9D%B1%E6%B5%B7%E9%81%93%E6%9C%AC%E7%B7%9A%E8%B7%AF%E7%B7%9A%E5%9B%B3.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/09/image-2.png?resize=1024%2C576&ssl=1',
        caption: '日本の主要路線はすべて直通',
      },
    ],
    badge: '長大直通',
  },
  {
    id: 'rail-kanto-express',
    title: '関東高速鉄道（妄想鉄道会社）',
    subtitle: '配線図・簡略路線図・種別一覧表 統合Excel',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      '配線図、簡略路線図、種別一覧表の3つを1つのExcelファイルにまとめた妄想鉄道データです。\n【運行範囲】大宮 - 赤羽 - 東京 - 品川 - 羽田 - 木更津 - 館山 - 安房鴨川',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E9%96%A2%E6%9D%B1%E9%AB%98%E9%80%9F%E9%89%84%E9%81%93.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-3.png?resize=1024%2C576&ssl=1',
        caption: '配線図',
      },
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-4.png?resize=1024%2C576&ssl=1',
        caption: '簡略路線図',
      },
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-5.png?resize=1024%2C576&ssl=1',
        caption: '種別一覧表',
      },
    ],
    note: '上記3つの図面は1つのExcelファイル内にシート別に収録されています。',
  },
  {
    id: 'rail-japan-third-excel',
    title: '日本第三鉄道（妄想鉄道会社）Excelファイル',
    subtitle: '環七線・東房総線・空港線・茂原線 路線図',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      '首都圏環状線と房総連絡を網羅する妄想私鉄の路線データです。\n【範囲】\n・環七線: 安房鴨川-安房笹川-木更津-小島新田-鶴見-成城学園前-武蔵境-光ヶ丘-赤羽-北千住-新小岩-西葛西-東京テレポート-品川\n・東房総線: 木更津-上総村上-ちはら台-誉田-八街-成田-印旛日本医大-勝田台-稲毛-磯辺\n・空港線: 茂原-誉田-八街-成田空港-旭新町-銚子-若松中央-鹿島神宮\n・茂原線: 木更津-横田-上総牛久-茂原-九十九里-干潟',
    format: 'XLSX',
    formatColor: 'teal-darken-1',
    downloadUrl: 'https://enoki.xyz/customfiles/%E6%97%A5%E6%9C%AC%E7%AC%AC%E4%B8%89%E9%89%84%E9%81%93.xlsx',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/09/image-1.png?resize=1024%2C576&ssl=1',
        caption: '環七線 路線図',
      },
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/09/image.png?resize=1024%2C576&ssl=1',
        caption: '東房総線 路線図',
      },
    ],
    note: '2路線および支線網が1つのExcelファイルにまとめられています。',
  },
  {
    id: 'rail-japan-third-oudia',
    title: '日本第三鉄道 OuDiaSecondファイル',
    subtitle: '羽田空港大宮線 ダイヤ・時刻表データ（未完成）',
    category: 'railway',
    categoryLabel: '鉄道路線図',
    description:
      '細かい種別設定、時刻表、運行ダイヤ、駅の配線情報が記録されたOuDiaSecond用ファイルです（制作途中の未完成データ）。',
    format: 'OUD2',
    formatColor: 'orange-darken-3',
    downloadUrl: 'https://enoki.xyz/customfiles/%E7%BE%BD%E7%94%B0%E7%A9%BA%E6%B8%AF%E5%A4%A7%E5%AE%AE%E7%B7%9A.oud2',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/05/image-6.png?resize=1024%2C576&ssl=1',
        caption: '羽田空港大宮線 ダイヤプレビュー',
      },
    ],
    note: 'ダイヤグラム描画ソフト「OuDiaSecond」等で開くことができます。',
  },

  // ================= 4. 電光掲示板関連 =================
  {
    id: 'led-vision-e233',
    title: 'LEDVISION用ファイル（JR東日本E233系風）',
    subtitle: '内房線、宇都宮線、常磐線、羽田空港線など',
    category: 'led',
    categoryLabel: '電光掲示板関連',
    description:
      '電光掲示板を制御するソフト「LEDVISION」用の行先表示・運行案内データです。JR東日本E233系風のリアルなドットアニメーションを再現しています。',
    format: 'ZIP',
    formatColor: 'amber-darken-2',
    downloadUrl: 'https://enoki.xyz/customfiles/train_led_iroiro.zip',
    images: [
      {
        url: 'https://i0.wp.com/enoki.xyz/wp-content/uploads/2021/12/download-g10a15c0c8_640.png?fit=150%2C150&ssl=1',
        caption: 'LEDVISION設定ファイル パッケージ',
      },
    ],
    blogUrl: 'https://blog.caramelos.xyz/electro/denko_tsukuru/',
    blogTitle: '【電子工作】暇だし電光掲示板・行先表示器でも作るか(´・ω・｀)【E233系】',
    blogImage:
      'https://i0.wp.com/blog.caramelos.xyz/wp-content/uploads/2021/06/title-8.jpg?w=3840&ssl=1',
    youtubeId: 'Q3VU0a8KBfk',
    youtubeTitle: '宇都宮線 新快速 黒磯行き（LED表示再現）',
    note: 'LEDマトリクスのサイズが 32×128 以外の場合、正しく表示されない場合があります。',
    badge: '電子工作',
  },
]

export const EXTERNAL_RESOURCES: ExternalResource[] = [
  {
    title: 'GitHub リポジトリ',
    description:
      'ときえのき自作ゲーム、オープンソースソフトウェア、Webアプリ等のソースコード・バイナリを公開しています。',
    url: 'https://enoki.xyz/github',
    icon: 'mdi-github',
    color: '#24292e',
    badge: 'オープンソース',
  },
  {
    title: 'Caramel OS 配布ポータル',
    description:
      'Caramel OSの最新版以外のisoイメージ、最新版含むmd5チェックサム・sha256ハッシュを公式ポータルで配布しています。',
    url: 'https://caramelos.xyz/download',
    icon: 'mdi-linux',
    color: '#d97706',
    badge: 'OSイメージ',
  },
  {
    title: 'Fascode Network',
    description:
      'Fascode Networkが共同管理・ホスティングしている各種ソフトウェアやツールをダウンロードできます。',
    url: 'https://fascode.net',
    icon: 'mdi-lan',
    color: '#0284c7',
    badge: '連携開発',
  },
  {
    title: '山d.com (ミラー/CDN)',
    description:
      '一部ファイルやFascode関連プロダクトの高速ダウンロードミラーサーバーです。',
    url: 'https://山d.com',
    icon: 'mdi-server-network',
    color: '#059669',
    badge: 'ミラー',
  },
  {
    title: 'Google Drive 公開フォルダ',
    description:
      '未公表のソフトウェア、制作物アーカイブ、テストバージョンなどを限定・先行公開している場合があります。',
    url: 'https://drive.google.com/open?id=1aMcH6R5XcJ9vjB5BQ_psJAsHMUJ74Mk9',
    icon: 'mdi-google-drive',
    color: '#4285F4',
    badge: 'アーカイブ',
  },
]
