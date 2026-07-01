import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A single settings list row (mirrors `.set-row` in styles.css).
///
/// ```css
/// .set-row{ display:flex; align-items:center; gap:12px; padding:13.5px 15px;
///   border-bottom:1px solid var(--hair); width:100%; text-align:left; }
/// .set-row .set-ic{ width:19px; height:19px; stroke:var(--gold-deep); }
/// .set-label{ flex:1; font-size:12.5px; font-weight:600; letter-spacing:.03em; }
/// .set-sub{ font-size:9.5px; color:var(--ink-faint); margin-top:2px; }
/// .set-arrow{ width:14px; height:14px; stroke:var(--ink-faint); }
/// ```
///
/// The row is laid out as: leading icon · title (+ optional subtitle) ·
/// trailing. If [trailing] is omitted and [onTap] is set, a chevron
/// (`.set-arrow`) is shown automatically.
///
/// Leading icon precedence: [leading] (custom widget, e.g. a tinted swallow /
/// SVG path icon from the mockup) wins; otherwise [leadingIcon] renders a
/// 19px Material icon in `goldDeep` (or [BisuColors] danger red when [danger]).
///
/// [danger] turns the icon + title red (`#A04545`) for ログアウト / アカウント削除.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.leadingIcon,
    this.leading,
    this.danger = false,
    this.showDivider = true,
  });

  /// Row label (`.set-label`).
  final String title;

  /// Optional secondary line (`.set-sub`).
  final String? subtitle;

  /// Trailing widget (toggle / badge / custom). Null + [onTap] → chevron.
  final Widget? trailing;

  /// Tap handler.
  final VoidCallback? onTap;

  /// Material icon fallback for the leading slot.
  final IconData? leadingIcon;

  /// Custom leading widget (overrides [leadingIcon]) — e.g. an SVG path icon.
  final Widget? leading;

  /// Danger styling (`#A04545`) for logout / delete rows.
  final bool danger;

  /// Whether to draw the bottom hairline (`border-bottom`). The mockup omits
  /// it on the last row of a list.
  final bool showDivider;

  static const Color _danger = Color(0xFFA04545);

  @override
  Widget build(BuildContext context) {
    final Color accent = danger ? _danger : BisuColors.goldDeep;

    final Widget? leadingWidget = leading ??
        (leadingIcon != null
            ? Icon(leadingIcon, size: 19, color: accent)
            : null);

    final Widget? trailingWidget = trailing ??
        (onTap != null
            ? const Icon(
                Icons.chevron_right,
                size: 14,
                color: BisuColors.inkFaint,
              )
            : null);

    final Widget row = DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: BisuColors.hair, width: 1),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13.5),
        child: Row(
          children: <Widget>[
            if (leadingWidget != null) ...<Widget>[
              SizedBox(width: 19, height: 19, child: Center(child: leadingWidget)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.375, // ~.03em of 12.5px
                      color: danger ? _danger : BisuColors.ink,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: BisuColors.inkFaint,
                          height: 1.4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailingWidget != null) ...<Widget>[
              const SizedBox(width: 12),
              trailingWidget,
            ],
          ],
        ),
      ),
    );

    if (onTap == null) return row;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}
