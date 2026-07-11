import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitviora/features/home/data/repositories/seasonal_food_repository.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/seasonal_food_repository.dart';
import '../../domain/entities/seasonal_food.dart';

class HomePageViewModel extends ChangeNotifier {
  HomePageViewModel({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    SeasonalFoodRepository seasonalFoodRepository =
        const SeasonalFoodRepository(),
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _seasonalFoodRepository = seasonalFoodRepository;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;
  final SeasonalFoodRepository _seasonalFoodRepository;

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  FirebaseFirestore get firestore =>
      _firestore ?? FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _mealSubscription;

  bool isLoading = false;
  String? error;

  String fullName = 'FitViora User';

  int dailyCalorieGoal = 2000;

  int consumedCalories = 0;
  int proteinConsumed = 0;
  int carbsConsumed = 0;
  int fatConsumed = 0;

  int proteinGoal = 150;
  int carbsGoal = 200;
  int fatGoal = 90;

  int breakfastCalories = 0;
  int lunchCalories = 0;
  int dinnerCalories = 0;

  List<SeasonalFood> _seasonalFoods = [];

  List<SeasonalFood> get seasonalFoods =>
      List<SeasonalFood>.unmodifiable(_seasonalFoods);

  List<SeasonalFood> get seasonalFruits {
    return _seasonalFoods
        .where(
          (food) => food.category == SeasonalFoodCategory.fruit,
        )
        .toList(growable: false);
  }

  List<SeasonalFood> get seasonalVegetables {
    return _seasonalFoods
        .where(
          (food) => food.category == SeasonalFoodCategory.vegetable,
        )
        .toList(growable: false);
  }

  List<SeasonalFood> get seasonalFishAndProteins {
    return _seasonalFoods.where((food) {
      return food.category == SeasonalFoodCategory.fish ||
          food.category == SeasonalFoodCategory.protein;
    }).toList(growable: false);
  }

  List<String> get seasonalFruitNames {
    return seasonalFruits
        .map((food) => food.displayName)
        .toList(growable: false);
  }

  List<String> get seasonalVegetableNames {
    return seasonalVegetables
        .map((food) => food.displayName)
        .toList(growable: false);
  }

  List<String> get seasonalFishAndProteinNames {
    return seasonalFishAndProteins
        .map((food) => food.displayName)
        .toList(growable: false);
  }

  String get currentMonthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[DateTime.now().month - 1];
  }

  int get caloriesLeft {
    final value = dailyCalorieGoal - consumedCalories;
    return value < 0 ? 0 : value;
  }

  double get calorieProgress {
    if (dailyCalorieGoal <= 0) return 0;
    return (consumedCalories / dailyCalorieGoal).clamp(0.0, 1.0);
  }

  int get breakfastPercentage => _percentage(breakfastCalories);

  int get lunchPercentage => _percentage(lunchCalories);

  int get dinnerPercentage => _percentage(dinnerCalories);

  double get proteinProgress =>
      proteinGoal <= 0
          ? 0
          : (proteinConsumed / proteinGoal).clamp(0.0, 1.0);

  double get carbsProgress =>
      carbsGoal <= 0
          ? 0
          : (carbsConsumed / carbsGoal).clamp(0.0, 1.0);

  double get fatProgress =>
      fatGoal <= 0
          ? 0
          : (fatConsumed / fatGoal).clamp(0.0, 1.0);

  String get todayLabel {
    final now = DateTime.now();

    const weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${weekDays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}';
  }

  Future<void> loadHomeData() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      _loadSeasonalFoods();

      await _loadUserProfile(user.uid);
      _listenTodaySelectedMeals(user.uid);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadSeasonalFoods() {
    _seasonalFoods = _seasonalFoodRepository.getFoodsForMonth(
      DateTime.now().month,
    );
  }

  Future<void> _loadUserProfile(String userId) async {
    final snapshot = await firestore.collection('users').doc(userId).get();

    if (!snapshot.exists || snapshot.data() == null) return;

    final data = snapshot.data()!;

    fullName = _stringValue(
      data['fullName'],
      fallback: 'FitViora User',
    );

    final weightKg = _toDouble(data['weightKg']);
    final heightCm = _toDouble(data['heightCm']);

    final activityLevel = _stringValue(
      data['activityLevel'],
      fallback: 'Moderate',
    );

    final goal = _stringValue(
      data['goal'],
      fallback: 'Maintenance',
    );

    dailyCalorieGoal = _calculateDailyCalorieGoal(
      weightKg: weightKg,
      heightCm: heightCm,
      activityLevel: activityLevel,
      goal: goal,
    );
  }

  void _listenTodaySelectedMeals(String userId) {
    _mealSubscription?.cancel();

    final now = DateTime.now();

    final selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).toIso8601String();

    _mealSubscription = firestore
        .collection('selected_meals')
        .where('userId', isEqualTo: userId)
        .where('selectedDate', isEqualTo: selectedDate)
        .snapshots()
        .listen(
      (snapshot) {
        _resetMealTotals();

        for (final doc in snapshot.docs) {
          final data = doc.data();

          final mealType = _stringValue(
            data['mealType'],
            fallback: '',
          );

          final calories = _toInt(data['totalCalories']);

          consumedCalories += calories;
          proteinConsumed += _toDouble(data['proteinG']).round();
          carbsConsumed += _toDouble(data['carbsG']).round();
          fatConsumed += _toDouble(data['fatG']).round();

          if (mealType == 'Breakfast') {
            breakfastCalories += calories;
          } else if (mealType == 'Lunch') {
            lunchCalories += calories;
          } else if (mealType == 'Dinner') {
            dinnerCalories += calories;
          }
        }

        notifyListeners();
      },
      onError: (Object exception) {
        error = exception.toString();
        notifyListeners();
      },
    );
  }

  void _resetMealTotals() {
    consumedCalories = 0;
    proteinConsumed = 0;
    carbsConsumed = 0;
    fatConsumed = 0;

    breakfastCalories = 0;
    lunchCalories = 0;
    dinnerCalories = 0;
  }

  int _calculateDailyCalorieGoal({
    required double weightKg,
    required double heightCm,
    required String activityLevel,
    required String goal,
  }) {
    if (weightKg <= 0 || heightCm <= 0) return 2000;

    double calories =
        (10 * weightKg) + (6.25 * heightCm) - (5 * 25) + 5;

    final activity = activityLevel.toLowerCase();

    if (activity == 'low') {
      calories *= 1.2;
    } else if (activity == 'high') {
      calories *= 1.725;
    } else {
      calories *= 1.55;
    }

    final normalizedGoal = goal.toLowerCase();

    if (normalizedGoal.contains('loss')) {
      calories -= 500;
    } else if (normalizedGoal.contains('gain')) {
      calories += 400;
    }

    return calories.round().clamp(1200, 3500);
  }

  int _percentage(int mealCalories) {
    if (dailyCalorieGoal <= 0) return 0;

    return ((mealCalories / dailyCalorieGoal) * 100).round();
  }

  static String _stringValue(
    dynamic value, {
    required String fallback,
  }) {
    if (value == null) return fallback;

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();

    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  void dispose() {
    _mealSubscription?.cancel();
    super.dispose();
  }
}






