import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A rounded progress bar (mirrors `.gp-bar` + `.gp-bar i` in styles.css).
///
/// ```css
/// .gp-bar{ height:4px; border-radius:99px; background:rgba(255,255,255,.18); overflow:hidden; }
/// .gp-bar i{ height:100%; border-radius:99px;
///   background:linear-gradient(90deg, var(--rank-soft), var(--rank));
///   box-shadow:0 0 12px var(--rank); }
/// ```
///
/// On Home the fill is the rank gradient (soft → rank). Callers pass the
/// concrete [fillColor] (typically the active `rank.color`); when both a fill
/// and [fillSoft] are given the bar renders the soft→strong gradient and the
/// glow. The track defaults to [BisuColors.hair] (light screens); on the night
/// Home screen pass `trackColor: const Color(0x2EFFFFFF)` for `rgba(255,255,255,.18)`.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.percent,
    this.fillColor,
    this.fillSoft,
    this.trackColor = BisuColors.hair,
    this.height = 6,
    this.glow = false,
  });

  /// Fill amount, 0–100. Values outside the range are clamped.
  final int percent;

  /// Strong end of the fill gradient. Null = [BisuColors.goldDeep].
  final Color? fillColor;

  /// Soft start of the fill gradient. Null = a lightened [fillColor].
  final Color? fillSoft;

  /// Track (background) color.
  final Color trackColor;

  /// Bar thickness. CSS is 4px on Home; contract default is 6.
  final double height;

  /// Whether to render the rank glow (`box-shadow:0 0 12px var(--rank)`).
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final double frac = (percent.clamp(0, 100)) / 100.0;
    final Color strong = fillColor ?? BisuColors.goldDeep;
    final Color soft = fillSoft ?? Color.lerp(strong, BisuColors.white, 0.45)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: frac,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[soft, strong],
                  ),
                  boxShadow: glow
                      ? <BoxShadow>[
                          BoxShadow(color: strong, blurRadius: 12),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
