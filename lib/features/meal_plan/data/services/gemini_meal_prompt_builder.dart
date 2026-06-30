
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
    final limitedComponents = _pickPromptComponents(components);

    final payload = {
      'task':
          'Create exactly only $mealCount Sri Lankan $mealType meal recommendations using only availableComponents.',
      'rules': [
        'Return valid JSON only.',
        'Do not use markdown.',
        'Do not invent foods.',
        'Use only component ids from availableComponents.',
        'Each meal must be practical and culturally suitable in Sri Lanka.',
        'Each meal must include portion sizes.',
        'Consider goal, BMI, allergies, health conditions, and weather.',
      ],
      'userContext': {
        'mealType': mealType,
        'dietaryPreference': dietaryPreference,
        'goal': goal,
        'allergies': allergies,
        'healthConditions': healthConditions,
        'bmi': bmi,
        'bmiCategory': bmiCategory,
        'weatherCondition': weatherCondition,
        'temperatureCelsius': temperatureCelsius,
        'humidity': humidity,
      },
      'requiredJsonOutput': {
        'mealType': mealType,
        'mealCount': mealCount,
        'meals': [
          {
            'title': 'string',
            'description': 'string',
            'tags': ['string'],
            'portionSize': 'string',
            'totalCalories': 0,
            'proteinG': 0,
            'carbsG': 0,
            'fatG': 0,
            'componentIds': ['string'],
            'components': [
              {
                'id': 'string',
                'name': 'string',
                'portion': 'string',
              }
            ],
            'whyRecommended': ['string'],
            'weatherNote': 'string',
            'goalNote': 'string',
            'healthNote': 'string',
          }
        ],
      },
      'availableComponents':
          limitedComponents.map(_componentToPromptJson).toList(),
    };

    return jsonEncode(payload);
  }

  Map<String, dynamic> _componentToPromptJson(FoodComponent component) {
    return {
      'id': component.id,
      'name': component.name,
      'role': component.mealRole,
      'portion': component.servingLabel,
      'cal': component.nutrition.caloriesKcal,
      'protein': component.nutrition.proteinG,
      'carbs': component.nutrition.carbsG,
      'fat': component.nutrition.fatG,
      'flags': component.healthFlags,
      'pairingRoles': component.pairingRoles,
      'bestWith': component.llmHints['bestWith'] ?? [],
      'avoidWith': component.llmHints['avoidWith'] ?? [],
    };
  }



  List<FoodComponent> _pickPromptComponents(List<FoodComponent> components) {
    final bases = components
        .where((item) => item.mealRole.toLowerCase() == 'base')
        .take(6)
        .toList();

    final proteins = components
        .where((item) =>
            item.mealRole.toLowerCase() == 'protein' ||
            item.pairingRoles.contains('Protein') ||
            item.category.toLowerCase().contains('protein'))
        .take(8)
        .toList();

    final vegetables = components
        .where((item) =>
            item.mealRole.toLowerCase() == 'vegetable' ||
            item.pairingRoles.contains('Vegetable') ||
            item.category.toLowerCase().contains('vegetable'))
        .take(8)
        .toList();

    final sides = components
        .where((item) =>
            item.mealRole.toLowerCase() == 'side' ||
            item.pairingRoles.contains('Side') ||
            item.name.toLowerCase().contains('sambal') ||
            item.name.toLowerCase().contains('mallum'))
        .take(6)
        .toList();

    final selected = <String, FoodComponent>{};

    for (final item in [
      ...bases,
      ...proteins,
      ...vegetables,
      ...sides,
      ...components.take(10),
    ]) {
      selected[item.id] = item;
    }

    return selected.values.take(25).toList();
  }
}