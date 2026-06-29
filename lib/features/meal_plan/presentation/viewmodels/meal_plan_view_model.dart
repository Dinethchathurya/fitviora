import 'package:flutter/foundation.dart';

import '../../data/repositories/food_component_repository.dart';
import '../../data/repositories/user_meal_profile_repository.dart';
import '../../data/services/food_component_filter_service.dart';
import '../../domain/entities/food_component.dart';
import '../../domain/entities/user_meal_profile.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({
    required FoodComponentRepository repository,
    required UserMealProfileRepository userProfileRepository,
    FoodComponentFilterService filterService = const FoodComponentFilterService(),
  })  : _repository = repository,
        _userProfileRepository = userProfileRepository,
        _filterService = filterService;

  final FoodComponentRepository _repository;
  final UserMealProfileRepository _userProfileRepository;
  final FoodComponentFilterService _filterService;

  List<FoodComponent> _allFoods = [];
  List<FoodComponent> _availableFoods = [];

  List<FoodComponent> get availableFoods => _availableFoods;

  UserMealProfile? _userProfile;
  UserMealProfile? get userProfile => _userProfile;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadFoodDataset({
    required String mealType,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _userProfile = await _userProfileRepository.getCurrentUserMealProfile();
      _allFoods = await _repository.getAllFoodComponents();

      _applyFilters(mealType: mealType);
    } catch (e) {
      _error = e.toString();
      _allFoods = [];
      _availableFoods = [];
    }

    _loading = false;
    notifyListeners();
  }

  void filterByMealType(String mealType) {
    _applyFilters(mealType: mealType);
    notifyListeners();
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


  Future<void> refresh({
    required String mealType,
  }) async {
    await loadFoodDataset(mealType: mealType);
  }

  FoodComponent? getFoodById(String id) {
    try {
      return _availableFoods.firstWhere((food) => food.id == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _allFoods = [];
    _availableFoods = [];
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
}