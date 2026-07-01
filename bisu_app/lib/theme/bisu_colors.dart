import 'package:flutter/widgets.dart';

/// BI-SU design tokens (mirrors styles.css `:root`).
///
/// Warm ivory × champagne gold. Do NOT introduce MIRANEST's grey palette.
class BisuColors {
  const BisuColors._();

  // ---- Surfaces ----
  /// `--ivory` #F4F1EA — app background.
  static const Color ivory = Color(0xFFF4F1EA);

  /// `--paper` #FBFAF6 — cards / raised surfaces.
  static const Color paper = Color(0xFFFBFAF6);

  // ---- Text / ink ----
  /// `--ink` #2A2620 — primary text.
  static const Color ink = Color(0xFF2A2620);

  /// `--ink-soft` #6F6757 — secondary text.
  static const Color inkSoft = Color(0xFF6F6757);

  /// `--ink-faint` #A39A88 — tertiary / caption text.
  static const Color inkFaint = Color(0xFFA39A88);

  /// `--hair` #E3DCCE — hairline borders / dividers.
  static const Color hair = Color(0xFFE3DCCE);

  // ---- Gold ----
  /// `--gold` #A8895A — accent / EN labels.
  static const Color gold = Color(0xFFA8895A);

  /// `--gold-deep` #8A6E42 — strong accent / active tab.
  static const Color goldDeep = Color(0xFF8A6E42);

  /// `--gold-pale` #D9C8A8 — soft accent fill.
  static const Color goldPale = Color(0xFFD9C8A8);

  // ---- Night ----
  /// `--night` #10100E — splash / home journey background.
  static const Color night = Color(0xFF10100E);

  // ---- Misc helpers ----
  /// Pure white used by chips / card insets in the mockup.
  static const Color white = Color(0xFFFFFFFF);
}

/// Shared layout constants (mirrors styles.css `:root` + reference frame).
class BisuMetrics {
  const BisuMetrics._();

  /// `--tabbar-h` 62px.
  static const double tabBarHeight = 62;

  /// `--status-h` 44px.
  static const double statusBarHeight = 44;

  /// Reference design frame width.
  static const double frameWidth = 390;

  /// Reference design frame height.
  static const double frameHeight = 844;
}
