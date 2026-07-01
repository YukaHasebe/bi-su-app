import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// First-run tutorial overlay (mirrors `.coach` in styles.css / SCR-006 in
/// index.html).
///
/// ```css
/// .coach-veil{ background:rgba(10,10,8,.7); backdrop-filter:blur(2px); }
/// .coach-card{ left:24px; right:24px; bottom:calc(62px + 30px); background:#FFFDF8;
///   border-radius:18px; padding:22px 22px 20px; }
/// .coach-title{ font-family:var(--serif); font-size:16px; text-align:center; }
/// .coach-list li{ font-size:11.5px; ... } li::before{ gold dot } b{ color:var(--gold-deep); }
/// ```
///
/// Renders a darkened veil with a bottom card. Provide [items] for the bulleted
/// tutorial list (each rendered with a gold dot); otherwise the single
/// [message] line is shown. Bold spans in the mockup copy are not parsed —
/// pass plain strings.
class CoachMark extends StatelessWidget {
  const CoachMark({
    super.key,
    required this.message,
    this.title = 'アプリの使い方',
    this.items = const <String>[],
    this.dismissLabel = 'はじめる',
    this.onDismiss,
  });

  /// Single-line body, shown when [items] is empty.
  final String message;

  /// Card heading (`.coach-title`).
  final String title;

  /// Bullet list (`.coach-list`). When non-empty, [message] is ignored.
  final List<String> items;

  /// Confirm button label.
  final String dismissLabel;

  /// Called when the button is tapped (and when the veil is tapped).
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // veil
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const ColoredBox(color: Color(0xB30A0A08)), // rgba(10,10,8,.7)
            ),
          ),
        ),
        // card
        Positioned(
          left: 24,
          right: 24,
          bottom: BisuMetrics.tabBarHeight + 30,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x66000000), // rgba(0,0,0,.4)
                  blurRadius: 44,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.6,
                      color: BisuColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.7,
                        color: BisuColors.inkSoft,
                      ),
                    )
                  else
                    for (int i = 0; i < items.length; i++)
                      _CoachItem(
                        text: items[i],
                        showDivider: i != items.length - 1,
                      ),
                  const SizedBox(height: 12),
                  BisuButton(label: dismissLabel, onPressed: onDismiss),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoachItem extends StatelessWidget {
  const _CoachItem({required this.text, required this.showDivider});

  final String text;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: BisuColors.hair, width: 1),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 6, right: 11, left: 4),
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: BisuColors.gold,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.7,
                  color: BisuColors.inkSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
