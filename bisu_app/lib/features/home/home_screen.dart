import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/member.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/screens/club_program_screen.dart';
import 'package:bisu_app/screens/login_screen.dart';
import 'package:bisu_app/screens/membership_card_sheet.dart';
import 'package:bisu_app/screens/tbd_screen.dart';
import 'package:bisu_app/shared/format.dart';
import 'package:bisu_app/shared/swallow_svg.dart';
import 'package:bisu_app/shared/widgets/glass_card.dart';
import 'package:bisu_app/shared/widgets/progress_bar.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// HOME / STATUS tab (mockup `#screen-home`, renderHome 446–544).
///
/// A PLAIN scrollable widget (no Scaffold of its own) hosted by RootScaffold.
/// Night background tinted by the current rank, the membership-status hero
/// (emblem + rank EN/JP/place), and the bottom card stack. Two states driven
/// by [AppState.loggedIn]:
///  - member: progress card + BI-SU points card + store-points card + the
///    CLUB MEMBERS PROGRAM link.
///  - guest: a brand visual ("ようこそ") + connect-CTA card + store-points card
///    (guest balance); the member-only cards are hidden.
///
/// The header carries the membership-card button (`#qr-btn`) which opens
/// [MembershipCardSheet] via `showModalBottomSheet`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.watch(context);
    final Rank r = s.rank;
    final bool loggedIn = s.loggedIn;

    // .home-content padding: calc(var(--status-h) + 6px) 18px calc(var(--tabbar-h) + 18px)
    const double topPad = BisuMetrics.statusBarHeight + 6;
    const double bottomPad = BisuMetrics.tabBarHeight + 18;

    return DecoratedBox(
      // .screen-home{ background:var(--night); }
      decoration: const BoxDecoration(color: BisuColors.night),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // .home-bg — gradient band tinted by the rank color (video capture
          // not required; the rank tint reproduces the journey ambience).
          _HomeBackground(rank: r),
          // .home-scrim — top + bottom darkening so text stays legible.
          const _HomeScrim(),
          // .home-content
          SafeArea(
            top: false,
            bottom: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewport) {
                // .home-content is a full-height flex column; .home-cards uses
                // margin-top:auto so the card stack sits at the bottom. We pin
                // the content to the viewport height and space-between the
                // top group (header+hero) and the bottom card stack.
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: viewport.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, topPad, 18, bottomPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Top group: .home-top + .home-hero
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _HomeHeader(),
                              const SizedBox(height: 34),
                              _HomeHero(rank: r, loggedIn: loggedIn),
                            ],
                          ),
                          // Bottom group: .home-cards
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: _HomeCards(
                              rank: r,
                              loggedIn: loggedIn,
                              storePoints: s.storePoints,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Background + scrim
// =============================================================================

/// `.home-bg` — a rank-tinted vertical gradient over the night base.
///
/// The mockup paints an animated journey scene/video here; the brief directs a
/// gradient tinted by the rank color instead (video capture not required). The
/// rank's soft tint sits high (sky/light), fading to night at the bottom.
class _HomeBackground extends StatelessWidget {
  const _HomeBackground({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            // Soft rank wash up top (kept dim so it reads as ambience).
            Color.lerp(rank.soft, BisuColors.night, 0.42)!,
            Color.lerp(rank.color, BisuColors.night, 0.62)!,
            BisuColors.night,
          ],
          stops: const <double>[0.0, 0.45, 0.92],
        ),
      ),
      // Centered radial halo in the rank color behind the hero emblem.
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.42), // ~42% from top (focus origin)
            radius: 0.9,
            colors: <Color>[
              rank.color.withValues(alpha: 0.30),
              rank.color.withValues(alpha: 0.0),
            ],
            stops: const <double>[0.0, 0.7],
          ),
        ),
      ),
    );
  }
}

