import 'package:flutter/material.dart';

import 'package:bisu_app/data/mock_data.dart';
import 'package:bisu_app/features/extras/overlay_page.dart';
import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/shared/format.dart';
import 'package:bisu_app/shared/swallow_svg.dart';
import 'package:bisu_app/state/app_state.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// CLUB MEMBERS PROGRAM (SCR-102).
///
/// Mirrors app.js `openClub()` (1073–1093) + `clubBenefits()` (1064–1072) and
/// index.html `#screen-club`. Lead copy, the five rank tiers (current rank
/// highlighted with a `現在` badge + colored border/glow), per-tier rows
/// (年間購入金額 / 還元率 / 特典), and the closing note.
class ClubProgramScreen extends StatelessWidget {
  const ClubProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RankId current = AppScope.watch(context).rankId;

    return OverlayPage(
      title: 'CLUB MEMBERS PROGRAM',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // .club-lead
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 2, 4, 16),
            child: Text(
              '年間のご購入金額に応じて翌年のステータスが決まり、毎年1月に更新されます。'
              'アプリには前年確定の公式ステータスを表示します。',
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 11.5,
                height: 1.9,
                color: BisuColors.inkSoft,
              ),
            ),
          ),
          // .club-tier × 5 (member → diamond)
          for (final Rank rank in Ranks.all)
            _ClubTier(rank: rank, isCurrent: rank.id == current),
          // .club-note
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 6, 4, 6),
            child: Text(
              '※ 集計期間・対象（税込/税抜・返品・店頭購入の扱い等）の細則は'
              '確定後に反映します（OP-03）。',
              style: TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 9.5,
                height: 1.8,
                color: BisuColors.inkFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single `.club-tier` card.
class _ClubTier extends StatelessWidget {
  const _ClubTier({required this.rank, required this.isCurrent});

  final Rank rank;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    // thr = threshold>0 ? '年間 ¥... 〜' : '一般会員（ご入会で付与）'
    final String thr = rank.threshold > 0
        ? '年間 ${yen(rank.threshold)} 〜'
        : '一般会員（ご入会で付与）';

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BisuColors.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? rank.color : BisuColors.hair,
          // .is-current adds box-shadow 0 0 0 1.5px var(--rk); approximate the
          // ring with a slightly heavier colored border.
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: <BoxShadow>[
          if (isCurrent)
            const BoxShadow(
              color: Color(0x24785A28), // rgba(120,90,40,.14)
              blurRadius: 14,
              offset: Offset(0, 4),
            )
          else
            const BoxShadow(
              color: Color(0x0D463C28), // rgba(70,60,40,.05)
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // .club-tier-head
          Row(
            children: <Widget>[
              // .club-tier-head svg{ width:30px; height:24px; }
              SwallowEmblem(color: rank.color, width: 30, height: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // .club-tier-en
                    Text(
                      rank.en,
                      style: const TextStyle(
                        fontFamilyFallback: BisuType.serifFallback,
                        fontSize: 14,
                        letterSpacing: 2.52, // ~.18em of 14px
                        color: BisuColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // .club-tier-jp
                    Text(
                      rank.jp,
                      style: const TextStyle(
                        fontFamilyFallback: BisuType.sansFallback,
                        fontSize: 9.5,
                        color: BisuColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent) ...<Widget>[
                const SizedBox(width: 8),
                // .club-now
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: rank.color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '現在',
                    style: TextStyle(
                      fontFamilyFallback: BisuType.sansFallback,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: BisuColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 11),
          // .club-tier-rows (dl/dt/dd grid: auto 1fr, gap 5×12)
          _TierRow(label: '年間購入金額', value: thr),
          const SizedBox(height: 5),
          _TierRow(label: '還元率', value: '100円 = ${rank.rate}pt'),
          const SizedBox(height: 5),
          _TierRow(label: '特典', value: clubBenefits(rank.id)),
        ],
      ),
    );
  }
}

/// One `dt`/`dd` line of `.club-tier-rows`.
class _TierRow extends StatelessWidget {
  const _TierRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // dt: fixed-ish label column (grid-template-columns: auto 1fr).
        SizedBox(
          width: 72,
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              label,
              style: const TextStyle(
                fontFamilyFallback: BisuType.sansFallback,
                fontSize: 10,
                letterSpacing: 0.6, // ~.06em
                color: BisuColors.inkFaint,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // dd
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 11.5,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: BisuColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
