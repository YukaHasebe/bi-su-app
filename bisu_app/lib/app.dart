import 'package:flutter/material.dart';

import 'package:bisu_app/features/splash/splash_screen.dart';
import 'package:bisu_app/root_scaffold.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_theme.dart';

/// Root application widget.
///
/// Wires the shared [AppState] into the tree via [AppScope] (an
/// [InheritedNotifier]), then builds the [MaterialApp] with [BisuTheme.light].
/// The app boots logged-in at the `member` rank (the [AppState] default),
/// mirroring the mockup's `state = { rank:'member', loggedIn:true }`.
///
/// `home` is the [SplashScreen] (journey video + rank reveal). When the splash
/// finishes it replaces itself with the [RootScaffold] app shell. The splash is
/// built inside a [Builder] so the context captured by `onDone` is a descendant
/// of the [MaterialApp]'s [Navigator].
class BisuApp extends StatefulWidget {
  const BisuApp({super.key});

  @override
  State<BisuApp> createState() => _BisuAppState();
}

class _BisuAppState extends State<BisuApp> {
  // The single AppState lives for the lifetime of the app; disposed with it.
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _state,
      child: MaterialApp(
        title: 'BI-SU',
        debugShowCheckedModeBanner: false,
        theme: BisuTheme.light,
        home: Builder(
          builder: (BuildContext context) {
            return SplashScreen(
              rank: AppScope.of(context).rankId,
              onDone: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const RootScaffold(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