/// `.home-scrim` — two stacked linear gradients darkening top & bottom.
class _HomeScrim extends StatelessWidget {
  const _HomeScrim();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // linear-gradient(180deg, rgba(8,9,10,.52)0%, .28@30%, 0@54%)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x85080A0A), // rgba(8,9,10,.52)
                  Color(0x47080A0A), // rgba(8,9,10,.28)
                  Color(0x00080A0A),
                ],
                stops: <double>[0.0, 0.30, 0.54],
              ),
            ),
          ),
          // linear-gradient(0deg, rgba(8,9,10,.62)0%, .18@34%, 0@55%)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  Color(0x9E080A0A), // rgba(8,9,10,.62)
                  Color(0x2E080A0A), // rgba(8,9,10,.18)
                  Color(0x00080A0A),
                ],
                stops: <double>[0.0, 0.34, 0.55],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Header (.home-top)  — QR button + white logo + spacer
// =============================================================================

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // #qr-btn -> MembershipCardSheet.show
        const _QrButton(),
        // .home-logo (white logo, width 92)
        Image.asset(
          'assets/images/logo_w.png',
          width: 92,
          fit: BoxFit.contain,
          errorBuilder: (BuildContext c, Object e, StackTrace? st) {
            // Fallback wordmark if the binary is missing.
            return const Text(
              'BI-SU',
              style: TextStyle(
                fontFamilyFallback: BisuType.serifFallback,
                fontSize: 20,
                letterSpacing: 4,
                color: Color(0xFFF8F2E4),
              ),
            );
          },
        ),
        // .home-top-spacer (width 64) — balances the qr button.
        const SizedBox(width: 64),
      ],
    );
  }
}

/// `.qr-btn` — frosted icon button opening the membership card sheet.
class _QrButton extends StatelessWidget {
  const _QrButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => MembershipCardSheet.show(context),
      child: Container(
        width: 64,
        padding: const EdgeInsets.fromLTRB(0, 9, 0, 7),
        decoration: BoxDecoration(
          color: const Color(0x5C10100E), // rgba(16,16,14,.36)
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x47FFFFFF)), // rgba(255,255,255,.28)
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x40000000), // rgba(0,0,0,.25)
              blurRadius: 18,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.qr_code_2,
              size: 22,
              color: Color(0xFFF3ECDC),
            ),
            SizedBox(height: 3),
            Text(
              '会員証',
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.26, // .14em of 9px
                color: Color(0xFFF3ECDC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Hero (.home-hero) — emblem + status label + rank EN / JP / place
// =============================================================================

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.rank, required this.loggedIn});

  final Rank rank;
  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    // Guest: brand wordmark "BI-SU" / "Member's App"; member: rank EN / JP.
    final String enText = loggedIn ? rank.en : 'BI-SU';
    final String jpText = loggedIn ? rank.jp : "Member's App";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // .member-emblem (64x50). Flat swallow tinted by rank.soft (matches
        // renderHome's flat fallback: swallowSVG(r.soft)).
        _HeroEmblem(rank: rank),
        const SizedBox(height: 8),
        // .home-status-label
        const Text(
          'MEMBERSHIP STATUS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 9,
            letterSpacing: 4.14, // .46em of 9px
            color: Color(0x99FFFFFF), // rgba(255,255,255,.6)
          ),
        ),
        const SizedBox(height: 6),
        // .home-rank-en
        Text(
          enText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 40,
            height: 1.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 12, // .3em of 40px
            color: Color(0xFFF8F2E4),
            shadows: <Shadow>[
              Shadow(
                color: Color(0x8C000000), // rgba(0,0,0,.55)
                blurRadius: 26,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // .home-rank-jp
        Text(
          jpText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 12,
            letterSpacing: 5.04, // .42em of 12px
            color: Color(0xD9F8F2E4), // rgba(248,242,228,.85)
          ),
        ),
        const SizedBox(height: 14),
        // .home-place
        Text(
          rank.place,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 9.5,
            letterSpacing: 3.23, // .34em of 9.5px
            color: Color(0x80FFFFFF), // rgba(255,255,255,.5)
          ),
        ),
      ],
    );
  }
}

