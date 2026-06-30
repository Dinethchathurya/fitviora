import 'package:flutter/foundation.dart';

import '../../data/repositories/food_component_repository.dart';
import '../../data/repositories/user_meal_profile_repository.dart';
import '../../data/services/food_component_filter_service.dart';
import '../../data/services/gemini_meal_prompt_builder.dart';
import '../../data/services/gemini_meal_service.dart';
import '../../domain/entities/ai_meal_recommendation.dart';
import '../../domain/entities/food_component.dart';
import '../../domain/entities/user_meal_profile.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({
    required FoodComponentRepository repository,
    required UserMealProfileRepository userProfileRepository,
    required GeminiMealService geminiMealService,
    FoodComponentFilterService filterService = const FoodComponentFilterService(),
    GeminiMealPromptBuilder promptBuilder = const GeminiMealPromptBuilder(),
  })  : _repository = repository,
        _userProfileRepository = userProfileRepository,
        _geminiMealService = geminiMealService,
        _filterService = filterService,
        _promptBuilder = promptBuilder;

  final FoodComponentRepository _repository;
  final UserMealProfileRepository _userProfileRepository;
  final GeminiMealService _geminiMealService;
  final FoodComponentFilterService _filterService;
  final GeminiMealPromptBuilder _promptBuilder;

  List<FoodComponent> _allFoods = [];
  List<FoodComponent> _availableFoods = [];
  List<AiMealRecommendation> _meals = [];

  List<FoodComponent> get availableFoods => _availableFoods;
  List<AiMealRecommendation> get meals => _meals;

  UserMealProfile? _userProfile;
  UserMealProfile? get userProfile => _userProfile;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadMeals({
    required String mealType,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _userProfile = await _userProfileRepository.getCurrentUserMealProfile();
      _allFoods = await _repository.getAllFoodComponents();

      _applyFilters(mealType: mealType);

      final profile = _userProfile;
      if (profile == null) {
        _meals = [];
        return;
      }

      final prompt = _promptBuilder.build(
        components: _availableFoods,
        mealType: mealType,
        dietaryPreference: profile.foodPreference,
        goal: profile.goal,
        allergies: profile.allergies,
        healthConditions: profile.healthConditions,
        bmi: profile.bmi,
        bmiCategory: profile.bmiCategory,
        weatherCondition: 'Unknown',
        temperatureCelsius: 0,
        humidity: 0,
        mealCount: 5,
      );

      _meals = await _geminiMealService.generateMeals(prompt);
    } catch (e) {
      _error = e.toString();
      _availableFoods = [];
      _meals = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> changeMealType(String mealType) async {
    await loadMeals(mealType: mealType);
  }

  void _applyFilters({
    required String mealType,
  }) {
    final profile = _userProfile;

    if (profile == null) {
      _availableFoods = [];
      return;
    }

    _availableFoods = _filterService.filter(
      components: _allFoods,
      mealType: mealType,
      dietaryPreference: profile.foodPreference,
      healthConditions: profile.healthConditions,
    );
  }

  void clear() {
    _allFoods = [];
    _availableFoods = [];
    _meals = [];
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
}