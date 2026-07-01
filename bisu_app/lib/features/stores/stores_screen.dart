import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/store.dart';
import 'package:bisu_app/shared/widgets/store_card_web.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// STORES tab (root tab 4) — v2.1 WebView placeholder of the official site
/// store page. Native list / map / detail screens were DEPRECATED (OP-20確定,
/// app.js:1181), so this renders a styled native facsimile of the official
/// `bi-su.jp/stores` page inside a browser-chrome frame.
///
/// Mirrors `#screen-stores` in index.html + `renderStoresWebView` (app.js
/// 1043-1061) + the `.webview-*` / `.wv-*` rules in styles.css.
///
/// PLAIN scrollable widget — no [Scaffold] of its own (the host [RootScaffold]
/// supplies the Scaffold + tab bar). Provides its own `.page-head` header.
class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // .screen-page: ivory bg + padding-top:var(--status-h) for the notch area.
    return Container(
      color: BisuColors.ivory,
      padding: const EdgeInsets.only(top: BisuMetrics.statusBarHeight),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _StoresHeader(),
          Expanded(child: _StoresBody()),
        ],
      ),
    );
  }
}

/// `.page-head` for the STORES screen: EN eyebrow "STORES" + h2 "店舗一覧".
class _StoresHeader extends StatelessWidget {
  const _StoresHeader();

  @override
  Widget build(BuildContext context) {
    // .page-head: padding 18/22/14, bottom hairline, paper->ivory gradient.
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[BisuColors.paper, BisuColors.ivory],
        ),
        border: Border(bottom: BorderSide(color: BisuColors.hair, width: 1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // .page-head-en: serif 10.5px, letter-spacing .34em, gold.
          Text(
            'STORES',
            style: TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 10.5 * 0.34,
              color: BisuColors.gold,
            ),
          ),
          SizedBox(height: 4),
          // .page-head h2: serif 21px w600, letter-spacing .12em.
          Text(
            '店舗一覧',
            style: TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: 21 * 0.12,
              color: BisuColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// `.page-body.webview-body`: scrollable column holding the WebView frame
/// placeholder and the explanatory note beneath it.
class _StoresBody extends StatelessWidget {
  const _StoresBody();

  @override
  Widget build(BuildContext context) {
    // .page-body: padding 16/16, bottom = tabbar-h + 28 (RootScaffold's tab bar
    // overlaps the IndexedStack body, so reserve room here).
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        BisuMetrics.tabBarHeight + 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _WebViewFrame(),
          _WebViewNote(),
        ],
      ),
    );
  }
}

/// `.webview-frame` — browser chrome (address bar + content) wrapping the
/// official store-page facsimile.
class _WebViewFrame extends StatelessWidget {
  const _WebViewFrame();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // .webview-frame: 1px hair border, radius 14, white bg, soft shadow.
      decoration: BoxDecoration(
        color: BisuColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BisuColors.hair, width: 1),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F463C28), // rgba(70,60,40,.06)
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      // overflow:hidden — clip children (bar tint, content) to the radius.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _WebViewBar(),
            _WebViewContent(),
          ],
        ),
      ),
    );
  }
}

/// `.webview-bar` — faux browser address bar: 🔒 lock + URL + ⟳ reload.
class _WebViewBar extends StatelessWidget {
  const _WebViewBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      // .webview-bar: padding 9/12, bg #ECE7DB, bottom hairline, gap 8.
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: const BoxDecoration(
        color: Color(0xFFECE7DB),
        border: Border(bottom: BorderSide(color: BisuColors.hair, width: 1)),
      ),
      child: const Row(
        children: <Widget>[
          // .wv-lock: 10px.
          Text(
            '🔒',
            style: TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 10,
            ),
          ),
          SizedBox(width: 8),
          // .wv-url: flex 1, 11px, w600, letter-spacing .02em, ink-soft.
          Expanded(
            child: Text(
              'bi-su.jp/stores',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 11 * 0.02,
                color: BisuColors.inkSoft,
              ),
            ),
          ),
          SizedBox(width: 8),
          // .wv-reload: ink-faint.
          Text(
            '⟳',
            style: TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 11,
              color: BisuColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}

/// `.webview-content` — the official store-page facsimile: heading, sub-label,
/// the [StoreCardWeb] rows, and the source footer.
class _WebViewContent extends StatelessWidget {
  const _WebViewContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // .webview-content: padding 14/14/16.
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // .wv-page-h: serif 16px, letter-spacing .06em.
          const Text(
            'BI-SU 店舗一覧',
            style: TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 16 * 0.06,
              color: BisuColors.ink,
            ),
          ),
          // .wv-page-sub: 10.5px, ink-soft, margin 4/0/12.
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              '直営店・取扱店・期間限定ストア',
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 10.5,
                color: BisuColors.inkSoft,
              ),
            ),
          ),
          // .wv-store rows — each draws its own top hairline.
          for (final Store store in kStores) StoreCardWeb(store: store),
          // .wv-foot: 9px, ink-faint, centered, margin-top 14,
          //   border-top:1px dashed var(--hair) + padding-top 10.
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: _DashedDivider(color: BisuColors.hair),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'bi-su.jp — 公式サイト店舗ページ（WebViewでの表示イメージ）',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 9,
                color: BisuColors.inkFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.webview-note` — explains that real builds load the official site in a
/// WebView (OP-20確定). The `<b>` span is rendered in goldDeep + bold.
class _WebViewNote extends StatelessWidget {
  const _WebViewNote();

  @override
  Widget build(BuildContext context) {
    // .webview-note: 10px, ink-faint, line-height 1.8, margin 12/4/0;
    //   .webview-note b: gold-deep.
    return const Padding(
      padding: EdgeInsets.only(top: 12, left: 4, right: 4),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontFamilyFallback: BisuType.sansFallback,
            fontSize: 10,
            height: 1.8,
            color: BisuColors.inkFaint,
          ),
          children: <InlineSpan>[
            TextSpan(text: '※ 店舗一覧・マップ・店舗詳細は、本番アプリでは'),
            TextSpan(
              text: '公式サイトの店舗ページをWebViewで表示',
              style: TextStyle(
                color: BisuColors.goldDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: 'します（OP-20確定）。上の枠はその表示位置のプレースホルダです。'),
          ],
        ),
      ),
    );
  }
}

/// A 1px horizontal dashed rule (reproduces `border-top:1px dashed var(--hair)`
/// used by `.wv-foot`). Flutter's [Border] cannot draw dashes, so we paint it.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider({required this.color});

  final Color color;
  static const double thickness = 1;
  static const double dashWidth = 3;
  static const double dashGap = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: thickness,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          thickness: thickness,
          dashWidth: dashWidth,
          dashGap: dashGap,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double thickness;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;
    final double y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        dashWidth != oldDelegate.dashWidth ||
        dashGap != oldDelegate.dashGap;
  }
}
