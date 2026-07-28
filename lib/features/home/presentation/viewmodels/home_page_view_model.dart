import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitviora/features/home/data/repositories/seasonal_food_repository.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/seasonal_food.dart';

class HomePageViewModel extends ChangeNotifier {
  HomePageViewModel({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    SeasonalFoodRepository seasonalFoodRepository =
        const SeasonalFoodRepository(),
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _seasonalFoodRepository = seasonalFoodRepository;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;
  final SeasonalFoodRepository _seasonalFoodRepository;

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

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
        .where((food) => food.category == SeasonalFoodCategory.fruit)
        .toList(growable: false);
  }

  List<SeasonalFood> get seasonalVegetables {
    return _seasonalFoods
        .where((food) => food.category == SeasonalFoodCategory.vegetable)
        .toList(growable: false);
  }

  List<SeasonalFood> get seasonalFishAndProteins {
    return _seasonalFoods
        .where((food) {
          return food.category == SeasonalFoodCategory.fish ||
              food.category == SeasonalFoodCategory.protein;
        })
        .toList(growable: false);
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
      proteinGoal <= 0 ? 0 : (proteinConsumed / proteinGoal).clamp(0.0, 1.0);

  double get carbsProgress =>
      carbsGoal <= 0 ? 0 : (carbsConsumed / carbsGoal).clamp(0.0, 1.0);

  double get fatProgress =>
      fatGoal <= 0 ? 0 : (fatConsumed / fatGoal).clamp(0.0, 1.0);

  int get breakfastTargetCalories => (dailyCalorieGoal * 0.30).round();

  int get lunchTargetCalories => (dailyCalorieGoal * 0.40).round();

  int get dinnerTargetCalories =>
      dailyCalorieGoal - breakfastTargetCalories - lunchTargetCalories;

  double get breakfastProgress {
    if (breakfastTargetCalories <= 0) return 0;

    return (breakfastCalories / breakfastTargetCalories).clamp(0.0, 1.0);
  }

  double get lunchProgress {
    if (lunchTargetCalories <= 0) return 0;

    return (lunchCalories / lunchTargetCalories).clamp(0.0, 1.0);
  }

  double get dinnerProgress {
    if (dinnerTargetCalories <= 0) return 0;

    return (dinnerCalories / dinnerTargetCalories).clamp(0.0, 1.0);
  }

  int get breakfastCompletionPercentage => (breakfastProgress * 100).round();

  int get lunchCompletionPercentage => (lunchProgress * 100).round();

  int get dinnerCompletionPercentage => (dinnerProgress * 100).round();

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

    if (!snapshot.exists || snapshot.data() == null) {
      return;
    }

    final data = snapshot.data()!;

    fullName = _stringValue(data['fullName'], fallback: 'FitViora User');

    final weightKg = _toDouble(data['weightKg']);
    final heightCm = _toDouble(data['heightCm']);

    final gender = _stringValue(data['gender'], fallback: 'Male');

    int _calculateAge(DateTime? dateOfBirth) {
      if (dateOfBirth == null) {
        return 25;
      }

      final today = DateTime.now();

      int age = today.year - dateOfBirth.year;

      final hasNotHadBirthdayThisYear =
          today.month < dateOfBirth.month ||
          (today.month == dateOfBirth.month && today.day < dateOfBirth.day);

      if (hasNotHadBirthdayThisYear) {
        age--;
      }

      if (age < 1 || age > 120) {
        return 25;
      }

      return age;
    }

    DateTime? _toDateTime(dynamic value) {
      if (value == null) {
        return null;
      }

      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is DateTime) {
        return value;
      }

      return DateTime.tryParse(value.toString());
    }

    final dateOfBirth = _toDateTime(data['dateOfBirth']);
    final age = _calculateAge(dateOfBirth);

    final activityLevel = _stringValue(
      data['activityLevel'],
      fallback: 'Sedentary',
    );

    final goal = _stringValue(data['goal'], fallback: 'Maintenance');

    dailyCalorieGoal = _calculateDailyCalorieGoal(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );

    await firestore.collection('users').doc(userId).update({
      'dailyCalorieGoal': dailyCalorieGoal,
      'breakfastTargetCalories': breakfastTargetCalories,
      'lunchTargetCalories': lunchTargetCalories,
      'dinnerTargetCalories': dinnerTargetCalories,
    });
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

              final mealType = _stringValue(data['mealType'], fallback: '');

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
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    if (weightKg <= 0 || heightCm <= 0 || age <= 0) {
      return 2000;
    }

    final normalizedGender = gender.trim().toLowerCase();

    // Mifflin–St Jeor BMR
    double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);

    if (normalizedGender == 'female') {
      bmr -= 161;
    } else {
      bmr += 5;
    }

    double _getActivityFactor(String activityLevel) {
      final normalized = activityLevel.trim().toLowerCase();

      switch (normalized) {
        case 'sedentary':
        case 'low':
          return 1.2;

        case 'light':
        case 'lightly active':
          return 1.375;

        case 'moderate':
        case 'moderately active':
          return 1.55;

        case 'active':
        case 'high':
        case 'very active':
          return 1.725;

        default:
          return 1.2;
      }
    }

    double _calculateBmi({required double weightKg, required double heightCm}) {
      if (weightKg <= 0 || heightCm <= 0) {
        return 0;
      }

      final heightMetres = heightCm / 100;

      return weightKg / (heightMetres * heightMetres);
    }

    int _calculateAge(DateTime? dateOfBirth) {
      if (dateOfBirth == null) {
        return 25;
      }

      final today = DateTime.now();

      var age = today.year - dateOfBirth.year;

      final birthdayHasNotOccurred =
          today.month < dateOfBirth.month ||
          (today.month == dateOfBirth.month && today.day < dateOfBirth.day);

      if (birthdayHasNotOccurred) {
        age--;
      }

      return age > 0 ? age : 25;
    }

    DateTime? _toDateTime(dynamic value) {
      if (value == null) return null;

      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is DateTime) {
        return value;
      }

      return DateTime.tryParse(value.toString());
    }

    final activityFactor = _getActivityFactor(activityLevel);

    // Maintenance calories
    final tdee = bmr * activityFactor;

    final bmi = _calculateBmi(weightKg: weightKg, heightCm: heightCm);

    final normalizedGoal = goal.trim().toLowerCase();

    double finalCalories = tdee;

    if (normalizedGoal.contains('loss')) {
      /*
     * Weight-loss plans reduce TDEE.
     * A stronger reduction is used for obesity.
     */
      if (bmi >= 30) {
        finalCalories -= 600;
      } else {
        finalCalories -= 500;
      }
    } else if (normalizedGoal.contains('gain')) {
      finalCalories += 400;
    } else {
      // Maintenance plan
      finalCalories = tdee;
    }

    return finalCalories.round().clamp(1200, 3500);
  }

  int _percentage(int mealCalories) {
    if (dailyCalorieGoal <= 0) return 0;

    return ((mealCalories / dailyCalorieGoal) * 100).round();
  }

  static String _stringValue(dynamic value, {required String fallback}) {
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
