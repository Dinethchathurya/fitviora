import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/ai_meal_recommendation.dart';

class GeminiCookingService {
  const GeminiCookingService({
    required this.apiKey,
  });

  final String apiKey;

  static const String _flashLiteModel = 'gemini-2.5-flash-lite';
  static const String _flashModel = 'gemini-2.5-flash';

  Future<String> generateCookingGuide({
    required AiMealRecommendation meal,
    required String mealType,
  }) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API key is missing');
    }

    final prompt = _buildPrompt(meal: meal, mealType: mealType);

    Exception? lastError;

    for (int attempt = 1; attempt <= 5; attempt++) {
      try {
        return await _callGemini(
          model: _flashLiteModel,
          prompt: prompt,
        );
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }

    try {
      return await _callGemini(
        model: _flashModel,
        prompt: prompt,
      );
    } catch (e) {
      throw Exception(
        'Gemini cooking guide failed after retries. Last error: ${lastError ?? e}',
      );
    }
  }

  String _buildPrompt({
    required AiMealRecommendation meal,
    required String mealType,
  }) {
    return jsonEncode({
      'task': 'Explain how to cook this Sri Lankan meal.',
      'rules': [
        'Return simple plain text only.',
        'Do not use markdown tables.',
        'Use clear step by step cooking instructions.',
        'Use only the provided meal details.',
        'Include ingredients, preparation steps, cooking steps, and serving advice.',
        'Keep it practical for a home cook in Sri Lanka.',
      ],
      'meal': {
        'mealType': mealType,
        'title': meal.title,
        'description': meal.description,
        'portionSize': meal.portionSize,
        'totalCalories': meal.totalCalories,
        'proteinG': meal.proteinG,
        'carbsG': meal.carbsG,
        'fatG': meal.fatG,
        'tags': meal.tags,
        'componentIds': meal.componentIds,
      },
    });
  }

  Future<String> _callGemini({
    required String model,
    required String prompt,
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
              {'text': prompt}
            ],
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'topP': 0.8,
          'maxOutputTokens': 2000,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('$model failed: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = body['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) {
      throw Exception('$model returned no cooking guide');
    }

    final firstCandidate = candidates.first as Map<String, dynamic>;
    final finishReason = firstCandidate['finishReason']?.toString();

    if (finishReason == 'MAX_TOKENS') {
      throw Exception('$model response was cut');
    }

    final content = firstCandidate['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('$model returned empty cooking guide');
    }

    final text = parts.first['text']?.toString().trim() ?? '';

    if (text.isEmpty) {
      throw Exception('$model cooking guide text is empty');
    }

    return text;
  }
}