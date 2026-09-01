import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/meal_diversity_analysis.dart';
import '../../domain/repositories/meal_diversity_repository.dart';

class MealDiversityRepositoryImpl
    implements MealDiversityRepository {
  MealDiversityRepositoryImpl({
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
  Future<MealDiversityAnalysis> getMealDiversity({
    required DateTime endDate,
    int numberOfDays = 7,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    /*
     * We query the user's meals and perform the 7-day filter locally.
     *
     * This avoids requiring an additional Firestore composite index for:
     *
     * userId + selectedDate range
     */
    final snapshot = await firestore
        .collection('selected_meals')
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .get();

    final normalizedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    final startDate = normalizedEndDate.subtract(
      Duration(days: numberOfDays - 1),
    );

    final tomorrow = normalizedEndDate.add(
      const Duration(days: 1),
    );

    final componentCounts = <String, int>{};

    var mealsAnalyzed = 0;
    var totalFoodSelections = 0;

    for (final document in snapshot.docs) {
      final data = document.data();

      final selectedDate = _parseDate(
        data['selectedDate'],
      );

      if (selectedDate == null) {
        continue;
      }

      /*
       * Accept:
       *
       * startDate <= selectedDate < tomorrow
       */
      if (selectedDate.isBefore(startDate) ||
          !selectedDate.isBefore(tomorrow)) {
        continue;
      }

      final componentIds = _stringList(
        data['componentIds'],
      );

      /*
       * Ignore malformed selected meals without components.
       */
      if (componentIds.isEmpty) {
        continue;
      }

      mealsAnalyzed++;

      for (final componentId in componentIds) {
        final normalizedId = componentId.trim();

        if (normalizedId.isEmpty) {
          continue;
        }

        totalFoodSelections++;

        componentCounts[normalizedId] =
            (componentCounts[normalizedId] ?? 0) + 1;
      }
    }

    if (mealsAnalyzed == 0 ||
        totalFoodSelections == 0 ||
        componentCounts.isEmpty) {
      return const MealDiversityAnalysis(
        score: 0,
        uniqueFoodCount: 0,
        totalFoodSelections: 0,
        mealsAnalyzed: 0,
        repeatedFoods: [],
        statusTitle: 'Not enough data',
        statusMessage:
            'Select meals during the week to build your meal diversity score.',
      );
    }

    final uniqueFoodCount = componentCounts.length;

    final score = _calculateDiversityScore(
      uniqueFoodCount: uniqueFoodCount,
      totalFoodSelections: totalFoodSelections,
    );

    final repeatedFoods = componentCounts.entries
        .where(
          (entry) => entry.value > 1,
        )
        .map(
          (entry) => MealDiversityFood(
            componentId: entry.key,
            displayName: _foodDisplayName(
              entry.key,
            ),
            count: entry.value,
          ),
        )
        .toList()
      ..sort(
        (first, second) =>
            second.count.compareTo(first.count),
      );

    final status = _buildStatus(
      score,
    );

    return MealDiversityAnalysis(
      score: score,
      uniqueFoodCount: uniqueFoodCount,
      totalFoodSelections: totalFoodSelections,
      mealsAnalyzed: mealsAnalyzed,
      repeatedFoods:
          repeatedFoods.take(4).toList(growable: false),
      statusTitle: status.title,
      statusMessage: status.message,
    );
  }

  // ---------------------------------------------------------------------------
  // Diversity calculation
  // ---------------------------------------------------------------------------

  static int _calculateDiversityScore({
    required int uniqueFoodCount,
    required int totalFoodSelections,
  }) {
    if (uniqueFoodCount <= 0 ||
        totalFoodSelections <= 0) {
      return 0;
    }

    /*
     * Part 1 — Variety ratio (70%)
     *
     * Example:
     *
     * 10 unique foods from 15 food selections
     *
     * 10 / 15 = 66.7%
     */
    final varietyRatio =
        uniqueFoodCount / totalFoodSelections;

    /*
     * Part 2 — Weekly unique-food coverage (30%)
     *
     * For this app, reaching 12 different food components
     * within seven days receives the full coverage score.
     *
     * This is an application heuristic, not a medical score.
     */
    const weeklyUniqueFoodTarget = 12;

    final uniqueCoverage =
        (uniqueFoodCount / weeklyUniqueFoodTarget)
            .clamp(0.0, 1.0);

    final result =
        (varietyRatio * 70) +
        (uniqueCoverage * 30);

    return result.round().clamp(0, 100);
  }

  static _DiversityStatus _buildStatus(
    int score,
  ) {
    if (score >= 85) {
      return const _DiversityStatus(
        title: 'Excellent variety',
        message:
            'You are including a wide variety of foods in your recent meals.',
      );
    }

    if (score >= 70) {
      return const _DiversityStatus(
        title: 'Good variety',
        message:
            'Your meals contain good variety with some repeated foods.',
      );
    }

    if (score >= 50) {
      return const _DiversityStatus(
        title: 'Moderate variety',
        message:
            'Your meals contain some variety, but several foods are being repeated.',
      );
    }

    return const _DiversityStatus(
      title: 'Low variety',
      message:
          'Your recent meals rely on a smaller set of foods. Try varying your meal selections.',
    );
  }

  // ---------------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------------

  static String _foodDisplayName(
    String componentId,
  ) {
    var value = componentId
        .trim()
        .toLowerCase();

    /*
     * Remove common serving suffixes:
     *
     * red_rice_80g       -> red_rice
     * kiribath_100g      -> kiribath
     * hoppers_3pcs       -> hoppers
     * milk_200ml         -> milk
     */
    value = value.replaceFirst(
      RegExp(
        r'_(\d+(?:\.\d+)?)'
        r'(g|kg|mg|ml|l|pc|pcs|piece|pieces|slice|slices)$',
      ),
      '',
    );

    final words = value
        .split('_')
        .where(
          (word) => word.trim().isNotEmpty,
        );

    return words
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

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

  static List<String> _stringList(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    return value
        .map(
          (item) => item.toString().trim(),
        )
        .where(
          (item) => item.isNotEmpty,
        )
        .toList(growable: false);
  }
}

class _DiversityStatus {
  const _DiversityStatus({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}