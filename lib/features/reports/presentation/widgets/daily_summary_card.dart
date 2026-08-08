import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DailySummaryCard extends StatelessWidget {
  final String proteinPercent;
  final String carbsPercent;
  final String fatsPercent;
  final String caloriePercent;

  const DailySummaryCard({
    super.key,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatsPercent,
    required this.caloriePercent,
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
          const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.emerald500,
              ),
              SizedBox(width: 10),
              Text(
                'Daily Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _SummaryRow(
            backgroundColor: const Color(0xFFE3F0FF),
            valueColor: AppColors.blue600,
            label: 'Avg. Protein',
            percent: proteinPercent,
          ),

          const SizedBox(height: 12),

          _SummaryRow(
            backgroundColor: const Color(0xFFFFE7CC),
            valueColor: AppColors.orange500,
            label: 'Avg. Carbohydrates',
            percent: carbsPercent,
          ),

          const SizedBox(height: 12),

          _SummaryRow(
            backgroundColor: const Color(0xFFFFE0E8),
            valueColor: AppColors.pink500,
            label: 'Avg. Fats',
            percent: fatsPercent,
          ),

          const SizedBox(height: 12),

          _SummaryRow(
            backgroundColor: const Color(0xFFE9FBEF),
            valueColor: AppColors.emerald600,
            label: 'Avg. Calorie Adherence',
            percent: caloriePercent,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final Color backgroundColor;
  final Color valueColor;
  final String label;
  final String percent;

  const _SummaryRow({
    required this.backgroundColor,
    required this.valueColor,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),
          ),
          Text(
            percent,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}