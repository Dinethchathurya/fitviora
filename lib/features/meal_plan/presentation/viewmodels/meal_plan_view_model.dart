import 'package:flutter/foundation.dart';

import '../../data/repositories/food_component_repository.dart';
import '../../domain/entities/food_component.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({
    required FoodComponentRepository repository,
  }) : _repository = repository;

  final FoodComponentRepository _repository;

  List<FoodComponent> _availableFoods = [];

  List<FoodComponent> get availableFoods => _availableFoods;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  Future<void> loadFoodDataset() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _availableFoods = await _repository.getAllFoodComponents();
    } catch (e) {
      _error = e.toString();
      _availableFoods = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadFoodDataset();
  }

  FoodComponent? getFoodById(String id) {
    try {
      return _availableFoods.firstWhere((food) => food.id == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _availableFoods = [];
    _error = null;
    notifyListeners();
  }
}