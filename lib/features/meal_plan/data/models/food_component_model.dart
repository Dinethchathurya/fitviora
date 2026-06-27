import '../../domain/entities/food_component.dart';
import '../../domain/entities/nutrition_info.dart';

class FoodComponentModel extends FoodComponent {
  const FoodComponentModel({
    required super.id,
    required super.name,
    required super.mealTypes,
    required super.mealRole,
    required super.category,
    required super.servingLabel,
    required super.nutrition,
    required super.dietTags,
    required super.healthFlags,
    required super.avoidWeatherTags,
    required super.allergenTags,
    required super.pairingRoles,
    required super.llmHints,
  });

  factory FoodComponentModel.fromJson(Map<String, dynamic> json) {
    final nutritionJson = json['nutrition'] as Map<String, dynamic>;

    return FoodComponentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mealTypes: _stringList(json['mealTypes']),
      mealRole: json['mealRole'] as String,
      category: json['category'] as String,
      servingLabel: json['servingLabel'] as String,
      nutrition: NutritionInfo(
        caloriesKcal: _toDouble(nutritionJson['caloriesKcal']),
        proteinG: _toDouble(nutritionJson['proteinG']),
        carbsG: _toDouble(nutritionJson['carbsG']),
        fatG: _toDouble(nutritionJson['fatG']),
      ),
      dietTags: _stringList(json['dietTags']),
      healthFlags: _stringList(json['healthFlags']),
      avoidWeatherTags: _stringList(json['avoidWeatherTags']),
      allergenTags: _stringList(json['allergenTags']),
      pairingRoles: _stringList(json['pairingRoles']),
      llmHints: Map<String, dynamic>.from(json['llmHints'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mealTypes': mealTypes,
      'mealRole': mealRole,
      'category': category,
      'servingLabel': servingLabel,
      'nutrition': {
        'caloriesKcal': nutrition.caloriesKcal,
        'proteinG': nutrition.proteinG,
        'carbsG': nutrition.carbsG,
        'fatG': nutrition.fatG,
      },
      'dietTags': dietTags,
      'healthFlags': healthFlags,
      'avoidWeatherTags': avoidWeatherTags,
      'allergenTags': allergenTags,
      'pairingRoles': pairingRoles,
      'llmHints': llmHints,
    };
  }

  FoodComponent toEntity() => FoodComponent(
        id: id,
        name: name,
        mealTypes: mealTypes,
        mealRole: mealRole,
        category: category,
        servingLabel: servingLabel,
        nutrition: nutrition,
        dietTags: dietTags,
        healthFlags: healthFlags,
        avoidWeatherTags: avoidWeatherTags,
        allergenTags: allergenTags,
        pairingRoles: pairingRoles,
        llmHints: llmHints,
      );

  static List<String> _stringList(dynamic value) {
    return (value as List).map((item) => item.toString()).toList();
  }

  static double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.parse(value.toString());
  }
}
