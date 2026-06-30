import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/ai_meal_recommendation.dart';

class SelectedMealRepository {
  const SelectedMealRepository();

  Future<void> saveSelectedMeal({
    required AiMealRecommendation meal,
    required String mealType,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final now = DateTime.now();

    await FirebaseFirestore.instance.collection('selected_meals').add({
      'userId': user.uid,
      'mealType': mealType,
      'title': meal.title,
      'tags': meal.tags,
      'portionSize': meal.portionSize,
      'totalCalories': meal.totalCalories,
      'proteinG': meal.proteinG,
      'carbsG': meal.carbsG,
      'fatG': meal.fatG,
      'selectedDate': DateTime(now.year, now.month, now.day).toIso8601String(),
      'selectedAt': now.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}