import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class WeeklyNutritionSummaryCard
    extends StatelessWidget {
  const WeeklyNutritionSummaryCard({
    super.key,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.averageCalories,
    required this.highestDay,
    required this.lowestDay,
  });

  final String totalCalories;
  final String totalProtein;
  final String totalCarbs;
  final String totalFat;

  final String averageCalories;
  final String highestDay;
  final String lowestDay;

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
          const Row(
            children: [
              Icon(
                Icons.calendar_view_week_rounded,
                color: AppColors.emerald600,
                size: 21,
              ),
              SizedBox(width: 10),
              Text(
                '7-Day Nutrition Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Calories',
                  value: totalCalories,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryStat(
                  label: 'Protein',
                  value: totalProtein,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Carbs',
                  value: totalCarbs,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryStat(
                  label: 'Fats',
                  value: totalFat,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(
            color: AppColors.gray200,
          ),

          const SizedBox(height: 10),

          _InformationRow(
            label:
                'Average Daily Calories',
            value: averageCalories,
          ),

          const SizedBox(height: 10),

          _InformationRow(
            label:
                'Highest Calorie Day',
            value: highestDay,
          ),

          const SizedBox(height: 10),

          _InformationRow(
            label:
                'Lowest Calorie Day',
            value: lowestDay,
          ),
        ],
      ),
    );
  }
}

class _SummaryStat
    extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.emerald50,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
              color:
                  AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,
              color:
                  AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationRow
    extends StatelessWidget {
  const _InformationRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
              color:
                  AppColors.gray600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w900,
            color:
                AppColors.gray900,
          ),
        ),
      ],
    );
  }
}