/// `.member-emblem` (64×50) — flat swallow tinted by the soft rank color.
///
/// The CSS uses `filter: drop-shadow(0 3px 12px rgba(0,0,0,.45))`, which follows
/// the swallow alpha. We approximate it shape-faithfully by stacking a blurred
/// dark copy of the same SVG (offset down) under the soft-tinted emblem.
class _HeroEmblem extends StatelessWidget {
  const _HeroEmblem({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Shape-following soft shadow (blurred dark swallow, offset 0,3).
          Positioned(
            left: 0,
            top: 3,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: const SwallowEmblem(
                color: Color(0xFF000000),
                opacity: 0.45, // rgba(0,0,0,.45)
                width: 64,
                height: 50,
              ),
            ),
          ),
          // Shared swallow source, filled with the SOFT rank color to match
          // renderHome's flat fallback `swallowSVG(r.soft)`.
          SwallowEmblem(
            color: rank.soft,
            width: 64,
            height: 50,
            semanticLabel: '${rank.en} emblem',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Cards (.home-cards)
// =============================================================================

class _HomeCards extends StatelessWidget {
  const _HomeCards({
    required this.rank,
    required this.loggedIn,
    required this.storePoints,
  });

  final Rank rank;
  final bool loggedIn;
  final int storePoints;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    // .home-name
    children.add(_HomeName(loggedIn: loggedIn));
    children.add(const SizedBox(height: 10));

    if (!loggedIn) {
      // ===== Guest: connect CTA + store-points (guest balance) =====
      children.add(_GuestCtaCard(
        onLogin: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        ),
      ));
      children.add(const SizedBox(height: 10));
      children.add(_StorePointsCard(
        balance: storePoints,
        loggedIn: false,
        onTap: () => _openStorePoints(context),
      ));
      // member-only cards (progress / points / club link) hidden for guests.
    } else {
      // ===== Member (logged-in) =====
      children.add(_ProgressCard(rank: rank));
      children.add(const SizedBox(height: 10));
      children.add(_PointsCard(rank: rank));
      children.add(const SizedBox(height: 10));
      children.add(_StorePointsCard(
        balance: storePoints,
        loggedIn: true,
        onTap: () => _openStorePoints(context),
      ));
      children.add(const SizedBox(height: 10));
      // .home-club-link -> ClubProgramScreen
      children.add(_ClubLink(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ClubProgramScreen()),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  void _openStorePoints(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const TbdScreen(kind: TbdKind.storepoint),
      ),
    );
  }
}

/// `.home-name` — `{name} 様` (member) or `ようこそ` (guest).
class _HomeName extends StatelessWidget {
  const _HomeName({required this.loggedIn});

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    const Color base = Color(0xEBFFFFFF); // rgba(255,255,255,.92)
    const List<Shadow> shadows = <Shadow>[
      Shadow(
        color: Color(0x80000000), // rgba(0,0,0,.5)
        blurRadius: 12,
        offset: Offset(0, 1),
      ),
    ];

    if (!loggedIn) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
        child: Text(
          'ようこそ',
          style: TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 14,
            letterSpacing: 2.52, // .18em of 14px
            color: base,
            shadows: shadows,
          ),
        ),
      );
    }

    const Member m = kMember;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(text: m.name),
            const TextSpan(
              text: ' 様',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xA6FFFFFF), // rgba(255,255,255,.65)
              ),
            ),
          ],
        ),
        style: const TextStyle(
          fontFamilyFallback: BisuType.serifFallback,
          fontSize: 14,
          letterSpacing: 2.52,
          color: base,
          shadows: shadows,
        ),
      ),
    );
  }
}

// ----- Reusable glass-card row primitives (.gp-row / .gp-label / .gp-value) --

