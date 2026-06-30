
import 'dart:convert';
import 'dart:math';
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
    int mealCount = 5,
  }) {
    final limitedComponents = _pickPromptComponents(components);

    final payload = {
      'task':
          'Generate exactly 5 meals, complete Sri Lankan $mealType meal recommendations using only availableComponents.',
      'rules': [
        'Generate exactly 5 meals. Never return more than $mealCount meals.',
        'The meals array length must be exactly $mealCount.',
        'Keep portionSize under 45 characters.',
        'Do not write long combined descriptions in portionSize.',
        'Use short portionSize like "1 plate", "1 bowl", or "Rice 80g + Curry 100g".',
        'Return valid JSON only.',
        'Do not use markdown.',
        'Do not invent foods.',
        'Use only component ids from availableComponents.',
        'Do not recommend a single food item as a meal.',
        'Every meal must be a full meal combination, not just a base food.',
        'Each meal must include portion sizes for every selected component.',
        'Calculate totalCalories, proteinG, carbsG, and fatG by summing the selected components.',
        'Use nutrition values from availableComponents only.',
        'Consider goal, BMI, allergies, health conditions, and weather.',
      ],
      'mealCompositionRules': [
        'For Lunch and Dinner, each meal must include at least 3 components.',
        'For Lunch and Dinner, each meal should normally include: 1 Base + 1 Curry/Protein + 1 Vegetable or Side.',
        'For Breakfast, each meal must include at least 2 components.',
        'For Breakfast, acceptable combinations include kiribath + lunu miris, hoppers + dhal curry, string hoppers + dhal curry, roti + sambol, bread + curry, or similar available combinations.',
        'Never output only rice, bread, roti, hoppers, or string hoppers alone.',
        'Use bestWith relationships when available.',
        'Avoid avoidWith relationships.',
        'If a complete meal cannot be formed, use the closest sensible Sri Lankan combination from availableComponents.',
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
            'portionSize': 'combined portion summary',
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
    final random = Random();

    List<FoodComponent> randomTake(
      Iterable<FoodComponent> items,
      int count,
    ) {
      final list = items.toList()..shuffle(random);
      return list.take(count).toList();
    }

    final bases = components
        .where((item) => item.mealRole.toLowerCase() == 'base')
        .toList();

    final proteins = randomTake(
      components.where((item) =>
          item.mealRole.toLowerCase() == 'protein' ||
          item.pairingRoles.contains('Protein') ||
          item.category.toLowerCase().contains('protein')),
      5,
    );

    final vegetables = randomTake(
      components.where((item) =>
          item.mealRole.toLowerCase() == 'vegetable' ||
          item.pairingRoles.contains('Vegetable') ||
          item.category.toLowerCase().contains('vegetable')),
      5,
    );

    final sides = randomTake(
      components.where((item) =>
          item.mealRole.toLowerCase() == 'side' ||
          item.pairingRoles.contains('Side') ||
          item.name.toLowerCase().contains('sambal') ||
          item.name.toLowerCase().contains('mallum')),
      4,
    );

    final fallback = randomTake(components, 10);

    final selected = <String, FoodComponent>{};

    for (final item in [
      ...bases,
      ...proteins,
      ...vegetables,
      ...sides,
      ...fallback,
    ]) {
      selected[item.id] = item;
    }

    return selected.values.take(25).toList();
  }


 
}