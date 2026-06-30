// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../../domain/entities/ai_meal_recommendation.dart';

// class SelectedMealRepository {
//   const SelectedMealRepository();

//   Future<void> saveSelectedMeal({
//     required AiMealRecommendation meal,
//     required String mealType,
//   }) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       throw Exception('User is not logged in');
//     }

//     final now = DateTime.now();

//     await FirebaseFirestore.instance.collection('selected_meals').add({
//       'userId': user.uid,
//       'mealType': mealType,
//       'title': meal.title,
//       'tags': meal.tags,
//       'portionSize': meal.portionSize,
//       'totalCalories': meal.totalCalories,
//       'proteinG': meal.proteinG,
//       'carbsG': meal.carbsG,
//       'fatG': meal.fatG,
//       'selectedDate': DateTime(now.year, now.month, now.day).toIso8601String(),
//       'selectedAt': now.toIso8601String(),
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }
// }


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
    final selectedDate = DateTime(now.year, now.month, now.day).toIso8601String();
    await FirebaseFirestore.instance.collection('selected_meals').add({
      'userId': user.uid,
      'mealType': mealType,

      'title': meal.title,
      'description': meal.description,
      'tags': meal.tags,
      'portionSize': meal.portionSize,

      'totalCalories': meal.totalCalories,
      'proteinG': meal.proteinG,
      'carbsG': meal.carbsG,
      'fatG': meal.fatG,

      'componentIds': meal.componentIds,

      'selectedDate':
          selectedDate,
      'selectedAt': now.toIso8601String(),

      'createdAt': FieldValue.serverTimestamp(),
    });

  
  }


  Future<AiMealRecommendation?> getTodaySelectedMeal({
    required String mealType,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final now = DateTime.now();
    final selectedDate =
        DateTime(now.year, now.month, now.day).toIso8601String();

    final snapshot = await FirebaseFirestore.instance
      .collection('selected_meals')
      .where('userId', isEqualTo: user.uid)
      .where('mealType', isEqualTo: mealType)
      .where('selectedDate', isEqualTo: selectedDate)
      .limit(1)
      .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final data = snapshot.docs.first.data();

    return AiMealRecommendation(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      portionSize: data['portionSize'] ?? '',
      totalCalories: _toInt(data['totalCalories']),
      proteinG: _toDouble(data['proteinG']),
      carbsG: _toDouble(data['carbsG']),
      fatG: _toDouble(data['fatG']),
      componentIds: List<String>.from(data['componentIds'] ?? []),
    );
  }




  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}