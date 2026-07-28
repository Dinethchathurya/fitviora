import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

class BmiSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String weight;
  final String bmi;
  final Color badgeColor;
  final Color badgeTextColor;
  final String badgeText;

  const BmiSummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.weight,
    required this.bmi,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weight,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'BMI: $bmi',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}