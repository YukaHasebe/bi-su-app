import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/member.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/screens/login_screen.dart';
import 'package:bisu_app/shared/swallow_svg.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

import 'package:bisu_app/features/membership_card/barcode_painter.dart';

/// Digital / temporary membership card (modal bottom sheet).
///
/// Faithful port of app.js `openQR()` (lines ~883–914) + `generateBarcodeSVG`
/// + the `.qr-*` / `.barcode-box` styles (styles.css ~673–715, 339–345).
///
/// Logged-in (会員): swallow emblem in the rank color + rank EN, title
/// 「デジタル会員証」, a barcode of `'BISU-' + MEMBER.no`, the 会員番号,
/// 「{name} 様」, an in-store hint, and a 閉じる button.
/// Guest (未ログイン): emblem in [BisuColors.inkFaint] (`#A39A88`) + `GUEST`,
/// title 「仮会員証」, a barcode of `'BISU-TEMP-' + tempNo`, 未登録ユーザー,
/// the guest hint, then a 「ログイン / 新規登録」 CTA (→ close + [LoginScreen])
/// followed by 閉じる.
class MembershipCardSheet extends StatelessWidget {
  const MembershipCardSheet({super.key});

  /// `.qr-card` background — `#FFFDF8` (warmer than [BisuColors.paper]).
  static const Color _cardColor = Color(0xFFFFFDF8);

  /// `.qr-rank-en` / `.qr-rankline svg` use the guest grey `#A39A88`.
  static const Color _guestEmblem = BisuColors.inkFaint;

