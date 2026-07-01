import 'package:flutter/widgets.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/models/rank.dart';

/// App-wide mutable state (ChangeNotifier).
///
/// Boots logged-in at the `member` rank, matching the mockup's
/// `state = { rank:'member', loggedIn:true }`.
class AppState extends ChangeNotifier {
  AppState({
    RankId rank = RankId.member,
    bool loggedIn = true,
  })  : _rank = rank,
        _loggedIn = loggedIn;

  RankId _rank;
  bool _loggedIn;

  /// Current rank id.
  RankId get rankId => _rank;

  /// The resolved [Rank] object for [rankId].
  Rank get rank => Ranks.of(_rank);

  /// Whether the user is logged in (member) vs. guest.
  bool get loggedIn => _loggedIn;

  /// BI-SU points balance shown on Home (`round(annual / 100 * rate)`).
  int get points => rank.points;

  /// Progress-bar fill percent (0–100) toward the next tier.
  int get progressPct => rank.progressPct;

  /// Label under the progress bar (next-tier remaining, or top-tier thanks).
  String get progressLabel => rank.progressLabel;

  /// Store-points balance: 480 when logged in, 120 for guest.
  int get storePoints => kStorePoints.balanceFor(loggedIn: _loggedIn);

  /// Sets the active rank and notifies listeners (no-op if unchanged).
  void setRank(RankId value) {
    if (_rank == value) return;
    _rank = value;
    notifyListeners();
  }

  /// Sets the auth state and notifies listeners (no-op if unchanged).
  void setLoggedIn(bool value) {
    if (_loggedIn == value) return;
    _loggedIn = value;
    notifyListeners();
  }

  /// Convenience: flip auth state.
  void toggleLoggedIn() => setLoggedIn(!_loggedIn);
}

/// Exposes [AppState] to the widget tree via [InheritedNotifier].
///
/// - [AppScope.of] returns the state WITHOUT subscribing (use in callbacks).
/// - [AppScope.watch] returns the state AND subscribes (rebuild on change).
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  /// Reads the [AppState] without registering a dependency.
  /// Use inside event handlers / `onPressed`.
  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope.of() called with no AppScope above.');
    return scope!.notifier!;
  }

  /// Reads the [AppState] and rebuilds the caller when it notifies.
  /// Use inside `build`.
  static AppState watch(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope.watch() called with no AppScope above.');
    return scope!.notifier!;
  }
}
