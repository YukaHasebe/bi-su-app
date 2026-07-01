import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/features/extras/overlay_page.dart';
import 'package:bisu_app/shared/widgets/setting_row.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// 言語 / Language (SCR-509).
///
/// Mirrors app.js `openLang()` (1115) + `handleLangPick()` (1117–1126) and
/// index.html `#screen-lang`: a selectable list (日本語 / English) where the
/// chosen row gets the `.is-lang-on` background tint and a `選択中` badge.
/// Selection is local UI state only — the mockup does not switch app text.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  /// Selected language id ('ja' | 'en'). Defaults to 日本語 (`is-lang-on`).
  String _selected = 'ja';

  @override
  Widget build(BuildContext context) {
    return OverlayPage(
      title: '言語 / Language',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // .card.set-list — paper card holding the two rows.
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: BisuColors.paper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BisuColors.hair),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x0D463C28), // rgba(70,60,40,.05)
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: <Widget>[
                  _LangRow(
                    id: 'ja',
                    title: '日本語',
                    subtitle: 'Japanese',
                    selected: _selected == 'ja',
                    showDivider: true,
                    onTap: () => setState(() => _selected = 'ja'),
                  ),
                  _LangRow(
                    id: 'en',
                    title: 'English',
                    subtitle: '英語',
                    selected: _selected == 'en',
                    showDivider: false,
                    onTap: () => setState(() => _selected = 'en'),
                  ),
                ],
              ),
            ),
          ),
          // .lang-note
          const Padding(
            padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: Text(
              '※ モックアップでは表示テキストの切替は行いません'
              '（実装時に日本語 / English を切り替えます。対応範囲は OP-30）。',
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 10,
                height: 1.8,
                color: BisuColors.inkFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single language row built on the shared [SettingRow].
///
/// Selected → `.is-lang-on` (#FFFDF8 tint) + a `.lang-badge`(選択中) trailing.
/// Leading is the globe `.set-ic` SVG rebuilt verbatim from index.html.
class _LangRow extends StatelessWidget {
  const _LangRow({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.showDivider,
    required this.onTap,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool selected;
  final bool showDivider;
  final VoidCallback onTap;

  /// `.set-ic` globe icon (verbatim path from index.html), stroke gold-deep.
  static const String _globeSvg =
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" '
      'fill="none" stroke="#8A6E42" stroke-width="1.6">'
      '<path d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20ZM2 12h20'
      'M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 '
      '15.3 15.3 0 0 1-4-10A15.3 15.3 0 0 1 12 2Z"/></svg>';

  @override
  Widget build(BuildContext context) {
    final Widget row = SettingRow(
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      showDivider: showDivider,
      leading: SvgPicture.string(_globeSvg, width: 19, height: 19),
      trailing: selected ? const _LangBadge() : const SizedBox.shrink(),
    );

    // .set-row.is-lang-on{ background:#FFFDF8; }
    if (!selected) return row;
    return ColoredBox(color: const Color(0xFFFFFDF8), child: row);
  }
}

/// `.lang-badge` — 選択中 pill.
class _LangBadge extends StatelessWidget {
  const _LangBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x1AA8895A), // rgba(168,137,90,.1)
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        '選択中',
        style: TextStyle(
          fontFamilyFallback: BisuType.sansFallback,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.54, // ~.06em
          color: BisuColors.goldDeep,
        ),
      ),
    );
  }
}
