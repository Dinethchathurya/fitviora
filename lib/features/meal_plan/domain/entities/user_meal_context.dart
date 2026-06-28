class UserMealContext {
  const UserMealContext({
    required this.dietaryPreference,
    required this.healthConditions,
    required this.allergies,
    required this.goal,
    required this.bmi,
    required this.weatherCondition,
  });

  final String dietaryPreference;
  final List<String> healthConditions;
  final List<String> allergies;
  final String goal;
  final double bmi;
  final String weatherCondition;
}