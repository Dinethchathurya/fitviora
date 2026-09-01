import 'package:flutter/foundation.dart';

import '../../data/datasources/report_remote_data_source.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/weekly_nutrition_repository_impl.dart';
import '../../domain/entities/daily_report.dart';
import '../../domain/entities/weekly_nutrition_analysis.dart';
import '../../domain/usecases/get_daily_report_usecase.dart';
import '../../domain/usecases/get_weekly_nutrition_analysis_usecase.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel({
    GetDailyReportUseCase? getDailyReportUseCase,
    GetWeeklyNutritionAnalysisUseCase?
        getWeeklyNutritionAnalysisUseCase,
  })  : _getDailyReportUseCase =
            getDailyReportUseCase ??
                GetDailyReportUseCase(
                  ReportRepositoryImpl(
                    remoteDataSource:
                        const ReportRemoteDataSource(),
                  ),
                ),
        _getWeeklyNutritionAnalysisUseCase =
            getWeeklyNutritionAnalysisUseCase ??
                GetWeeklyNutritionAnalysisUseCase(
                  WeeklyNutritionRepositoryImpl(),
                );

  final GetDailyReportUseCase
      _getDailyReportUseCase;

  final GetWeeklyNutritionAnalysisUseCase
      _getWeeklyNutritionAnalysisUseCase;

  DailyReport? _report;

  DailyReport? get report => _report;

  WeeklyNutritionAnalysis? _weeklyAnalysis;

  WeeklyNutritionAnalysis?
      get weeklyAnalysis =>
          _weeklyAnalysis;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  bool get hasData =>
      _report != null ||
      _weeklyAnalysis != null;

  // ------------------------------------------------------------
  // Load
  // ------------------------------------------------------------

  Future<void> loadReport({
    DateTime? date,
  }) async {
    if (_isLoading) {
      return;
    }

    final selectedDate =
        date ?? DateTime.now();

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      /*
       * Existing daily report.
       */
      _report =
          await _getDailyReportUseCase(
        date: selectedDate,
      );

      /*
       * NEW weekly analysis.
       */
      _weeklyAnalysis =
          await _getWeeklyNutritionAnalysisUseCase(
        endDate: selectedDate,
      );
    } catch (e) {
      _error = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadReport(
      date: _report?.date ??
          DateTime.now(),
    );
  }

  // ------------------------------------------------------------
  // EXISTING DAILY REPORT
  // ------------------------------------------------------------

  String get dateLabel =>
      _report?.dateLabel ?? '';

  String get calorieText =>
      _report?.calorieText ??
      '0 / 0 kcal';

  double get calorieProgress =>
      _report?.calorieProgress ?? 0;

  String get proteinText =>
      _report?.proteinText ??
      '0g / 0g';

  String get carbsText =>
      _report?.carbsText ??
      '0g / 0g';

  String get fatText =>
      _report?.fatText ??
      '0g / 0g';

  double get proteinProgress =>
      _report?.proteinProgress ?? 0;

  double get carbsProgress =>
      _report?.carbsProgress ?? 0;

  double get fatProgress =>
      _report?.fatProgress ?? 0;

  String get statusTitle =>
      _report?.statusTitle ??
      'Daily Report';

  String get statusMessage =>
      _report?.statusMessage ??
      'No report data available.';

  // ------------------------------------------------------------
  // WEEKLY SUMMARY
  // ------------------------------------------------------------

  String get weeklyCaloriesText =>
      '${_weeklyAnalysis?.totalCalories ?? 0} kcal';

  String get weeklyProteinText =>
      '${(_weeklyAnalysis?.totalProteinG ?? 0).round()}g';

  String get weeklyCarbsText =>
      '${(_weeklyAnalysis?.totalCarbsG ?? 0).round()}g';

  String get weeklyFatText =>
      '${(_weeklyAnalysis?.totalFatG ?? 0).round()}g';

  String get weeklyAverageCaloriesText =>
      '${_weeklyAnalysis?.averageCalories ?? 0} kcal';

  int get weeklyMealsAnalyzed =>
      _weeklyAnalysis?.mealsAnalyzed ?? 0;

  int get weeklyActiveDays =>
      _weeklyAnalysis?.activeDays ?? 0;

  String get highestCalorieDayText {
    final data = _weeklyAnalysis;

    if (data == null ||
        data.highestCalorieValue == 0) {
      return 'No data';
    }

    return '${data.highestCalorieDay} • '
        '${data.highestCalorieValue} kcal';
  }

  String get lowestCalorieDayText {
    final data = _weeklyAnalysis;

    if (data == null ||
        data.lowestCalorieValue == 0) {
      return 'No data';
    }

    return '${data.lowestCalorieDay} • '
        '${data.lowestCalorieValue} kcal';
  }

  // ------------------------------------------------------------
  // MEAL TYPE CONTRIBUTION
  // ------------------------------------------------------------

  List<MealTypeContribution>
      get mealTypeContributions =>
          _weeklyAnalysis
              ?.mealTypeContributions ??
          const [];

  MealTypeContribution
      _mealContribution(
    String type,
  ) {
    for (final contribution
        in mealTypeContributions) {
      if (contribution.mealType ==
          type) {
        return contribution;
      }
    }

    return MealTypeContribution(
      mealType: type,
      calories: 0,
      percentage: 0,
    );
  }

  double get breakfastContribution =>
      _mealContribution(
        'Breakfast',
      ).percentage /
      100;

  double get lunchContribution =>
      _mealContribution(
        'Lunch',
      ).percentage /
      100;

  double get dinnerContribution =>
      _mealContribution(
        'Dinner',
      ).percentage /
      100;

  String get breakfastContributionText =>
      '${_mealContribution('Breakfast').percentage.round()}%';

  String get lunchContributionText =>
      '${_mealContribution('Lunch').percentage.round()}%';

  String get dinnerContributionText =>
      '${_mealContribution('Dinner').percentage.round()}%';

  String get breakfastCaloriesText =>
      '${_mealContribution('Breakfast').calories} kcal';

  String get lunchCaloriesText =>
      '${_mealContribution('Lunch').calories} kcal';

  String get dinnerCaloriesText =>
      '${_mealContribution('Dinner').calories} kcal';

  // ------------------------------------------------------------
  // BASE FOOD DIVERSITY
  // ------------------------------------------------------------

  List<BaseFoodUsage>
      get baseFoodUsage =>
          _weeklyAnalysis
              ?.baseFoodUsage ??
          const [];

  int get uniqueBaseFoodCount =>
      _weeklyAnalysis
          ?.uniqueBaseFoodCount ??
      0;

  // ------------------------------------------------------------
  // MEAL REPETITION
  // ------------------------------------------------------------

  List<RepeatedMeal>
      get repeatedMeals =>
          _weeklyAnalysis
              ?.repeatedMeals ??
          const [];

  bool get hasRepeatedMeals =>
      repeatedMeals.isNotEmpty;
}