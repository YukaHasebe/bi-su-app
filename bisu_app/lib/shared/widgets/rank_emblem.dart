import 'package:flutter/widgets.dart';

import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/shared/swallow_svg.dart';

/// The swallow rank emblem, tinted with the rank's color.
///
/// Wraps [SwallowEmblem] (which bakes the fill into the SVG string). The
/// emblem's intrinsic aspect ratio is 100:80, matching the mockup where it is
/// drawn at e.g. `30×24` (`.club-tier-head svg`) or `30×24` (`.qr-rankline svg`).
/// [size] is the WIDTH; height is derived as `size * 0.8` to preserve aspect.
///
/// Flat 2D only — the mockup's optional Three.js 3D emblem is intentionally
/// not reproduced (3D not required).
class RankEmblem extends StatelessWidget {
  const RankEmblem({
    super.key,
    required this.rank,
    this.size = 40,
    this.opacity = 1,
  });

  /// The rank whose [Rank.color] tints the emblem.
  final Rank rank;

  /// Emblem width in logical pixels (height = `size * 0.8`).
  final double size;

  /// Fill opacity (0–1).
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SwallowEmblem(
      color: rank.color,
      opacity: opacity,
      width: size,
      height: size * 0.8,
      semanticLabel: '${rank.en} emblem',
    );
  }
}