/// `.gp-row` — label left, value right (CSS `align-items:baseline`; we use
/// centre alignment to stay robust with pill-shaped value widgets).
class _GpRow extends StatelessWidget {
  const _GpRow({required this.label, required this.value, this.topMargin = 0});

  final Widget label;
  final Widget value;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: label),
          const SizedBox(width: 10),
          value,
        ],
      ),
    );
  }
}

/// `.gp-label` — small spaced caption.
class _GpLabel extends StatelessWidget {
  const _GpLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamilyFallback: BisuType.sansFallback,
        fontSize: 10,
        letterSpacing: 2.0, // .2em of 10px
        fontWeight: FontWeight.w600,
        color: Color(0x9EFFFFFF), // rgba(255,255,255,.62)
      ),
    );
  }
}

/// `.gp-value` — serif value, optional `<small>` suffix (e.g. `pt`).
class _GpValue extends StatelessWidget {
  const _GpValue(this.value, {this.suffix});

  final String value;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: value),
          if (suffix != null)
            TextSpan(
              text: suffix,
              style: const TextStyle(fontSize: 11),
            ),
        ],
      ),
      style: const TextStyle(
        fontFamilyFallback: BisuType.serifFallback,
        fontSize: 17,
        letterSpacing: 1.02, // .06em of 17px
        color: Color(0xFFF8F2E4),
      ),
    );
  }
}

/// Progress glass card: 年間ご購入金額 + ProgressBar + next-rank label.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _GpRow(
            label: const _GpLabel('年間ご購入金額'),
            value: _GpValue(yen(rank.annual)),
          ),
          // .gp-bar (margin-top:10) — rank gradient, glow, night track.
          const SizedBox(height: 10),
          ProgressBar(
            percent: rank.progressPct,
            fillColor: rank.color,
            fillSoft: rank.soft,
            trackColor: const Color(0x2EFFFFFF), // rgba(255,255,255,.18)
            height: 4,
            glow: true,
          ),
          // .gp-next (margin-top:8) — next-rank remaining (bold figure) or
          // top-tier thanks. Bold span uses .gp-next b color #F2E3BC.
          const SizedBox(height: 8),
          _GpNext(rank: rank),
        ],
      ),
    );
  }
}

/// `.gp-next` — renders `翌年 {EN} まであと <b>¥…</b>` (bold figure) or the
/// top-tier thank-you, matching renderHome exactly.
class _GpNext extends StatelessWidget {
  const _GpNext({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    const TextStyle base = TextStyle(
      fontFamilyFallback: BisuType.sansFallback,
      fontSize: 10.5,
      height: 1.5,
      letterSpacing: 0.42, // .04em of 10.5px
      color: Color(0xA8FFFFFF), // rgba(255,255,255,.66)
    );

    final Rank? nx = rank.nextRank;
    if (nx == null) {
      return const Text(
        '最上位ステータスのお客様です。いつもありがとうございます。',
        style: base,
      );
    }
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: '翌年 ${nx.en} まであと '),
          TextSpan(
            text: yen(nx.threshold - rank.annual),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2E3BC), // .gp-next b
            ),
          ),
        ],
      ),
      style: base,
    );
  }
}

/// BI-SU points glass card: 残高 + 還元率タグ.
class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _GpRow(
            label: const _GpLabel('BI-SUポイント残高'),
            value: _GpValue(thousands(rank.points), suffix: 'pt'),
          ),
          // second row (margin-top:9): いまの還元率 + .gp-rate tag
          _GpRow(
            topMargin: 9,
            label: const _GpLabel('いまの還元率'),
            value: _RateTag(rank: rank),
          ),
        ],
      ),
    );
  }
}

/// `.gp-rate` — pill with the rank gradient, `100円 = {rate}pt`.
class _RateTag extends StatelessWidget {
  const _RateTag({required this.rank});

