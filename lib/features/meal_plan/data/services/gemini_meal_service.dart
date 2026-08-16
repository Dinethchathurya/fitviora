// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../../domain/entities/ai_meal_recommendation.dart';

// class GeminiMealService {
//   const GeminiMealService({
//     required this.apiKey,
//   });

//   final String apiKey;

// static const String _liteModel = 'gemini-3.1-flash-lite';
// static const String _fallbackModel = 'gemini-3.6-flash';

//   Future<List<AiMealRecommendation>> generateMeals(String prompt) async {
//     if (apiKey.trim().isEmpty) {
//       throw Exception('Gemini API key is missing');
//     }

//     Exception? lastError;

//     for (var attempt = 1; attempt <= 5; attempt++) {
//       try {
//         return await _generateWithModel(
//           prompt: prompt,
//           model: _liteModel,
//         );
//       } catch (e) {
//         lastError = e is Exception ? e : Exception(e.toString());

//         if (attempt < 3) {
//           await Future.delayed(Duration(seconds: attempt * 2));
//         }
//       }
//     }

//     try {
//       return await _generateWithModel(
//         prompt: prompt,
//         model: _fallbackModel,
//       );
//     } catch (e) {
//       throw Exception(
//         'Gemini failed after 3 retries with $_liteModel and 1 fallback try with $_fallbackModel. Last error: $e. Previous error: $lastError',
//       );
//     }
//   }

//   Future<List<AiMealRecommendation>> _generateWithModel({
//     required String prompt,
//     required String model,
//   }) async {
//     final uri = Uri.parse(
//       'https://generativelanguage.googleapis.com/v1beta/models/'
//       '$model:generateContent?key=$apiKey',
//     );

//     final response = await http.post(
//       uri,
//       headers: const {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'contents': [
//           {
//             'parts': [
//               {'text': prompt}
//             ],
//           }
//         ],
//         'generationConfig': {
//           'temperature': 0.3,
//           'topP': 0.8,
//           'maxOutputTokens': 9000,
//           'responseMimeType': 'application/json',
//         },
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Gemini $model API failed: ${response.body}');
//     }

//     final body = jsonDecode(response.body) as Map<String, dynamic>;

//     final candidates = body['candidates'] as List<dynamic>?;
//     if (candidates == null || candidates.isEmpty) {
//       throw Exception('Gemini $model returned no candidates');
//     }

//     final firstCandidate = candidates.first as Map<String, dynamic>;

//     final finishReason = firstCandidate['finishReason']?.toString();
//     if (finishReason == 'MAX_TOKENS') {
//       throw Exception(
//         'Gemini $model response was cut. Reduce available components or increase maxOutputTokens.',
//       );
//     }

//     final content = firstCandidate['content'] as Map<String, dynamic>?;
//     final parts = content?['parts'] as List<dynamic>?;

//     if (parts == null || parts.isEmpty) {
//       throw Exception('Gemini $model returned empty content');
//     }

//     final text = parts.first['text']?.toString().trim() ?? '';
//     if (text.isEmpty) {
//       throw Exception('Gemini $model response text is empty');
//     }

//     final decoded = jsonDecode(text) as Map<String, dynamic>;
//     final mealsJson = decoded['meals'] as List<dynamic>?;

//     if (mealsJson == null) {
//       throw Exception('Gemini $model JSON does not contain meals');
//     }

//     return mealsJson
//         .take(5)
//         .map(
//           (item) => AiMealRecommendation.fromJson(
//             item as Map<String, dynamic>,
//           ),
//         )
//         .toList();
//   }
// }



// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../../domain/entities/ai_meal_recommendation.dart';

// class GeminiMealService {
//   const GeminiMealService({
//     required this.apiKey,
//   });

//   final String apiKey;

//   static const String _liteModel = 'gemini-3.1-flash-lite';
//   static const String _fallbackModel = 'gemini-3.6-flash';

//   Future<List<AiMealRecommendation>> generateMeals(String prompt) async {
//     if (apiKey.trim().isEmpty) {
//       throw Exception('Gemini API key is missing');
//     }

//     /*
//      * The prompt already contains the exact Base food IDs selected before
//      * calling Gemini. We extract and keep them here so Gemini's returned
//      * baseFoodId can be validated and corrected.
//      */
//     final allowedBaseFoodIds = _extractAllowedBaseFoodIds(prompt);

//     if (allowedBaseFoodIds.isEmpty) {
//       throw Exception(
//         'No Base food IDs were found in the Gemini meal prompt.',
//       );
//     }

//     Exception? lastError;

