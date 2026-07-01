import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// The guest gate shown on member-only tabs (mirrors `.login-notice` in
/// styles.css / `loginNotice(title, msg)` in app.js).
///
/// ```css
/// .login-notice{ margin:40px 10px; padding:30px 22px 26px; background:var(--paper);
///   border:1px solid var(--hair); border-radius:18px; text-align:center; }
/// .ln-ic{ width:40px; height:40px; stroke:var(--gold); stroke-width:1.4; }
/// .ln-title{ font-family:var(--serif); font-size:15px; }
/// .ln-msg{ font-size:11.5px; line-height:1.9; color:var(--ink-soft); }
/// .ln-btn{ width:100%; ... background:linear-gradient(120deg, var(--gold-deep), var(--gold)); }
/// ```
///
/// Used by [SubscriptionScreen] / [OrderHistoryScreen] for the
/// 定期情報/購入履歴 guest states. The button label is always
/// `ログイン / 新規登録`.
class LoginNotice extends StatelessWidget {
  const LoginNotice({
    super.key,
    required this.title,
    required this.message,
    required this.onLogin,
  });

  /// Heading (e.g. `定期情報はログインが必要です`).
  final String title;

  /// Body copy.
  final String message;

  /// Tapped when the login button is pressed.
  final VoidCallback onLogin;

  /// Lock glyph (`.ln-ic`) — verbatim path from `loginNotice` in app.js.
  static const String _lockSvg =
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" '
      'fill="none" stroke="#A8895A" stroke-width="1.4" '
      'stroke-linecap="round" stroke-linejoin="round">'
      '<rect x="5" y="11" width="14" height="9" rx="2"/>'
      '<path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: BisuColors.paper,
          border: Border.all(color: BisuColors.hair),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0F463C28), // rgba(70,60,40,.06)
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 30, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: SvgPicture.string(_lockSvg, width: 40, height: 40),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamilyFallback: <String>[
                    'Hiragino Mincho ProN',
                    'Yu Mincho',
                    'YuMincho',
                    'Noto Serif JP',
                    'Times New Roman',
                    'serif',
                  ],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: BisuColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.9,
                  color: BisuColors.inkSoft,
                ),
              ),
              const SizedBox(height: 18),
              BisuButton(
                label: 'ログイン / 新規登録',
                onPressed: onLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
