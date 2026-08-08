import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportMealData {
  const ReportMealData({
    required this.mealType,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String mealType;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

class ReportUserData {
  const ReportUserData({
    required this.weightKg,
    required this.heightCm,
    required this.gender,
    required this.dateOfBirth,
    required this.activityLevel,
    required this.goal,
  });

  final double weightKg;
  final double heightCm;
  final String gender;
  final DateTime? dateOfBirth;
  final String activityLevel;
  final String goal;
}

class ReportRemoteDataSource {
  const ReportRemoteDataSource({
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

  Future<ReportUserData> getCurrentUser() async {
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
      throw Exception('User profile was not found.');
    }

    return ReportUserData(
      weightKg: _toDouble(data['weightKg']),
      heightCm: _toDouble(data['heightCm']),
      gender: _stringValue(
        data['gender'],
        fallback: 'Male',
      ),
      dateOfBirth: _toDateTime(
        data['dateOfBirth'],
      ),
      activityLevel: _stringValue(
        data['activityLevel'],
        fallback: 'Moderate',
      ),
      goal: _stringValue(
        data['goal'],
        fallback: 'Maintenance',
      ),
    );
  }

  Future<List<ReportMealData>> getMealsForDate({
    required DateTime date,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    final snapshot = await firestore
        .collection('selected_meals')
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .where(
          'selectedDate',
          isEqualTo: selectedDate,
        )
        .get();

    return snapshot.docs.map((document) {
      final data = document.data();

      return ReportMealData(
        mealType: _stringValue(
          data['mealType'],
          fallback: '',
        ),
        calories: _toInt(
          data['totalCalories'],
        ),
        proteinG: _toDouble(
          data['proteinG'],
        ),
        carbsG: _toDouble(
          data['carbsG'],
        ),
        fatG: _toDouble(
          data['fatG'],
        ),
      );
    }).toList(growable: false);
  }

  static String _stringValue(
    dynamic value, {
    required String fallback,
  }) {
    if (value == null) return fallback;

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is num) return value.round();

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static DateTime? _toDateTime(
    dynamic value,
  ) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}