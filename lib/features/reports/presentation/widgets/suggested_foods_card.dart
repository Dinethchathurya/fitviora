import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SuggestedFoodsCard extends StatelessWidget {
  const SuggestedFoodsCard({super.key});

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
          const Text(
            'Suggested Foods',
            style: TextStyle(
fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 14),
          _FoodRow(
            background: const Color(0xFFDCEBFF),
            border: const Color(0xFFBFD7FF),
            title: 'Boiled Eggs',
            subtitle: 'High in Protein & Vitamin D',
          ),
          const SizedBox(height: 12),
          _FoodRow(
            background: const Color(0xFFE3F3FF),
            border: const Color(0xFFCFE9FF),
            title: 'Salmon',
            subtitle: 'Rich in Protein & Omega-3',
          ),
        ],
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  final Color background;
  final Color border;
  final String title;
  final String subtitle;

  const _FoodRow({
    required this.background,
    required this.border,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.restaurant,
            color: AppColors.blue600,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              elevation: 0,
              backgroundColor: AppColors.blue500,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

