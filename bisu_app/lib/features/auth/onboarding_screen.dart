import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/screens/splash_screen.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// オンボーディング (SCR-003) — mirrors `#screen-onboarding` (index.html) +
/// `showOnboarding` / `finishOnboarding` (app.js 984-1015).
///
/// Night-background three-page intro with paging dots. The trailing button is
/// 次へ until the last page, then はじめる. A スキップ link finishes
/// immediately. Finishing sets logged-in and replays the splash, which then
/// lands on the app shell.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // nextOnboarding(): last page -> finish; else advance.
  void _next() {
    if (_page >= _OnboardingPages.pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // finishOnboarding(): setLoggedIn(true); playSplash().
  void _finish() {
    AppScope.of(context).setLoggedIn(true);
    // Splash replays then lands on the app shell (RootScaffold).
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SplashScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _page >= _OnboardingPages.pages.length - 1;
    // ob-next text: last ? 'はじめる' : '次へ'
    final String buttonLabel = isLast ? 'はじめる' : '次へ';

    return Scaffold(
      // .screen-onboarding{ background:var(--night); color:#FFF; }
      backgroundColor: BisuColors.night,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // .ob-pages{ flex:1; }
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _OnboardingPages.pages.length,
                onPageChanged: (int i) => setState(() => _page = i),
                itemBuilder: (_, int i) => _OnboardingPages.pages[i],
              ),
            ),
            // .ob-footer{ padding:0 28 40; gap:12; }
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _Dots(count: _OnboardingPages.pages.length, active: _page),
                  const SizedBox(height: 8),
                  BisuButton(label: buttonLabel, onPressed: _next),
                  const SizedBox(height: 12),
                  // .auth-link — スキップ (ob-skip -> finishOnboarding)
                  _SkipLink(onTap: _finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The three onboarding pages, copied verbatim from `#ob-pages` (index.html).
class _OnboardingPages {
  const _OnboardingPages._();

  static const List<Widget> pages = <Widget>[
    _OnboardingPage(
      visual: _OnboardingLogo(),
      title: "BI-SU Member's Appへ\nようこそ",
      desc: '会員証の提示、ランク確認、定期情報の管理、\nすべてをこのアプリで。',
    ),
    _OnboardingPage(
      visual: _IconCard(),
      title: 'デジタル会員証',
      desc: '店舗のお会計でQRコードをかざすだけ。\n会員番号とランクを瞬時に提示できます。',
    ),
    _OnboardingPage(
      visual: _IconSubscription(),
      title: '定期情報もひと目で',
      desc: '次回お届け日、定期コースの内容、\n購入履歴をいつでも確認できます。',
    ),
  ];
}

/// A single `.ob-page` — centered visual + serif title + body on night bg.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.visual,
    required this.title,
    required this.desc,
  });

  final Widget visual;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // .ob-page{ padding:0 32px; }
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // .ob-visual{ width:120; height:120; margin-bottom:32; }
          SizedBox(
            width: 120,
            height: 120,
            child: Center(child: visual),
          ),
          const SizedBox(height: 32),
          // .ob-title{ color:#F5EEDF; }
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.65,
              letterSpacing: 2.64, // ~.12em
              color: Color(0xFFF5EEDF),
            ),
          ),
          // .ob-desc{ color:rgba(245,238,223,.7); margin-top:14px; }
          const SizedBox(height: 14),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 12,
              height: 2,
              letterSpacing: 0.48, // ~.04em
              color: Color(0xB3F5EEDF), // rgba(245,238,223,.7)
            ),
          ),
        ],
      ),
    );
  }
}

/// `.ob-logo` — BI-SU wordmark (`logo_w.png`) with a soft drop shadow.
class _OnboardingLogo extends StatelessWidget {
  const _OnboardingLogo();

  @override
  Widget build(BuildContext context) {
    // .ob-logo{ filter:drop-shadow(0 2px 14px rgba(0,0,0,.4)); }
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 14,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_w.png',
        width: 80,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80),
      ),
    );
  }
}

/// `.ob-icon` page-1 SVG (digital membership card motif), gold stroke.
class _IconCard extends StatelessWidget {
  const _IconCard();

  // Copied verbatim from index.html onboarding page data-page="1".
  static const String _svg =
      '<svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="40" cy="40" r="38" fill="none" stroke="#A8895A" stroke-width="1.2"/>'
      '<rect x="22" y="18" width="36" height="44" rx="4" fill="none" stroke="#A8895A" stroke-width="1.5"/>'
      '<rect x="30" y="28" width="20" height="20" rx="2" fill="none" stroke="#A8895A" stroke-width="1.2"/>'
      '<path d="M34 52h12" stroke="#A8895A" stroke-width="1.2" stroke-linecap="round"/></svg>';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: 80, height: 80);
  }
}

/// `.ob-icon` page-2 SVG (subscription overview motif), gold stroke.
class _IconSubscription extends StatelessWidget {
  const _IconSubscription();

  // Copied verbatim from index.html onboarding page data-page="2".
  static const String _svg =
      '<svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="40" cy="40" r="38" fill="none" stroke="#A8895A" stroke-width="1.2"/>'
      '<rect x="20" y="24" width="40" height="32" rx="3" fill="none" stroke="#A8895A" stroke-width="1.5"/>'
      '<path d="M20 34h40" stroke="#A8895A" stroke-width="1.2"/>'
      '<circle cx="32" cy="44" r="4" fill="none" stroke="#A8895A" stroke-width="1.2"/>'
      '<path d="M42 42h12M42 47h8" stroke="#A8895A" stroke-width="1.2" stroke-linecap="round"/></svg>';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: 80, height: 80);
  }
}

/// `.ob-dots` — pill paging indicator on the night background.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < count; i++) ...<Widget>[
          if (i != 0) const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: i == active ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              // .ob-dot{ background:rgba(255,255,255,.25); } / .is-on -> gold
              color: i == active ? BisuColors.gold : const Color(0x40FFFFFF),
            ),
          ),
        ],
      ],
    );
  }
}

/// `.auth-link` — スキップ link on the night onboarding footer.
class _SkipLink extends StatelessWidget {
  const _SkipLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'スキップ',
          style: TextStyle(
            fontFamilyFallback: BisuType.sansFallback,
            fontSize: 12,
            letterSpacing: 0.48,
            color: BisuColors.goldDeep,
            decoration: TextDecoration.underline,
            decorationColor: BisuColors.goldDeep,
          ),
        ),
      ),
    );
  }
}
