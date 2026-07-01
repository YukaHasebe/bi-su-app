import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// The five-tab bottom navigation bar (mirrors `.tabbar` / `TABS` in app.js).
///
/// ```css
/// .tabbar{ height:calc(62px + safe-area); background:rgba(250,249,245,.92);
///   backdrop-filter:blur(14px); border-top:1px solid var(--hair); }
/// .tab{ color:var(--ink-faint); }  .tab.is-on{ color:var(--gold-deep); }
/// .tab svg{ width:23px; height:23px; stroke:currentColor; fill:none;
///   stroke-width:1.5; stroke-linecap:round; stroke-linejoin:round; }
/// .tab span{ font-size:9.5px; letter-spacing:.06em; font-weight:600; }
/// ```
///
/// Tabs (index → label): 0 ホーム · 1 定期情報 · 2 購入履歴 · 3 ストアーズ · 4 設定.
/// The active tab is gold-deep; inactive is ink-faint. Height is the design
/// token [BisuMetrics.tabBarHeight] (62) plus the bottom safe-area inset.
class BisuTabBar extends StatelessWidget {
  const BisuTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// The selected tab index (0–4).
  final int currentIndex;

  /// Tap callback with the new index.
  final ValueChanged<int> onTap;

  // ---- TABS (verbatim icon paths from app.js TABS ~171-182) ----
  static const List<_TabSpec> _tabs = <_TabSpec>[
    _TabSpec(
      label: 'ホーム',
      paths: <String>[
        '<path d="M3.5 10.5 12 3.5l8.5 7"/>',
        '<path d="M5.5 9.5V20h13V9.5"/>',
        '<path d="M10 20v-5.5h4V20"/>',
      ],
    ),
    _TabSpec(
      label: '定期情報',
      paths: <String>[
        '<path d="M20.5 12a8.5 8.5 0 1 1-2.4-5.9"/>',
        '<path d="M20.5 3.5v4h-4"/>',
        '<path d="M12 8v4.2l3 1.8"/>',
      ],
    ),
    _TabSpec(
      label: '購入履歴',
      paths: <String>[
        '<path d="M5 3.5h14V21l-2.4-1.5L14 21l-2-1.3L10 21l-2.6-1.5L5 21Z"/>',
        '<path d="M8.5 8h7M8.5 12h7M8.5 16h4"/>',
      ],
    ),
    _TabSpec(
      label: 'ストアーズ',
      paths: <String>[
        '<path d="M12 21.5s-7-5.6-7-11.3A7 7 0 0 1 19 10.2c0 5.7-7 11.3-7 11.3Z"/>',
        '<circle cx="12" cy="10" r="2.6"/>',
      ],
    ),
    _TabSpec(
      label: '設定',
      paths: <String>[
        '<path d="M4 7h9M17.5 7H20"/>',
        '<circle cx="15" cy="7" r="2.2"/>',
        '<path d="M4 17h3M11.5 17H20"/>',
        '<circle cx="9" cy="17" r="2.2"/>',
      ],
    ),
  ];

  /// Builds a 24×24 stroked-icon SVG string in [color] for the given paths.
  static String _iconSvg(List<String> paths, Color color) {
    final String hex = _hex(color);
    final String body = paths.join();
    return '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" '
        'fill="none" stroke="$hex" stroke-width="1.5" '
        'stroke-linecap="round" stroke-linejoin="round">$body</svg>';
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xEBFAF9F5), // rgba(250,249,245,.92)
        border: Border(top: BorderSide(color: BisuColors.hair, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 6,
          left: 6,
          right: 6,
          bottom: 6 + bottomInset,
        ),
        child: SizedBox(
          height: BisuMetrics.tabBarHeight - 12, // padding already added
          child: Row(
            children: <Widget>[
              for (int i = 0; i < _tabs.length; i++)
                Expanded(
                  child: _TabButton(
                    spec: _tabs[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? BisuColors.goldDeep : BisuColors.inkFaint;
    return InkResponse(
      onTap: onTap,
      radius: 40,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.string(
            BisuTabBar._iconSvg(spec.paths, color),
            width: 23,
            height: 23,
          ),
          const SizedBox(height: 3),
          Text(
            spec.label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.57, // ~.06em of 9.5px
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({required this.label, required this.paths});
  final String label;
  final List<String> paths;
}

String _hex(Color c) {
  final int r = (c.r * 255.0).round() & 0xff;
  final int g = (c.g * 255.0).round() & 0xff;
  final int b = (c.b * 255.0).round() & 0xff;
  String two(int v) => v.toRadixString(16).padLeft(2, '0');
  return '#${two(r)}${two(g)}${two(b)}';
}
