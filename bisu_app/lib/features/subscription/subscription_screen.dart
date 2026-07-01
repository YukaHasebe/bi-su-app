import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/subscription.dart';
import 'package:bisu_app/screens/login_screen.dart';
import 'package:bisu_app/shared/widgets/login_notice.dart';
import 'package:bisu_app/shared/widgets/subscription_card.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// SUBSCRIPTION tab (tab index 1). A PLAIN scrollable widget — no Scaffold of
/// its own — reproducing `renderSubs()` (app.js ~557-588) and the `定期情報`
/// page skeleton (index.html ~73-79).
///
/// - Guest (`!loggedIn`): a single [LoginNotice].
/// - Member: `ご利用中の定期コース` (active) then `解約済みの定期コース`
///   (cancelled), each a [SubscriptionCard].
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // .page-head (with the device status-bar inset folded into its top
        // padding, matching the mockup's `.screen{ padding-top:status-h }`).
        const _PageHead(en: 'SUBSCRIPTION', title: '定期情報'),
        // .page-body — scrollable region.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              // calc(var(--tabbar-h) + 28px) = 62 + 28.
              90,
            ),
            child: state.loggedIn
                ? const _SubscriptionList()
                : LoginNotice(
                    title: '定期情報はログインが必要です',
                    message:
                        'ログインして楽楽アカウントと連携すると、次回お届け日や定期コースの内容を確認できます。',
                    onLogin: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LoginScreen(),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Member view: active section then cancelled section.
class _SubscriptionList extends StatelessWidget {
  const _SubscriptionList();

  @override
  Widget build(BuildContext context) {
    final List<Subscription> active = <Subscription>[
      for (final Subscription s in kSubscriptions)
        if (s.isActive) s,
    ];
    final List<Subscription> cancelled = <Subscription>[
      for (final Subscription s in kSubscriptions)
        if (s.isCancelled) s,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _SecLabel('ご利用中の定期コース', first: true),
        for (final Subscription s in active)
          SubscriptionCard(subscription: s),
        const _SecLabel('解約済みの定期コース'),
        for (final Subscription s in cancelled)
          SubscriptionCard(subscription: s),
      ],
    );
  }
}

/// `.page-head` — EN eyebrow + JP title with the paper→ivory gradient and a
/// bottom hairline. Folds the top status-bar safe-area inset into its padding.
class _PageHead extends StatelessWidget {
  const _PageHead({required this.en, required this.title});

  final String en;
  final String title;

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
    final double topInset = MediaQuery.of(context).padding.top;

    return Container(
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
      padding: EdgeInsets.fromLTRB(22, 18 + topInset, 22, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // .page-head-en: serif 10.5px, ls .34em (~3.57), gold.
          Text(
            en,
            style: const TextStyle(
              fontFamilyFallback: _serif,
              fontSize: 10.5,
              height: 1.2,
              fontWeight: FontWeight.w400,
              letterSpacing: 3.57,
              color: BisuColors.gold,
            ),
          ),
          const SizedBox(height: 4),
          // .page-head h2: serif 21px w600, ls .12em (~2.52).
          Text(
            title,
            style: const TextStyle(
              fontFamilyFallback: _serif,
              fontSize: 21,
              height: 1.25,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.52,
              color: BisuColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// `.sec-label` — goldDeep w700 10px, ls .26em (~2.6); margin 18/6/9, but the
/// first label uses margin-top 2px.
class _SecLabel extends StatelessWidget {
  const _SecLabel(this.text, {this.first = false});

  final String text;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6, first ? 2 : 18, 6, 9),
      child: Text(
        text,
        style: const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 10,
          height: 1.3,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.6,
          color: BisuColors.goldDeep,
        ),
      ),
    );
  }
}
