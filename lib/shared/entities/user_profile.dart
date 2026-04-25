class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String dateOfBirth;
  final double heightCm;
  final double weightKg;
  final String gender;
  final String activityLevel;
  final String foodPreference;
  final List<String> healthConditions;
  final String allergies;
  final String goal;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.activityLevel,
    required this.foodPreference,
    required this.healthConditions,
    required this.allergies,
    required this.goal,
  });
}
