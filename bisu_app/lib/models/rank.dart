import 'package:flutter/painting.dart' show Color;

import 'package:bisu_app/shared/format.dart';

/// Stable rank identifiers (lowercase), in ascending order.
/// Mirrors app.js `RANK_ORDER`.
enum RankId { member, silver, gold, platinum, diamond }

/// A membership rank tier (mirrors a single entry of app.js `RANKS`).
///
/// Pure value type. Per-rank computations (points/progress) live here as
/// methods so screens never re-derive them.
class Rank {
  const Rank({
    required this.id,
    required this.en,
    required this.jp,
    required this.rate,
    required this.color,
    required this.soft,
    required this.threshold,
    required this.nextId,
    required this.annual,
    required this.place,
    required this.video,
    this.videoStart,
    this.videoEnd,
  });

  /// Stable id (also the map key in [Ranks.byId]).
  final RankId id;

  /// Uppercase English name, e.g. `MEMBER` (serif EN label).
  final String en;

  /// Japanese status name, e.g. `一般会員`.
  final String jp;

  /// Point earn rate: `100円 = {rate}pt`.
  final int rate;

  /// Primary rank color (`RANKS[*].color`).
  final Color color;

  /// Soft tint of the rank color (`RANKS[*].soft`).
  final Color soft;

  /// Annual-spend threshold to *be* this rank.
  final int threshold;

  /// The next rank up, or null if this is the top tier (diamond).
  final RankId? nextId;

  /// Demo "current annual spend" used for Home progress.
  final int annual;

  /// Journey caption, e.g. `BORNEO ISLAND — ボルネオ島上空`.
  final String place;

  /// Asset path of the boot journey video (under `assets/videos/`).
  final String video;

  /// Optional start time (seconds) to seek the journey video to.
  final double? videoStart;

  /// Optional end time (seconds) to stop the journey video at.
  final double? videoEnd;

  /// Points balance shown on Home: `round(annual / 100 * rate)`.
  int get points => (annual / 100 * rate).round();

  /// The resolved next [Rank], or null for the top tier.
  Rank? get nextRank => nextId == null ? null : Ranks.byId[nextId!];

  /// Whether this is the top tier (no next rank).
  bool get isTop => nextId == null;

  /// Progress bar fill percent (0–100) toward the next tier.
  ///
  /// Mirrors renderHome: for non-top ranks
  /// `clamp(round((annual - threshold) / (next.threshold - threshold) * 100), 4, 100)`.
  /// Top tier is always 100.
  int get progressPct {
    final Rank? nx = nextRank;
    if (nx == null) return 100;
    final int span = nx.threshold - threshold;
    if (span <= 0) return 100;
    final int raw = ((annual - threshold) / span * 100).round();
    return raw.clamp(4, 100);
  }

  /// The label under the progress bar.
  ///
  /// Non-top: `翌年 {next.en} まであと ¥{(next.threshold - annual)}`.
  /// Top:     `最上位ステータスのお客様です。いつもありがとうございます。`.
  String get progressLabel {
    final Rank? nx = nextRank;
    if (nx == null) {
      return '最上位ステータスのお客様です。いつもありがとうございます。';
    }
    return '翌年 ${nx.en} まであと ${yen(nx.threshold - annual)}';
  }

  /// Plain remaining-yen amount to the next tier (already formatted), or null
  /// at the top tier. Convenience for screens that bold the figure separately.
  String? get amountToNextRank {
    final Rank? nx = nextRank;
    if (nx == null) return null;
    return yen(nx.threshold - annual);
  }
}

/// The authoritative immutable rank catalog (mirrors app.js `RANKS`).
class Ranks {
  const Ranks._();

  /// All ranks keyed by id.
  static const Map<RankId, Rank> byId = <RankId, Rank>{
    RankId.member: Rank(
      id: RankId.member,
      en: 'MEMBER',
      jp: '一般会員',
      rate: 1,
      color: Color(0xFFC2A878),
      soft: Color(0xFFEBDFC8),
      threshold: 0,
      nextId: RankId.silver,
      annual: 138400,
      place: 'BORNEO ISLAND — ボルネオ島上空',
      video: 'assets/videos/journey-member.mp4',
      videoEnd: 3.05,
    ),
    RankId.silver: Rank(
      id: RankId.silver,
      en: 'SILVER',
      jp: 'シルバーステータス',
      rate: 2,
      color: Color(0xFF97A4AF),
      soft: Color(0xFFDCE3E8),
      threshold: 300000,
      nextId: RankId.gold,
      annual: 386200,
      place: 'RAINFOREST — 熱帯雨林の奥へ',
      video: 'assets/videos/journey-silver.mp4',
    ),
    RankId.gold: Rank(
      id: RankId.gold,
      en: 'GOLD',
      jp: 'ゴールドステータス',
      rate: 3,
      color: Color(0xFFC3A050),
      soft: Color(0xFFEBD9A8),
      threshold: 500000,
      nextId: RankId.platinum,
      annual: 712800,
      place: 'CAVE GATE — 洞窟の入り口',
      video: 'assets/videos/journey-gold.mp4',
      videoEnd: 2.8,
    ),
    RankId.platinum: Rank(
      id: RankId.platinum,
      en: 'PLATINUM',
      jp: 'プラチナステータス',
      rate: 5,
      color: Color(0xFF4E94B0),
      soft: Color(0xFFC2E0EC),
      threshold: 1000000,
      nextId: RankId.diamond,
      annual: 1386000,
      place: 'INSIDE THE CAVE — アナツバメの聖域',
      video: 'assets/videos/journey-platinum.mp4',
      videoStart: 6,
    ),
    RankId.diamond: Rank(
      id: RankId.diamond,
      en: 'DIAMOND',
      jp: 'ダイヤモンドステータス',
      rate: 10,
      color: Color(0xFFB23B52),
      soft: Color(0xFFEFC2CC),
      threshold: 2000000,
      nextId: null,
      annual: 2468000,
      place: 'THE NEST — 神秘の巣',
      video: 'assets/videos/journey-diamond.mp4',
    ),
  };

  /// All ranks in ascending order (member → diamond).
  /// Mirrors app.js `RANK_ORDER`.
  static const List<RankId> order = <RankId>[
    RankId.member,
    RankId.silver,
    RankId.gold,
    RankId.platinum,
    RankId.diamond,
  ];

  /// All ranks as a list, in [order].
  static List<Rank> get all =>
      order.map((RankId id) => byId[id]!).toList(growable: false);

  /// Lookup helper.
  static Rank of(RankId id) => byId[id]!;
}
