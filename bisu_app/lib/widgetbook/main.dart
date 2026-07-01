// BI-SU APP — Widgetbook catalog (separate entry point).
//
// Run with:  flutter run -t lib/widgetbook/main.dart
//
// This is a standalone Widgetbook app (NOT the production BisuApp). It catalogs
// the shared widgets so they can be reviewed in isolation against the v2.1
// mockup. Built with the manual (no-codegen) widgetbook ^3.9.x API:
// `Widgetbook(directories: [...])` of `WidgetbookComponent`/`WidgetbookUseCase`,
// with a `MaterialThemeAddon` carrying `BisuTheme.light`.
//
// Rank-dependent use cases (RankEmblem, ProfileCard, ...) expose a rank picker
// via a standard list knob (`context.knobs.list`) and wrap their subject in an
// `AppScope` so anything reading `AppScope.watch(context).rank` reflects the
// chosen tier.

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/order.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/models/subscription.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_theme.dart';
import 'package:bisu_app/shared/widgets/bisu_button.dart';
import 'package:bisu_app/shared/widgets/bisu_chip.dart';
import 'package:bisu_app/shared/widgets/bisu_text_field.dart';
import 'package:bisu_app/shared/widgets/code_input.dart';
import 'package:bisu_app/shared/widgets/confirm_dialog.dart';
import 'package:bisu_app/shared/widgets/glass_card.dart';
import 'package:bisu_app/shared/widgets/order_card.dart';
import 'package:bisu_app/shared/widgets/profile_card.dart';
import 'package:bisu_app/shared/widgets/progress_bar.dart';
import 'package:bisu_app/shared/widgets/rank_emblem.dart';
import 'package:bisu_app/shared/widgets/setting_row.dart';
import 'package:bisu_app/shared/widgets/subscription_card.dart';
import 'package:bisu_app/shared/widgets/toggle_switch.dart';

void main() => runApp(const BisuWidgetbook());

/// Reference frame size from the mockup (390 × 844).
const double _kFrameWidth = 390;
const double _kFrameHeight = 844;

class BisuWidgetbook extends StatelessWidget {
  const BisuWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // The catalog tree. Folders group by area; each component holds its
      // use cases.
      directories: <WidgetbookNode>[
        WidgetbookFolder(
          name: 'Foundation',
          children: <WidgetbookNode>[
            _glassCardComponent,
            _rankEmblemComponent,
            _progressBarComponent,
          ],
        ),
        WidgetbookFolder(
          name: 'Controls',
          children: <WidgetbookNode>[
            _chipComponent,
            _buttonComponent,
            _textFieldComponent,
            _codeInputComponent,
            _toggleComponent,
            _settingRowComponent,
            _confirmDialogComponent,
          ],
        ),
        WidgetbookFolder(
          name: 'Cards',
          children: <WidgetbookNode>[
            _profileCardComponent,
            _subscriptionCardComponent,
            _orderCardComponent,
          ],
        ),
      ],
      addons: <WidgetbookAddon>[
        MaterialThemeAddon(
          themes: <WidgetbookTheme<ThemeData>>[
            WidgetbookTheme<ThemeData>(
              name: 'BI-SU Light',
              data: BisuTheme.light,
            ),
          ],
        ),
        // Note: the viewport/device-frame addon is intentionally NOT used —
        // its DeviceInfo constructor shape varies across widgetbook 3.x point
        // releases. Instead every use case is hosted on a fixed 390×844 frame
        // by `_stage` (see below), which is version-stable.
      ],
    );
  }
}

// ===========================================================================
// Shared helpers
// ===========================================================================

/// A rank picker knob shared by rank-dependent use cases.
Rank _rankKnob(BuildContext context) {
  final RankId id = context.knobs.list<RankId>(
    label: 'Rank',
    options: Ranks.order,
    initialOption: RankId.member,
    labelBuilder: (RankId id) => Ranks.of(id).en, // MEMBER / SILVER / ...
  );
  return Ranks.of(id);
}

/// Wraps [child] in an [AppScope] seeded with [rank] / [loggedIn] so widgets
/// that read `AppScope.watch(context)` reflect the knob selection.
Widget _scoped({
  required RankId rank,
  bool loggedIn = true,
  required Widget child,
}) {
  return AppScope(
    notifier: AppState(rank: rank, loggedIn: loggedIn),
    child: child,
  );
}

