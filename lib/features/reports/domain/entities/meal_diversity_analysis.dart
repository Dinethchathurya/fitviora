class MealDiversityFood {
  const MealDiversityFood({
    required this.componentId,
    required this.displayName,
    required this.count,
  });

  final String componentId;
  final String displayName;
  final int count;
}

class MealDiversityAnalysis {
  const MealDiversityAnalysis({
    required this.score,
    required this.uniqueFoodCount,
    required this.totalFoodSelections,
    required this.mealsAnalyzed,
    required this.repeatedFoods,
    required this.statusTitle,
    required this.statusMessage,
  });

  final int score;

  /// Number of different component IDs eaten during the period.
  final int uniqueFoodCount;

  /// Total number of component occurrences.
  ///
  /// Example:
  /// Rice + Dhal + Mallum = 3 selections.
  final int totalFoodSelections;

  /// Number of selected meals included in the analysis.
  final int mealsAnalyzed;

  /// Most commonly repeated foods.
  final List<MealDiversityFood> repeatedFoods;

  final String statusTitle;
  final String statusMessage;

  bool get hasData => mealsAnalyzed > 0;
}