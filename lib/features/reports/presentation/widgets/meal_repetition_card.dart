import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/weekly_nutrition_analysis.dart';

class MealRepetitionCard
    extends StatelessWidget {
  const MealRepetitionCard({
    super.key,
    required this.meals,
  });

  final List<RepeatedMeal> meals;

  @override
  Widget build(BuildContext context) {
    final visibleMeals =
        meals.take(5).toList();

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
            'Meal Repetition',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
              color:
                  AppColors.gray900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Meals repeated during the last 7 days',
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
              color:
                  AppColors.gray600,
            ),
          ),

          const SizedBox(height: 14),

          if (visibleMeals.isEmpty)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                14,
              ),
              decoration:
                  BoxDecoration(
                color:
                    AppColors.emerald50,
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child: const Text(
                'No repeated meals this week. Great variety!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w800,
                  color: AppColors
                      .emerald600,
                ),
              ),
            )
          else
            ...List.generate(
              visibleMeals.length,
              (index) {
                final meal =
                    visibleMeals[index];

                return Padding(
                  padding:
                      EdgeInsets.only(
                    bottom: index <
                            visibleMeals
                                    .length -
                                1
                        ? 10
                        : 0,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets
                            .all(13),
                    decoration:
                        BoxDecoration(
                      color:
                          AppColors.gray50,
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .repeat_rounded,
                          size: 19,
                          color: AppColors
                              .orange500,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            meal.title,
                            style:
                                const TextStyle(
                              fontSize:
                                  12,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              color:
                                  AppColors
                                      .gray900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '×${meal.count}',
                          style:
                              const TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight
                                    .w900,
                            color: AppColors
                                .orange500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}