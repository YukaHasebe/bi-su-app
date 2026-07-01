import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// Visual variants of [BisuButton].
enum BisuButtonVariant {
  /// `.auth-btn` / `.ln-btn` — gold-gradient pill, white text.
  primary,

  /// `.sd-cta` — outlined pill, gold-deep text on transparent.
  outline,

  /// `.auth-link` — borderless underlined gold-deep text link.
  text,
}

/// The primary call-to-action button (mirrors `.auth-btn` / `.sd-cta` /
/// `.auth-link` in styles.css).
///
/// ```css
/// .auth-btn{ padding:15px 0; font-size:13px; font-weight:700; letter-spacing:.2em;
///   color:#FFF; border-radius:999px;
///   background:linear-gradient(120deg, var(--gold-deep), var(--gold)); }
/// .auth-btn:disabled{ opacity:.4; }
/// .sd-cta{ font-size:12px; font-weight:700; letter-spacing:.22em; color:var(--gold-deep);
///   border:1px solid var(--gold); border-radius:999px; padding:14px 0; background:transparent; }
/// ```
///
/// A null [onPressed] renders the disabled state (CSS `:disabled{opacity:.4}`).
class BisuButton extends StatelessWidget {
  const BisuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BisuButtonVariant.primary,
    this.fullWidth = true,
    this.icon,
  });

  /// Button text.
  final String label;

  /// Tap handler. Null = disabled.
  final VoidCallback? onPressed;

  /// Color/shape variant.
  final BisuButtonVariant variant;

  /// Whether the button stretches to fill its parent's width.
  final bool fullWidth;

  /// Optional leading icon (rendered before the label).
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    final Widget labelWidget = _buildLabel();
    Widget core;

    switch (variant) {
      case BisuButtonVariant.primary:
        core = Opacity(
          opacity: enabled ? 1 : 0.4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                // linear-gradient(120deg, var(--gold-deep), var(--gold))
                begin: Alignment(-0.7, -1),
                end: Alignment(0.7, 1),
                colors: <Color>[BisuColors.goldDeep, BisuColors.gold],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(child: labelWidget),
            ),
          ),
        );
      case BisuButtonVariant.outline:
        core = Opacity(
          opacity: enabled ? 1 : 0.4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: BisuColors.gold),
              color: const Color(0x00000000),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(child: labelWidget),
            ),
          ),
        );
      case BisuButtonVariant.text:
        core = Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(child: labelWidget),
          ),
        );
    }

    if (fullWidth && variant != BisuButtonVariant.text) {
      core = SizedBox(width: double.infinity, child: core);
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        splashColor: const Color(0x22FFFFFF),
        highlightColor: const Color(0x11000000),
        child: core,
      ),
    );
  }

  Widget _buildLabel() {
    final TextStyle style = switch (variant) {
      BisuButtonVariant.primary => const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.6, // ~.2em of 13px
          color: BisuColors.white,
        ),
      BisuButtonVariant.outline => const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.64, // ~.22em of 12px
          color: BisuColors.goldDeep,
        ),
      BisuButtonVariant.text => const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: BisuColors.goldDeep,
          decoration: TextDecoration.underline,
          decorationColor: BisuColors.goldDeep,
        ),
    };

    final Text text = Text(label, style: style, textAlign: TextAlign.center);
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon!,
        const SizedBox(width: 8),
        text,
      ],
    );
  }
}
