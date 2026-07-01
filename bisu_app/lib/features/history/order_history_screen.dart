import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/order.dart';
import 'package:bisu_app/screens/login_screen.dart';
import 'package:bisu_app/shared/widgets/login_notice.dart';
import 'package:bisu_app/shared/widgets/order_card.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// 購入履歴 — Order History (tab index 3).
///
/// Faithful port of app.js `renderHistory` (lines ~591–621) and the
/// `#screen-history` skeleton in index.html (`.page-head` + `.page-body`).
///
/// - Guest (`!loggedIn`): a single [LoginNotice]
///   (`購入履歴はログインが必要です`).
/// - Member: a list of [OrderCard] built from `kOrders`
///   (出荷日 + 注文番号; thumb + name + chips [定期購入/通常購入, channel,
///   optional channelSub]; 数量 N点 + price (税込)).
///
/// This is a TAB ROOT screen: a PLAIN scrollable widget with its own header
/// and NO [Scaffold] of its own. It is hosted inside `RootScaffold`'s
/// `IndexedStack`.
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.watch(context);

    return ColoredBox(
      color: BisuColors.ivory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ---- .page-head (status-bar inset + header) ----
          const _HistoryHeader(),
          // ---- .page-body (scrollable) ----
          Expanded(
            child: state.loggedIn
                ? const _HistoryList()
                : _HistoryGuest(onLogin: () => _openLogin(context)),
          ),
        ],
      ),
    );
  }

  /// Opens the login / 新規登録 flow (mirrors `go('login')` in app.js).
  void _openLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }
}

/// `.page-head` for the history tab:
/// EN micro-label `ORDER HISTORY` + heading `購入履歴`.
///
/// ```css
/// .screen-page{ padding-top:var(--status-h); }            // 44px
/// .page-head{ padding:18px 22px 14px; border-bottom:1px solid var(--hair);
///   background:linear-gradient(180deg, var(--paper), var(--ivory)); }
/// .page-head-en{ font:serif 10.5/.34em gold; margin-bottom:4px; }
/// .page-head h2{ font:serif 21/600/.12em; }
/// ```
class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  // serif fallback list (BisuType.serifFallback) — inlined since the theme
  // default family is sans.
  static const List<String> _serif = <String>[
    'Hiragino Mincho ProN',
    'Yu Mincho',
    'YuMincho',
    'Noto Serif JP',
    'Times New Roman',
    'serif',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // .screen-page padding-top:var(--status-h) collapses into the header
      // (the status bar sits above the page in the mockup frame).
      padding: const EdgeInsets.fromLTRB(
        22,
        BisuMetrics.statusBarHeight + 18,
        22,
        14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[BisuColors.paper, BisuColors.ivory],
        ),
        border: Border(
          bottom: BorderSide(color: BisuColors.hair),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'ORDER HISTORY',
            style: TextStyle(
              fontFamilyFallback: _serif,
              fontSize: 10.5,
              letterSpacing: 3.57, // 10.5 * 0.34em
              color: BisuColors.gold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '購入履歴',
            style: TextStyle(
              fontFamilyFallback: _serif,
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.52, // 21 * 0.12em
              color: BisuColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Member state: `.page-body` with the `kOrders` list as [OrderCard]s.
///
/// `.page-body{ padding:16px 16px calc(var(--tabbar-h) + 28px); }`
/// => bottom = 62 + 28 = 90.
class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        BisuMetrics.tabBarHeight + 28,
      ),
      itemCount: kOrders.length,
      itemBuilder: (BuildContext context, int index) {
        final Order order = kOrders[index];
        return OrderCard(order: order);
      },
    );
  }
}

/// Guest state: the login gate shown in place of the order list
/// (mirrors `renderHistory`'s `!state.loggedIn` branch).
class _HistoryGuest extends StatelessWidget {
  const _HistoryGuest({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        BisuMetrics.tabBarHeight + 28,
      ),
      child: LoginNotice(
        title: '購入履歴はログインが必要です',
        message:
            'ログインして楽楽アカウントと連携すると、ネット注文・店頭購入の履歴を確認できます。',
        onLogin: onLogin,
      ),
    );
  }
}
