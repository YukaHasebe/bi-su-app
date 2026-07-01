import 'package:flutter/material.dart';

import 'package:bisu_app/models/subscription.dart';
import 'package:bisu_app/shared/format.dart';
import 'package:bisu_app/shared/widgets/bisu_chip.dart';
import 'package:bisu_app/theme/bisu_colors.dart';

/// A subscription course card (mirrors `.card.sub-card` in styles.css /
/// `renderSubs` in app.js).
///
/// ```css
/// .sub-card{ display:flex; gap:13px; padding:14px; margin-bottom:12px; }
/// .sub-card.is-cancelled{ background:#F3F0E9; }
/// .sub-thumb{ width:74px; height:74px; border-radius:12px; border:1px solid var(--hair); }
/// ```
///
/// Active items show a gold `注文継続中` chip + `次回お届け`; cancelled items
/// show a grey `解約済み` chip + `最終お届け` and a desaturated thumbnail.
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.subscription});

  /// The subscription to render.
  final Subscription subscription;

  static const Color _cancelledBg = Color(0xFFF3F0E9);

  @override
  Widget build(BuildContext context) {
    final bool cancelled = subscription.isCancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cancelled ? _cancelledBg : BisuColors.paper,
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Thumb(img: subscription.img, desaturate: cancelled),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          subscription.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.45,
                            letterSpacing: 0.26,
                            color: BisuColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BisuChip(
                        label: cancelled ? '解約済み' : '注文継続中',
                        style:
                            cancelled ? BisuChipStyle.gray : BisuChipStyle.gold,
                        dot: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  _DefRow(
                    label: cancelled ? '最終お届け' : '次回お届け',
                    value: cancelled
                        ? (subscription.last ?? '—')
                        : (subscription.next ?? '—'),
                  ),
                  _DefRow(label: 'お届けサイクル', value: subscription.cycle),
                  _DefRow(label: '個数', value: '${subscription.qty}個'),
                  _DefRow(
                    label: 'ご注文金額',
                    value: yen(subscription.price),
                    valueIsPrice: true,
                    suffix: '(税込)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.img, required this.desaturate});

  final String img;
  final bool desaturate;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      img,
      width: 74,
      height: 74,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(color: BisuColors.white),
    );
    if (desaturate) {
      // filter:grayscale(.85) opacity(.75)
      image = Opacity(
        opacity: 0.75,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2589, 0.4570, 0.0876, 0, 0,
            0.2589, 0.4570, 0.0876, 0, 0,
            0.2589, 0.4570, 0.0876, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: image,
        ),
      );
    }
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: BisuColors.white,
        border: Border.all(color: BisuColors.hair),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: image,
    );
  }
}

class _DefRow extends StatelessWidget {
  const _DefRow({
    required this.label,
    required this.value,
    this.valueIsPrice = false,
    this.suffix,
  });

  final String label;
  final String value;
  final bool valueIsPrice;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: BisuColors.inkFaint,
                letterSpacing: 0.6,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamilyFallback: valueIsPrice
                      ? const <String>[
                          'Hiragino Mincho ProN',
                          'Yu Mincho',
                          'YuMincho',
                          'Noto Serif JP',
                          'Times New Roman',
                          'serif',
                        ]
                      : const <String>[
                          'Hiragino Kaku Gothic ProN',
                          'Yu Gothic Medium',
                          'YuGothic',
                          'Noto Sans JP',
                          'Segoe UI',
                          'sans-serif',
                        ],
                  fontSize: valueIsPrice ? 13 : 11.5,
                  fontWeight: FontWeight.w600,
                  color: BisuColors.ink,
                ),
                children: <InlineSpan>[
                  TextSpan(text: value),
                  if (suffix != null)
                    TextSpan(
                      text: ' $suffix',
                      style: const TextStyle(
                        fontSize: 9,
                        color: BisuColors.inkFaint,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
