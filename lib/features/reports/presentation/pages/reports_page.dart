import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../viewmodels/reports_view_model.dart';
import '../widgets/base_food_diversity_card.dart';
import '../widgets/macro_breakdown_card.dart';
import '../widgets/meal_repetition_card.dart';
import '../widgets/meal_type_contribution_card.dart';
import '../widgets/report_metric_card.dart';
import '../widgets/report_status_card.dart';
import '../widgets/weekly_nutrition_summary_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
  });

  @override
  State<ReportsPage> createState() =>
      _ReportsPageState();
}

class _ReportsPageState
    extends State<ReportsPage> {
  late final ReportsViewModel
      _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel =
        ReportsViewModel();

    _viewModel.addListener(
      _onViewModelChanged,
    );

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        _viewModel.loadReport();
      },
    );
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(
      _onViewModelChanged,
    );

    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_viewModel.isLoading &&
        !_viewModel.hasData) {
      return const SafeArea(
        child: Center(
          child:
              CircularProgressIndicator(
            color:
                AppColors.emerald500,
          ),
        ),
      );
    }

    if (_viewModel.error != null &&
        !_viewModel.hasData) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: Text(
              _viewModel.error!,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w700,
                color:
                    AppColors.gray600,
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh:
            _viewModel.refresh,
        color:
            AppColors.emerald500,
        child:
            SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 19,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
              children: [
                const SizedBox(
                  height: 12,
                ),

                // --------------------------------------
                // Header
                // --------------------------------------

                Container(
                  padding:
                      const EdgeInsets
                          .only(
                    top: 8,
                    bottom: 16,
                  ),
                  decoration:
                      const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(
                        color: AppColors
                            .gray200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Nutrition Report',
                        style:
                            TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight
                                  .w900,
                          color: AppColors
                              .gray900,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        _viewModel
                            .dateLabel,
                        style:
                            const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight
                                  .w800,
                          color: AppColors
                              .gray600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // --------------------------------------
                // Existing today's calories
                // --------------------------------------

                ReportMetricCard(
                  label:
                      'Today\'s Calories',
                  value:
                      _viewModel
                          .calorieText,
                  progress:
                      _viewModel
                          .calorieProgress,
                ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // Existing today's macros
                // --------------------------------------

                // MacroBreakdownCard(
                //   proteinProgress:
                //       _viewModel
                //           .proteinProgress,
                //   carbsProgress:
                //       _viewModel
                //           .carbsProgress,
                //   fatsProgress:
                //       _viewModel
                //           .fatProgress,
                //   proteinValue:
                //       _viewModel
                //           .proteinText,
                //   carbsValue:
                //       _viewModel
                //           .carbsText,
                //   fatsValue:
                //       _viewModel
                //           .fatText,
                // ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // NEW: Weekly nutrition totals
                // --------------------------------------

                WeeklyNutritionSummaryCard(
                  totalCalories:
                      _viewModel
                          .weeklyCaloriesText,
                  totalProtein:
                      _viewModel
                          .weeklyProteinText,
                  totalCarbs:
                      _viewModel
                          .weeklyCarbsText,
                  totalFat:
                      _viewModel
                          .weeklyFatText,
                  averageCalories:
                      _viewModel
                          .weeklyAverageCaloriesText,
                  highestDay:
                      _viewModel
                          .highestCalorieDayText,
                  lowestDay:
                      _viewModel
                          .lowestCalorieDayText,
                ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // NEW: Meal Type Contribution
                // --------------------------------------

                MealTypeContributionCard(
                  breakfastProgress:
                      _viewModel
                          .breakfastContribution,
                  lunchProgress:
                      _viewModel
                          .lunchContribution,
                  dinnerProgress:
                      _viewModel
                          .dinnerContribution,
                  breakfastPercentage:
                      _viewModel
                          .breakfastContributionText,
                  lunchPercentage:
                      _viewModel
                          .lunchContributionText,
                  dinnerPercentage:
                      _viewModel
                          .dinnerContributionText,
                  breakfastCalories:
                      _viewModel
                          .breakfastCaloriesText,
                  lunchCalories:
                      _viewModel
                          .lunchCaloriesText,
                  dinnerCalories:
                      _viewModel
                          .dinnerCaloriesText,
                ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // NEW: Base Food Diversity
                // --------------------------------------

                BaseFoodDiversityCard(
                  uniqueCount:
                      _viewModel
                          .uniqueBaseFoodCount,
                  foods:
                      _viewModel
                          .baseFoodUsage,
                ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // NEW: Meal Repetition
                // --------------------------------------

                MealRepetitionCard(
                  meals:
                      _viewModel
                          .repeatedMeals,
                ),

                const SizedBox(
                  height: 16,
                ),

                // --------------------------------------
                // Existing Final Status
                // --------------------------------------

                ReportStatusCard(
                  title:
                      _viewModel
                          .statusTitle,
                  message:
                      _viewModel
                          .statusMessage,
                ),

                const SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}