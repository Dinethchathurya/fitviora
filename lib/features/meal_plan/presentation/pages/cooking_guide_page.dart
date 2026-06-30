import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/services/gemini_cooking_service.dart';
import '../../domain/entities/ai_meal_recommendation.dart';

class CookingGuidePage extends StatefulWidget {
  const CookingGuidePage({
    super.key,
    required this.meal,
    required this.mealType,
  });

  final AiMealRecommendation meal;
  final String mealType;

  @override
  State<CookingGuidePage> createState() => _CookingGuidePageState();
}

class _CookingGuidePageState extends State<CookingGuidePage> {
  late final Future<String> _guideFuture;

  @override
  void initState() {
    super.initState();

    _guideFuture = GeminiCookingService(
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
    ).generateCookingGuide(
      meal: widget.meal,
      mealType: widget.mealType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        title: const Text('How to Cook'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _guideFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }

            final guide = snapshot.data ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.meal.portionSize,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      guide,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}