  final Rank rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topLeft, // 120deg-ish
          end: Alignment.bottomRight,
          colors: <Color>[rank.soft, rank.color],
        ),
      ),
      child: Text(
        '100円 = ${rank.rate}pt',
        style: const TextStyle(
          fontFamilyFallback: BisuType.sansFallback,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.95, // .1em of 9.5px
          color: Color(0xFF10100E),
        ),
      ),
    );
  }
}

/// Store-points glass card (member + guest). Tappable -> TbdScreen storepoint.
class _StorePointsCard extends StatelessWidget {
  const _StorePointsCard({
    required this.balance,
    required this.loggedIn,
    required this.onTap,
  });

  final int balance;
  final bool loggedIn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _GpRow(
              label: const _GpLabel('店舗ポイント残高'),
              value: _GpValue(thousands(balance), suffix: 'pt'),
            ),
            _GpRow(
              topMargin: 9,
              label: const _GpNextPlain('来店・店頭購入で付与'),
              value: _StoreTag(loggedIn: loggedIn),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.gp-next` styled inline note used as a row label (no top margin).
class _GpNextPlain extends StatelessWidget {
  const _GpNextPlain(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamilyFallback: BisuType.sansFallback,
        fontSize: 10.5,
        letterSpacing: 0.42,
        color: Color(0xA8FFFFFF), // rgba(255,255,255,.66)
      ),
    );
  }
}

/// `.gp-store-tag` — frosted pill: 会員ポイント / 仮会員ポイント.
class _StoreTag extends StatelessWidget {
  const _StoreTag({required this.loggedIn});

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0x1FFFFFFF), // rgba(255,255,255,.12)
        border: Border.all(color: const Color(0x38FFFFFF)), // rgba(255,255,255,.22)
      ),
      child: Text(
        loggedIn ? '会員ポイント' : '仮会員ポイント',
        style: const TextStyle(
          fontFamilyFallback: BisuType.sansFallback,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.72, // .08em of 9px
          color: Color(0xFFEFDDB4),
        ),
      ),
    );
  }
}

/// `.glass-cta` — guest connect card (会員ステータスを表示 + desc + CTA button).
class _GuestCtaCard extends StatelessWidget {
  const _GuestCtaCard({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // .cta-title
          const Text(
            '会員ステータスを表示',
            style: TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 14,
              letterSpacing: 1.4, // .1em of 14px
              color: Color(0xFFF8F2E4),
            ),
          ),
          // .cta-desc (margin-top:7)
          const SizedBox(height: 7),
          const Text(
            'ログインすると、ランク・ポイント・定期情報・購入履歴をご確認いただけます。',
            style: TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 10.5,
              height: 1.8,
              color: Color(0xB8FFFFFF), // rgba(255,255,255,.72)
            ),
          ),
          // .cta-btn (margin-top:13) — gold gradient pill.
          const SizedBox(height: 13),
          _CtaButton(label: 'ログイン / 新規登録', onTap: onLogin),
        ],
      ),
    );
  }
}

/// `.cta-btn` — full-width gold-gradient pill (guest login CTA).
class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, // 120deg
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFEBD9A8), Color(0xFFC6B484)],
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamilyFallback: BisuType.sansFallback,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.16, // .18em of 12px
            color: Color(0xFF10100E),
          ),
        ),
      ),
    );
  }
}

/// `.home-club-link` — frosted outline pill -> ClubProgramScreen.
class _ClubLink extends StatelessWidget {
  const _ClubLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: const Color(0x4D10100E), // rgba(16,16,14,.30)
          border: Border.all(color: const Color(0x4DFFFFFF)), // rgba(255,255,255,.30)
        ),
        child: const Text(
          'CLUB MEMBERS PROGRAM',
          style: TextStyle(
            fontFamilyFallback: BisuType.serifFallback,
            fontSize: 10.5,
            letterSpacing: 2.73, // .26em of 10.5px
            color: Color(0xFFEFDDB4),
          ),
        ),
      ),
    );
  }
}
