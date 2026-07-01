import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// Local helper that reproduces the mockup's `.overlay-screen` chrome
/// (`.ovs-header` / `.ovs-back` / `.ovs-title` / `.ovs-body`) for the
/// EXTRAS flow pages (CLUB / TBD / LANGUAGE).
///
/// Not a shared-contract widget — kept inside the feature folder because the
/// three pages here all share the exact same header + scroll-body structure.
///
/// ```css
/// .overlay-screen{ background:var(--ivory); display:flex; flex-direction:column; }
/// .ovs-header{ padding:calc(status-h + 8px) 14px 12px; gap:6px;
///   border-bottom:1px solid var(--hair);
///   background:linear-gradient(180deg, var(--paper), var(--ivory)); }
/// .ovs-back{ width:36px; height:36px; border-radius:99px; color:var(--ink); }
/// .ovs-title{ font-family:serif; font-size:15px; font-weight:600; letter-spacing:.12em; }
/// .ovs-body{ flex:1; overflow-y:auto; padding:16px 16px calc(tabbar-h + 28px); }
/// ```
class OverlayPage extends StatelessWidget {
  const OverlayPage({
    super.key,
    required this.title,
    required this.child,
    this.bodyPadding = const EdgeInsets.fromLTRB(16, 16, 16, 90),
  });

  /// Header title (`.ovs-title`). Rendered serif, spaced.
  final String title;

  /// Scrollable body content (`.ovs-body`).
  final Widget child;

  /// Padding around [child]. Bottom default ≈ tabbar-h(62) + 28.
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    final double statusInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: BisuColors.ivory,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ---- .ovs-header ----
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[BisuColors.paper, BisuColors.ivory],
              ),
              border: Border(
                bottom: BorderSide(color: BisuColors.hair, width: 1),
              ),
            ),
            child: Padding(
              // status-h(44) ~ device top inset; +8 below it, 14 sides, 12 bottom.
              padding: EdgeInsets.fromLTRB(14, statusInset + 8, 14, 12),
              child: Row(
                children: <Widget>[
                  _BackButton(onTap: () => Navigator.of(context).maybePop()),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: BisuType.title.copyWith(letterSpacing: 1.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ---- .ovs-body ----
          Expanded(
            child: SingleChildScrollView(
              padding: bodyPadding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// The round `.ovs-back` chevron button.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Center(
            // .ovs-back svg: 20px, stroke currentColor(ink), stroke-width 2.
            child: Icon(Icons.chevron_left, size: 24, color: BisuColors.ink),
          ),
        ),
      ),
    );
  }
}
