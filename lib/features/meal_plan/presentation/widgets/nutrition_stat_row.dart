import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

class NutritionStatRow extends StatelessWidget {
  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  const NutritionStatRow({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    Widget statColumn({
      required String label,
      required String value,
      required Color valueColor,
    }) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.gray500,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        statColumn(
          label: 'Calories',
          value: '$calories',
          valueColor: AppColors.gray900,
        ),
        const SizedBox(width: 10),
        statColumn(
          label: 'Protein',
          value: protein,
          valueColor: AppColors.blue500,
        ),
        const SizedBox(width: 10),
        statColumn(
          label: 'Carbs',
          value: carbs,
          valueColor: AppColors.orange500,
        ),
        const SizedBox(width: 10),
        statColumn(
          label: 'Fat',
          value: fat,
          valueColor: AppColors.pink500,
        ),
      ],
    );
  }
}

