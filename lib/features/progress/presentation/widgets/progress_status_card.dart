import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

class ProgressStatusCard extends StatelessWidget {
  final String title;
  final String text;

  const ProgressStatusCard({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emerald50,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.emerald500,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

