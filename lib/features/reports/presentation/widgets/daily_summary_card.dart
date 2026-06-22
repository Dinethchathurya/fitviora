import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

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
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.emerald500),
              const SizedBox(width: 10),
              const Text(
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
            percent: '85%',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            backgroundColor: const Color(0xFFFFE7CC),
            valueColor: AppColors.orange500,
            label: 'Avg. Carbohydrates',
            percent: '89%',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            backgroundColor: const Color(0xFFFFE0E8),
            valueColor: AppColors.pink500,
            label: 'Avg. Fats',
            percent: '80%',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            backgroundColor: const Color(0xFFE9FBEF),
            valueColor: AppColors.emerald600,
            label: 'Avg. Calorie Adherence',
            percent: '91%',
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

