import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/meal_diversity_analysis.dart';

class MealDiversityCard extends StatelessWidget {
  const MealDiversityCard({
    super.key,
    required this.score,
    required this.progress,
    required this.uniqueFoodCount,
    required this.mealsAnalyzed,
    required this.title,
    required this.message,
    required this.repeatedFoods,
  });

  final int score;
  final double progress;
  final int uniqueFoodCount;
  final int mealsAnalyzed;
  final String title;
  final String message;
  final List<MealDiversityFood> repeatedFoods;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
                Icons.diversity_1_rounded,
                color: AppColors.emerald600,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Meal Diversity',
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
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray900,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3,
                ),
                child: Text(
                  '/ 100',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(
                0.0,
                1.0,
              ),
              minHeight: 9,
              backgroundColor:
                  AppColors.gray200,
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                AppColors.emerald500,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.gray600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Unique Foods',
                  value: '$uniqueFoodCount',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'Meals Analyzed',
                  value: '$mealsAnalyzed',
                ),
              ),
            ],
          ),

          if (repeatedFoods.isNotEmpty) ...[
            const SizedBox(height: 18),

            const Text(
              'Most Repeated',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: repeatedFoods
                  .map(
                    (food) => Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.emerald50,
                        borderRadius:
                            BorderRadius.circular(
                          999,
                        ),
                      ),
                      child: Text(
                        '${food.displayName} ×${food.count}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              AppColors.emerald600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}