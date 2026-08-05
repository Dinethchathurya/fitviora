
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







// ====================





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

//     final minimumCalories = (targetCalories * 0.95).round();
//     final maximumCalories = (targetCalories * 1.05).round();

//     final payload = {
//       'task':
//           'Generate exactly $mealCount complete Sri Lankan $mealType meals '
//           'using only availableComponents. Adjust serving quantities so every '
//           'meal reaches the specified calorie target.',

//       'calorieTarget': {
//         'targetCalories': targetCalories,
//         'minimumAllowedCalories': minimumCalories,
//         'maximumAllowedCalories': maximumCalories,
//       },

//       'criticalCalorieRules': [
//         'Every meal MUST contain between $minimumCalories and '
//             '$maximumCalories kcal.',
//         'A meal below $minimumCalories kcal is invalid.',
//         'A meal above $maximumCalories kcal is invalid.',
//         'Increase or decrease servingMultiplier values until the meal falls '
//             'inside the allowed calorie range.',
//         'Do not simply use one default serving of every component.',
//         'Use multiple servings or fractional servings when required.',
//         'Calculate each component calories as '
//             'baseCalories * servingMultiplier.',
//         'Calculate totalCalories as the sum of all scaled component calories.',
//         'Before returning JSON, verify that every meal is inside the required '
//             'calorie range.',
//         'Do not return a meal until its calculated calorie total satisfies '
//             'the target range.',
//       ],

//       'rules': [
//         'Generate exactly $mealCount meals.',
//         'The meals array length must be exactly $mealCount.',
//         'Keep portionSize concise and under 70 characters.',
//         'Return valid JSON only.',
//         'Do not use markdown.',
//         'Do not invent foods.',
//         'Use only component ids from availableComponents.',
//         'Do not recommend a single food item as a complete meal.',
//         'Each meal must include portion sizes for every component.',
//         'Use the nutrition values supplied in availableComponents.',
//         'Consider goal, BMI, allergies, health conditions, and weather.',
//         'Every meal must return exactly one baseFoodId.',
//         'baseFoodId must be the exact id of the selected component whose role is Base.',
//         'Do not return Protein, Vegetable, Curry, or Side ids inside baseFoodId.',
//         'Do not modify, translate, shorten, or invent the base component id.',
//         'baseFoodId must exactly match an id from availableComponents.',
//         'The baseFoodId is used as a Flutter image filename.',
//       ],

//       'servingRules': [
//         'servingMultiplier represents how many base servings are used.',
//         'servingMultiplier may range from 0.25 to 6.0.',
//         'Examples: 0.5 means half a base serving, 2 means two base servings.',
//         'The displayed portion must agree with servingMultiplier.',
//         'Scale calories, protein, carbohydrates, and fat using the same '
//             'servingMultiplier.',
//         'Use realistic Sri Lankan meal portions.',
//         'When additional calories are needed, preferably increase the Base '
//             'and Protein portions rather than adding excessive sambol or '
//             'high-sodium sides.',
//       ],

//       'mealCompositionRules': [
//         'Lunch and Dinner must include at least 3 components.',
//         'Lunch and Dinner should normally include 1 Base, 1 Protein or Curry, '
//             'and 1 Vegetable or Side.',
//         'Breakfast must include at least 2 components.',
//         'Breakfast combinations may include kiribath with lunu miris, '
//             'hoppers with dhal curry, string hoppers with dhal curry, '
//             'roti with sambol, or similar available combinations.',
//         'Never output only rice, bread, roti, hoppers, or string hoppers.',
//         'Use bestWith relationships where available.',
//         'Avoid avoidWith relationships.',
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
//             'portionSize': 'short combined portion summary',
//             'totalCalories': targetCalories,
//             'proteinG': 0,
//             'carbsG': 0,
//             'fatG': 0,
//             'baseFoodId': 'exact id of the selected Base component',
//             'componentIds': ['string'],
//             'components': [
//               {
//                 'id': 'string',
//                 'name': 'string',
//                 'baseServing': 'string',
//                 'servingMultiplier': 1.0,
//                 'portion': 'actual scaled portion',
//                 'calories': 0,
//                 'proteinG': 0,
//                 'carbsG': 0,
//                 'fatG': 0,
//               }
//             ],
//             'calorieVerification': {
//               'targetCalories': targetCalories,
//               'calculatedCalories': targetCalories,
//               'differenceFromTarget': 0,
//               'withinAllowedRange': true,
//             },
//             'whyRecommended': ['string'],
//             'weatherNote': 'string',
//             'goalNote': 'string',
//             'healthNote': 'string',
//           }
//         ],
//       },

