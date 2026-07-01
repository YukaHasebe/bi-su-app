import 'package:flutter/material.dart';

import 'package:bisu_app/models/member.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// The settings-screen profile card (mirrors `.card.profile-card` in
/// styles.css / `renderSettings`).
///
/// ```css
/// .profile-card{ display:flex; align-items:center; gap:14px; padding:16px; }
/// .avatar{ width:52px; height:52px; border-radius:99px; font-family:var(--serif);
///   font-size:18px; color:#FFF; background:linear-gradient(135deg, var(--rank), var(--rank-soft)); }
/// .profile-guest{ background:#F3F0E9; }
/// .avatar-guest{ background:linear-gradient(135deg,#B6AE9E,#D6CDBA); }
/// ```
///
/// Member view: rank-gradient avatar (initials) + `{name} 様` + 会員番号 / mail・since.
/// Guest view ([guest] = true): grey avatar (`G`) + `未ログイン` + a prompt to log in.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.member,
    required this.rank,
    this.guest = false,
  });

  /// Member profile (ignored except for [Member.initials]/[Member.name] etc.
  /// in the member view).
  final Member member;

  /// Current rank — drives the avatar gradient in the member view.
  final Rank rank;

  /// Render the未ログイン (guest) variant.
  final bool guest;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: guest ? const Color(0xFFF3F0E9) : BisuColors.paper,
        border: Border.all(color: BisuColors.hair),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F463C28), // rgba(70,60,40,.06)
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            _Avatar(rank: rank, guest: guest, initials: member.initials),
            const SizedBox(width: 14),
            Expanded(
              child: guest ? _guestText() : _memberText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${member.name} 様',
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.87, // ~.06em of 14.5px
            color: BisuColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '会員番号 ${member.no}\n${member.mail}・${member.since}ご入会',
          style: const TextStyle(
            fontSize: 10,
            color: BisuColors.inkSoft,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _guestText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '未ログイン',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.87,
            color: BisuColors.ink,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'ログインすると会員情報・通知設定・定期情報・購入履歴をご利用いただけます',
          style: TextStyle(
            fontSize: 10,
            color: BisuColors.inkSoft,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.rank,
    required this.guest,
    required this.initials,
  });

  final Rank rank;
  final bool guest;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = guest
        ? const <Color>[Color(0xFFB6AE9E), Color(0xFFD6CDBA)]
        : <Color>[rank.color, rank.soft];
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft, // 135deg
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Text(
        guest ? 'G' : initials,
        style: const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Mincho ProN',
            'Yu Mincho',
            'YuMincho',
            'Noto Serif JP',
            'Times New Roman',
            'serif',
          ],
          fontSize: 18,
          color: BisuColors.white,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}
