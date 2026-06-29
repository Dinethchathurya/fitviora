class UserMealProfile {
  const UserMealProfile({
    required this.foodPreference,
    required this.healthConditions,
    required this.allergies,
    required this.goal,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
  });

  final String foodPreference;
  final List<String> healthConditions;
  final List<String> allergies;
  final String goal;
  final double heightCm;
  final double weightKg;
  final String activityLevel;

  double get bmi {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    final value = bmi;

    if (value < 18.5) return 'Underweight';
    if (value < 25) return 'Normal';
    if (value < 30) return 'Overweight';
    return 'Obese';
  }
}