//       'availableComponents': limitedComponents
//           .map(_componentToPromptJson)
//           .toList(growable: false),
//     };

//     return jsonEncode(payload);
//   }

//   Map<String, dynamic> _componentToPromptJson(
//     FoodComponent component,
//   ) {
//     return {
//       'id': component.id,
//       'name': component.name,
//       'mealRole': component.mealRole,
//       'baseServing': component.servingLabel,
//       'baseCalories': component.nutrition.caloriesKcal,
//       'baseProteinG': component.nutrition.proteinG,
//       'baseCarbsG': component.nutrition.carbsG,
//       'baseFatG': component.nutrition.fatG,
//       'flags': component.healthFlags,
//       'pairingRoles': component.pairingRoles,
//       'bestWith': component.llmHints['bestWith'] ?? [],
//       'avoidWith': component.llmHints['avoidWith'] ?? [],
//     };
//   }

//   List<FoodComponent> _pickPromptComponents(
//     List<FoodComponent> components,
//   ) {
//     final random = Random();

//     List<FoodComponent> randomTake(
//       Iterable<FoodComponent> items,
//       int count,
//     ) {
//       final list = items.toList()..shuffle(random);
//       return list.take(count).toList();
//     }

//     final bases = components
//         .where(
//           (item) => item.mealRole.trim().toLowerCase() == 'base',
//         )
//         .toList();

//     final proteins = randomTake(
//       components.where(
//         (item) =>
//             item.mealRole.trim().toLowerCase() == 'protein' ||
//             item.pairingRoles.any(
//               (role) => role.trim().toLowerCase() == 'protein',
//             ) ||
//             item.category.toLowerCase().contains('protein'),
//       ),
//       6,
//     );

//     final vegetables = randomTake(
//       components.where(
//         (item) =>
//             item.mealRole.trim().toLowerCase() == 'vegetable' ||
//             item.pairingRoles.any(
//               (role) => role.trim().toLowerCase() == 'vegetable',
//             ) ||
//             item.category.toLowerCase().contains('vegetable'),
//       ),
//       6,
//     );

//     final sides = randomTake(
//       components.where(
//         (item) =>
//             item.mealRole.trim().toLowerCase() == 'side' ||
//             item.pairingRoles.any(
//               (role) => role.trim().toLowerCase() == 'side',
//             ) ||
//             item.name.toLowerCase().contains('sambol') ||
//             item.name.toLowerCase().contains('mallum'),
//       ),
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

