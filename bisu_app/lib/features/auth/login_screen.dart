import 'package:flutter/material.dart';

import 'package:bisu_app/features/auth/auth_code_screen.dart';
import 'package:bisu_app/root_scaffold.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/shared/widgets/bisu_text_field.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// ログイン (SCR-010) — mirrors `#screen-login` (index.html) + `showLogin`
/// (app.js 917-921).
///
/// `.auth-overlay` ivory background, BI-SU logo, a single text field
/// prefilled with the demo email, a gold-gradient submit button that opens
/// [AuthCodeScreen], 利用規約/プライバシーポリシー consent copy, and an
/// 「あとで」 link that drops the user into the app as a guest.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // showLogin(): #login-input value = 'y-hasebe@mstyle-j.co.jp'
  final TextEditingController _controller =
      TextEditingController(text: 'y-hasebe@mstyle-j.co.jp');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // login-submit -> showAuthCode
  void _submit() {
    // showAuthCode() masks `#login-input` (default 'y-hasebe@mstyle-j.co.jp').
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AuthCodeScreen(),
      ),
    );
  }

  // login-skip -> setLoggedIn(false); hideLogin(); finishSplash()
  void _skip() {
    AppScope.of(context).setLoggedIn(false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const RootScaffold()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // .auth-overlay{ background:var(--ivory); }
      backgroundColor: BisuColors.ivory,
      body: SafeArea(
        // .auth-body{ flex:1; align-items:center; padding:0 28px; overflow-y:auto; }
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // .auth-logo{ width:64px; margin-top:80px; margin-bottom:28px; }
              const SizedBox(height: 80),
              Image.asset(
                'assets/images/logo.png',
                width: 64,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 64,
                  height: 64,
                ),
              ),
              const SizedBox(height: 28),
              // .auth-title — ログイン
              const Text(
                'ログイン',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamilyFallback: BisuType.serifFallback,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2, // ~.1em
                  color: BisuColors.ink,
                ),
              ),
              // .auth-desc{ margin-top:12px; }
              const SizedBox(height: 12),
              const Text(
                'メールアドレスまたは電話番号を\n入力してください',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamilyFallback: BisuType.sansFallback,
                  fontSize: 12.5,
                  height: 1.9,
                  color: BisuColors.inkSoft,
                ),
              ),
              // .auth-field{ width:100%; margin-top:32px; }
              const SizedBox(height: 32),
              BisuTextField(
                controller: _controller,
                hintText: 'メールアドレスまたは電話番号',
                keyboardType: TextInputType.emailAddress,
              ),
              // .auth-btn{ margin-top:24px; } — 認証コードを送信
              const SizedBox(height: 24),
              BisuButton(
                label: '認証コードを送信',
                onPressed: _submit,
              ),
              // .auth-terms{ margin-top:20px; }
              const SizedBox(height: 20),
              const _TermsText(),
              // .auth-skip{ margin-top:24px; } — あとで
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _skip,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'あとで',
                    style: TextStyle(
                      fontFamilyFallback: BisuType.sansFallback,
                      fontSize: 14,
                      letterSpacing: 1.4, // ~.1em
                      color: BisuColors.inkFaint,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

/// 利用規約 / プライバシーポリシー consent copy (`.auth-terms`).
///
/// The links are inert in the mockup (`href="javascript:void(0)"`), so they
/// are rendered as underlined gold-deep inline spans without navigation.
class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    const TextStyle base = TextStyle(
      fontFamilyFallback: BisuType.sansFallback,
      fontSize: 9.5,
      height: 1.8,
      color: BisuColors.inkFaint,
    );
    const TextStyle link = TextStyle(
      fontFamilyFallback: BisuType.sansFallback,
      fontSize: 9.5,
      height: 1.8,
      color: BisuColors.goldDeep,
      decoration: TextDecoration.underline,
      decorationColor: BisuColors.goldDeep,
    );
    return const Text.rich(
      TextSpan(
        style: base,
        children: <InlineSpan>[
          TextSpan(text: 'ログインすることで'),
          TextSpan(text: '利用規約', style: link),
          TextSpan(text: 'と'),
          TextSpan(text: 'プライバシーポリシー', style: link),
          TextSpan(text: 'に同意したものとみなされます'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
