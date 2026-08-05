
// import 'dart:convert';
// import 'dart:math';
// import '../../domain/entities/food_component.dart';

// class GeminiMealPromptBuilder {
//   const GeminiMealPromptBuilder();

//   String build({
//     required List<FoodComponent> components,
//     required String mealType,
//     required String dietaryPreference,
//     required String goal,
//     required List<String> allergies,
//     required List<String> healthConditions,
//     required double bmi,
//     required String bmiCategory,
//     required String weatherCondition,
//     required double temperatureCelsius,
//     required int humidity,
//     required int targetCalories,
//     int mealCount = 5,
//   }) {
//     final limitedComponents = _pickPromptComponents(components);

//     final payload = {
//       'task':
//           'Generate exactly 5 meals, complete Sri Lankan $mealType meal recommendations using only availableComponents.',
//       'rules': [
//         'Generate exactly 5 meals. Never return more than $mealCount meals.',
//         'The meals array length must be exactly $mealCount.',
//           'Each meal should be as close as possible to $targetCalories kcal.',
//           'Keep each meal within approximately 10% of $targetCalories kcal.',
//         'Keep portionSize under 45 characters.',
//         'Do not write long combined descriptions in portionSize.',
//         'Use short portionSize like "1 plate", "1 bowl", or "Rice 80g + Curry 100g".',
//         'Return valid JSON only.',
//         'Do not use markdown.',
//         'Do not invent foods.',
//         'Use only component ids from availableComponents.',
//         'Do not recommend a single food item as a meal.',
//         'Every meal must be a full meal combination, not just a base food.',
//         'Each meal must include portion sizes for every selected component.',
//         'Calculate totalCalories, proteinG, carbsG, and fatG by summing the selected components.',
//         'Use nutrition values from availableComponents only.',
//         'Consider goal, BMI, allergies, health conditions, and weather.',
//       ],
//       'mealCompositionRules': [
//         'For Lunch and Dinner, each meal must include at least 3 components.',
//         'For Lunch and Dinner, each meal should normally include: 1 Base + 1 Curry/Protein + 1 Vegetable or Side.',
//         'For Breakfast, each meal must include at least 2 components.',
//         'For Breakfast, acceptable combinations include kiribath + lunu miris, hoppers + dhal curry, string hoppers + dhal curry, roti + sambol, bread + curry, or similar available combinations.',
//         'Never output only rice, bread, roti, hoppers, or string hoppers alone.',
//         'Use bestWith relationships when available.',
//         'Avoid avoidWith relationships.',
//         'If a complete meal cannot be formed, use the closest sensible Sri Lankan combination from availableComponents.',
//       ],
//       'userContext': {
//         'mealType': mealType,
//         'targetCalories': targetCalories,
//         'dietaryPreference': dietaryPreference,
//         'goal': goal,
//         'allergies': allergies,
//         'healthConditions': healthConditions,
//         'bmi': bmi,
//         'bmiCategory': bmiCategory,
//         'weatherCondition': weatherCondition,
//         'temperatureCelsius': temperatureCelsius,
//         'humidity': humidity,
//       },
//       'requiredJsonOutput': {
//         'mealType': mealType,
//         'targetCalories': targetCalories,
//         'mealCount': mealCount,
//         'meals': [
//           {
//             'title': 'string',
//             'description': 'string',
//             'tags': ['string'],
//             'portionSize': 'combined portion summary',
//             'totalCalories': 0,
//             'proteinG': 0,
//             'carbsG': 0,
//             'fatG': 0,
//             'componentIds': ['string'],
//             'components': [
//               {
//                 'id': 'string',
//                 'name': 'string',
//                 'portion': 'string',
//               }
//             ],
//             'whyRecommended': ['string'],
//             'weatherNote': 'string',
//             'goalNote': 'string',
//             'healthNote': 'string',
//           }
//         ],
//       },
//       'availableComponents':
//           limitedComponents.map(_componentToPromptJson).toList(),
//     };

//     return jsonEncode(payload);
//   }

//   Map<String, dynamic> _componentToPromptJson(FoodComponent component) {
//     return {
//       'id': component.id,
//       'name': component.name,
//       'role': component.mealRole,
//       'portion': component.servingLabel,
//       'cal': component.nutrition.caloriesKcal,
//       'protein': component.nutrition.proteinG,
//       'carbs': component.nutrition.carbsG,
//       'fat': component.nutrition.fatG,
//       'flags': component.healthFlags,
//       'pairingRoles': component.pairingRoles,
//       'bestWith': component.llmHints['bestWith'] ?? [],
//       'avoidWith': component.llmHints['avoidWith'] ?? [],
//     };
//   }

    
//   List<FoodComponent> _pickPromptComponents(List<FoodComponent> components) {
//     final random = Random();

