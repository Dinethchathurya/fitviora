import '../entities/food_item.dart';
import '../entities/food_variant.dart';

class MealSuggestionService {
  const MealSuggestionService();

  List<FoodItem> suggestMeals({
    required List<FoodItem> foods,
    required String mealType,
    required String dietaryPreference,
    required String goal,
    List<String> allergies = const [],
    int limit = 10,
  }) {
    final scoredFoods = <_ScoredFood>[];

    for (final food in foods) {
      if (!food.mealTypes.contains(mealType)) continue;

      final variant = _defaultVariant(food);
      if (variant == null) continue;

      if (_hasAllergyConflict(variant, allergies)) continue;
      if (!_matchesDietaryPreference(variant, dietaryPreference)) continue;

      final score = _calculateScore(
        food: food,
        variant: variant,
        mealType: mealType,
        goal: goal,
      );

      scoredFoods.add(_ScoredFood(food: food, score: score));
    }

    scoredFoods.sort((a, b) => b.score.compareTo(a.score));

    return scoredFoods.take(limit).map((item) => item.food).toList();
  }

  FoodVariant? _defaultVariant(FoodItem food) {
    if (food.variants.isEmpty) return null;

    return food.variants.firstWhere(
      (variant) => variant.isDefaultVariant,
      orElse: () => food.variants.first,
    );
  }

  bool _hasAllergyConflict(FoodVariant variant, List<String> allergies) {
    return variant.allergenTags.any(
      (allergen) => allergies.contains(allergen),
    );
  }

  bool _matchesDietaryPreference(
    FoodVariant variant,
    String dietaryPreference,
  ) {
    if (dietaryPreference.isEmpty || dietaryPreference == 'Any') {
      return true;
    }

    return variant.preferenceTags.contains(dietaryPreference);
  }

  int _calculateScore({
    required FoodItem food,
    required FoodVariant variant,
    required String mealType,
    required String goal,
  }) {
    var score = 0;

    if (food.mealTypes.contains(mealType)) score += 20;

    if (variant.goalFitTargets.contains(goal)) score += 35;

    if (variant.healthFlags.contains('Balanced')) score += 15;

    if (goal == 'WeightLoss') {
      if (variant.healthFlags.contains('WeightLossFriendly')) score += 25;
      if (variant.healthFlags.contains('LowAddedSugar')) score += 10;
      if (variant.nutrition.caloriesKcal <= 250) score += 10;
    }

    if (goal == 'MuscleGain') {
      if (variant.healthFlags.contains('HighProtein')) score += 25;
      if (variant.nutrition.proteinG >= 10) score += 10;
    }

    if (goal == 'Maintenance') {
      if (variant.healthFlags.contains('Balanced')) score += 20;
      if (variant.healthFlags.contains('Traditional')) score += 5;
    }

    return score;
  }
}

class _ScoredFood {
  const _ScoredFood({
    required this.food,
    required this.score,
  });

  final FoodItem food;
  final int score;
}