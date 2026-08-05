// import 'package:flutter/foundation.dart';

// import '../../data/repositories/food_component_repository.dart';
// import '../../data/repositories/selected_meal_repository.dart';
// import '../../data/repositories/user_meal_profile_repository.dart';
// import '../../data/services/food_component_filter_service.dart';
// import '../../data/services/gemini_meal_prompt_builder.dart';
// import '../../data/services/gemini_meal_service.dart';
// import '../../domain/entities/ai_meal_recommendation.dart';
// import '../../domain/entities/food_component.dart';
// import '../../domain/entities/user_meal_profile.dart';

// class MealPlanViewModel extends ChangeNotifier {
//   MealPlanViewModel({
//     required FoodComponentRepository repository,
//     required UserMealProfileRepository userProfileRepository,
//     required GeminiMealService geminiMealService,
//     required SelectedMealRepository selectedMealRepository,
//     FoodComponentFilterService filterService =
//         const FoodComponentFilterService(),
//     GeminiMealPromptBuilder promptBuilder = const GeminiMealPromptBuilder(),
//   }) : _repository = repository,
//        _userProfileRepository = userProfileRepository,
//        _geminiMealService = geminiMealService,
//        _selectedMealRepository = selectedMealRepository,
//        _filterService = filterService,
//        _promptBuilder = promptBuilder;

//   final FoodComponentRepository _repository;
//   final UserMealProfileRepository _userProfileRepository;
//   final GeminiMealService _geminiMealService;
//   final SelectedMealRepository _selectedMealRepository;
//   final FoodComponentFilterService _filterService;
//   final GeminiMealPromptBuilder _promptBuilder;

//   List<FoodComponent> _allFoods = [];
//   List<FoodComponent> _availableFoods = [];
//   List<AiMealRecommendation> _meals = [];

//   List<FoodComponent> get availableFoods => _availableFoods;
//   List<AiMealRecommendation> get meals => _meals;

//   AiMealRecommendation? _selectedMeal;
//   AiMealRecommendation? get selectedMeal => _selectedMeal;

//   bool get hasSelectedMeal => _selectedMeal != null;

//   UserMealProfile? _userProfile;
//   UserMealProfile? get userProfile => _userProfile;

//   bool _loading = false;
//   bool get loading => _loading;

//   String? _error;
//   String? get error => _error;

//   Future<void> loadMeals({required String mealType}) async {
//     _loading = true;
//     _error = null;
//     _meals = [];
//     _selectedMeal = null;
//     notifyListeners();

//     try {
//       final savedMeal = await _selectedMealRepository.getTodaySelectedMeal(
//         mealType: mealType,
//       );

//       if (savedMeal != null) {
//         _selectedMeal = savedMeal;
//         _meals = [savedMeal];
//         _loading = false;
//         notifyListeners();
//         return;
//       }

//       _userProfile = await _userProfileRepository.getCurrentUserMealProfile();
//       _allFoods = await _repository.getAllFoodComponents();

//       _applyFilters(mealType: mealType);

//       final profile = _userProfile;
//       if (profile == null) {
//         _meals = [];
//         return;
//       }

//       final prompt = _promptBuilder.build(
//         components: _availableFoods,
//         mealType: mealType,
//         dietaryPreference: profile.foodPreference,
//         goal: profile.goal,
//         allergies: profile.allergies,
//         healthConditions: profile.healthConditions,
//         bmi: profile.bmi,
//         bmiCategory: profile.bmiCategory,
//         weatherCondition: 'Unknown',
//         temperatureCelsius: 0,
//         humidity: 0,
//         mealCount: 5,
//         targetCalories: profile.targetCaloriesForMeal(mealType),
//       );

//       _meals = await _geminiMealService.generateMeals(prompt);
//     } catch (e) {
//       _error = e.toString();
//       _availableFoods = [];
//       _meals = [];
//       _selectedMeal = null;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   Future<void> changeMealType({
//   required String mealType,
// }) async {
//   await loadMeals(
//     mealType: mealType,
//   );
// }

