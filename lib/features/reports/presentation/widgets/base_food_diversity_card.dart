import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/weekly_nutrition_analysis.dart';

class BaseFoodDiversityCard
    extends StatelessWidget {
  const BaseFoodDiversityCard({
    super.key,
    required this.uniqueCount,
    required this.foods,
  });

  final int uniqueCount;
  final List<BaseFoodUsage> foods;

  @override
  Widget build(BuildContext context) {
    final visibleFoods =
        foods.take(6).toList();

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
            offset:
                const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Base Food Diversity',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
              color:
                  AppColors.gray900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$uniqueCount different base foods used this week',
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
              color:
                  AppColors.gray600,
            ),
          ),

          if (visibleFoods.isNotEmpty) ...[
            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  visibleFoods.map(
                (food) {
                  return Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          AppColors.emerald50,
                      borderRadius:
                          BorderRadius
                              .circular(
                        999,
                      ),
                    ),
                    child: Text(
                      '${food.displayName} ×${food.count}',
                      style:
                          const TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight
                                .w800,
                        color: AppColors
                            .emerald600,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ] else ...[
            const SizedBox(height: 14),
            const Text(
              'No base food data available for this week.',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
                color:
                    AppColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}