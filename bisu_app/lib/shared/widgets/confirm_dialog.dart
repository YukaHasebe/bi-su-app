import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A centered confirmation dialog (mirrors `.dlg-box` in styles.css).
///
/// ```css
/// .dlg-box{ width:calc(100% - 48px); max-width:320px; background:#FFFDF8;
///   border-radius:20px; padding:26px 24px 20px; text-align:center; }
/// .dlg-title{ font-family:var(--serif); font-size:17px; font-weight:600; }
/// .dlg-msg{ font-size:12px; line-height:1.9; color:var(--ink-soft); }
/// .dlg-cancel{ background:transparent; color:var(--ink-soft); border:1px solid var(--hair); }
/// .dlg-danger{ background:#A04545; color:#FFF; }
/// ```
///
/// Use [ConfirmDialog.show] to present it via `showDialog`; it resolves to
/// `true` (confirm), `false` (cancel), or `null` (dismissed by tapping the
/// backdrop). The confirm button is the danger red (`#A04545`) when [danger]
/// is set, otherwise the gold gradient.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmLabel = 'OK',
    this.cancelLabel = 'キャンセル',
    this.danger = false,
  });

  /// Dialog heading.
  final String title;

  /// Optional body copy.
  final String? message;

  /// Confirm button text.
  final String confirmLabel;

  /// Cancel button text.
  final String cancelLabel;

  /// Danger styling for the confirm button.
  final bool danger;

  /// Presents the dialog and resolves to true/false/null.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'OK',
    String cancelLabel = 'キャンセル',
    bool danger = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: const Color(0x8C0C0B09), // rgba(12,11,9,.55)
      builder: (BuildContext context) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        danger: danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFDF8),
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamilyFallback: <String>[
                    'Hiragino Mincho ProN',
                    'Yu Mincho',
                    'YuMincho',
                    'Noto Serif JP',
                    'Times New Roman',
                    'serif',
                  ],
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.7,
                  color: BisuColors.ink,
                ),
              ),
              if (message != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.9,
                    color: BisuColors.inkSoft,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _DlgButton(
                      label: cancelLabel,
                      onTap: () => Navigator.of(context).pop(false),
                      filled: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DlgButton(
                      label: confirmLabel,
                      onTap: () => Navigator.of(context).pop(true),
                      filled: true,
                      danger: danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DlgButton extends StatelessWidget {
  const _DlgButton({
    required this.label,
    required this.onTap,
    required this.filled,
    this.danger = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = BorderRadius.circular(999);
    final Color textColor =
        filled ? BisuColors.white : BisuColors.inkSoft;

    final BoxDecoration decoration = filled
        ? (danger
            ? const BoxDecoration(
                color: Color(0xFFA04545),
                borderRadius: BorderRadius.all(Radius.circular(999)),
              )
            : BoxDecoration(
                borderRadius: br,
                gradient: const LinearGradient(
                  begin: Alignment(-0.7, -1),
                  end: Alignment(0.7, 1),
                  colors: <Color>[BisuColors.goldDeep, BisuColors.gold],
                ),
              ))
        : BoxDecoration(
            borderRadius: br,
            border: Border.all(color: BisuColors.hair),
          );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: br,
        child: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
