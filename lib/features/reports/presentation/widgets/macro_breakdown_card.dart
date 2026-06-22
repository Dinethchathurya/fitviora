import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class MacroBreakdownCard extends StatelessWidget {
  final double proteinProgress;
  final double carbsProgress;
  final double fatsProgress;

  const MacroBreakdownCard({
    super.key,
    required this.proteinProgress,
    required this.carbsProgress,
    required this.fatsProgress,
  });

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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Macronutrient Breakdown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 18,
                  color: AppColors.emerald600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MacroRow(
            label: 'Protein',
            value: '125g / 150g',
            progressColor: AppColors.blue500,
            progress: proteinProgress,
          ),
          const SizedBox(height: 16),
          _MacroRow(
            label: 'Carbs',
            value: '198g / 225g',
            progressColor: AppColors.orange500,
            progress: carbsProgress,
          ),
          const SizedBox(height: 16),
          _MacroRow(
            label: 'Fats',
            value: '52g / 67g',
            progressColor: AppColors.pink500,
            progress: fatsProgress,
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color progressColor;

  const _MacroRow({
    required this.label,
    required this.value,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: safeProgress,
            minHeight: 10,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}

