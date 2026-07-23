import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_meal_profile.dart';

class UserMealProfileRepository {
  const UserMealProfileRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get firebaseAuth =>
      _firebaseAuth ?? FirebaseAuth.instance;

  FirebaseFirestore get firestore =>
      _firestore ?? FirebaseFirestore.instance;

  Future<UserMealProfile> getCurrentUserMealProfile() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      throw Exception('User profile not found.');
    }

    final dailyCalorieGoal = _intValue(
      data['dailyCalorieGoal'],
      fallback: 2000,
    );

    final breakfastTargetCalories = _intValue(
      data['breakfastTargetCalories'],
      fallback: (dailyCalorieGoal * 0.30).round(),
    );

    final lunchTargetCalories = _intValue(
      data['lunchTargetCalories'],
      fallback: (dailyCalorieGoal * 0.40).round(),
    );

    final calculatedDinnerTarget =
        dailyCalorieGoal -
        breakfastTargetCalories -
        lunchTargetCalories;

    final dinnerTargetCalories = _intValue(
      data['dinnerTargetCalories'],
      fallback: calculatedDinnerTarget,
    );

    return UserMealProfile(
      foodPreference: _stringValue(
        data['foodPreference'],
        fallback: 'Any',
      ),
      healthConditions: _stringList(
        data['healthConditions'],
      ),
      allergies: _allergyList(
        data['allergies'],
      ),
      goal: _normalizeGoal(
        _stringValue(
          data['goal'],
          fallback: 'Maintenance',
        ),
      ),
      heightCm: _doubleValue(
        data['heightCm'],
      ),
      weightKg: _doubleValue(
        data['weightKg'],
      ),
      activityLevel: _stringValue(
        data['activityLevel'],
        fallback: 'Moderate',
      ),
      dailyCalorieGoal: dailyCalorieGoal,
      breakfastTargetCalories: breakfastTargetCalories,
      lunchTargetCalories: lunchTargetCalories,
      dinnerTargetCalories: dinnerTargetCalories,
    );
  }

  static String _stringValue(
    dynamic value, {
    required String fallback,
  }) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static int _intValue(
    dynamic value, {
    required int fallback,
  }) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double _doubleValue(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) {
      return [];
    }

    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return [];
    }

    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<String> _allergyList(dynamic value) {
    return _stringList(value);
  }

  static String _normalizeGoal(String value) {
    final normalized = value.trim().toLowerCase();

    if (normalized == 'weight loss') {
      return 'WeightLoss';
    }

    if (normalized == 'weight gain') {
      return 'WeightGain';
    }

    if (normalized == 'muscle gain') {
      return 'MuscleGain';
    }

    if (normalized == 'maintenance') {
      return 'Maintenance';
    }

    return value.replaceAll(' ', '');
  }
}