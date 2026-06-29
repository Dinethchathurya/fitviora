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

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  Future<UserMealProfile> getCurrentUserMealProfile() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final snapshot = await firestore.collection('users').doc(user.uid).get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('User profile not found.');
    }

    final data = snapshot.data()!;

    return UserMealProfile(
      foodPreference: _stringValue(data['foodPreference'], fallback: 'Any'),
      healthConditions: _stringList(data['healthConditions']),
      allergies: _allergyList(data['allergies']),
      goal: _normalizeGoal(_stringValue(data['goal'], fallback: 'Maintenance')),
      heightCm: _doubleValue(data['heightCm']),
      weightKg: _doubleValue(data['weightKg']),
      activityLevel: _stringValue(data['activityLevel'], fallback: 'Moderate'),
    );
  }

  static String _stringValue(dynamic value, {required String fallback}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static double _doubleValue(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final text = value.toString().trim();
    if (text.isEmpty) return [];

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

    if (normalized == 'weight loss') return 'WeightLoss';
    if (normalized == 'weight gain') return 'WeightGain';
    if (normalized == 'muscle gain') return 'MuscleGain';
    if (normalized == 'maintenance') return 'Maintenance';

    return value.replaceAll(' ', '');
  }
}