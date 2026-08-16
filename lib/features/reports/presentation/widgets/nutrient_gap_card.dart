import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/daily_report.dart';

class NutrientGapCard extends StatelessWidget {
  final List<NutrientGap> gaps;

  const NutrientGapCard({
    super.key,
    required this.gaps,
  });

  @override
  Widget build(BuildContext context) {
    final visibleGaps = gaps.take(2).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Nutrient Gap Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
            ),
          ),

          const SizedBox(height: 14),

          if (visibleGaps.isEmpty)
            const _GapWarningBox(
              label: 'No major gaps',
              subLabel: '— targets are on track',
              backgroundColor: Color(0xFFE9FBEF),
              borderColor: AppColors.emerald500,
              textColor: AppColors.gray900,
            )
          else
            ...List.generate(
              visibleGaps.length,
              (index) {
                final gap = visibleGaps[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index < visibleGaps.length - 1 ? 12 : 0,
                  ),
                  child: _GapWarningBox(
                    label: gap.name,
                    subLabel:
                        '— ${gap.gapPercentage.round()}% below target',
                    backgroundColor: index == 0
                        ? const Color(0xFFFFF1CC)
                        : const Color(0xFFFFE6EA),
                    borderColor: index == 0
                        ? const Color(0xFFFFD66A)
                        : const Color(0xFFF8B4C0),
                    textColor: AppColors.gray900,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _GapWarningBox extends StatelessWidget {
  final String label;
  final String subLabel;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _GapWarningBox({
    required this.label,
    required this.subLabel,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: borderColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label $subLabel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}