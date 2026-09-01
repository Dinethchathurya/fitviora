import '../entities/meal_diversity_analysis.dart';

abstract class MealDiversityRepository {
  Future<MealDiversityAnalysis> getMealDiversity({
    required DateTime endDate,
    int numberOfDays = 7,
  });
}