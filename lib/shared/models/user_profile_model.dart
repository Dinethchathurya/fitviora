import '../entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.dateOfBirth,
    required super.heightCm,
    required super.weightKg,
    required super.gender,
    required super.activityLevel,
    required super.foodPreference,
    required super.healthConditions,
    required super.allergies,
    required super.goal,
  });

  factory UserProfileModel.fromMap(String id, Map<String, dynamic> map) {
    return UserProfileModel(
      id: id,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      heightCm: (map['heightCm'] ?? 0).toDouble(),
      weightKg: (map['weightKg'] ?? 0).toDouble(),
      gender: map['gender'] ?? '',
      activityLevel: map['activityLevel'] ?? '',
      foodPreference: map['foodPreference'] ?? '',
      healthConditions: List<String>.from(map['healthConditions'] ?? []),
      allergies: map['allergies'] ?? '',
      goal: map['goal'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'gender': gender,
      'activityLevel': activityLevel,
      'foodPreference': foodPreference,
      'healthConditions': healthConditions,
      'allergies': allergies,
      'goal': goal,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
