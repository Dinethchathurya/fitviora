import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class NutrientGapCard extends StatelessWidget {
  const NutrientGapCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          _GapWarningBox(
            label: 'Protein',
            subLabel: '— 17% below target',
            backgroundColor: const Color(0xFFFFF1CC),
            borderColor: const Color(0xFFFFD66A),
            textColor: AppColors.gray900,
          ),
          const SizedBox(height: 12),
          _GapWarningBox(
            label: 'Vitamin D',
            subLabel: '— 25% below target',
            backgroundColor: const Color(0xFFFFE6EA),
            borderColor: const Color(0xFFF8B4C0),
            textColor: AppColors.gray900,
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
        border: Border.all(color: borderColor),
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