//   Future<bool> selectMeal({
//     required AiMealRecommendation meal,
//     required String mealType,
//   }) async {
//     try {
//       await _selectedMealRepository.saveSelectedMeal(
//         meal: meal,
//         mealType: mealType,
//       );

//       _selectedMeal = meal;
//       _meals = [meal];
//       _error = null;
//       notifyListeners();

//       return true;
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//       return false;
//     }
//   }

//   void _applyFilters({required String mealType}) {
//     final profile = _userProfile;

//     if (profile == null) {
//       _availableFoods = [];
//       return;
//     }

//     _availableFoods = _filterService.filter(
//       components: _allFoods,
//       mealType: mealType,
//       dietaryPreference: profile.foodPreference,
//       healthConditions: profile.healthConditions,
//     );
//   }

//   void clear() {
//     _allFoods = [];
//     _availableFoods = [];
//     _meals = [];
//     _selectedMeal = null;
//     _userProfile = null;
//     _error = null;
//     notifyListeners();
//   }
// }




import 'package:flutter/foundation.dart';

import '../../data/repositories/food_component_repository.dart';
import '../../data/repositories/selected_meal_repository.dart';
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
    required SelectedMealRepository selectedMealRepository,
    FoodComponentFilterService filterService =
        const FoodComponentFilterService(),
    GeminiMealPromptBuilder promptBuilder = const GeminiMealPromptBuilder(),
  }) : _repository = repository,
       _userProfileRepository = userProfileRepository,
       _geminiMealService = geminiMealService,
       _selectedMealRepository = selectedMealRepository,
       _filterService = filterService,
       _promptBuilder = promptBuilder;

  final FoodComponentRepository _repository;
  final UserMealProfileRepository _userProfileRepository;
  final GeminiMealService _geminiMealService;
  final SelectedMealRepository _selectedMealRepository;
  final FoodComponentFilterService _filterService;
  final GeminiMealPromptBuilder _promptBuilder;

  List<FoodComponent> _allFoods = [];
  List<FoodComponent> _availableFoods = [];
  List<AiMealRecommendation> _meals = [];

  List<FoodComponent> get availableFoods =>
      List<FoodComponent>.unmodifiable(_availableFoods);

  List<AiMealRecommendation> get meals =>
      List<AiMealRecommendation>.unmodifiable(_meals);

  AiMealRecommendation? _selectedMeal;
  AiMealRecommendation? get selectedMeal => _selectedMeal;

  bool get hasSelectedMeal => _selectedMeal != null;

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
    _meals = [];
    _selectedMeal = null;
    notifyListeners();

    try {
      /*
       * Load the profile and food dataset first.
       *
       * We need the food dataset before processing either a saved meal
       * or a newly generated Gemini meal because baseFoodId must be checked
       * against the real Base component IDs.
       */
      _userProfile =
          await _userProfileRepository.getCurrentUserMealProfile();

      _allFoods = await _repository.getAllFoodComponents();

      _applyFilters(mealType: mealType);

      /*
       * Try to load an already selected meal for today.
       */
      final savedMeal =
          await _selectedMealRepository.getTodaySelectedMeal(
        mealType: mealType,
      );

      if (savedMeal != null) {
        final correctedSavedMeal = _correctMealBaseFoodId(savedMeal);

        _selectedMeal = correctedSavedMeal;
        _meals = [correctedSavedMeal];
        return;
      }

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
        targetCalories: profile.targetCaloriesForMeal(mealType),
      );

      /*
       * Generate raw meals from Gemini.
       */
      final generatedMeals =
          await _geminiMealService.generateMeals(prompt);

      /*
       * Correct every Gemini baseFoodId before the UI receives the meals.
       */
      _meals = generatedMeals
          .map(_correctMealBaseFoodId)
          .toList(growable: false);
    } catch (e, stackTrace) {
      debugPrint('Meal loading error: $e');
      debugPrintStack(stackTrace: stackTrace);

      _error = e.toString();
      _availableFoods = [];
      _meals = [];
      _selectedMeal = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> changeMealType({
    required String mealType,
  }) async {
    await loadMeals(mealType: mealType);
  }

  Future<bool> selectMeal({
    required AiMealRecommendation meal,
    required String mealType,
  }) async {
    try {
      /*
       * Correct the ID one final time before saving to Firestore.
       */
      final correctedMeal = _correctMealBaseFoodId(meal);

      await _selectedMealRepository.saveSelectedMeal(
        meal: correctedMeal,
        mealType: mealType,
      );

      _selectedMeal = correctedMeal;
      _meals = [correctedMeal];
      _error = null;
      notifyListeners();

      return true;
    } catch (e, stackTrace) {
      debugPrint('Meal selection error: $e');
      debugPrintStack(stackTrace: stackTrace);

      _error = e.toString();
      notifyListeners();

      return false;
    }
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

  // ---------------------------------------------------------------------------
  // Base-food ID correction
  // ---------------------------------------------------------------------------

  AiMealRecommendation _correctMealBaseFoodId(
    AiMealRecommendation meal,
  ) {
    final validBaseFoods = _availableFoods
        .where(_isBaseComponent)
        .toList(growable: false);

    /*
     * If filtered foods do not contain Base components, use Base components
     * from the complete dataset as a fallback.
     */
    final baseFoods = validBaseFoods.isNotEmpty
        ? validBaseFoods
        : _allFoods.where(_isBaseComponent).toList(growable: false);

    if (baseFoods.isEmpty) {
      debugPrint(
        'No valid Base components were found. '
        'Keeping Gemini baseFoodId: ${meal.baseFoodId}',
      );

      return meal;
    }

    final correctedBaseFoodId = _findBestBaseFoodId(
      geminiBaseFoodId: meal.baseFoodId,
      componentIds: meal.componentIds,
      validBaseFoods: baseFoods,
    );

    debugPrint(
      'Gemini baseFoodId: ${meal.baseFoodId} '
      '→ corrected baseFoodId: $correctedBaseFoodId',
    );

    /*
     * Keep all meal information unchanged.
     * Only replace baseFoodId.
     */
    return AiMealRecommendation(
      title: meal.title,
      description: meal.description,
      tags: meal.tags,
      portionSize: meal.portionSize,
      totalCalories: meal.totalCalories,
      proteinG: meal.proteinG,
      carbsG: meal.carbsG,
      fatG: meal.fatG,
      baseFoodId: correctedBaseFoodId,
      componentIds: meal.componentIds,
    );
  }

  String _findBestBaseFoodId({
    required String geminiBaseFoodId,
    required List<String> componentIds,
    required List<FoodComponent> validBaseFoods,
  }) {
    final validBaseIds =
        validBaseFoods.map((food) => food.id).toList(growable: false);

    /*
     * Rule 1:
     * Gemini already returned an exact valid Base ID.
     */
    if (validBaseIds.contains(geminiBaseFoodId)) {
      return geminiBaseFoodId;
    }

    /*
     * Rule 2:
     * Find an exact Base ID inside componentIds.
     *
     * Gemini may return the wrong baseFoodId but still include the correct
     * dataset ID inside componentIds.
     */
    for (final componentId in componentIds) {
      if (validBaseIds.contains(componentId)) {
        return componentId;
      }
    }

    /*
     * Rule 3:
     * Compare Gemini baseFoodId against the valid Base IDs.
     */
    final normalizedGeminiId = _normalizeFoodId(geminiBaseFoodId);

    FoodComponent? bestMatch;
    double bestScore = -1;

    for (final baseFood in validBaseFoods) {
      final candidateScore = _calculateIdSimilarity(
        normalizedGeminiId,
        _normalizeFoodId(baseFood.id),
      );

      if (candidateScore > bestScore) {
        bestScore = candidateScore;
        bestMatch = baseFood;
      }
    }

    /*
     * Rule 4:
     * Also compare all Gemini component IDs.
     *
     * Sometimes Gemini's baseFoodId is badly modified, while a component ID
     * is much closer to the real Base component.
     */
    for (final componentId in componentIds) {
      final normalizedComponentId = _normalizeFoodId(componentId);

      for (final baseFood in validBaseFoods) {
        final candidateScore = _calculateIdSimilarity(
          normalizedComponentId,
          _normalizeFoodId(baseFood.id),
        );

        if (candidateScore > bestScore) {
          bestScore = candidateScore;
          bestMatch = baseFood;
        }
      }
    }

    /*
     * Rule 5:
     * Return the closest real dataset Base ID.
     */
    if (bestMatch != null) {
      return bestMatch.id;
    }

    /*
     * Final fallback.
     *
     * This prevents a non-existent image filename from reaching the UI.
     */
    return validBaseFoods.first.id;
  }

  double _calculateIdSimilarity(
    String first,
    String second,
  ) {
    if (first == second) {
      return 1000;
    }

    var score = 0.0;

    /*
     * Strong match when one normalized value contains the other.
     *
     * Example:
     * string_hoppers_15pcs → string_hoppers
     * string_hoppers_5pcs  → string_hoppers
     */
    if (first.contains(second) || second.contains(first)) {
      score += 200;
    }

    final firstTokens = first
        .split('_')
        .where((token) => token.isNotEmpty)
        .toSet();

    final secondTokens = second
        .split('_')
        .where((token) => token.isNotEmpty)
        .toSet();

    final matchingTokens =
        firstTokens.intersection(secondTokens).length;

    score += matchingTokens * 50;

    /*
     * Prefer matching the first food word.
     */
    if (firstTokens.isNotEmpty &&
        secondTokens.isNotEmpty &&
        firstTokens.first == secondTokens.first) {
      score += 40;
    }

    /*
     * Small edit-distance bonus.
     */
    final distance = _levenshteinDistance(first, second);
    final longestLength =
        first.length > second.length ? first.length : second.length;

    if (longestLength > 0) {
      final textSimilarity = 1 - (distance / longestLength);
      score += textSimilarity * 100;
    }

    return score;
  }

  String _normalizeFoodId(
    String value,
  ) {
    var normalized = value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    /*
     * Known language aliases in your dataset.
     */
    normalized = normalized
        .replaceAll('pol_roti', 'coconut_roti')
        .replaceAll('plain_bread', 'white_bread');

    /*
     * Remove serving suffixes only for comparison.
     *
     * The real ID returned to the application is never modified.
     *
     * Examples removed:
     * _100g
     * _250g
     * _200ml
     * _1pc
     * _4pcs
     * _5slices
     */
    normalized = normalized.replaceFirst(
      RegExp(
        r'_(\d+(?:\.\d+)?)'
        r'(g|kg|ml|l|pc|pcs|piece|pieces|slice|slices)$',
      ),
      '',
    );

    normalized = normalized.replaceAll(
      RegExp(r'_+'),
      '_',
    );

    return normalized;
  }

  int _levenshteinDistance(
    String first,
    String second,
  ) {
    if (first == second) return 0;
    if (first.isEmpty) return second.length;
    if (second.isEmpty) return first.length;

    final previousRow =
        List<int>.generate(second.length + 1, (index) => index);

    for (var firstIndex = 1;
        firstIndex <= first.length;
        firstIndex++) {
      final currentRow = List<int>.filled(second.length + 1, 0);

      currentRow[0] = firstIndex;

      for (var secondIndex = 1;
          secondIndex <= second.length;
          secondIndex++) {
        final insertCost = currentRow[secondIndex - 1] + 1;
        final deleteCost = previousRow[secondIndex] + 1;

        final replacementCost =
            previousRow[secondIndex - 1] +
            (first[firstIndex - 1] == second[secondIndex - 1] ? 0 : 1);

        currentRow[secondIndex] = _minimumOfThree(
          insertCost,
          deleteCost,
          replacementCost,
        );
      }

      for (var index = 0;
          index < previousRow.length;
          index++) {
        previousRow[index] = currentRow[index];
      }
    }

    return previousRow.last;
  }

  int _minimumOfThree(
    int first,
    int second,
    int third,
  ) {
    var minimum = first;

    if (second < minimum) {
      minimum = second;
    }

    if (third < minimum) {
      minimum = third;
    }

    return minimum;
  }

  bool _isBaseComponent(
    FoodComponent component,
  ) {
    return component.mealRole.trim().toLowerCase() == 'base';
  }

  void clear() {
    _allFoods = [];
    _availableFoods = [];
    _meals = [];
    _selectedMeal = null;
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
}