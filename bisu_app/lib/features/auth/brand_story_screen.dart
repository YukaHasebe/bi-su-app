import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/features/auth/onboarding_screen.dart';
import 'package:bisu_app/shared/swallow_svg.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// ブランドストーリー (SCR-002 初回紹介 / SCR-505 再閲覧) — mirrors
/// `#screen-story` (index.html) + `openBrandStory` (app.js 1129-1157).
///
/// Three-page swipeable story with paging dots. The trailing button is
/// 次へ until the last page, then はじめる (first-run) or 閉じる (review). A
/// スキップ link finishes immediately. First-run finish opens
/// [OnboardingScreen]; review-mode finish pops back.
class BrandStoryScreen extends StatefulWidget {
  const BrandStoryScreen({super.key, this.review = false});

  /// SCR-505 re-view mode: last button is 閉じる and finishing pops back
  /// instead of advancing to onboarding.
  final bool review;

  @override
  State<BrandStoryScreen> createState() => _BrandStoryScreenState();
}

class _BrandStoryScreenState extends State<BrandStoryScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // nextBrandStory(): last page -> finish; else advance.
  void _next() {
    if (_page >= _StoryPages.pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // finishBrandStory(): review -> pop; first-run -> showOnboarding().
  void _finish() {
    if (widget.review) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _page >= _StoryPages.pages.length - 1;
    // story-next text: last ? (review ? '閉じる' : 'はじめる') : '次へ'
    final String buttonLabel =
        isLast ? (widget.review ? '閉じる' : 'はじめる') : '次へ';

    return Scaffold(
      // #screen-story is `.auth-overlay` — ivory background.
      backgroundColor: BisuColors.ivory,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // .ob-pages{ flex:1; } — swipeable story pages.
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _StoryPages.pages.length,
                onPageChanged: (int i) => setState(() => _page = i),
                itemBuilder: (_, int i) => _StoryPages.pages[i],
              ),
            ),
            // .ob-footer{ padding:0 28 40; gap:12; }
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // .ob-dots
                  _Dots(count: _StoryPages.pages.length, active: _page),
                  const SizedBox(height: 8),
                  BisuButton(label: buttonLabel, onPressed: _next),
                  const SizedBox(height: 12),
                  // .auth-link — スキップ (story-skip -> closeBrandStory)
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

/// The three story pages, copied verbatim from `#story-pages` (index.html).
class _StoryPages {
  const _StoryPages._();

  static const List<Widget> pages = <Widget>[
    _StoryPage(
      visual: _StoryLogo(),
      title: '自然への敬意から、\nBI-SUは生まれました',
      desc: 'アナツバメを傷つけず、自然と共生する。\n'
          '天然アナツバメの巣の可能性を、\n科学的根拠とともに世界へ届けます。',
    ),
    _StoryPage(
      // story-emblem: swallowSVG('#C6B484')
      visual: _StoryEmblem(),
      title: 'ボルネオの聖域から',
      desc: '手つかずの熱帯雨林、洞窟の奥深く。\n'
          'アナツバメが育む「巣」を、\n自然の循環を守りながら大切にいただきます。',
    ),
    _StoryPage(
      visual: _StoryFutureIcon(),
      title: '人と動物の\n未来のために',
      desc: '人の美しさと健やかさ、\n'
          'そして愛犬・愛猫の毎日に寄り添う。\nBI-SUは、その未来を見つめています。',
    ),
  ];
}

/// A single `.ob-page.story-page` — centered visual + serif title + body.
class _StoryPage extends StatelessWidget {
  const _StoryPage({
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
          // .ob-title — serif on ivory (uses --ink, not the night #F5EEDF).
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.65,
              letterSpacing: 2.64, // ~.12em
              color: BisuColors.ink,
            ),
          ),
          // .ob-desc{ margin-top:14px; }
          const SizedBox(height: 14),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 12,
              height: 2,
              letterSpacing: 0.48, // ~.04em
              color: BisuColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// `.ob-logo` — the BI-SU wordmark (`logo_w.png`).
class _StoryLogo extends StatelessWidget {
  const _StoryLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_w.png',
      width: 80,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80),
    );
  }
}

/// `#story-emblem` — the swallow emblem in champagne `#C6B484`.
class _StoryEmblem extends StatelessWidget {
  const _StoryEmblem();

  @override
  Widget build(BuildContext context) {
    // .story-emblem{ width:90px; height:70px; }
    return const SwallowEmblem(
      color: Color(0xFFC6B484),
      width: 90,
      height: 70,
    );
  }
}

/// `.ob-icon` page-2 SVG (human-and-animal future motif), gold stroke.
class _StoryFutureIcon extends StatelessWidget {
  const _StoryFutureIcon();

  // Copied verbatim from index.html story page data-page="2".
  static const String _svg =
      '<svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="40" cy="40" r="38" fill="none" stroke="#A8895A" stroke-width="1.2"/>'
      '<path d="M26 46c4-10 8-16 14-16s10 6 14 16M30 40h20" stroke="#A8895A" '
      'stroke-width="1.4" fill="none" stroke-linecap="round"/></svg>';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: 80, height: 80);
  }
}

/// `.ob-dots` — pill paging indicator (active dot widens to 22px, gold).
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
              // On the ivory story screen the inactive dots use hair, not the
              // night-screen rgba(255,255,255,.25).
              color: i == active ? BisuColors.gold : BisuColors.hair,
            ),
          ),
        ],
      ],
    );
  }
}

/// `.auth-link` — スキップ link rendered on the ivory story footer.
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
