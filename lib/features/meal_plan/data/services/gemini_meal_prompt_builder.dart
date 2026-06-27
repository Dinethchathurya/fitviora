import 'dart:convert';

import '../../domain/entities/food_component.dart';

class GeminiMealPromptBuilder {
  const GeminiMealPromptBuilder();

  String build({
    required List<FoodComponent> components,
    required String mealType,
    required String dietaryPreference,
    required String goal,
    required List<String> allergies,
    required List<String> healthConditions,
    required double bmi,
    required String bmiCategory,
    required String weatherCondition,
    required double temperatureCelsius,
    required int humidity,
    int mealCount = 3,
  }) {
    final payload = {
      'task': 'Create Sri Lankan meal recommendations from the provided food components only.',
      'rules': [
        'Return valid JSON only. Do not include markdown.',
        'Use only component ids from availableComponents.',
        'Each meal must include a sensible Sri Lankan combination, for example base + protein/curry + vegetable/side where appropriate.',
        'Avoid allergens and unsuitable health-condition items.',
        'Consider weather, goal and BMI category when selecting meals.',
      ],
      'userContext': {
        'mealType': mealType,
        'dietaryPreference': dietaryPreference,
        'goal': goal,
        'allergies': allergies,
        'healthConditions': healthConditions,
        'bmi': bmi,
        'bmiCategory': bmiCategory,
        'weather': {
          'condition': weatherCondition,
          'temperatureCelsius': temperatureCelsius,
          'humidity': humidity,
        },
      },
      'outputJsonSchema': {
        'meals': [
          {
            'title': 'string',
            'mealType': 'string',
            'componentIds': ['string'],
            'reason': 'string',
            'healthNotes': ['string'],
            'weatherNote': 'string',
            'nutritionEstimate': {
              'caloriesKcal': 'number',
              'proteinG': 'number',
              'carbsG': 'number',
              'fatG': 'number',
            },
          }
        ],
      },
      'mealCount': mealCount,
      'availableComponents': components.map(_componentToPromptJson).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Map<String, dynamic> _componentToPromptJson(FoodComponent component) {
    return {
      'id': component.id,
      'name': component.name,
      'mealTypes': component.mealTypes,
      'mealRole': component.mealRole,
      'category': component.category,
      'servingLabel': component.servingLabel,
      'nutrition': {
        'caloriesKcal': component.nutrition.caloriesKcal,
        'proteinG': component.nutrition.proteinG,
        'carbsG': component.nutrition.carbsG,
        'fatG': component.nutrition.fatG,
      },
      'dietTags': component.dietTags,
      'healthFlags': component.healthFlags,
      'avoidWeatherTags': component.avoidWeatherTags,
      'allergenTags': component.allergenTags,
      'pairingRoles': component.pairingRoles,
      'llmHints': component.llmHints,
    };
  }
}
