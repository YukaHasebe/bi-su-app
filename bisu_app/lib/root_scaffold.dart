import 'package:flutter/material.dart';

import 'package:bisu_app/features/history/order_history_screen.dart';
import 'package:bisu_app/features/home/home_screen.dart';
import 'package:bisu_app/features/settings/settings_screen.dart';
import 'package:bisu_app/features/stores/stores_screen.dart';
import 'package:bisu_app/features/subscription/subscription_screen.dart';
import 'package:bisu_app/shared/widgets/bisu_tab_bar.dart';
import 'package:bisu_app/state/app_state.dart';

/// The app shell: the five tab-root screens behind a persistent bottom tab bar.
///
/// Mirrors the mockup, where the tab bar (`.tabbar`) is a translucent overlay
/// pinned to the bottom of the active `.screen`. Each tab-root screen is a
/// PLAIN scrollable widget (no [Scaffold] of its own) that already reserves
/// `tabbar-h` worth of bottom padding, so the tab bar here is laid out as a
/// bottom-anchored overlay in a [Stack] (NOT a displacing
/// `Scaffold.bottomNavigationBar`) — otherwise the screens' self-reserved
/// padding would double-count and leave a gap above the bar.
///
/// The screens are kept alive across tab switches by an [IndexedStack].
///
/// Tab order (MUST match [BisuTabBar]'s indices):
/// 0 ホーム · 1 定期情報 · 2 購入履歴 · 3 ストアーズ · 4 設定.
class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  /// The currently selected tab index (0–4).
  int _currentTab = 0;

  void _onTap(int index) {
    if (index == _currentTab) return;
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to AppState so rank / login changes rebuild the shell (the
    // individual tab screens also watch AppScope themselves).
    AppScope.watch(context);

    return Scaffold(
      // Each tab-root screen paints its own background (Home = night, others =
      // ivory); the Scaffold background is only visible during transitions.
      body: Stack(
        children: <Widget>[
          // Tab bodies, kept alive across switches.
          Positioned.fill(
            child: IndexedStack(
              index: _currentTab,
              children: const <Widget>[
                HomeScreen(),
                SubscriptionScreen(),
                OrderHistoryScreen(),
                StoresScreen(),
                SettingsScreen(),
              ],
            ),
          ),
          // Translucent tab bar overlaying the bottom of the active screen.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BisuTabBar(
              currentIndex: _currentTab,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}
