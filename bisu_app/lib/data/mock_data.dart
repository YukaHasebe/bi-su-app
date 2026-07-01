import 'package:bisu_app/models/member.dart';
import 'package:bisu_app/models/order.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/models/store.dart';
import 'package:bisu_app/models/subscription.dart';

/// All demo data is a faithful copy of app.js (lines ~8–139, 1064–1072).
/// Displayed member info / orders / distances are dummy values.
///
/// Asset note: app.js referenced flat paths like `assets/p_jelly.jpg`; the
/// binaries were copied under `assets/images/`, so every path here is
/// `assets/images/<name>` (images) or `assets/videos/<name>` (videos).

/// 会員プロフィール（ダミー）.
const Member kMember = Member(
  name: '長谷部 由香',
  initials: 'YH',
  no: 'BS-00124857',
  mail: 'y.hasebe@example.com',
  since: '2023年4月',
);

/// 店舗ポイント（アプリ独自・来店/店頭購入で付与・ダミー）.
const StorePoints kStorePoints = StorePoints(
  balance: 480,
  guestBalance: 120,
  tempNo: 'TEMP-7F3A-9C21',
);

/// 定期情報（ダミー）.
const List<Subscription> kSubscriptions = <Subscription>[
  Subscription(
    name: 'BI-SUエキスゼリースティック',
    img: 'assets/images/p_jelly.jpg',
    status: SubscriptionStatus.active,
    next: '2026/06/24（水）',
    cycle: '30日ごと',
    qty: 1,
    price: 16200,
  ),
  Subscription(
    name: 'BI-SUサプリメント W-500',
    img: 'assets/images/p_w500.jpg',
    status: SubscriptionStatus.active,
    next: '2026/07/02（木）',
    cycle: '30日ごと',
    qty: 1,
    price: 35640,
  ),
  Subscription(
    name: 'BI-SU酵素スティック',
    img: 'assets/images/p_enzyme.jpg',
    status: SubscriptionStatus.cancelled,
    last: '2026/03/15',
    cycle: '30日ごと',
    qty: 1,
    price: 17820,
  ),
];

/// 購入履歴（ダミー）.
const List<Order> kOrders = <Order>[
  Order(
    date: '2026/06/02',
    no: 'BS-260602-0412',
    channel: OrderChannel.online,
    kind: OrderKind.subscription,
    name: 'BI-SUエキスゼリースティック',
    img: 'assets/images/p_jelly.jpg',
    qty: 1,
    price: 16200,
  ),
  Order(
    date: '2026/05/28',
    no: 'BS-260528-1187',
    channel: OrderChannel.store,
    channelSub: 'BI-SU GINZA SIX',
    kind: OrderKind.normal,
    name: 'BI-SUフェイスクリーム フローラル 40g',
    img: 'assets/images/p_facecream.jpg',
    qty: 1,
    price: 25300,
  ),
  Order(
    date: '2026/05/19',
    no: 'BS-260519-0233',
    channel: OrderChannel.online,
    kind: OrderKind.normal,
    name: 'BI-SUキャンディー（30個入り）',
    img: 'assets/images/p_candy.jpg',
    qty: 2,
    price: 8100,
  ),
  Order(
    date: '2026/05/03',
    no: 'BS-260503-0871',
    channel: OrderChannel.online,
    kind: OrderKind.subscription,
    name: 'BI-SUサプリメント W-500',
    img: 'assets/images/p_w500.jpg',
    qty: 1,
    price: 35640,
  ),
  Order(
    date: '2026/04/26',
    no: 'BS-260426-0099',
    channel: OrderChannel.store,
    channelSub: '美巣 京都祇園店',
    kind: OrderKind.normal,
    name: 'BI-SUシャンプー',
    img: 'assets/images/p_shampoo.jpg',
    qty: 1,
    price: 7700,
  ),
  Order(
    date: '2026/04/11',
    no: 'BS-260411-0510',
    channel: OrderChannel.online,
    kind: OrderKind.normal,
    name: 'BI-SUフェイスマスク Type-R（4枚入り）',
    img: 'assets/images/p_mask.jpg',
    qty: 1,
    price: 6600,
  ),
  Order(
    date: '2026/03/30',
    no: 'BS-260330-0786',
    channel: OrderChannel.online,
    kind: OrderKind.subscription,
    name: 'BI-SUエキスドリンク E-3000',
    img: 'assets/images/p_e3000.jpg',
    qty: 1,
    price: 13500,
  ),
];