//     List<FoodComponent> randomTake(
//       Iterable<FoodComponent> items,
//       int count,
//     ) {
//       final list = items.toList()..shuffle(random);
//       return list.take(count).toList();
//     }

//     final bases = components
//         .where((item) => item.mealRole.toLowerCase() == 'base')
//         .toList();

//     final proteins = randomTake(
//       components.where((item) =>
//           item.mealRole.toLowerCase() == 'protein' ||
//           item.pairingRoles.contains('Protein') ||
//           item.category.toLowerCase().contains('protein')),
//       5,
//     );

//     final vegetables = randomTake(
//       components.where((item) =>
//           item.mealRole.toLowerCase() == 'vegetable' ||
//           item.pairingRoles.contains('Vegetable') ||
//           item.category.toLowerCase().contains('vegetable')),
//       5,
//     );

//     final sides = randomTake(
//       components.where((item) =>
//           item.mealRole.toLowerCase() == 'side' ||
//           item.pairingRoles.contains('Side') ||
//           item.name.toLowerCase().contains('sambal') ||
//           item.name.toLowerCase().contains('mallum')),
//       4,
//     );

//     final fallback = randomTake(components, 10);

//     final selected = <String, FoodComponent>{};

//     for (final item in [
//       ...bases,
//       ...proteins,
//       ...vegetables,
//       ...sides,
//       ...fallback,
//     ]) {
//       selected[item.id] = item;
//     }

