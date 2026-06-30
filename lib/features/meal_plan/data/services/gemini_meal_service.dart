import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/ai_meal_recommendation.dart';

class GeminiMealService {
  const GeminiMealService({
    required this.apiKey,
  });

  final String apiKey;

  static const String _liteModel = 'gemini-2.5-flash-lite';
  static const String _fallbackModel = 'gemini-2.5-flash';

  Future<List<AiMealRecommendation>> generateMeals(String prompt) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API key is missing');
    }

    Exception? lastError;

    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        return await _generateWithModel(
          prompt: prompt,
          model: _liteModel,
        );
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());

        if (attempt < 3) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }

    try {
      return await _generateWithModel(
        prompt: prompt,
        model: _fallbackModel,
      );
    } catch (e) {
      throw Exception(
        'Gemini failed after 3 retries with $_liteModel and 1 fallback try with $_fallbackModel. Last error: $e. Previous error: $lastError',
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
              {'text': prompt}
            ],
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'topP': 0.8,
          'maxOutputTokens': 9000,
          'responseMimeType': 'application/json',
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini $model API failed: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    final candidates = body['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini $model returned no candidates');
    }

    final firstCandidate = candidates.first as Map<String, dynamic>;

    final finishReason = firstCandidate['finishReason']?.toString();
    if (finishReason == 'MAX_TOKENS') {
      throw Exception(
        'Gemini $model response was cut. Reduce available components or increase maxOutputTokens.',
      );
    }

    final content = firstCandidate['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('Gemini $model returned empty content');
    }

    final text = parts.first['text']?.toString().trim() ?? '';
    if (text.isEmpty) {
      throw Exception('Gemini $model response text is empty');
    }

    final decoded = jsonDecode(text) as Map<String, dynamic>;
    final mealsJson = decoded['meals'] as List<dynamic>?;

    if (mealsJson == null) {
      throw Exception('Gemini $model JSON does not contain meals');
    }

    return mealsJson
        .take(5)
        .map(
          (item) => AiMealRecommendation.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}