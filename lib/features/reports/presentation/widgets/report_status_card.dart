import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ReportStatusCard extends StatelessWidget {
  const ReportStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.emerald50,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald600.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.emerald100,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.gray200),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.emerald600,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Excellent Progress! 🎉',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "You're consistently meeting your nutritional goals. Consider adding more protein-rich foods to bridge the remaining gap.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

