

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/ai_meal_recommendation.dart';

class GeminiMealService {
  const GeminiMealService({
    required this.apiKey,
  });

  final String apiKey;

  Future<List<AiMealRecommendation>> generateMeals(String prompt) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('Gemini API key is missing');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'gemini-2.5-flash:generateContent?key=$apiKey',
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
      throw Exception('Gemini API failed: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    final candidates = body['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini returned no candidates');
    }

    final firstCandidate = candidates.first as Map<String, dynamic>;

    final finishReason = firstCandidate['finishReason']?.toString();
    if (finishReason == 'MAX_TOKENS') {
      throw Exception(
        'Gemini response was cut. Reduce available components or increase maxOutputTokens.',
      );
    }

    final content = firstCandidate['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('Gemini returned empty content');
    }

    final text = parts.first['text']?.toString().trim() ?? '';
    if (text.isEmpty) {
      throw Exception('Gemini response text is empty');
    }

    final decoded = jsonDecode(text) as Map<String, dynamic>;
    final mealsJson = decoded['meals'] as List<dynamic>?;

    if (mealsJson == null) {
      throw Exception('Gemini JSON does not contain meals');
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