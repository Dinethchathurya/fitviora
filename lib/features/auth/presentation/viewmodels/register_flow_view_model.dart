import 'package:flutter/material.dart';

class RegisterFlowViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final heightController = TextEditingController(text: '170');
  final weightController = TextEditingController(text: '70');
  final allergyController = TextEditingController();

  String gender = '';
  String activityLevel = '';
  String foodPreference = '';
  final Set<String> healthConditions = {};
  String goal = '';

  @override
  void dispose() {
    fullNameController.dispose();
    dateOfBirthController.dispose();
    heightController.dispose();
    weightController.dispose();
    allergyController.dispose();
    super.dispose();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setActivityLevel(String value) {
    activityLevel = value;
    notifyListeners();
  }

  void setFoodPreference(String value) {
    foodPreference = value;
    notifyListeners();
  }

  void toggleHealthCondition(String value) {
    if (healthConditions.contains(value)) {
      healthConditions.remove(value);
    } else {
      healthConditions.add(value);
    }
    notifyListeners();
  }

  void setGoal(String value) {
    goal = value;
    notifyListeners();
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'fullName': fullNameController.text.trim(),
      'dateOfBirth': dateOfBirthController.text.trim(),
      'heightCm': double.tryParse(heightController.text.trim()) ?? 0,
      'weightKg': double.tryParse(weightController.text.trim()) ?? 0,
      'gender': gender,
      'activityLevel': activityLevel,
      'foodPreference': foodPreference,
      'healthConditions': healthConditions.toList(),
      'allergies': allergyController.text.trim(),
      'goal': goal,
    };
  }
}
