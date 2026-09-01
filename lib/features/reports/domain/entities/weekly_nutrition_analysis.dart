class MealTypeContribution {
  const MealTypeContribution({
    required this.mealType,
    required this.calories,
    required this.percentage,
  });

  final String mealType;
  final int calories;
  final double percentage;
}

class BaseFoodUsage {
  const BaseFoodUsage({
    required this.baseFoodId,
    required this.displayName,
    required this.count,
  });

  final String baseFoodId;
  final String displayName;
  final int count;
}

class RepeatedMeal {
  const RepeatedMeal({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;
}

class WeeklyNutritionAnalysis {
  const WeeklyNutritionAnalysis({
    required this.startDate,
    required this.endDate,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.averageCalories,
    required this.highestCalorieDay,
    required this.highestCalorieValue,
    required this.lowestCalorieDay,
    required this.lowestCalorieValue,
    required this.mealsAnalyzed,
    required this.activeDays,
    required this.mealTypeContributions,
    required this.baseFoodUsage,
    required this.repeatedMeals,
  });

  final DateTime startDate;
  final DateTime endDate;

  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;

  final int averageCalories;

  final String highestCalorieDay;
  final int highestCalorieValue;

  final String lowestCalorieDay;
  final int lowestCalorieValue;

  final int mealsAnalyzed;
  final int activeDays;

  final List<MealTypeContribution> mealTypeContributions;
  final List<BaseFoodUsage> baseFoodUsage;
  final List<RepeatedMeal> repeatedMeals;

  bool get hasData => mealsAnalyzed > 0;

  int get uniqueBaseFoodCount => baseFoodUsage.length;
}