/// Purchase channel (mirrors `ORDERS[*].ch`).
enum OrderChannel {
  /// ネット注文
  online,

  /// 店頭購入
  store,
}

/// Purchase kind (mirrors `ORDERS[*].kind`).
enum OrderKind {
  /// 通常購入
  normal,

  /// 定期購入
  subscription,
}

/// A past purchase (mirrors a single entry of app.js `ORDERS`).
/// Immutable value type.
class Order {
  const Order({
    required this.date,
    required this.no,
    required this.channel,
    required this.kind,
    required this.name,
    required this.img,
    required this.qty,
    required this.price,
    this.channelSub,
  });

  /// 出荷日, e.g. `2026/06/02`.
  final String date;

  /// 注文番号, e.g. `BS-260602-0412`.
  final String no;

  /// ネット注文 / 店頭購入.
  final OrderChannel channel;

  /// 通常購入 / 定期購入.
  final OrderKind kind;

  /// 商品名（BI-SU表記）.
  final String name;

  /// Product image asset path (under `assets/images/`).
  final String img;

  /// 個数.
  final int qty;

  /// ご注文金額, in yen.
  final int price;

  /// Store name for in-store purchases, e.g. `BI-SU GINZA SIX`. Null online.
  final String? channelSub;

  /// Display label for [channel] (mirrors the JS string values).
  String get channelLabel =>
      channel == OrderChannel.store ? '店頭購入' : 'ネット注文';

  /// Display label for [kind] (mirrors the JS string values).
  String get kindLabel =>
      kind == OrderKind.subscription ? '定期購入' : '通常購入';
}
