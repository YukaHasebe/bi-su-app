import 'package:flutter/widgets.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// BI-SU type system (mirrors `--serif` / `--sans` in styles.css).
///
/// No font binaries are bundled — we rely on platform fonts via
/// [fontFamilyFallback]. The first available family on the device wins.
class BisuType {
  const BisuType._();

  /// Serif stack: headings, rank names, EN labels.
  /// `"Hiragino Mincho ProN","Yu Mincho","Noto Serif JP",...,serif`.
  static const List<String> serifFallback = <String>[
    'Hiragino Mincho ProN',
    'Yu Mincho',
    'YuMincho',
    'Noto Serif JP',
    'Times New Roman',
    'serif',
  ];

  /// Sans stack: body, captions, UI labels.
  /// `"Hiragino Kaku Gothic ProN","Yu Gothic","Noto Sans JP",...,sans-serif`.
  static const List<String> sansFallback = <String>[
    'Hiragino Kaku Gothic ProN',
    'Yu Gothic Medium',
    'YuGothic',
    'Noto Sans JP',
    'Segoe UI',
    'sans-serif',
  ];

  // ---------------------------------------------------------------------------
  // SERIF — display / heading / EN label
  // ---------------------------------------------------------------------------

  /// Large serif display (e.g. rank EN on Home). ~30px.
  static const TextStyle display = TextStyle(
    fontFamilyFallback: serifFallback,
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.04,
    color: BisuColors.ink,
  );

  /// Section heading serif. ~20px.
  static const TextStyle heading = TextStyle(
    fontFamilyFallback: serifFallback,
    fontSize: 20,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.02,
    color: BisuColors.ink,
  );

  /// Smaller serif title (card titles, rank JP). ~15px.
  static const TextStyle title = TextStyle(
    fontFamilyFallback: serifFallback,
    fontSize: 15,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: BisuColors.ink,
  );

  /// Spaced EN micro-label in serif (gold), e.g. eyebrow / page header EN.
  /// Mirrors letter-spacing: ~.26em used by `.club-tier-en` etc.
  static const TextStyle enLabel = TextStyle(
    fontFamilyFallback: serifFallback,
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.4,
    color: BisuColors.goldDeep,
  );

  // ---------------------------------------------------------------------------
  // SANS — body / caption
  // ---------------------------------------------------------------------------

  /// Default body text. ~13.5px.
  static const TextStyle body = TextStyle(
    fontFamilyFallback: sansFallback,
    fontSize: 13.5,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: BisuColors.ink,
  );

  /// Emphasized body (values, names). ~13.5px, semibold.
  static const TextStyle bodyStrong = TextStyle(
    fontFamilyFallback: sansFallback,
    fontSize: 13.5,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: BisuColors.ink,
  );

  /// Caption / faint label. ~10px.
  static const TextStyle caption = TextStyle(
    fontFamilyFallback: sansFallback,
    fontSize: 10,
    height: 1.4,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.6,
    color: BisuColors.inkFaint,
  );

  /// Tab bar / button label sans. ~10px, bold, spaced.
  static const TextStyle label = TextStyle(
    fontFamilyFallback: sansFallback,
    fontSize: 10,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: BisuColors.inkSoft,
  );
}
