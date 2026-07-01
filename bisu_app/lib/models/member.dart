/// A member profile (mirrors app.js `MEMBER`). Immutable value type.
class Member {
  const Member({
    required this.name,
    required this.initials,
    required this.no,
    required this.mail,
    required this.since,
  });

  /// Full name, e.g. `長谷部 由香`.
  final String name;

  /// Avatar initials, e.g. `YH`.
  final String initials;

  /// Membership number, e.g. `BS-00124857`.
  final String no;

  /// Email address.
  final String mail;

  /// Member-since label, e.g. `2023年4月`.
  final String since;
}

/// The app-independent store-points wallet (mirrors app.js `STORE_POINTS`).
///
/// Separate from BI-SU points (rakuraku EC). Accrues even for the temporary
/// (guest / not-logged-in) card. Display-only demo (OP-28).
class StorePoints {
  const StorePoints({
    required this.balance,
    required this.guestBalance,
    required this.tempNo,
  });

  /// Logged-in member balance (480).
  final int balance;

  /// Guest / temporary-card balance (120).
  final int guestBalance;

  /// Temporary card number for guests, e.g. `TEMP-7F3A-9C21`.
  final String tempNo;

  /// Returns the balance for the given auth state.
  int balanceFor({required bool loggedIn}) =>
      loggedIn ? balance : guestBalance;
}
