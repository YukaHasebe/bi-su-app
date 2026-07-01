import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The swallow silhouette path (公式ランクアイコンのモチーフを簡略化した線画).
/// Copied verbatim from scenes.js `SWALLOW_PATH`.
const String kSwallowPath =
    'M8 14 C22 6 36 14 44 26 C47 22 52 21 56 25 '
    'C66 14 82 8 96 10 C84 16 74 22 66 32 '
    'C62 37 59 44 57 52 C55 60 52 66 47 70 '
    'C48 62 48 54 46 47 C42 50 36 52 30 52 '
    'C36 47 40 42 41 36 C30 36 16 28 8 14 Z';

/// Builds the swallow emblem SVG string in [color] at [opacity].
///
/// Mirrors scenes.js `swallowSVG(color, opacity)`. [color] is rendered as a
/// `#RRGGBB` fill; the SVG `viewBox` is `0 0 100 80`.
String swallowSvg({required Color color, double opacity = 1}) {
  final String hex = _hex(color);
  return '<svg viewBox="0 0 100 80" xmlns="http://www.w3.org/2000/svg">'
      '<path d="$kSwallowPath" fill="$hex" opacity="$opacity"/></svg>';
}

/// Renders the swallow emblem via [flutter_svg].
///
/// The fill color is baked into the SVG string by [swallowSvg], so this is a
/// thin [SvgPicture.string] wrapper that preserves the 100×80 aspect ratio.
class SwallowEmblem extends StatelessWidget {
  const SwallowEmblem({
    super.key,
    required this.color,
    this.opacity = 1,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  });

  /// Fill color of the swallow.
  final Color color;

  /// Fill opacity (0–1).
  final double opacity;

  /// Square size shortcut. If set, used for both [width] and [height] unless
  /// those are given explicitly.
  final double? size;

  /// Explicit width (overrides [size]).
  final double? width;

  /// Explicit height (overrides [size]).
  final double? height;

  /// How to inscribe the 100×80 picture into its box.
  final BoxFit fit;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      swallowSvg(color: color, opacity: opacity),
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      semanticsLabel: semanticLabel,
    );
  }
}

String _hex(Color c) {
  final int r = (c.r * 255.0).round() & 0xff;
  final int g = (c.g * 255.0).round() & 0xff;
  final int b = (c.b * 255.0).round() & 0xff;
  String two(int v) => v.toRadixString(16).padLeft(2, '0');
  return '#${two(r)}${two(g)}${two(b)}';
}