/// Hosts a use-case subject on the mockup's 390×844 reference frame, centered
/// on the ivory (or night) app background with comfortable padding. The fixed
/// frame replaces the device-frame/viewport addon (kept version-stable).
Widget _stage(Widget child, {bool dark = false}) {
  return Center(
    child: SizedBox(
      width: _kFrameWidth,
      height: _kFrameHeight,
      child: ColoredBox(
        color: dark ? BisuColors.night : BisuColors.ivory,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    ),
  );
}

// ===========================================================================
// Foundation
// ===========================================================================

final WidgetbookComponent _glassCardComponent = WidgetbookComponent(
  name: 'GlassCard',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Night glass (default)',
      builder: (BuildContext context) {
        // Default frosted glass reads over a dark background.
        return _stage(
          const GlassCard(
            child: Text(
              'GLASS CARD\nrgba(18,18,16,.40) + blur(14)',
              textAlign: TextAlign.center,
              style: TextStyle(color: BisuColors.white, fontSize: 13),
            ),
          ),
          dark: true,
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Light (paper fill)',
      builder: (BuildContext context) {
        return _stage(
          const GlassCard(
            background: BisuColors.paper,
            child: Text(
              'GlassCard(background: paper) — opaque light card',
              style: TextStyle(color: BisuColors.ink, fontSize: 13),
            ),
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _rankEmblemComponent = WidgetbookComponent(
  name: 'RankEmblem',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Single (rank knob)',
      builder: (BuildContext context) {
        final Rank rank = _rankKnob(context);
        final double size = context.knobs.double.slider(
          label: 'Size (width)',
          initialValue: 80,
          min: 24,
          max: 160,
        );
        return _scoped(
          rank: rank.id,
          child: _stage(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RankEmblem(rank: rank, size: size),
                const SizedBox(height: 12),
                Text(
                  rank.en,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w700,
                    color: BisuColors.goldDeep,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'All 5 ranks',
      builder: (BuildContext context) {
        return _stage(
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: <Widget>[
              for (final Rank rank in Ranks.all)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RankEmblem(rank: rank, size: 64),
                    const SizedBox(height: 8),
                    Text(
                      rank.en,
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                        color: BisuColors.goldDeep,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _progressBarComponent = WidgetbookComponent(
  name: 'ProgressBar',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Light (gold)',
      builder: (BuildContext context) {
        final int percent = context.knobs.int.slider(
          label: 'Percent',
          initialValue: 42,
          min: 0,
          max: 100,
        );
        return _stage(ProgressBar(percent: percent));
      },
    ),
    WidgetbookUseCase(
      name: 'Night (rank tinted, glow)',
      builder: (BuildContext context) {
        final Rank rank = _rankKnob(context);
        final int percent = context.knobs.int.slider(
          label: 'Percent',
          initialValue: rank.progressPct,
          min: 0,
          max: 100,
        );
        return _stage(
          ProgressBar(
            percent: percent,
            fillColor: rank.color,
            fillSoft: rank.soft,
            trackColor: const Color(0x2EFFFFFF),
            height: 4,
            glow: true,
          ),
          dark: true,
        );
      },
    ),
  ],
);

// ===========================================================================
// Controls
// ===========================================================================

final WidgetbookComponent _chipComponent = WidgetbookComponent(
  name: 'BisuChip',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Knob (style + dot)',
      builder: (BuildContext context) {
        final BisuChipStyle style = context.knobs.list<BisuChipStyle>(
          label: 'Style',
          options: BisuChipStyle.values,
          initialOption: BisuChipStyle.gold,
          labelBuilder: (BisuChipStyle s) => s.name,
        );
        final bool dot = context.knobs.boolean(label: 'Dot', initialValue: true);
        final String label = context.knobs.string(
          label: 'Label',
          initialValue: '注文継続中',
        );
        return _stage(
          Align(
            alignment: Alignment.centerLeft,
            child: BisuChip(label: label, style: style, dot: dot),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'All variants',
      builder: (BuildContext context) {
        return _stage(
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              BisuChip(label: '注文継続中', style: BisuChipStyle.gold, dot: true),
              BisuChip(label: '定期購入', style: BisuChipStyle.gold),
              BisuChip(label: '通常購入'),
              BisuChip(label: 'ネット注文'),
              BisuChip(label: '解約済み', style: BisuChipStyle.gray, dot: true),
              BisuChip(label: '直営店', style: BisuChipStyle.gray),
            ],
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _buttonComponent = WidgetbookComponent(
  name: 'BisuButton',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Knob (variant + enabled)',
      builder: (BuildContext context) {
        final BisuButtonVariant variant = context.knobs.list<BisuButtonVariant>(
          label: 'Variant',
          options: BisuButtonVariant.values,
          initialOption: BisuButtonVariant.primary,
          labelBuilder: (BisuButtonVariant v) => v.name,
        );
        final bool enabled =
            context.knobs.boolean(label: 'Enabled', initialValue: true);
        final String label = context.knobs.string(
          label: 'Label',
          initialValue: 'ログイン / 新規登録',
        );
        return _stage(
          BisuButton(
            label: label,
            variant: variant,
            onPressed: enabled ? () {} : null,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Primary / Outline / Text / Disabled',
      builder: (BuildContext context) {
        return _stage(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BisuButton(label: 'はじめる', onPressed: () {}),
              const SizedBox(height: 14),
              BisuButton(
                label: '店舗で見る',
                variant: BisuButtonVariant.outline,
                onPressed: () {},
              ),
              const SizedBox(height: 14),
              BisuButton(
                label: '別の方法でログイン',
                variant: BisuButtonVariant.text,
                onPressed: () {},
              ),
              const SizedBox(height: 14),
              const BisuButton(label: '送信（無効）', onPressed: null),
            ],
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _textFieldComponent = WidgetbookComponent(
  name: 'BisuTextField',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'With label + hint',
      builder: (BuildContext context) {
        final bool withLabel =
            context.knobs.boolean(label: 'Show label', initialValue: true);
        final bool obscure =
            context.knobs.boolean(label: 'Obscure', initialValue: false);
        return _stage(
          _TextFieldDemo(withLabel: withLabel, obscure: obscure),
        );
      },
    ),
  ],
);

/// Stateful host owning the [TextEditingController] for [BisuTextField].
class _TextFieldDemo extends StatefulWidget {
  const _TextFieldDemo({required this.withLabel, required this.obscure});

  final bool withLabel;
  final bool obscure;

  @override
  State<_TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<_TextFieldDemo> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BisuTextField(
      controller: _controller,
      label: widget.withLabel ? 'メールアドレス' : null,
      hintText: 'name@example.com',
      keyboardType: TextInputType.emailAddress,
      obscureText: widget.obscure,
    );
  }
}

final WidgetbookComponent _codeInputComponent = WidgetbookComponent(
  name: 'CodeInput',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Auth code boxes',
      builder: (BuildContext context) {
        final int length =
            context.knobs.int.slider(label: 'Length', initialValue: 6, min: 4, max: 8);
        return _stage(
          _CodeInputDemo(length: length),
        );
      },
    ),
  ],
);

/// Hosts [CodeInput] and surfaces the current/completed code below it.
class _CodeInputDemo extends StatefulWidget {
  const _CodeInputDemo({required this.length});

  final int length;

  @override
  State<_CodeInputDemo> createState() => _CodeInputDemoState();
}

class _CodeInputDemoState extends State<_CodeInputDemo> {
  String _value = '';
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CodeInput(
          // Key on length so changing the knob rebuilds the field cleanly.
          key: ValueKey<int>(widget.length),
          length: widget.length,
          onChanged: (String v) => setState(() {
            _value = v;
            _completed = false;
          }),
          onCompleted: (String v) => setState(() {
            _value = v;
            _completed = true;
          }),
        ),
        const SizedBox(height: 16),
        Text(
          _completed ? '完了: $_value' : '入力中: $_value',
          style: const TextStyle(fontSize: 12, color: BisuColors.inkSoft),
        ),
      ],
    );
  }
}

final WidgetbookComponent _toggleComponent = WidgetbookComponent(
  name: 'ToggleSwitch',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'On / Off',
      builder: (BuildContext context) {
        return _stage(const _ToggleDemo());
      },
    ),
  ],
);

/// Owns the bool for [ToggleSwitch] (the widget is stateless).
class _ToggleDemo extends StatefulWidget {
  const _ToggleDemo();

  @override
  State<_ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<_ToggleDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ToggleSwitch(
          value: _value,
          onChanged: (bool v) => setState(() => _value = v),
        ),
        const SizedBox(width: 14),
        Text(
          _value ? 'ON' : 'OFF',
          style: const TextStyle(fontSize: 12, color: BisuColors.inkSoft),
        ),
      ],
    );
  }
}

final WidgetbookComponent _settingRowComponent = WidgetbookComponent(
  name: 'SettingRow',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Variants (chevron / subtitle / toggle / danger)',
      builder: (BuildContext context) {
        return _stage(
          DecoratedBox(
            decoration: BoxDecoration(
              color: BisuColors.paper,
              border: Border.all(color: BisuColors.hair),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: <Widget>[
                SettingRow(
                  title: '言語',
                  subtitle: '日本語',
                  leadingIcon: Icons.translate,
                  onTap: () {},
                ),
                SettingRow(
                  title: 'CLUB MEMBERS PROGRAM',
                  leadingIcon: Icons.workspace_premium_outlined,
                  onTap: () {},
                ),
                const SettingRow(
                  title: 'プッシュ通知',
                  leadingIcon: Icons.notifications_none,
                  trailing: _InlineToggle(),
                ),
                const SettingRow(
                  title: 'ログアウト',
                  leadingIcon: Icons.logout,
                  danger: true,
                  showDivider: false,
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
);

/// A self-contained toggle for the SettingRow trailing slot.
class _InlineToggle extends StatefulWidget {
  const _InlineToggle();

  @override
  State<_InlineToggle> createState() => _InlineToggleState();
}

class _InlineToggleState extends State<_InlineToggle> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      value: _value,
      onChanged: (bool v) => setState(() => _value = v),
    );
  }
}

final WidgetbookComponent _confirmDialogComponent = WidgetbookComponent(
  name: 'ConfirmDialog',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Normal (inline)',
      builder: (BuildContext context) {
        // Render the dialog body inline (not via showDialog) so it is always
        // visible in the catalog.
        return _stage(
          const Center(
            child: ConfirmDialog(
              title: 'ログアウトしますか？',
              message: '再度ご利用の際はログインが必要です。',
              confirmLabel: 'OK',
              cancelLabel: 'キャンセル',
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Danger (inline)',
      builder: (BuildContext context) {
        return _stage(
          const Center(
            child: ConfirmDialog(
              title: 'アカウントを削除しますか？',
              message: 'この操作は取り消せません。',
              confirmLabel: '削除する',
              cancelLabel: 'キャンセル',
              danger: true,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Via show() (button)',
      builder: (BuildContext context) {
        return _stage(
          Center(
            child: BisuButton(
              label: 'ダイアログを開く',
              fullWidth: false,
              onPressed: () => ConfirmDialog.show(
                context,
                title: 'ログアウトしますか？',
                message: '再度ご利用の際はログインが必要です。',
              ),
            ),
          ),
        );
      },
    ),
  ],
);

// ===========================================================================
// Cards
// ===========================================================================

final WidgetbookComponent _profileCardComponent = WidgetbookComponent(
  name: 'ProfileCard',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Member (rank knob)',
      builder: (BuildContext context) {
        final Rank rank = _rankKnob(context);
        return _scoped(
          rank: rank.id,
          child: _stage(
            ProfileCard(member: kMember, rank: rank),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Guest',
      builder: (BuildContext context) {
        // member is ignored in the guest variant; pass kMember as placeholder.
        return _scoped(
          rank: RankId.member,
          loggedIn: false,
          child: _stage(
            ProfileCard(
              member: kMember,
              rank: Ranks.of(RankId.member),
              guest: true,
            ),
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _subscriptionCardComponent = WidgetbookComponent(
  name: 'SubscriptionCard',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Active',
      builder: (BuildContext context) {
        final Subscription sub = kSubscriptions.firstWhere(
          (Subscription s) => s.isActive,
        );
        return _stage(SubscriptionCard(subscription: sub));
      },
    ),
    WidgetbookUseCase(
      name: 'Cancelled',
      builder: (BuildContext context) {
        final Subscription sub = kSubscriptions.firstWhere(
          (Subscription s) => s.isCancelled,
        );
        return _stage(SubscriptionCard(subscription: sub));
      },
    ),
    WidgetbookUseCase(
      name: 'All',
      builder: (BuildContext context) {
        return _stage(
          Column(
            children: <Widget>[
              for (final Subscription s in kSubscriptions)
                SubscriptionCard(subscription: s),
            ],
          ),
        );
      },
    ),
  ],
);

final WidgetbookComponent _orderCardComponent = WidgetbookComponent(
  name: 'OrderCard',
  useCases: <WidgetbookUseCase>[
    WidgetbookUseCase(
      name: 'Online subscription',
      builder: (BuildContext context) {
        final Order order = kOrders.firstWhere(
          (Order o) =>
              o.channel == OrderChannel.online &&
              o.kind == OrderKind.subscription,
        );
        return _stage(OrderCard(order: order));
      },
    ),
    WidgetbookUseCase(
      name: 'In-store normal',
      builder: (BuildContext context) {
        final Order order = kOrders.firstWhere(
          (Order o) => o.channel == OrderChannel.store,
        );
        return _stage(OrderCard(order: order));
      },
    ),
    WidgetbookUseCase(
      name: 'All',
      builder: (BuildContext context) {
        return _stage(
          Column(
            children: <Widget>[
              for (final Order o in kOrders) OrderCard(order: o),
            ],
          ),
        );
      },
    ),
  ],
);
