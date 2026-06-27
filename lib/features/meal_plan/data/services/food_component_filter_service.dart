import '../../domain/entities/food_component.dart';

class FoodComponentFilterService {
  const FoodComponentFilterService();

  List<FoodComponent> filter({
    required List<FoodComponent> components,
    required String mealType,
    required String dietaryPreference,
    required String goal,
    required List<String> allergies,
    required List<String> healthConditions,
    String? weatherCondition,
    String? bmiCategory,
  }) {
    return components.where((component) {
      if (!component.mealTypes.contains(mealType)) return false;
      if (!_matchesDiet(component, dietaryPreference)) return false;
      if (!_matchesGoal(component, goal)) return false;
      if (_hasAllergyConflict(component, allergies)) return false;
      if (!_matchesHealthConditions(component, healthConditions)) return false;
      if (!_matchesWeather(component, weatherCondition)) return false;
      if (!_matchesBmi(component, bmiCategory)) return false;
      return true;
    }).toList();
  }

  bool _matchesDiet(FoodComponent component, String dietaryPreference) {
    if (dietaryPreference.isEmpty || dietaryPreference == 'Any') return true;
    return component.dietTags.contains(dietaryPreference);
  }

  bool _matchesGoal(FoodComponent component, String goal) {
    if (goal.isEmpty) return true;

    if (goal == 'WeightLoss') {
      return component.healthFlags.contains('WeightLossFriendly') ||
          component.healthFlags.contains('Balanced') ||
          component.nutrition.caloriesKcal <= 250;
    }

    if (goal == 'WeightGain' || goal == 'MuscleGain') {
      return component.healthFlags.contains('HighProtein') ||
          component.healthFlags.contains('EnergyDense') ||
          component.healthFlags.contains('Balanced');
    }

    if (goal == 'Maintenance') {
      return component.healthFlags.contains('Balanced') ||
          component.healthFlags.contains('Traditional');
    }

    return true;
  }

  bool _hasAllergyConflict(FoodComponent component, List<String> allergies) {
    final normalizedAllergies = allergies.map(_normalize).toSet();

    return component.allergenTags.any(
      (allergen) => normalizedAllergies.contains(_normalize(allergen)),
    );
  }

  bool _matchesHealthConditions(
    FoodComponent component,
    List<String> healthConditions,
  ) {
    if (healthConditions.isEmpty) return true;

    for (final condition in healthConditions) {
      if (condition == 'Diabetes' &&
          component.healthFlags.contains('HighAddedSugar')) {
        return false;
      }

      if (condition == 'Hypertension' &&
          component.healthFlags.contains('HighSodium')) {
        return false;
      }
    }

    return true;
  }

  bool _matchesWeather(FoodComponent component, String? weatherCondition) {
    if (weatherCondition == null || weatherCondition.isEmpty) return true;

    final avoidTag = '${weatherCondition}Avoid';
    final directAvoidTag = weatherCondition;

    return !component.avoidWeatherTags.contains(avoidTag) &&
        !component.avoidWeatherTags.contains(directAvoidTag);
  }

  bool _matchesBmi(FoodComponent component, String? bmiCategory) {
    if (bmiCategory == null || bmiCategory.isEmpty) return true;

    if (bmiCategory == 'Overweight' || bmiCategory == 'Obese') {
      return !component.healthFlags.contains('EnergyDense');
    }

    if (bmiCategory == 'Underweight') {
      return component.healthFlags.contains('EnergyDense') ||
          component.healthFlags.contains('HighProtein') ||
          component.healthFlags.contains('Balanced');
    }

    return true;
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(' ', '');
  }
}
