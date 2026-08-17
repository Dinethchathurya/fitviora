import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class MealTypeContributionCard
    extends StatelessWidget {
  const MealTypeContributionCard({
    super.key,
    required this.breakfastProgress,
    required this.lunchProgress,
    required this.dinnerProgress,
    required this.breakfastPercentage,
    required this.lunchPercentage,
    required this.dinnerPercentage,
    required this.breakfastCalories,
    required this.lunchCalories,
    required this.dinnerCalories,
  });

  final double breakfastProgress;
  final double lunchProgress;
  final double dinnerProgress;

  final String breakfastPercentage;
  final String lunchPercentage;
  final String dinnerPercentage;

  final String breakfastCalories;
  final String lunchCalories;
  final String dinnerCalories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Meal Type Contribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
              color:
                  AppColors.gray900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Share of weekly calories',
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.gray600,
            ),
          ),

          const SizedBox(height: 16),

          _ContributionRow(
            label: 'Breakfast',
            percentage:
                breakfastPercentage,
            calories:
                breakfastCalories,
            progress:
                breakfastProgress,
            progressColor:
                AppColors.orange500,
          ),

          const SizedBox(height: 16),

          _ContributionRow(
            label: 'Lunch',
            percentage:
                lunchPercentage,
            calories:
                lunchCalories,
            progress:
                lunchProgress,
            progressColor:
                AppColors.emerald500,
          ),

          const SizedBox(height: 16),

          _ContributionRow(
            label: 'Dinner',
            percentage:
                dinnerPercentage,
            calories:
                dinnerCalories,
            progress:
                dinnerProgress,
            progressColor:
                AppColors.blue500,
          ),
        ],
      ),
    );
  }
}

class _ContributionRow
    extends StatelessWidget {
  const _ContributionRow({
    required this.label,
    required this.percentage,
    required this.calories,
    required this.progress,
    required this.progressColor,
  });

  final String label;
  final String percentage;
  final String calories;
  final double progress;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style:
                    const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      AppColors.gray900,
                ),
              ),
            ),
            Text(
              percentage,
              style:
                  const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w900,
                color:
                    AppColors.gray900,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            999,
          ),
          child:
              LinearProgressIndicator(
            value: progress.clamp(
              0.0,
              1.0,
            ),
            minHeight: 9,
            backgroundColor:
                AppColors.gray200,
            valueColor:
                AlwaysStoppedAnimation<
                    Color>(
              progressColor,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          calories,
          style: const TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
            color:
                AppColors.gray500,
          ),
        ),
      ],
    );
  }
}