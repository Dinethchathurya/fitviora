import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class NutrientRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color progressColor;

  const NutrientRow({
    super.key,
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
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
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

