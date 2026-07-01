import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bisu_app/features/auth/brand_story_screen.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/shared/widgets/code_input.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// 認証コード入力 (SCR-011) — mirrors `#screen-authcode` (index.html) +
/// `showAuthCode` / `startCountdown` / `handleCodeDigit` (app.js 925-981).
///
/// Shows the masked destination, a 6-digit [CodeInput], a 120s resend
/// countdown (`MM:SS 後に再送可能` → `再送できます`), a 認証コードを再送する
/// link (enabled once the countdown ends), and a 認証する button enabled only
/// when all six digits are filled. Submitting opens [BrandStoryScreen]
/// (first-run, `review: false`); the back arrow returns to the login screen.
class AuthCodeScreen extends StatefulWidget {
  const AuthCodeScreen({super.key});

  @override
  State<AuthCodeScreen> createState() => _AuthCodeScreenState();
}

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  // showAuthCode(): masks `#login-input` (default 'y-hasebe@mstyle-j.co.jp').
  static const String _email = 'y-hasebe@mstyle-j.co.jp';

  Timer? _timer;
  int _seconds = 120;
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// startCountdown(): 120s tick; resend disabled until it reaches 0.
  void _startCountdown() {
    _timer?.cancel();
    setState(() => _seconds = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_seconds <= 0) {
        t.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  bool get _canResend => _seconds <= 0;

  // var masked = val.charAt(0) + '***' + val.substring(val.indexOf('@'));
  String get _maskedEmail {
    final int at = _email.indexOf('@');
    if (at > 0) {
      return '${_email[0]}***${_email.substring(at)}';
    }
    if (_email.length > 7) {
      return '${_email.substring(0, 3)}****'
          '${_email.substring(_email.length - 4)}';
    }
    return _email;
  }

  // el.textContent = MM:SS + ' 後に再送可能' / '再送できます'
  String get _countdownText {
    if (_seconds <= 0) return '再送できます';
    final int m = _seconds ~/ 60;
    final int s = _seconds % 60;
    final String mm = m < 10 ? '0$m' : '$m';
    final String ss = s < 10 ? '0$s' : '$s';
    return '$mm:$ss 後に再送可能';
  }

  void _onCodeChanged(String code) {
    final bool filled = code.length == 6;
    if (filled != _filled) {
      setState(() => _filled = filled);
    }
  }

  // authcode-submit -> openBrandStory(false)
  void _submit() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BrandStoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // .auth-overlay{ background:var(--ivory); }
      backgroundColor: BisuColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // .auth-header{ padding:(status+10) 18 0; } — back arrow
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _BackButton(
                  // authcode-back -> hideAuthCode(); showLogin()
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Expanded(
              // .auth-body{ align-items:center; padding:0 28px; overflow-y:auto; }
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 36),
                    // .auth-title — 認証コード入力
                    const Text(
                      '認証コード入力',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamilyFallback: BisuType.serifFallback,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.2, // ~.1em
                        color: BisuColors.ink,
                      ),
                    ),
                    // .auth-desc — masked + に\n認証コードを送信しました
                    const SizedBox(height: 12),
                    Text(
                      '$_maskedEmail に\n認証コードを送信しました',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamilyFallback: BisuType.sansFallback,
                        fontSize: 12.5,
                        height: 1.9,
                        color: BisuColors.inkSoft,
                      ),
                    ),
                    // .code-boxes{ margin-top:28px; }
                    const SizedBox(height: 28),
                    CodeInput(
                      length: 6,
                      onChanged: _onCodeChanged,
                      onCompleted: _onCodeChanged,
                    ),
                    // .auth-countdown{ margin-top:20px; }
                    const SizedBox(height: 20),
                    Text(
                      _countdownText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamilyFallback: BisuType.sansFallback,
                        fontSize: 11,
                        letterSpacing: 0.88, // ~.08em
                        fontFeatures: <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                        color: BisuColors.inkFaint,
                      ),
                    ),
                    // .auth-link (resend) — 認証コードを再送する; disabled until 0
                    const SizedBox(height: 14),
                    _AuthLink(
                      label: '認証コードを再送する',
                      // authcode-resend -> startCountdown
                      onTap: _canResend ? _startCountdown : null,
                    ),
                    // .auth-btn{ margin-top:24px; } — 認証する; disabled until 6
                    const SizedBox(height: 24),
                    BisuButton(
                      label: '認証する',
                      onPressed: _filled ? _submit : null,
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.auth-back` — 36px circular back chevron (stroked SVG path `M15 19l-7-7 7-7`).
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            Icons.chevron_left,
            size: 24,
            color: BisuColors.ink,
          ),
        ),
      ),
    );
  }
}

/// `.auth-link` — underlined gold-deep text link; `disabled` greys out and
/// drops the underline (`.auth-link:disabled`).
class _AuthLink extends StatelessWidget {
  const _AuthLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 12,
              letterSpacing: 0.48, // ~.04em
              color: enabled ? BisuColors.goldDeep : BisuColors.inkFaint,
              decoration:
                  enabled ? TextDecoration.underline : TextDecoration.none,
              decorationColor: BisuColors.goldDeep,
            ),
          ),
        ),
      ),
    );
  }
}
