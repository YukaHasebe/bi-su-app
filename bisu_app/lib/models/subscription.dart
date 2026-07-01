/// State of a subscription course (mirrors `SUBSCRIPTIONS[*].status`).
enum SubscriptionStatus {
  /// 注文継続中
  active,

  /// 解約済み
  cancelled,
}

/// A recurring-delivery course (mirrors a single entry of app.js
/// `SUBSCRIPTIONS`). Immutable value type.
class Subscription {
  const Subscription({
    required this.name,
    required this.img,
    required this.status,
    required this.cycle,
    required this.qty,
    required this.price,
    this.next,
    this.last,
  });

  /// 商品名（BI-SU表記）.
  final String name;

  /// Product image asset path (under `assets/images/`).
  final String img;

  /// active / cancelled.
  final SubscriptionStatus status;

  /// お届けサイクル, e.g. `30日ごと`.
  final String cycle;

  /// 個数.
  final int qty;

  /// ご注文金額 (税込), in yen.
  final int price;

  /// 次回お届け date label, present when [status] is active, e.g.
  /// `2026/06/24（水）`. Null when cancelled.
  final String? next;

  /// 最終お届け date label, present when [status] is cancelled, e.g.
  /// `2026/03/15`. Null when active.
  final String? last;

  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get isActive => status == SubscriptionStatus.active;
}
