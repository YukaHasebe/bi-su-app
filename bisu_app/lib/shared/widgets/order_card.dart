import 'package:flutter/material.dart';

import 'package:bisu_app/models/order.dart';
import 'package:bisu_app/shared/format.dart';
import 'package:bisu_app/shared/widgets/bisu_chip.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// A past-order card (mirrors `.card.order-card` in styles.css / `renderHistory`).
///
/// ```css
/// .order-card{ padding:13px 14px; margin-bottom:12px; }
/// .order-top{ ...; border-bottom:1px dashed var(--hair); }
/// .order-thumb{ width:58px; height:58px; border-radius:10px; border:1px solid var(--hair); }
/// .order-price{ font-family:var(--serif); font-size:15px; }
/// ```
///
/// Chips (in order): kind (定期購入 = gold / 通常購入 = line), channel
/// (ネット注文 / 店頭購入 = line), and — for in-store buys — the store name (line).
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  /// The order to render.
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BisuColors.paper,
        border: Border.all(color: BisuColors.hair),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F463C28), // rgba(70,60,40,.06)
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ---- top row (出荷日 + 注文番号), dashed underline ----
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: '出荷日 ',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: BisuColors.inkFaint,
                              letterSpacing: 0.4,
                            ),
                          ),
                          TextSpan(
                            text: order.date,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: BisuColors.ink,
                              letterSpacing: 0.44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '注文番号 ${order.no}',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: BisuColors.inkFaint,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
            const _DashedDivider(),
            const SizedBox(height: 11),
            // ---- mid (thumb + name + chips) ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: BisuColors.white,
                    border: Border.all(color: BisuColors.hair),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    order.img,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: BisuColors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        order.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                          color: BisuColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: <Widget>[
                          BisuChip(
                            label: order.kindLabel,
                            style: order.kind == OrderKind.subscription
                                ? BisuChipStyle.gold
                                : BisuChipStyle.line,
                          ),
                          BisuChip(
                            label: order.channelLabel,
                            style: BisuChipStyle.line,
                          ),
                          if (order.channelSub != null)
                            BisuChip(
                              label: order.channelSub!,
                              style: BisuChipStyle.line,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ---- bottom (qty + price) ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '数量 ${order.qty}点',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: BisuColors.inkSoft,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: yen(order.price),
                        style: const TextStyle(
                          fontFamilyFallback: <String>[
                            'Hiragino Mincho ProN',
                            'Yu Mincho',
                            'YuMincho',
                            'Noto Serif JP',
                            'Times New Roman',
                            'serif',
                          ],
                          fontSize: 15,
                          letterSpacing: 0.6,
                          color: BisuColors.ink,
                        ),
                      ),
                      const TextSpan(
                        text: '(税込)',
                        style: TextStyle(
                          fontSize: 10,
                          color: BisuColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reproduces `border-bottom:1px dashed var(--hair)`.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashedPainter()),
    );
  }
}

class _DashedPainter extends CustomPainter {
  static const double _dash = 4;
  static const double _gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = BisuColors.hair
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + _dash, 0), paint);
      x += _dash + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter oldDelegate) => false;
}
