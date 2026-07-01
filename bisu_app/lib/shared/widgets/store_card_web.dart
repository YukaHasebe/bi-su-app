import 'package:flutter/material.dart';

import 'package:bisu_app/models/store.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// A store row as shown inside the WebView-style stores list (mirrors
/// `.wv-store` in styles.css / `renderStoresWebView` in app.js).
///
/// ```css
/// .wv-store{ display:flex; align-items:flex-start; gap:8px; padding:11px 0;
///   border-top:1px solid var(--hair); }
/// .wv-store-name{ font-size:12.5px; font-weight:700; }
/// .wv-store-addr{ font-size:10px; color:var(--ink-soft); margin-top:3px; }
/// .wv-store-period{ font-size:10px; color:var(--gold-deep); font-weight:700; margin-top:3px; }
/// .wv-badge{ font-size:9px; font-weight:700; border-radius:999px; padding:3px 9px; }
/// ```
///
/// Badge variant by [Store.type]: 直営店 → gold (`wv-badge-g`),
/// 期間限定 → grey (`wv-badge-p`), 取扱店 → line (`wv-badge-l`).
///
/// The top hairline (`border-top`) is drawn by this row, matching the CSS where
/// every `.wv-store` has a top border (the first one separates it from the
/// page sub-heading).
class StoreCardWeb extends StatelessWidget {
  const StoreCardWeb({super.key, required this.store});

  /// The store to render.
  final Store store;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BisuColors.hair, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: BisuColors.ink,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      store.addr,
                      style: const TextStyle(
                        fontSize: 10,
                        color: BisuColors.inkSoft,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (store.period != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        store.period!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: BisuColors.goldDeep,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _Badge(type: store.type, label: store.typeLabel),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.type, required this.label});

  final StoreType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    late final Color fg;
    late final Color bg;
    late final Color border;
    switch (type) {
      case StoreType.direct: // wv-badge-g
        fg = BisuColors.goldDeep;
        bg = const Color(0xFFF1E8D4);
        border = const Color(0xFFE0D2B2);
      case StoreType.reseller: // wv-badge-l
        fg = BisuColors.inkSoft;
        bg = BisuColors.white;
        border = BisuColors.hair;
      case StoreType.popup: // wv-badge-p
        fg = const Color(0xFF8B857A);
        bg = const Color(0xFFEEEBE3);
        border = const Color(0xFFE0DBD0);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}
