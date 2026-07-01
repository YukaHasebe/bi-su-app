import 'package:flutter/widgets.dart';

import 'package:bisu_app/models/rank.dart';

/// A rank's two-tone color pair (mirrors RANKS[*].color / .soft in app.js).
class RankColors {
  const RankColors({required this.color, required this.soft});

  /// Primary rank color (`--rank`).
  final Color color;

  /// Soft tint of the rank color (`--rank-soft`).
  final Color soft;
}

/// Per-rank champagne/jewel palette, keyed by [RankId].
///
/// Values copied verbatim from app.js RANKS.
class RankPalette {
  const RankPalette._();

  static const Map<RankId, RankColors> _byId = <RankId, RankColors>{
    RankId.member: RankColors(color: Color(0xFFC2A878), soft: Color(0xFFEBDFC8)),
    RankId.silver: RankColors(color: Color(0xFF97A4AF), soft: Color(0xFFDCE3E8)),
    RankId.gold: RankColors(color: Color(0xFFC3A050), soft: Color(0xFFEBD9A8)),
    RankId.platinum:
        RankColors(color: Color(0xFF4E94B0), soft: Color(0xFFC2E0EC)),
    RankId.diamond:
        RankColors(color: Color(0xFFB23B52), soft: Color(0xFFEFC2CC)),
  };

  /// Returns the [RankColors] for [id].
  static RankColors of(RankId id) => _byId[id]!;

  /// Primary color for [id].
  static Color color(RankId id) => _byId[id]!.color;

  /// Soft tint for [id].
  static Color soft(RankId id) => _byId[id]!.soft;
}