/// ストアーズ（公式サイト掲載店舗）.
const List<Store> kStores = <Store>[
  Store(
    id: 'gsix',
    name: 'BI-SU GINZA SIX',
    en: 'GINZA SIX — TOKYO',
    type: StoreType.direct,
    img: 'assets/images/s_gsix.jpg',
    dist: '1.8km',
    city: 'tokyo',
    addr: '東京都中央区銀座6-10-1 GINZA SIX B1F',
    hours: '10:30〜20:30',
    closed: '元日および施設休館日',
    tel: '03-6824-4117',
    access: <String>[
      '東京メトロ「銀座駅」A3出口より徒歩2分',
      '東急プラザ銀座方面 地下通路からもアクセス可',
    ],
    desc:
        'ボルネオの洞窟が持つ生命の神秘を、銀座の地へ。無垢な光を放つ「巣」のオブジェが彩る空間で、インナーケアのテイスティングと、スキンケアの全ラインをお試しいただけます。',
    planNote: 'GINZA SIX B1F・北側エスカレーター付近（簡略図）',
  ),
  Store(
    id: 'salone',
    name: 'BI-SU ISETAN SALONE',
    en: 'TOKYO MIDTOWN',
    type: StoreType.direct,
    img: 'assets/images/s_salone.jpg',
    dist: '4.2km',
    city: 'tokyo',
    addr: '東京都港区赤坂9-7-4 東京ミッドタウン ガレリア2F',
    hours: '11:00〜20:00',
    closed: '施設休館日に準ずる',
    tel: '03-4400-3827',
    access: <String>[
      '都営大江戸線「六本木駅」8番出口より直結',
      '東京メトロ日比谷線「六本木駅」より地下通路直結',
    ],
    desc:
        'ツバメの巣のコンシェルジュ拠点。おひとりおひとりの美しさと向き合い、最適なケアをご提案するプレミアムなサロン体験をご用意しています。',
    planNote: '東京ミッドタウン ガレリア2F（簡略図）',
  ),
  Store(
    id: 'isetan',
    name: 'イセタン ビューティー アポセカリー',
    en: 'ISETAN SHINJUKU',
    type: StoreType.reseller,
    img: 'assets/images/s_isetan.jpg',
    dist: '6.1km',
    city: 'tokyo',
    addr: '東京都新宿区新宿3-14-1 伊勢丹新宿店 本館B2F',
    hours: '10:00〜20:00',
    closed: '伊勢丹新宿店に準ずる',
    tel: null,
    access: <String>['東京メトロ「新宿三丁目駅」直結'],
    desc:
        '伊勢丹新宿店 本館B2F「ビューティーアポセカリー」内の常設ショップ。百貨店のお買い物とあわせて、BI-SUのアイテムをお手に取りいただけます。',
    planNote: '伊勢丹新宿店 本館B2F（簡略図）',
  ),
  Store(
    id: 'gion',
    name: '美巣 京都祇園店',
    en: 'KYOTO GION',
    type: StoreType.direct,
    img: 'assets/images/s_gion.jpg',
    dist: '368km',
    city: 'kyoto',
    addr: '京都府京都市東山区祇園町南側570-118',
    hours: '11:00〜19:00',
    closed: '水曜日',
    tel: null,
    access: <String>[
      '京阪本線「祇園四条駅」より徒歩5分',
      '阪急京都線「京都河原町駅」より徒歩8分',
    ],
    desc:
        '京都・祇園の町家に佇む路面店。のれんをくぐると、自然の神秘である天然アナツバメの巣の世界を、五感で体験いただけます。',
    planNote: '祇園町南側・花見小路通近く（簡略図）',
  ),
  Store(
    id: 'popup',
    name: 'ジェイアール京都伊勢丹 POP UP',
    en: 'KYOTO STATION',
    type: StoreType.popup,
    img: null,
    dist: '366km',
    city: 'kyoto',
    addr: '京都府京都市下京区烏丸通塩小路下ル東塩小路町',
    hours: '10:00〜20:00',
    closed: '期間中無休',
    tel: null,
    period: '2026.6.17（水）〜 6.23（火）',
    access: <String>['JR「京都駅」直結'],
    desc:
        'ジェイアール京都伊勢丹にて、期間限定のポップアップショップを開催します。この機会にぜひお立ち寄りください。',
  ),
];

/// CLUB MEMBERS PROGRAM (SCR-102) per-rank benefit text.
/// Mirrors app.js `clubBenefits(id)`.
String clubBenefits(RankId id) {
  switch (id) {
    case RankId.member:
      return 'バースデーギフト 100pt';
    case RankId.silver:
      return 'バースデーギフト';
    case RankId.gold:
    case RankId.platinum:
    case RankId.diamond:
      return 'バースデーギフト / シーズナルギフト / イベントご招待';
  }
}
