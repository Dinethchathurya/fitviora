import '../entities/weekly_nutrition_analysis.dart';

abstract class WeeklyNutritionRepository {
  Future<WeeklyNutritionAnalysis> getWeeklyAnalysis({
    required DateTime endDate,
  });
}