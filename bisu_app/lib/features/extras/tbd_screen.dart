import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/features/extras/overlay_page.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// Which "準備中" placeholder to show.
///
/// Mirrors the `kind` argument of app.js `openTbd(kind)` (1097–1111):
/// `storepoint` = 店舗ポイント (OP-28) · `checkin` = チェックイン (OP-29).
enum TbdKind { storepoint, checkin }

/// 準備中プレースホルダ (TBD-501/502 店舗ポイント・TBD-601 チェックイン).
///
/// Mirrors app.js `openTbd()` + index.html `#screen-tbd`: a clock icon, the
/// feature title with a `準備中` badge, a description, and the OP note box.
class TbdScreen extends StatelessWidget {
  const TbdScreen({super.key, required this.kind});

  /// Which placeholder to render.
  final TbdKind kind;

  /// Title / desc / OP copy, verbatim from app.js `openTbd()`.
  _TbdInfo get _info {
    switch (kind) {
      case TbdKind.storepoint:
        return const _TbdInfo(
          title: '店舗ポイント',
          desc: '来店・店頭購入で貯まる店舗ポイントの残高・履歴・交換機能です。'
              '仮会員証でも貯められます。',
          op: 'OP-28: ポイント制度自体が未策定のため、確定後に実装します。',
        );
      case TbdKind.checkin:
        return const _TbdInfo(
          title: 'チェックイン',
          desc: '店内のQRコードを読み取って来店を記録し、店舗ポイントを受け取れます。',
          op: 'OP-29: QRコード方式は確定。付与条件・不正防止ルールが未定のため、'
              '確定後に実装します。',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _TbdInfo info = _info;

    return OverlayPage(
      // .ovs-title is set to the feature title (app.js sets #tbd-title).
      title: info.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // .tbd-card{ text-align:center; padding:44px 24px; }
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
            child: Column(
              children: <Widget>[
                // .tbd-ic — clock, 48px, color gold.
                SvgPicture.string(_clockSvg, width: 48, height: 48),
                const SizedBox(height: 16),
                // .tbd-h{ serif 18px } + .tbd-h span{ 準備中 badge }
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      info.title,
                      style: const TextStyle(
                        fontFamilyFallback: BisuType.serifFallback,
                        fontSize: 18,
                        letterSpacing: 1.8, // ~.1em
                        color: BisuColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E8D4),
                        border: Border.all(color: const Color(0xFFE0D2B2)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '準備中',
                        style: TextStyle(
                          fontFamilyFallback: BisuType.sansFallback,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: BisuColors.goldDeep,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // .tbd-d
                Text(
                  info.desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamilyFallback: BisuType.sansFallback,
                    fontSize: 12,
                    height: 1.9,
                    color: BisuColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 16),
                // .tbd-op — boxed OP note.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BisuColors.paper,
                    border: Border.all(color: BisuColors.hair),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    info.op,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamilyFallback: BisuType.sansFallback,
                      fontSize: 10.5,
                      height: 1.8,
                      color: BisuColors.inkFaint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// `.tbd-ic` clock SVG (verbatim path from app.js), stroke baked as gold.
  static const String _clockSvg =
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="12" cy="12" r="9" fill="none" stroke="#A8895A" '
      'stroke-width="1.4"/>'
      '<path d="M12 7.5V12l3 2" fill="none" stroke="#A8895A" '
      'stroke-width="1.4" stroke-linecap="round"/></svg>';
}

/// Immutable copy bundle for one [TbdKind].
class _TbdInfo {
  const _TbdInfo({required this.title, required this.desc, required this.op});

  final String title;
  final String desc;
  final String op;
}