//     for (var attempt = 1; attempt <= 5; attempt++) {
//       try {
//         return await _generateWithModel(
//           prompt: prompt,
//           model: _liteModel,
//           allowedBaseFoodIds: allowedBaseFoodIds,
//         );
//       } catch (error) {
//         lastError = error is Exception
//             ? error
//             : Exception(error.toString());

//         if (attempt < 5) {
//           await Future.delayed(
//             Duration(seconds: attempt * 2),
//           );
//         }
//       }
//     }

//     try {
//       return await _generateWithModel(
//         prompt: prompt,
//         model: _fallbackModel,
//         allowedBaseFoodIds: allowedBaseFoodIds,
//       );
//     } catch (error) {
//       throw Exception(
//         'Gemini failed after 5 retries with $_liteModel and one fallback '
//         'attempt with $_fallbackModel. '
//         'Last error: $error. Previous error: $lastError',
//       );
//     }
//   }

//   Future<List<AiMealRecommendation>> _generateWithModel({
//     required String prompt,
//     required String model,
//     required List<String> allowedBaseFoodIds,
//   }) async {
//     final uri = Uri.parse(
//       'https://generativelanguage.googleapis.com/v1beta/models/'
//       '$model:generateContent?key=$apiKey',
//     );

//     final response = await http.post(
//       uri,
//       headers: const {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'contents': [
//           {
//             'parts': [
//               {
//                 'text': prompt,
//               },
//             ],
//           },
//         ],
//         'generationConfig': {
//           'temperature': 0.3,
//           'topP': 0.8,
//           'maxOutputTokens': 9000,
//           'responseMimeType': 'application/json',
//         },
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(
//         'Gemini $model API failed with status '
//         '${response.statusCode}: ${response.body}',
//       );
//     }

//     final decodedResponse = jsonDecode(response.body);

//     if (decodedResponse is! Map<String, dynamic>) {
//       throw Exception(
//         'Gemini $model returned an invalid response object.',
//       );
//     }

//     final candidates = decodedResponse['candidates'];

//     if (candidates is! List || candidates.isEmpty) {
//       throw Exception(
//         'Gemini $model returned no candidates.',
//       );
//     }

//     final firstCandidate = candidates.first;

//     if (firstCandidate is! Map<String, dynamic>) {
//       throw Exception(
//         'Gemini $model returned an invalid candidate.',
//       );
//     }

//     final finishReason = firstCandidate['finishReason']?.toString();

//     if (finishReason == 'MAX_TOKENS') {
//       throw Exception(
//         'Gemini $model response was cut because the maximum token limit '
//         'was reached.',
//       );
//     }

//     final content = firstCandidate['content'];

//     if (content is! Map<String, dynamic>) {
//       throw Exception(
//         'Gemini $model returned invalid content.',
//       );
//     }

//     final parts = content['parts'];

//     if (parts is! List || parts.isEmpty) {
//       throw Exception(
//         'Gemini $model returned empty content.',
//       );
//     }

//     final firstPart = parts.first;

//     if (firstPart is! Map<String, dynamic>) {
//       throw Exception(
//         'Gemini $model returned an invalid content part.',
//       );
//     }

//     final responseText = firstPart['text']?.toString().trim() ?? '';

//     if (responseText.isEmpty) {
//       throw Exception(
//         'Gemini $model response text is empty.',
//       );
//     }

//     final cleanedText = _removeMarkdownCodeBlock(responseText);
//     final decodedMealsResponse = jsonDecode(cleanedText);

//     if (decodedMealsResponse is! Map<String, dynamic>) {
//       throw Exception(
//         'Gemini $model did not return a valid JSON object.',
//       );
//     }

//     final mealsJson = decodedMealsResponse['meals'];

//     if (mealsJson is! List) {
//       throw Exception(
//         'Gemini $model JSON does not contain a valid meals array.',
//       );
//     }

//     final recommendations = <AiMealRecommendation>[];

//     for (final rawMeal in mealsJson.take(5)) {
//       if (rawMeal is! Map) {
//         continue;
//       }

//       final mealJson = Map<String, dynamic>.from(rawMeal);

//       /*
//        * Correct baseFoodId before passing the JSON to
//        * AiMealRecommendation.fromJson().
//        */
//       final correctedBaseFoodId = _resolveBaseFoodId(
//         returnedBaseFoodId: mealJson['baseFoodId']?.toString() ?? '',
//         componentIds: _stringList(mealJson['componentIds']),
//         allowedBaseFoodIds: allowedBaseFoodIds,
//       );

//       mealJson['baseFoodId'] = correctedBaseFoodId;

//       /*
//        * Make sure the corrected Base ID is also available in componentIds.
//        * Other IDs are retained because the cooking guide needs all meal
//        * components.
//        */
//       final componentIds = _stringList(mealJson['componentIds']);

//       if (!componentIds.contains(correctedBaseFoodId)) {
//         componentIds.insert(0, correctedBaseFoodId);
//       }

//       mealJson['componentIds'] = componentIds;

//       recommendations.add(
//         AiMealRecommendation.fromJson(mealJson),
//       );
//     }

//     if (recommendations.isEmpty) {
//       throw Exception(
//         'Gemini $model returned no valid meal recommendations.',
//       );
//     }

//     return recommendations;
//   }

//   /// Reads allowedBaseFoodIds from the JSON prompt created by
//   /// GeminiMealPromptBuilder.
//   List<String> _extractAllowedBaseFoodIds(String prompt) {
//     try {
//       final decodedPrompt = jsonDecode(prompt);

//       if (decodedPrompt is! Map<String, dynamic>) {
//         return [];
//       }

//       return _stringList(decodedPrompt['allowedBaseFoodIds'])
//           .where((id) => id.trim().isNotEmpty)
//           .toSet()
//           .toList(growable: false);
//     } catch (_) {
//       return [];
//     }
//   }

//   /// Resolves Gemini's returned Base food ID against the exact valid Base IDs
//   /// that were sent in the prompt.
//   String _resolveBaseFoodId({
//     required String returnedBaseFoodId,
//     required List<String> componentIds,
//     required List<String> allowedBaseFoodIds,
//   }) {
//     if (allowedBaseFoodIds.isEmpty) {
//       return returnedBaseFoodId;
//     }

//     final returnedId = returnedBaseFoodId.trim();

//     // 1. Gemini already returned an exact valid Base ID.
//     if (allowedBaseFoodIds.contains(returnedId)) {
//       return returnedId;
//     }

//     // 2. Search componentIds for an exact valid Base ID.
//     for (final componentId in componentIds) {
//       if (allowedBaseFoodIds.contains(componentId)) {
//         return componentId;
//       }
//     }

//     /*
//      * 3. Try matching Gemini's returned baseFoodId and all componentIds
//      * against the valid Base IDs.
//      */
//     final candidates = <String>[
//       returnedId,
//       ...componentIds,
//     ].where((id) => id.trim().isNotEmpty).toList();

//     String? bestMatch;
//     double bestScore = -1;

//     for (final candidate in candidates) {
//       for (final allowedId in allowedBaseFoodIds) {
//         final score = _similarityScore(
//           candidate,
//           allowedId,
//         );

//         if (score > bestScore) {
//           bestScore = score;
//           bestMatch = allowedId;
//         }
//       }
//     }

//     if (bestMatch != null) {
//       return bestMatch;
//     }

//     /*
//      * Final safe fallback. This always produces an existing image ID from the
//      * Base food list instead of allowing an invalid asset path.
//      */
//     return allowedBaseFoodIds.first;
//   }

//   double _similarityScore(
//     String firstId,
//     String secondId,
//   ) {
//     final first = _normalizeFoodId(firstId);
//     final second = _normalizeFoodId(secondId);

//     if (first.isEmpty || second.isEmpty) {
//       return 0;
//     }

//     if (first == second) {
//       return 100;
//     }

//     var score = 0.0;

//     /*
//      * Strong match after removing serving quantities.
//      *
//      * Examples:
//      * hoppers_4pcs -> hoppers_30g
//      * kiribath_250g -> kiribath_100g
//      */
//     final firstWithoutServing = _removeServingInformation(first);
//     final secondWithoutServing = _removeServingInformation(second);

//     if (firstWithoutServing == secondWithoutServing) {
//       score += 80;
//     }

//     if (firstWithoutServing.contains(secondWithoutServing) ||
//         secondWithoutServing.contains(firstWithoutServing)) {
//       score += 45;
//     }

//     final firstTokens = firstWithoutServing
//         .split('_')
//         .where((token) => token.isNotEmpty)
//         .toSet();

//     final secondTokens = secondWithoutServing
//         .split('_')
//         .where((token) => token.isNotEmpty)
//         .toSet();

//     if (firstTokens.isNotEmpty && secondTokens.isNotEmpty) {
//       final commonTokens = firstTokens.intersection(secondTokens).length;
//       final allTokens = firstTokens.union(secondTokens).length;

//       score += (commonTokens / allTokens) * 50;
//     }

//     final distance = _levenshteinDistance(
//       firstWithoutServing,
//       secondWithoutServing,
//     );

//     final longestLength = firstWithoutServing.length >
//             secondWithoutServing.length
//         ? firstWithoutServing.length
//         : secondWithoutServing.length;

//     if (longestLength > 0) {
//       score += (1 - (distance / longestLength)) * 25;
//     }

//     return score;
//   }

//   String _normalizeFoodId(String value) {
//     var normalized = value
//         .trim()
//         .toLowerCase()
//         .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
//         .replaceAll(RegExp(r'_+'), '_')
//         .replaceAll(RegExp(r'^_|_$'), '');

//     /*
//      * Small synonym normalization for common Sri Lankan food identifiers.
//      */
//     normalized = normalized
//         .replaceAll('pol_roti', 'coconut_roti')
//         .replaceAll('polroti', 'coconut_roti')
//         .replaceAll('sambal', 'sambol');

//     return normalized;
//   }

//   String _removeServingInformation(String value) {
//     final tokens = value.split('_');

//     final filteredTokens = tokens.where((token) {
//       return !_isServingToken(token);
//     }).toList();

//     return filteredTokens.join('_');
//   }

//   bool _isServingToken(String token) {
//     final normalized = token.trim().toLowerCase();

//     if (normalized.isEmpty) {
//       return true;
//     }

//     return RegExp(
//       r'^\d+(\.\d+)?(g|kg|mg|ml|l|pc|pcs|piece|pieces|slice|slices|cup|cups)?$',
//     ).hasMatch(normalized);
//   }

//   int _levenshteinDistance(
//     String first,
//     String second,
//   ) {
//     if (first == second) {
//       return 0;
//     }

//     if (first.isEmpty) {
//       return second.length;
//     }

//     if (second.isEmpty) {
//       return first.length;
//     }

//     var previousRow = List<int>.generate(
//       second.length + 1,
//       (index) => index,
//     );

//     for (var firstIndex = 0;
//         firstIndex < first.length;
//         firstIndex++) {
//       final currentRow = <int>[firstIndex + 1];

//       for (var secondIndex = 0;
//           secondIndex < second.length;
//           secondIndex++) {
//         final insertionCost = currentRow[secondIndex] + 1;
//         final deletionCost = previousRow[secondIndex + 1] + 1;

//         final substitutionCost = previousRow[secondIndex] +
//             (first[firstIndex] == second[secondIndex] ? 0 : 1);

//         var minimumCost = insertionCost;

//         if (deletionCost < minimumCost) {
//           minimumCost = deletionCost;
//         }

//         if (substitutionCost < minimumCost) {
//           minimumCost = substitutionCost;
//         }

//         currentRow.add(minimumCost);
//       }

//       previousRow = currentRow;
//     }

//     return previousRow.last;
//   }

//   List<String> _stringList(dynamic value) {
//     if (value is! List) {
//       return [];
//     }

//     return value
//         .map((item) => item.toString().trim())
//         .where((item) => item.isNotEmpty)
//         .toList();
//   }

//   String _removeMarkdownCodeBlock(String value) {
//     var cleaned = value.trim();

//     if (cleaned.startsWith('```')) {
//       cleaned = cleaned.replaceFirst(
//         RegExp(r'^```(?:json)?\s*'),
//         '',
//       );

//       cleaned = cleaned.replaceFirst(
//         RegExp(r'\s*```$'),
//         '',
//       );
//     }

//     return cleaned.trim();
//   }
// }




import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/ai_meal_recommendation.dart';

class GeminiMealService {
  const GeminiMealService({
    required this.apiKey,
  });

  final String apiKey;

  static const String _liteModel = 'gemini-3.1-flash-lite';
  static const String _fallbackModel = 'gemini-3.6-flash';

  Future<List<AiMealRecommendation>> generateMeals(
    String prompt,
  ) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API key is missing');
    }

    Exception? lastError;

    // ------------------------------------------------------------
    // Try main model
    // ------------------------------------------------------------

    for (var attempt = 1; attempt <= 5; attempt++) {
      try {
        return await _generateWithModel(
          prompt: prompt,
          model: _liteModel,
        );
      } catch (error) {
        lastError = error is Exception
            ? error
            : Exception(error.toString());

        if (attempt < 5) {
          await Future.delayed(
            Duration(seconds: attempt * 2),
          );
        }
      }
    }

    // ------------------------------------------------------------
    // Fallback model
    // ------------------------------------------------------------

    try {
      return await _generateWithModel(
        prompt: prompt,
        model: _fallbackModel,
      );
    } catch (error) {
      throw Exception(
        'Gemini failed after 5 retries with $_liteModel '
        'and one fallback attempt with $_fallbackModel. '
        'Last error: $error. '
        'Previous error: $lastError',
      );
    }
  }

  Future<List<AiMealRecommendation>> _generateWithModel({
    required String prompt,
    required String model,
  }) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$model:generateContent?key=$apiKey',
    );

    final response = await http.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              },
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.3,
          'topP': 0.8,
          'maxOutputTokens': 9000,
          'responseMimeType': 'application/json',
        },
      }),
    );

    // ------------------------------------------------------------
    // HTTP error
    // ------------------------------------------------------------

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini $model API failed with status '
        '${response.statusCode}: ${response.body}',
      );
    }

    // ------------------------------------------------------------
    // Parse Gemini API response
    // ------------------------------------------------------------

    final decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map<String, dynamic>) {
      throw Exception(
        'Gemini $model returned an invalid response object.',
      );
    }

    final candidates = decodedResponse['candidates'];

    if (candidates is! List || candidates.isEmpty) {
      throw Exception(
        'Gemini $model returned no candidates.',
      );
    }

    final firstCandidate = candidates.first;

    if (firstCandidate is! Map<String, dynamic>) {
      throw Exception(
        'Gemini $model returned an invalid candidate.',
      );
    }

    final finishReason =
        firstCandidate['finishReason']?.toString();

    if (finishReason == 'MAX_TOKENS') {
      throw Exception(
        'Gemini $model response was cut because '
        'the maximum token limit was reached.',
      );
    }

    // ------------------------------------------------------------
    // Get generated content
    // ------------------------------------------------------------

    final content = firstCandidate['content'];

    if (content is! Map<String, dynamic>) {
      throw Exception(
        'Gemini $model returned invalid content.',
      );
    }

    final parts = content['parts'];

    if (parts is! List || parts.isEmpty) {
      throw Exception(
        'Gemini $model returned empty content.',
      );
    }

    final firstPart = parts.first;

    if (firstPart is! Map<String, dynamic>) {
      throw Exception(
        'Gemini $model returned an invalid content part.',
      );
    }

    final responseText =
        firstPart['text']?.toString().trim() ?? '';

    if (responseText.isEmpty) {
      throw Exception(
        'Gemini $model response text is empty.',
      );
    }

    // ------------------------------------------------------------
    // Gemini should return JSON, but clean markdown just in case
    // ------------------------------------------------------------

    final cleanedText =
        _removeMarkdownCodeBlock(responseText);

    dynamic decodedMealsResponse;

    try {
      decodedMealsResponse =
          jsonDecode(cleanedText);
    } catch (error) {
      throw Exception(
        'Gemini $model returned invalid JSON: $error',
      );
    }

    if (decodedMealsResponse
        is! Map<String, dynamic>) {
      throw Exception(
        'Gemini $model did not return a valid JSON object.',
      );
    }

    final mealsJson =
        decodedMealsResponse['meals'];

    if (mealsJson is! List) {
      throw Exception(
        'Gemini $model JSON does not contain '
        'a valid meals array.',
      );
    }

    // ------------------------------------------------------------
    // Convert Gemini JSON → AiMealRecommendation
    //
    // IMPORTANT:
    // We intentionally DO NOT correct baseFoodId here.
    //
    // MealPlanViewModel owns that responsibility because it has
    // access to the real FoodComponent dataset.
    // ------------------------------------------------------------

    final recommendations =
        <AiMealRecommendation>[];

    for (final rawMeal in mealsJson.take(5)) {
      if (rawMeal is! Map) {
        continue;
      }

      try {
        final mealJson =
            Map<String, dynamic>.from(rawMeal);

        recommendations.add(
          AiMealRecommendation.fromJson(
            mealJson,
          ),
        );
      } catch (error) {
        // Skip only the invalid individual meal.
        continue;
      }
    }

    if (recommendations.isEmpty) {
      throw Exception(
        'Gemini $model returned no valid '
        'meal recommendations.',
      );
    }

    return recommendations;
  }

  // ------------------------------------------------------------
  // Gemini occasionally wraps JSON in ```json ... ```
  // ------------------------------------------------------------

  String _removeMarkdownCodeBlock(
    String value,
  ) {
    var cleaned = value.trim();

    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(
        RegExp(
          r'^```(?:json)?\s*',
          caseSensitive: false,
        ),
        '',
      );

      cleaned = cleaned.replaceFirst(
        RegExp(r'\s*```$'),
        '',
      );
    }

    return cleaned.trim();
  }
}