import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// Visual variants of [BisuChip] (mirrors `.chip-gold` / `.chip-line` /
/// `.chip-gray` in styles.css).
enum BisuChipStyle {
  /// `.chip-gold` — gold text on a champagne fill (e.g. 注文継続中 / 定期購入).
  gold,

  /// `.chip-line` — soft-ink text on white with a hairline border (e.g.
  /// 通常購入 / ネット注文 / store name).
  line,

  /// `.chip-gray` — muted text on a grey fill (e.g. 解約済み).
  gray,
}

/// A small pill label (mirrors `.chip` in styles.css).
///
/// ```css
/// .chip{
///   display:inline-flex; align-items:center; gap:4px;
///   font-size:9.5px; font-weight:700; letter-spacing:.08em;
///   border-radius:999px; padding:3.5px 9px; white-space:nowrap;
/// }
/// .chip-dot::before{ width:5px; height:5px; border-radius:99px; background:currentColor; }
/// ```
class BisuChip extends StatelessWidget {
  const BisuChip({
    super.key,
    required this.label,
    this.style = BisuChipStyle.line,
    this.dot = false,
  });

  /// The chip text.
  final String label;

  /// Color variant.
  final BisuChipStyle style;

  /// Whether to show the leading `.chip-dot` (5px dot in the text color).
  final bool dot;

  // ---- per-variant tokens (verbatim from styles.css) ----
  Color get _fg {
    switch (style) {
      case BisuChipStyle.gold:
        return BisuColors.goldDeep; // #8A6E42
      case BisuChipStyle.line:
        return BisuColors.inkSoft; // #6F6757
      case BisuChipStyle.gray:
        return const Color(0xFF8B857A);
    }
  }

  Color get _bg {
    switch (style) {
      case BisuChipStyle.gold:
        return const Color(0xFFF1E8D4);
      case BisuChipStyle.line:
        return BisuColors.white; // #FFF
      case BisuChipStyle.gray:
        return const Color(0xFFEEEBE3);
    }
  }

  Color get _border {
    switch (style) {
      case BisuChipStyle.gold:
        return const Color(0xFFE0D2B2);
      case BisuChipStyle.line:
        return BisuColors.hair; // #E3DCCE
      case BisuChipStyle.gray:
        return const Color(0xFFE0DBD0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fg = _fg;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (dot) ...<Widget>[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: fg,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.clip,
              softWrap: false,
              style: TextStyle(
                fontFamilyFallback: const <String>[
                  'Hiragino Kaku Gothic ProN',
                  'Yu Gothic Medium',
                  'YuGothic',
                  'Noto Sans JP',
                  'Segoe UI',
                  'sans-serif',
                ],
                fontSize: 9.5,
                height: 1.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.76, // ~.08em of 9.5px
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
