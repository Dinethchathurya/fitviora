import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/weekly_nutrition_analysis.dart';
import '../../domain/repositories/weekly_nutrition_repository.dart';

class WeeklyNutritionRepositoryImpl
    implements WeeklyNutritionRepository {
  WeeklyNutritionRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get firebaseAuth =>
      _firebaseAuth ?? FirebaseAuth.instance;

  FirebaseFirestore get firestore =>
      _firestore ?? FirebaseFirestore.instance;

  @override
  Future<WeeklyNutritionAnalysis> getWeeklyAnalysis({
    required DateTime endDate,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final normalizedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    final startDate = normalizedEndDate.subtract(
      const Duration(days: 6),
    );

    final tomorrow = normalizedEndDate.add(
      const Duration(days: 1),
    );

    /*
     * Query only by userId.
     *
     * The date range is filtered locally so you don't need to create
     * another Firestore composite index.
     */
    final snapshot = await firestore
        .collection('selected_meals')
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .get();

    var totalCalories = 0;
    var totalProteinG = 0.0;
    var totalCarbsG = 0.0;
    var totalFatG = 0.0;
    var mealsAnalyzed = 0;

    final caloriesByDate = <DateTime, int>{};

    final caloriesByMealType = <String, int>{
      'Breakfast': 0,
      'Lunch': 0,
      'Dinner': 0,
    };

    final baseFoodCounts = <String, int>{};
    final mealTitleCounts = <String, int>{};

    for (final document in snapshot.docs) {
      final data = document.data();

      final selectedDate = _parseDate(
        data['selectedDate'],
      );

      if (selectedDate == null) {
        continue;
      }

      /*
       * Keep only records in the last seven days.
       */
      if (selectedDate.isBefore(startDate) ||
          !selectedDate.isBefore(tomorrow)) {
        continue;
      }

      final calories = _toInt(
        data['totalCalories'],
      );

      final protein = _toDouble(
        data['proteinG'],
      );

      final carbs = _toDouble(
        data['carbsG'],
      );

      final fat = _toDouble(
        data['fatG'],
      );

      final mealType = _stringValue(
        data['mealType'],
      );

      final baseFoodId = _stringValue(
        data['baseFoodId'],
      );

      final title = _stringValue(
        data['title'],
      );

      mealsAnalyzed++;

      totalCalories += calories;
      totalProteinG += protein;
      totalCarbsG += carbs;
      totalFatG += fat;

      caloriesByDate[selectedDate] =
          (caloriesByDate[selectedDate] ?? 0) +
              calories;

      /*
       * Meal type contribution.
       */
      if (mealType.isNotEmpty) {
        caloriesByMealType[mealType] =
            (caloriesByMealType[mealType] ?? 0) +
                calories;
      }

      /*
       * Base food diversity.
       */
      if (baseFoodId.isNotEmpty) {
        baseFoodCounts[baseFoodId] =
            (baseFoodCounts[baseFoodId] ?? 0) + 1;
      }

      /*
       * Meal repetition.
       */
      if (title.isNotEmpty) {
        mealTitleCounts[title] =
            (mealTitleCounts[title] ?? 0) + 1;
      }
    }

    final activeDays = caloriesByDate.length;

    /*
     * Average per active day.
     *
     * This prevents days without any selected meals from artificially
     * reducing the average.
     */
    final averageCalories = activeDays == 0
        ? 0
        : (totalCalories / activeDays).round();

    String highestCalorieDay = 'No data';
    var highestCalorieValue = 0;

    String lowestCalorieDay = 'No data';
    var lowestCalorieValue = 0;

    if (caloriesByDate.isNotEmpty) {
      final sortedDays =
          caloriesByDate.entries.toList()
            ..sort(
              (first, second) =>
                  first.value.compareTo(
                second.value,
              ),
            );

      final lowest = sortedDays.first;
      final highest = sortedDays.last;

      lowestCalorieDay =
          _dayLabel(lowest.key);

      lowestCalorieValue =
          lowest.value;

      highestCalorieDay =
          _dayLabel(highest.key);

      highestCalorieValue =
          highest.value;
    }

    // ------------------------------------------------------------
    // Meal type contribution
    // ------------------------------------------------------------

    final mealTypeContributions =
        <MealTypeContribution>[];

    for (final mealType in [
      'Breakfast',
      'Lunch',
      'Dinner',
    ]) {
      final calories =
          caloriesByMealType[mealType] ?? 0;

      final percentage =
          totalCalories <= 0
              ? 0.0
              : (calories / totalCalories) * 100;

      mealTypeContributions.add(
        MealTypeContribution(
          mealType: mealType,
          calories: calories,
          percentage: percentage,
        ),
      );
    }

    // ------------------------------------------------------------
    // Base food diversity
    // ------------------------------------------------------------

    final baseFoodUsage =
        baseFoodCounts.entries
            .map(
              (entry) => BaseFoodUsage(
                baseFoodId: entry.key,
                displayName:
                    _foodDisplayName(
                  entry.key,
                ),
                count: entry.value,
              ),
            )
            .toList()
          ..sort(
            (first, second) =>
                second.count.compareTo(
              first.count,
            ),
          );

    // ------------------------------------------------------------
    // Meal repetition
    // ------------------------------------------------------------

    final repeatedMeals =
        mealTitleCounts.entries
            .where(
              (entry) => entry.value > 1,
            )
            .map(
              (entry) => RepeatedMeal(
                title: entry.key,
                count: entry.value,
              ),
            )
            .toList()
          ..sort(
            (first, second) =>
                second.count.compareTo(
              first.count,
            ),
          );

    return WeeklyNutritionAnalysis(
      startDate: startDate,
      endDate: normalizedEndDate,
      totalCalories: totalCalories,
      totalProteinG: totalProteinG,
      totalCarbsG: totalCarbsG,
      totalFatG: totalFatG,
      averageCalories: averageCalories,
      highestCalorieDay:
          highestCalorieDay,
      highestCalorieValue:
          highestCalorieValue,
      lowestCalorieDay:
          lowestCalorieDay,
      lowestCalorieValue:
          lowestCalorieValue,
      mealsAnalyzed: mealsAnalyzed,
      activeDays: activeDays,
      mealTypeContributions:
          mealTypeContributions,
      baseFoodUsage:
          List.unmodifiable(baseFoodUsage),
      repeatedMeals:
          List.unmodifiable(repeatedMeals),
    );
  }

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------

  static DateTime? _parseDate(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      final date = value.toDate();

      return DateTime(
        date.year,
        date.month,
        date.day,
      );
    }

    if (value is DateTime) {
      return DateTime(
        value.year,
        value.month,
        value.day,
      );
    }

    final parsed = DateTime.tryParse(
      value.toString(),
    );

    if (parsed == null) {
      return null;
    }

    return DateTime(
      parsed.year,
      parsed.month,
      parsed.day,
    );
  }

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static String _stringValue(
    dynamic value,
  ) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  static String _dayLabel(
    DateTime date,
  ) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[
        date.weekday - 1];
  }

  static String _foodDisplayName(
    String id,
  ) {
    var value = id.trim();

    /*
     * Remove serving amount only for UI display.
     *
     * red_rice_80g -> Red Rice
     * kiribath_100g -> Kiribath
     */
    value = value.replaceFirst(
      RegExp(
        r'_(\d+(?:\.\d+)?)'
        r'(g|kg|mg|ml|l|pc|pcs|piece|pieces|slice|slices)$',
        caseSensitive: false,
      ),
      '',
    );

    return value
        .split('_')
        .where(
          (word) => word.isNotEmpty,
        )
        .map(
          (word) =>
              '${word[0].toUpperCase()}'
              '${word.substring(1)}',
        )
        .join(' ');
  }
}