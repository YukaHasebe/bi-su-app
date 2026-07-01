import 'package:flutter/material.dart';

import 'package:bisu_app/features/splash/splash_screen.dart' as feature;
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/root_scaffold.dart';
import 'package:bisu_app/state/app_state.dart';

/// Canonical, self-wiring splash screen (`package:bisu_app/screens/splash_screen.dart`).
///
/// The feature splash ([feature.SplashScreen]) is intentionally navigation-free:
/// it takes a required `onDone` callback so it can be reused / previewed in
/// isolation. This shim is the app-level entry point used by both
/// [BisuApp] and `OnboardingScreen._finish()`. It plays the current rank's
/// journey video and, when finished, replaces itself with the [RootScaffold]
/// app shell.
///
/// Re-export note: the underlying [feature.SplashScreen] also carries the name
/// `SplashScreen`, so it is imported with the `feature.` prefix to avoid a
/// name clash with this wrapper.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Match the journey video to the current (boot = member) rank.
    final RankId rank = AppScope.of(context).rankId;
    return feature.SplashScreen(
      rank: rank,
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const RootScaffold()),
        );
      },
    );
  }
}