//     return selected.values.take(25).toList();
//   }


 
// }


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
    required int targetCalories,
    int mealCount = 5,
  }) {
    final limitedComponents = _pickPromptComponents(components);

    final minimumCalories = (targetCalories * 0.95).round();
    final maximumCalories = (targetCalories * 1.05).round();

    final payload = {
      'task':
          'Generate exactly $mealCount complete Sri Lankan $mealType meals '
          'using only availableComponents. Adjust serving quantities so every '
          'meal reaches the specified calorie target.',

      'calorieTarget': {
        'targetCalories': targetCalories,
        'minimumAllowedCalories': minimumCalories,
        'maximumAllowedCalories': maximumCalories,
      },

      'criticalCalorieRules': [
        'Every meal MUST contain between $minimumCalories and '
            '$maximumCalories kcal.',
        'A meal below $minimumCalories kcal is invalid.',
        'A meal above $maximumCalories kcal is invalid.',
        'Increase or decrease servingMultiplier values until the meal falls '
            'inside the allowed calorie range.',
        'Do not simply use one default serving of every component.',
        'Use multiple servings or fractional servings when required.',
        'Calculate each component calories as '
            'baseCalories * servingMultiplier.',
        'Calculate totalCalories as the sum of all scaled component calories.',
        'Before returning JSON, verify that every meal is inside the required '
            'calorie range.',
        'Do not return a meal until its calculated calorie total satisfies '
            'the target range.',
      ],

      'rules': [
        'Generate exactly $mealCount meals.',
        'The meals array length must be exactly $mealCount.',
        'Keep portionSize concise and under 70 characters.',
        'Return valid JSON only.',
        'Do not use markdown.',
        'Do not invent foods.',
        'Use only component ids from availableComponents.',
        'Do not recommend a single food item as a complete meal.',
        'Each meal must include portion sizes for every component.',
        'Use the nutrition values supplied in availableComponents.',
        'Consider goal, BMI, allergies, health conditions, and weather.',
        'Every meal must return exactly one baseFoodId.',
        'baseFoodId must be the exact id of the selected component whose role is Base.',
        'Do not return Protein, Vegetable, Curry, or Side ids inside baseFoodId.',
        'Do not modify, translate, shorten, or invent the base component id.',
        'baseFoodId must exactly match an id from availableComponents.',
        'The baseFoodId is used as a Flutter image filename.',
      ],

      'servingRules': [
        'servingMultiplier represents how many base servings are used.',
        'servingMultiplier may range from 0.25 to 6.0.',
        'Examples: 0.5 means half a base serving, 2 means two base servings.',
        'The displayed portion must agree with servingMultiplier.',
        'Scale calories, protein, carbohydrates, and fat using the same '
            'servingMultiplier.',
        'Use realistic Sri Lankan meal portions.',
        'When additional calories are needed, preferably increase the Base '
            'and Protein portions rather than adding excessive sambol or '
            'high-sodium sides.',
      ],

      'mealCompositionRules': [
        'Lunch and Dinner must include at least 3 components.',
        'Lunch and Dinner should normally include 1 Base, 1 Protein or Curry, '
            'and 1 Vegetable or Side.',
        'Breakfast must include at least 2 components.',
        'Breakfast combinations may include kiribath with lunu miris, '
            'hoppers with dhal curry, string hoppers with dhal curry, '
            'roti with sambol, or similar available combinations.',
        'Never output only rice, bread, roti, hoppers, or string hoppers.',
        'Use bestWith relationships where available.',
        'Avoid avoidWith relationships.',
      ],

      'userContext': {
        'mealType': mealType,
        'targetCalories': targetCalories,
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
        'targetCalories': targetCalories,
        'mealCount': mealCount,
        'meals': [
          {
            'title': 'string',
            'description': 'string',
            'tags': ['string'],
            'portionSize': 'short combined portion summary',
            'totalCalories': targetCalories,
            'proteinG': 0,
            'carbsG': 0,
            'fatG': 0,
            'baseFoodId': 'exact id of the selected Base component',
            'componentIds': ['string'],
            'components': [
              {
                'id': 'string',
                'name': 'string',
                'baseServing': 'string',
                'servingMultiplier': 1.0,
                'portion': 'actual scaled portion',
                'calories': 0,
                'proteinG': 0,
                'carbsG': 0,
                'fatG': 0,
              }
            ],
            'calorieVerification': {
              'targetCalories': targetCalories,
              'calculatedCalories': targetCalories,
              'differenceFromTarget': 0,
              'withinAllowedRange': true,
            },
            'whyRecommended': ['string'],
            'weatherNote': 'string',
            'goalNote': 'string',
            'healthNote': 'string',
          }
        ],
      },

      'availableComponents': limitedComponents
          .map(_componentToPromptJson)
          .toList(growable: false),
    };

    return jsonEncode(payload);
  }

  Map<String, dynamic> _componentToPromptJson(
    FoodComponent component,
  ) {
    return {
      'id': component.id,
      'name': component.name,
      'mealRole': component.mealRole,
      'baseServing': component.servingLabel,
      'baseCalories': component.nutrition.caloriesKcal,
      'baseProteinG': component.nutrition.proteinG,
      'baseCarbsG': component.nutrition.carbsG,
      'baseFatG': component.nutrition.fatG,
      'flags': component.healthFlags,
      'pairingRoles': component.pairingRoles,
      'bestWith': component.llmHints['bestWith'] ?? [],
      'avoidWith': component.llmHints['avoidWith'] ?? [],
    };
  }

  List<FoodComponent> _pickPromptComponents(
    List<FoodComponent> components,
  ) {
    final random = Random();

    List<FoodComponent> randomTake(
      Iterable<FoodComponent> items,
      int count,
    ) {
      final list = items.toList()..shuffle(random);
      return list.take(count).toList();
    }

    final bases = components
        .where(
          (item) => item.mealRole.trim().toLowerCase() == 'base',
        )
        .toList();

    final proteins = randomTake(
      components.where(
        (item) =>
            item.mealRole.trim().toLowerCase() == 'protein' ||
            item.pairingRoles.any(
              (role) => role.trim().toLowerCase() == 'protein',
            ) ||
            item.category.toLowerCase().contains('protein'),
      ),
      6,
    );

    final vegetables = randomTake(
      components.where(
        (item) =>
            item.mealRole.trim().toLowerCase() == 'vegetable' ||
            item.pairingRoles.any(
              (role) => role.trim().toLowerCase() == 'vegetable',
            ) ||
            item.category.toLowerCase().contains('vegetable'),
      ),
      6,
    );

    final sides = randomTake(
      components.where(
        (item) =>
            item.mealRole.trim().toLowerCase() == 'side' ||
            item.pairingRoles.any(
              (role) => role.trim().toLowerCase() == 'side',
            ) ||
            item.name.toLowerCase().contains('sambol') ||
            item.name.toLowerCase().contains('mallum'),
      ),
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

    return selected.values.take(25).toList(growable: false);
  }
}