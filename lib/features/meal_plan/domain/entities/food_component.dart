import 'nutrition_info.dart';

class FoodComponent {
  const FoodComponent({
    required this.id,
    required this.name,
    required this.mealTypes,
    required this.mealRole,
    required this.category,
    required this.servingLabel,
    required this.nutrition,
    required this.dietTags,
    required this.healthFlags,
    required this.avoidWeatherTags,
    required this.allergenTags,
    required this.pairingRoles,
    required this.llmHints,
  });

  final String id;
  final String name;
  final List<String> mealTypes;
  final String mealRole;
  final String category;
  final String servingLabel;
  final NutritionInfo nutrition;
  final List<String> dietTags;
  final List<String> healthFlags;
  final List<String> avoidWeatherTags;
  final List<String> allergenTags;
  final List<String> pairingRoles;
  final Map<String, dynamic> llmHints;
}
