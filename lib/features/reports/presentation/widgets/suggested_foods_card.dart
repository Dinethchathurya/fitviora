import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/daily_report.dart';

class SuggestedFoodsCard extends StatelessWidget {
  final List<SuggestedReportFood> foods;

  const SuggestedFoodsCard({
    super.key,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    final visibleFoods = foods.take(2).toList();

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

          if (visibleFoods.isEmpty)
            const Text(
              'No additional foods are required right now.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.gray600,
              ),
            )
          else
            ...List.generate(
              visibleFoods.length,
              (index) {
                final food = visibleFoods[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index < visibleFoods.length - 1 ? 12 : 0,
                  ),
                  child: _FoodRow(
                    background: index == 0
                        ? const Color(0xFFDCEBFF)
                        : const Color(0xFFE3F3FF),
                    border: index == 0
                        ? const Color(0xFFBFD7FF)
                        : const Color(0xFFCFE9FF),
                    title: food.name,
                    subtitle: food.reason,
                  ),
                );
              },
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
        border: Border.all(
          color: border,
        ),
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
          SizedBox(
            width: 80,
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
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
          ),
        ],
      ),
    );
  }
}