//     return selected.values.take(25).toList(growable: false);
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

    final allowedComponentIds = limitedComponents
        .map((component) => component.id)
        .toList(growable: false);

    final allowedBaseFoodIds = limitedComponents
        .where(_isBaseComponent)
        .map((component) => component.id)
        .toList(growable: false);

    final baseComponents = limitedComponents
        .where(_isBaseComponent)
        .map(
          (component) => {
            'id': component.id,
            'name': component.name,
            'mealRole': component.mealRole,
            'imageFileName': '${component.id}.png',
          },
        )
        .toList(growable: false);

    final minimumCalories = (targetCalories * 0.95).round();
    final maximumCalories = (targetCalories * 1.05).round();

    final payload = {
      'task':
          'Generate exactly $mealCount complete Sri Lankan $mealType meals '
          'using only availableComponents. Adjust serving quantities so every '
          'meal reaches the required calorie target. For every generated meal, '
          'select exactly one Base component and copy its id exactly into '
          'baseFoodId.',

      'calorieTarget': {
        'targetCalories': targetCalories,
        'minimumAllowedCalories': minimumCalories,
        'maximumAllowedCalories': maximumCalories,
      },

      /*
       * Gemini must select baseFoodId only from this explicit whitelist.
       * These values also match image filenames inside:
       *
       * assets/images/Foods/{baseFoodId}.png
       */
      'allowedBaseFoodIds': allowedBaseFoodIds,

      /*
       * This gives Gemini both the exact identifier and readable food name.
       * It must copy the id without modifying it.
       */
      'baseComponents': baseComponents,

      /*
       * All component IDs that Gemini may use in componentIds.
       */
      'allowedComponentIds': allowedComponentIds,

      'criticalBaseFoodIdRules': [
        'Every meal MUST return exactly one baseFoodId.',
        'baseFoodId is an enum value, not free text.',
        'baseFoodId MUST be selected only from allowedBaseFoodIds.',
        'Copy baseFoodId character-for-character from allowedBaseFoodIds.',
        'Do not create a new baseFoodId.',
        'Do not infer a baseFoodId from the food name.',
        'Do not remove serving quantities such as 80g, 100g, 150g, 1pc, 5pcs, or 250g.',
        'Do not shorten the identifier.',
        'Do not translate the identifier.',
        'Do not convert the identifier into a display name.',
        'Do not remove underscores.',
        'Do not add spaces.',
        'Do not change singular or plural words.',
        'Do not modify spelling.',
        'The selected baseFoodId must identify a component whose mealRole is Base.',
        'The selected baseFoodId must also appear inside componentIds.',
        'The selected Base component must also appear inside the components array.',
        'Before returning JSON, verify baseFoodId exactly equals one value from allowedBaseFoodIds.',
        'A baseFoodId that is not present in allowedBaseFoodIds makes the entire meal invalid.',
        'The Flutter application uses baseFoodId as an image filename.',
        'The image path will be assets/images/Foods/{baseFoodId}.png.',
      ],

      'invalidBaseFoodIdExamples': [
        {
          'invalid': 'string_hoppers',
          'reason':
              'The quantity suffix was removed. Use the exact allowed id such as string_hoppers_5pcs.',
        },
        {
          'invalid': 'hoppers',
          'reason':
              'The serving suffix was removed. Use the exact allowed id such as hoppers_1pc.',
        },
        {
          'invalid': 'kiribath',
          'reason':
              'The serving suffix was removed. Use the exact allowed id such as kiribath_100g.',
        },
        {
          'invalid': 'white rice',
          'reason':
              'Display names and spaces are not valid IDs. Copy the exact underscore-separated id.',
        },
      ],

      'baseFoodIdSelectionProcedure': [
        'Step 1: Select one object from baseComponents.',
        'Step 2: Read its id field.',
        'Step 3: Copy that id without any modification.',
        'Step 4: Use the copied value as baseFoodId.',
        'Step 5: Add the same exact id to componentIds.',
        'Step 6: Add the same component to the components array.',
        'Step 7: Verify that baseFoodId exists in allowedBaseFoodIds.',
      ],

      'criticalCalorieRules': [
        'Every meal MUST contain between $minimumCalories and $maximumCalories kcal.',
        'A meal below $minimumCalories kcal is invalid.',
        'A meal above $maximumCalories kcal is invalid.',
        'Increase or decrease servingMultiplier values until the meal falls inside the allowed calorie range.',
        'Do not simply use one default serving of every component.',
        'Use multiple servings or fractional servings when required.',
        'Calculate each component calories as baseCalories multiplied by servingMultiplier.',
        'Calculate totalCalories as the sum of all scaled component calories.',
        'Calculate proteinG, carbsG, and fatG using the same serving multipliers.',
        'Before returning JSON, verify every meal is inside the required calorie range.',
        'Do not return a meal until its calculated calorie total satisfies the target range.',
      ],

      'rules': [
        'Generate exactly $mealCount meals.',
        'The meals array length must be exactly $mealCount.',
        'Keep portionSize concise and under 70 characters.',
        'Return valid JSON only.',
        'Do not use markdown.',
        'Do not include explanations outside the JSON object.',
        'Do not invent foods.',
        'Use only IDs from allowedComponentIds.',
        'Every value inside componentIds must exactly match one value from allowedComponentIds.',
        'Do not recommend a single food item as a complete meal.',
        'Each meal must include portion sizes for every selected component.',
        'Use the nutrition values supplied in availableComponents.',
        'Consider goal, BMI, allergies, health conditions, and weather.',
      ],

      'servingRules': [
        'servingMultiplier represents how many base servings are used.',
        'servingMultiplier may range from 0.25 to 6.0.',
        '0.5 means half a base serving.',
        '1.0 means one base serving.',
        '2.0 means two base servings.',
        'The displayed portion must agree with servingMultiplier.',
        'Scale calories, protein, carbohydrates, and fat using the same servingMultiplier.',
        'Use realistic Sri Lankan meal portions.',
        'When additional calories are needed, preferably increase the Base and Protein portions rather than adding excessive sambol or high-sodium sides.',
      ],

      'mealCompositionRules': [
        'Lunch and Dinner must include at least 3 components.',
        'Lunch and Dinner should normally include 1 Base, 1 Protein or Curry, and 1 Vegetable or Side.',
        'Breakfast must include at least 2 components.',
        'Every meal must contain exactly one component whose mealRole is Base.',
        'The Base component must be selected from baseComponents.',
        'Breakfast combinations may include kiribath with lunu miris, hoppers with dhal curry, string hoppers with dhal curry, roti with sambol, bread with curry, or similar available combinations.',
        'Never output only rice, bread, roti, hoppers, string hoppers, pasta, noodles, or another Base component by itself.',
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

            /*
             * Gemini must replace this placeholder with one exact value
             * copied from allowedBaseFoodIds.
             */
            'baseFoodId': 'COPY_EXACT_VALUE_FROM_allowedBaseFoodIds',

            /*
             * Keep all meal component IDs here because the cooking guide
             * requires every component.
             */
            'componentIds': [
              'exact component id copied from allowedComponentIds',
            ],

            'components': [
              {
                'id': 'exact component id copied from allowedComponentIds',
                'name': 'string',
                'mealRole': 'Base, Protein, Curry, Vegetable, or Side',
                'baseServing': 'string',
                'servingMultiplier': 1.0,
                'portion': 'actual scaled portion',
                'calories': 0,
                'proteinG': 0,
                'carbsG': 0,
                'fatG': 0,
              },
            ],

            'baseFoodVerification': {
              'baseFoodIdCopiedExactly': true,
              'baseFoodIdExistsInAllowedBaseFoodIds': true,
              'baseFoodIdExistsInComponentIds': true,
              'selectedComponentMealRole': 'Base',
            },

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
          },
        ],
      },

      'finalValidationChecklist': [
        'The meals array contains exactly $mealCount meals.',
        'Every meal has exactly one baseFoodId.',
        'Every baseFoodId exactly matches one allowedBaseFoodIds value.',
        'No baseFoodId has been shortened or renamed.',
        'Every baseFoodId belongs to a Base component.',
        'Every baseFoodId also exists in that meal componentIds.',
        'Every componentIds value exists in allowedComponentIds.',
        'Every meal calorie total is between $minimumCalories and $maximumCalories.',
        'The response contains JSON only.',
      ],

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
      'category': component.category,
      'baseServing': component.servingLabel,
      'baseCalories': component.nutrition.caloriesKcal,
      'baseProteinG': component.nutrition.proteinG,
      'baseCarbsG': component.nutrition.carbsG,
      'baseFatG': component.nutrition.fatG,
      'flags': component.healthFlags,
      'pairingRoles': component.pairingRoles,
      'bestWith': component.llmHints['bestWith'] ?? [],
      'avoidWith': component.llmHints['avoidWith'] ?? [],

      /*
       * This is informational for Gemini.
       * It shows exactly how the component id maps to the image file.
       */
      'imageFileName': _isBaseComponent(component)
          ? '${component.id}.png'
          : null,
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
      return list.take(count).toList(growable: false);
    }

    /*
     * Include every available Base component.
     * This ensures Gemini receives every valid base image ID.
     */
    final bases = components.where(_isBaseComponent).toList(growable: false);

    final proteins = randomTake(
      components.where(
        (item) =>
            item.mealRole.trim().toLowerCase() == 'protein' ||
            item.mealRole.trim().toLowerCase() == 'curry' ||
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
            item.name.toLowerCase().contains('sambal') ||
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

    /*
     * Do not use take(25) directly because that could remove some Base
     * components when the dataset contains many Base items.
     *
     * All Base components are kept first. Remaining slots are filled with
     * proteins, vegetables, sides, and fallback items.
     */
    const maximumPromptComponents = 30;

    if (selected.length <= maximumPromptComponents) {
      return selected.values.toList(growable: false);
    }

    final result = <FoodComponent>[];
    final addedIds = <String>{};

    for (final base in bases) {
      if (addedIds.add(base.id)) {
        result.add(base);
      }
    }

    for (final component in selected.values) {
      if (result.length >= maximumPromptComponents) {
        break;
      }

      if (addedIds.add(component.id)) {
        result.add(component);
      }
    }

    return result;
  }

  bool _isBaseComponent(FoodComponent component) {
    return component.mealRole.trim().toLowerCase() == 'base';
  }
}