  /// Opens the sheet as a modal bottom sheet (mirrors `openQR()` / `closeQR()`).
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0x00000000),
      // .qr-backdrop: rgba(12,11,9,.62)
      barrierColor: const Color(0x9E0C0B09),
      builder: (BuildContext sheetContext) => const MembershipCardSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.watch(context);
    final bool isGuest = !state.loggedIn;
    final Rank r = state.rank;
    const Member member = kMember;

    final String no = isGuest ? kStorePoints.tempNo : member.no;
    final String barcodeData = (isGuest ? 'BISU-TEMP-' : 'BISU-') + no;
    final Color emblemColor = isGuest ? _guestEmblem : r.color;
    final String rankEn = isGuest ? 'GUEST' : r.en;
    final String title = isGuest ? '仮会員証' : 'デジタル会員証';
    final String name = isGuest ? '未登録ユーザー' : '${member.name} 様';
    // .qr-hint copy (newlines mirror the <br> tags in openQR()).
    final String hint = isGuest
        ? '店舗でのポイント付与の際にご提示ください\n'
            'ログインすると正式な会員証になり、貯めたポイントを引き継げます\n'
            '（モックアップ用のダミーバーコードです）'
        : '店舗でのお会計・ポイント付与の際にご提示ください\n'
            '（モックアップ用のダミーバーコードです）';

    // .qr-card: left/right 18, bottom 26, radius 24, padding 24/22/20, centered.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 26),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const <BoxShadow>[
              // box-shadow:0 -10px 50px rgba(0,0,0,.4)
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0, -10),
                blurRadius: 50,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _Rankline(color: emblemColor, en: rankEn),
                const SizedBox(height: 2),
                // .qr-title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamilyFallback: BisuType.serifFallback,
                    fontSize: 16,
                    letterSpacing: 3.2, // .2em of 16px
                    color: BisuColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                _BarcodeBox(data: barcodeData),
                const SizedBox(height: 13),
                // .qr-no
                Text(
                  no,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamilyFallback: BisuType.sansFallback,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.98, // .18em of 11px
                    color: BisuColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 5),
                // .qr-name
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamilyFallback: BisuType.serifFallback,
                    fontSize: 14,
                    letterSpacing: 1.96, // .14em of 14px
                    color: BisuColors.ink,
                  ),
                ),
                const SizedBox(height: 11),
                // .qr-hint
                Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamilyFallback: BisuType.sansFallback,
                    fontSize: 9.5,
                    height: 1.8,
                    color: BisuColors.inkFaint,
                  ),
                ),
                if (isGuest) ...<Widget>[
                  const SizedBox(height: 14),
                  _LoginCta(
                    onTap: () {
                      // closeQR(); showLogin();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  // .qr-login-cta + .qr-close { margin-top:9px } — outlined close.
                  const SizedBox(height: 9),
                  _CloseButton(
                    outlined: true,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ] else ...<Widget>[
                  const SizedBox(height: 14),
                  _CloseButton(
                    outlined: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.qr-rankline`: centered emblem (30×24) + spaced serif EN label.
class _Rankline extends StatelessWidget {
  const _Rankline({required this.color, required this.en});

  final Color color;
  final String en;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SwallowEmblem(color: color, width: 30, height: 24),
        const SizedBox(width: 8),
        // .qr-rank-en — note CSS adds letter-spacing .3em + text-indent .3em,
        // so the spaced label is nudged right by one space's worth.
        Padding(
          padding: const EdgeInsets.only(left: 3.9), // text-indent .3em of 13px
          child: Text(
            en,
            style: const TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 13,
              letterSpacing: 3.9, // .3em of 13px
              color: BisuColors.goldDeep,
            ),
          ),
        ),
      ],
    );
  }
}

/// `.qr-box.barcode-box`: 240×90 white inset card holding the barcode.
class _BarcodeBox extends StatelessWidget {
  const _BarcodeBox({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 90,
        // .qr-box: white fill, hair border radius 16, inset + soft shadow.
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: BisuColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BisuColors.hair),
          boxShadow: const <BoxShadow>[
            // 0 4px 18px rgba(90,70,40,.12)
            BoxShadow(
              color: Color(0x1F5A4628),
              offset: Offset(0, 4),
              blurRadius: 18,
            ),
          ],
        ),
        child: CustomPaint(
          // .barcode-box content area: 240 - 32 wide, 90 - 20 tall.
          size: Size.infinite,
          painter: BarcodePainter(data: data),
        ),
      ),
    );
  }
}

/// `.qr-login-cta`: pale-gold gradient pill, dark ink text (guest only).
class _LoginCta extends StatelessWidget {
  const _LoginCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              // linear-gradient(120deg,#EBD9A8,#C6B484)
              begin: Alignment(-0.7, -1),
              end: Alignment(0.7, 1),
              colors: <Color>[Color(0xFFEBD9A8), Color(0xFFC6B484)],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 2.3), // text-indent .2em
                child: Text(
                  'ログイン / 新規登録',
                  style: TextStyle(
                    fontFamilyFallback: BisuType.sansFallback,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.3, // .2em of 11.5px
                    color: BisuColors.night, // #10100E
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.qr-close`: full-width pill.
///
/// Default (member, standalone) = gold gradient + white text. When it follows
/// the login CTA (guest), CSS makes it transparent with an [BisuColors.inkSoft]
/// label and a [BisuColors.hair] border ([outlined] = true).
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.outlined, required this.onTap});

  final bool outlined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Widget label = Padding(
      padding: EdgeInsets.only(left: 3.45), // text-indent .3em of 11.5px
      child: Text(
        '閉じる',
        style: TextStyle(
          fontFamilyFallback: BisuType.sansFallback,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 3.45, // .3em of 11.5px
          color: BisuColors.white,
        ),
      ),
    );

    if (outlined) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: const Color(0x00000000),
              border: Border.all(color: BisuColors.hair),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 3.45),
                  child: Text(
                    '閉じる',
                    style: TextStyle(
                      fontFamilyFallback: BisuType.sansFallback,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.45,
                      color: BisuColors.inkSoft,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              // linear-gradient(120deg, var(--gold-deep), var(--gold))
              begin: Alignment(-0.7, -1),
              end: Alignment(0.7, 1),
              colors: <Color>[BisuColors.goldDeep, BisuColors.gold],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Center(child: label),
          ),
        ),
      ),
    );
  }
}
