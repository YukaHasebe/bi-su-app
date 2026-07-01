/// Store classification badge (mirrors `STORES[*].type`).
enum StoreType {
  /// 直営店
  direct,

  /// 取扱店
  reseller,

  /// 期間限定
  popup,
}

/// A store / sales location (mirrors a single entry of app.js `STORES`).
///
/// Stores are now rendered inside a WebView image of the official site, so
/// only the fields used by the WebView card list are strictly required; the
/// remaining detail fields are preserved verbatim for fidelity / future use.
/// Immutable value type.
class Store {
  const Store({
    required this.id,
    required this.name,
    required this.en,
    required this.type,
    required this.dist,
    required this.city,
    required this.addr,
    required this.hours,
    required this.closed,
    required this.access,
    required this.desc,
    this.img,
    this.tel,
    this.period,
    this.planNote,
  });

  /// Stable id, e.g. `gsix`.
  final String id;

  /// 店舗名, e.g. `BI-SU GINZA SIX`.
  final String name;

  /// EN sub-label, e.g. `GINZA SIX — TOKYO`.
  final String en;

  /// 直営店 / 取扱店 / 期間限定.
  final StoreType type;

  /// Distance label, e.g. `1.8km` (demo).
  final String dist;

  /// City key, e.g. `tokyo` / `kyoto`.
  final String city;

  /// 住所.
  final String addr;

  /// 営業時間, e.g. `10:30〜20:30`.
  final String hours;

  /// 定休日, e.g. `元日および施設休館日`.
  final String closed;

  /// アクセス lines.
  final List<String> access;

  /// 紹介文.
  final String desc;

  /// Store photo asset path (under `assets/images/`), or null (e.g. pop-up).
  final String? img;

  /// 電話番号, or null when not published.
  final String? tel;

  /// Open period for pop-up stores, e.g. `2026.6.17（水）〜 6.23（火）`. Null otherwise.
  final String? period;

  /// Floor-plan caption note, or null.
  final String? planNote;

  /// Display label for [type] (mirrors the JS string values).
  String get typeLabel {
    switch (type) {
      case StoreType.direct:
        return '直営店';
      case StoreType.reseller:
        return '取扱店';
      case StoreType.popup:
        return '期間限定';
    }
  }
}
