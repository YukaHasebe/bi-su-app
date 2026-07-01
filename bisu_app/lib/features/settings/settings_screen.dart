import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/member.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/screens/brand_story_screen.dart';
import 'package:bisu_app/screens/language_screen.dart';
import 'package:bisu_app/screens/login_screen.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/shared/widgets/confirm_dialog.dart';
import 'package:bisu_app/shared/widgets/profile_card.dart';
import 'package:bisu_app/shared/widgets/setting_row.dart';
import 'package:bisu_app/shared/widgets/toggle_switch.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// SETTINGS tab (tab index 4). A PLAIN scrollable widget — no Scaffold of its
/// own — reproducing `renderSettings()` (app.js ~765-861), the `設定` page
/// skeleton (index.html ~110-117), and the logout / delete dialogs
/// (index.html ~207-229).
///
/// Two states, switched on [AppState.loggedIn]:
///  - Guest: grey [ProfileCard] (`G` / 未ログイン), a `ログイン / 新規登録`
///    button, and a single 基本メニュー list (言語 / BI-SUについて / FAQ /
///    お問い合わせ / 利用規約), plus a guest footer.
///  - Member: member [ProfileCard], 通知設定 (3 toggle rows), アカウント
///    (8 rows), 言語 / Language, その他 (ログアウト / アカウント削除 danger
///    rows), plus the member footer.
///
/// Notification toggles are visual-only (mirrors the mockup, where `.toggle`
/// just flips `is-on`); local [StatefulWidget] state holds them.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification toggles — visual only, default: on / on / off (matches the
  // mockup's `is-on` classes on お知らせ通知 + お届け予定のリマインド).
  bool _notifyNews = true;
  bool _notifyReminder = true;
  bool _notifyCampaign = false;

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _openLanguage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LanguageScreen()),
    );
  }

  void _openBrandStoryReview() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BrandStoryScreen(review: true),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final bool? ok = await ConfirmDialog.show(
      context,
      title: 'ログアウト',
      message: 'ログアウトしますか？\n次回は認証コードでの再ログインが必要です。',
      confirmLabel: 'ログアウト',
      danger: true,
    );
    if (ok == true && mounted) {
      AppScope.of(context).setLoggedIn(false);
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final bool? ok = await ConfirmDialog.show(
      context,
      title: 'アカウント削除',
      message:
          'アカウントを削除すると、アプリ内のデータがすべて消去されます。この操作は取り消せません。\n\n'
          '※ EC会員情報・定期コースはそのまま残ります。',
      confirmLabel: '削除する',
      danger: true,
    );
    if (ok == true && mounted) {
      AppScope.of(context).setLoggedIn(false);
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // .page-head (status-bar inset folded into the top padding).
        const _PageHead(en: 'SETTINGS', title: '設定'),
        // .page-body — scrollable region.
        Expanded(
          child: SingleChildScrollView(
            // padding:16px 16px calc(var(--tabbar-h) + 28px) = 62 + 28 = 90.
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: state.loggedIn
                ? _MemberSettings(
                    member: kMember,
                    rank: state.rank,
                    notifyNews: _notifyNews,
                    notifyReminder: _notifyReminder,
                    notifyCampaign: _notifyCampaign,
                    onNotifyNews: (bool v) => setState(() => _notifyNews = v),
                    onNotifyReminder: (bool v) =>
                        setState(() => _notifyReminder = v),
                    onNotifyCampaign: (bool v) =>
                        setState(() => _notifyCampaign = v),
                    onLanguage: _openLanguage,
                    onAbout: _openBrandStoryReview,
                    onLogout: _confirmLogout,
                    onDeleteAccount: _confirmDeleteAccount,
                  )
                : _GuestSettings(
                    onLogin: _openLogin,
                    onLanguage: _openLanguage,
                    onAbout: _openBrandStoryReview,
                  ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// GUEST (未ログイン) — 基本メニューのみ.
// ---------------------------------------------------------------------------

class _GuestSettings extends StatelessWidget {
  const _GuestSettings({
    required this.onLogin,
    required this.onLanguage,
    required this.onAbout,
  });

  final VoidCallback onLogin;
  final VoidCallback onLanguage;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // .card.profile-card.profile-guest (avatar 'G' / 未ログイン).
        // member + rank are placeholders, ignored in the guest variant (the
        // avatar uses the fixed grey gradient when guest: true).
        ProfileCard(
          member: kMember,
          rank: Ranks.of(RankId.member),
          guest: true,
        ),
        // .set-login-btn — full-width gold pill.
        BisuButton(
          label: 'ログイン / 新規登録',
          onPressed: onLogin,
        ),
        const SizedBox(height: 6),
        const _SecLabel('基本メニュー', first: true),
        // .card.set-list — 言語 row first, then BI-SU / FAQ / 問い合わせ / 規約.
        _SettingsCard(
          children: <Widget>[
            _LangRow(onTap: onLanguage),
            SettingRow(
              title: 'BI-SUについて',
              leading: const _SetIcon(path: _SetIcons.about),
              onTap: onAbout,
            ),
            SettingRow(
              title: 'よくあるご質問',
              leading: const _SetIcon(path: _SetIcons.faq),
              onTap: () {},
            ),
            SettingRow(
              title: 'お問い合わせ',
              leading: const _SetIcon(path: _SetIcons.contact),
              onTap: () {},
            ),
            SettingRow(
              title: '利用規約・プライバシーポリシー',
              leading: const _SetIcon(path: _SetIcons.terms),
              onTap: () {},
              showDivider: false,
            ),
          ],
        ),
        const _Footer(
          'BI-SU Member\'s App（モックアップ）v0.4.0\n'
          '未ログインでも、仮会員証・店舗ポイント・店舗一覧・ブランド情報・言語切替・お問い合わせがご利用いただけます',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MEMBER — 通知設定 / アカウント / 言語 / その他.
// ---------------------------------------------------------------------------

class _MemberSettings extends StatelessWidget {
  const _MemberSettings({
    required this.member,
    required this.rank,
    required this.notifyNews,
    required this.notifyReminder,
    required this.notifyCampaign,
    required this.onNotifyNews,
    required this.onNotifyReminder,
    required this.onNotifyCampaign,
    required this.onLanguage,
    required this.onAbout,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final Member member;
  final Rank rank;
  final bool notifyNews;
  final bool notifyReminder;
  final bool notifyCampaign;
  final ValueChanged<bool> onNotifyNews;
  final ValueChanged<bool> onNotifyReminder;
  final ValueChanged<bool> onNotifyCampaign;
  final VoidCallback onLanguage;
  final VoidCallback onAbout;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // .card.profile-card (rank-gradient avatar + name 様 + no/mail/since).
        ProfileCard(member: member, rank: rank),

        // ── 通知設定 ──────────────────────────────────────────────
        const _SecLabel('通知設定', first: true),
        _SettingsCard(
          children: <Widget>[
            SettingRow(
              title: 'お知らせ通知',
              leading: const _SetIcon(path: _SetIcons.bell),
              trailing: ToggleSwitch(value: notifyNews, onChanged: onNotifyNews),
            ),
            SettingRow(
              title: 'お届け予定のリマインド',
              subtitle: '定期コースの出荷前にお知らせします',
              leading: const _SetIcon(path: _SetIcons.mail),
              trailing: ToggleSwitch(
                value: notifyReminder,
                onChanged: onNotifyReminder,
              ),
            ),
            SettingRow(
              title: 'キャンペーン情報',
              leading: const _SetIcon(path: _SetIcons.chat),
              trailing: ToggleSwitch(
                value: notifyCampaign,
                onChanged: onNotifyCampaign,
              ),
              showDivider: false,
            ),
          ],
        ),

        // ── アカウント ────────────────────────────────────────────
        const _SecLabel('アカウント'),
        _SettingsCard(
          children: <Widget>[
            SettingRow(
              title: '会員情報の変更',
              leading: const _SetIcon(path: _SetIcons.profile),
              onTap: () {},
            ),
            SettingRow(
              title: 'お支払い方法',
              leading: const _SetIcon(path: _SetIcons.payment),
              onTap: () {},
            ),
            SettingRow(
              title: 'お届け先の管理',
              leading: const _SetIcon(path: _SetIcons.address),
              onTap: () {},
            ),
            SettingRow(
              title: 'BI-SUについて',
              leading: const _SetIcon(path: _SetIcons.about),
              onTap: onAbout,
            ),
            SettingRow(
              title: 'お問い合わせ',
              leading: const _SetIcon(path: _SetIcons.contact),
              onTap: () {},
            ),
            SettingRow(
              title: 'よくあるご質問',
              leading: const _SetIcon(path: _SetIcons.faq),
              onTap: () {},
            ),
            SettingRow(
              title: '利用規約・プライバシーポリシー',
              leading: const _SetIcon(path: _SetIcons.terms),
              onTap: () {},
            ),
            SettingRow(
              title: 'アプリについて',
              leading: const _SetIcon(path: _SetIcons.appInfo),
              onTap: () {},
              showDivider: false,
            ),
          ],
        ),

        // ── 言語 / Language ───────────────────────────────────────
        const _SecLabel('言語 / Language'),
        _SettingsCard(
          children: <Widget>[
            _LangRow(onTap: onLanguage, showDivider: false),
          ],
        ),

        // ── その他 ────────────────────────────────────────────────
        const _SecLabel('その他'),
        _SettingsCard(
          children: <Widget>[
            SettingRow(
              title: 'ログアウト',
              danger: true,
              leading: const _SetIcon(path: _SetIcons.logout, danger: true),
              onTap: onLogout,
            ),
            SettingRow(
              title: 'アカウントを削除',
              danger: true,
              leading: const _SetIcon(path: _SetIcons.trash, danger: true),
              onTap: onDeleteAccount,
              showDivider: false,
            ),
          ],
        ),

        const _Footer(
          'BI-SU Member\'s App（モックアップ）v0.4.0\n'
          '表示されている会員情報・注文・距離はすべてダミーです',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets.
// ---------------------------------------------------------------------------

/// `.card.set-list` — a paper card wrapping a column of [SettingRow]s with the
/// list's bottom margin (14px) folded in.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: BisuColors.paper,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// The 言語 / Language row — a [SettingRow] whose trailing slot is the
/// `.lang-badge` pill (日本語) rather than a chevron.
class _LangRow extends StatelessWidget {
  const _LangRow({required this.onTap, this.showDivider = true});

  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      title: '言語 / Language',
      subtitle: '日本語 / English',
      leading: const _SetIcon(path: _SetIcons.language),
      trailing: const _LangBadge(),
      onTap: onTap,
      showDivider: showDivider,
    );
  }
}

/// `.lang-badge` — small gold pill reading 日本語.
class _LangBadge extends StatelessWidget {
  const _LangBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1AA8895A), // rgba(168,137,90,.1)
        borderRadius: BorderRadius.circular(99),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: const Text(
        '日本語',
        style: TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.54, // ~.06em of 9px
          color: BisuColors.goldDeep,
        ),
      ),
    );
  }
}

/// `.set-ic` — a 19×19 stroked SVG path icon (stroke goldDeep, or danger red
/// for logout/delete). The path data is copied verbatim from `renderSettings`.
class _SetIcon extends StatelessWidget {
  const _SetIcon({required this.path, this.danger = false});

  /// The `<path d="…">` data only (no `<svg>` wrapper).
  final String path;

  /// Render the stroke in danger red (`#A04545`) for logout / delete.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    // .set-ic{ width:19px; height:19px; stroke:var(--gold-deep);
    //   fill:none; stroke-width:1.6; } — danger rows override stroke #A04545.
    final String stroke = danger ? '#A04545' : '#8A6E42';
    final String svg =
        '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" '
        'fill="none" stroke="$stroke" stroke-width="1.6" '
        'stroke-linecap="round" stroke-linejoin="round">'
        '<path d="$path"/></svg>';
    return SvgPicture.string(svg, width: 19, height: 19);
  }
}

/// `.set-ic` SVG path data, verbatim from `renderSettings` (app.js ~768-841).
class _SetIcons {
  const _SetIcons._();

  static const String profile = 'M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm-7 9a7 7 0 0 1 14 0';
  static const String payment = 'M3 7h18v11H3Zm0 4h18M6 14.5h4';
  static const String address =
      'M12 21s-7-5.3-7-11a7 7 0 0 1 14 0c0 5.7-7 11-7 11Zm0-8.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z';
  static const String about =
      'M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2Zm1 15h-2v-6h2Zm0-8h-2V7h2Z';
  static const String contact =
      'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2Z';
  static const String faq =
      'M9.2 9a3 3 0 0 1 5.8 1c0 2-3 2.2-3 4M12 17.5h.01M12 21a9 9 0 1 1 9-9 9 9 0 0 1-9 9Z';
  static const String terms = 'M7 3h7l4 4v14H7ZM14 3v4h4M10 12h5M10 16h5';
  static const String appInfo =
      'M13 16h-1v-4h-1m1-4h.01M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z';
  static const String language =
      'M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20ZM2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10A15.3 15.3 0 0 1 12 2Z';
  static const String bell =
      'M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6Zm4.5 9a1.8 1.8 0 0 0 3 0';
  static const String mail = 'M3 8l9 5 9-5M4 6h16v12H4Z';
  static const String chat = 'M20 12a8 8 0 1 0-14.9 4L4 21l5-1.1A8 8 0 0 0 20 12Z';
  static const String logout = 'M9 21H5V3h4M14 16l4-4-4-4M18 12H9';
  static const String trash =
      'M3 6h18M8 6V4h8v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M10 11v6M14 11v6';
}

/// `.set-footer` — centered faint caption (multi-line) at the bottom.
class _Footer extends StatelessWidget {
  const _Footer(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamilyFallback: <String>[
            'Hiragino Kaku Gothic ProN',
            'Yu Gothic Medium',
            'YuGothic',
            'Noto Sans JP',
            'Segoe UI',
            'sans-serif',
          ],
          fontSize: 9.5,
          height: 1.9,
          color: BisuColors.inkFaint,
        ),
      ),
    );
  }
}

/// `.page-head` — EN eyebrow + JP title, paper→ivory gradient, bottom hairline.
/// Folds the device status-bar safe-area inset into its top padding (mirrors
/// `.screen{ padding-top:status-h }`). Matches the sibling tab screens.
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

/// `.sec-label` — goldDeep w700 10px, ls .26em (~2.6); margin 18/6/9, first uses
/// margin-top 2px.
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
