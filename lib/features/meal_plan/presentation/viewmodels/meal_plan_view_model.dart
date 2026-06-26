import 'package:flutter/foundation.dart';

import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/services/meal_suggestion_service.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({
    required FoodRepository repository,
    required MealSuggestionService suggestionService,
  })  : _repository = repository,
        _suggestionService = suggestionService;

  final FoodRepository _repository;
  final MealSuggestionService _suggestionService;

  List<FoodItem> _meals = [];

  List<FoodItem> get meals => _meals;

  bool _loading = false;

  bool get loading => _loading;

  Future<void> loadMeals({
    required String mealType,
    required String dietaryPreference,
    required String goal,
    List<String> allergies = const [],
  }) async {
    _loading = true;
    notifyListeners();

    final foods = await _repository.getAllFoods();

    _meals = _suggestionService.suggestMeals(
      foods: foods,
      mealType: mealType,
      dietaryPreference: dietaryPreference,
      goal: goal,
      allergies: allergies,
    );

    _loading = false;
    notifyListeners();
  }
}