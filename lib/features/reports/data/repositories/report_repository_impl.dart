import '../../domain/entities/daily_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl({
    required this.remoteDataSource,
  });

  final ReportRemoteDataSource remoteDataSource;

  @override
  Future<DailyReport> getDailyReport({
    required DateTime date,
  }) async {
    final user = await remoteDataSource.getCurrentUser();

    final meals = await remoteDataSource.getMealsForDate(
      date: date,
    );

    var calories = 0;
    var protein = 0.0;
    var carbs = 0.0;
    var fat = 0.0;

    for (final meal in meals) {
      calories += meal.calories;
      protein += meal.proteinG;
      carbs += meal.carbsG;
      fat += meal.fatG;
    }

    final calorieGoal = _calculateCalorieGoal(
      weightKg: user.weightKg,
      heightCm: user.heightCm,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      activityLevel: user.activityLevel,
      goal: user.goal,
    );

    /*
     * Macro targets based on the calculated calorie goal.
     *
     * Protein = 25% calories
     * Carbs   = 45% calories
     * Fat     = 30% calories
     *
     * Protein/carbs = 4 kcal per gram
     * Fat = 9 kcal per gram
     */
    final proteinGoal =
        (calorieGoal * 0.25) / 4;

    final carbsGoal =
        (calorieGoal * 0.45) / 4;

    final fatGoal =
        (calorieGoal * 0.30) / 9;

    final gaps = _calculateGaps(
      proteinConsumed: protein,
      proteinGoal: proteinGoal,
      carbsConsumed: carbs,
      carbsGoal: carbsGoal,
      fatConsumed: fat,
      fatGoal: fatGoal,
    );

    final suggestions =
        _buildSuggestions(gaps);

    return DailyReport(
      date: date,
      calorieConsumed: calories,
      calorieGoal: calorieGoal,
      proteinConsumed: protein,
      proteinGoal: proteinGoal,
      carbsConsumed: carbs,
      carbsGoal: carbsGoal,
      fatConsumed: fat,
      fatGoal: fatGoal,
      mealsSelected: meals.length,
      nutrientGaps: gaps,
      suggestedFoods: suggestions,
    );
  }

  List<NutrientGap> _calculateGaps({
    required double proteinConsumed,
    required double proteinGoal,
    required double carbsConsumed,
    required double carbsGoal,
    required double fatConsumed,
    required double fatGoal,
  }) {
    final gaps = <NutrientGap>[];

    void addGap(
      String name,
      double consumed,
      double target,
    ) {
      if (target <= 0 || consumed >= target) {
        return;
      }

      final percentage =
          ((target - consumed) / target) * 100;

      gaps.add(
        NutrientGap(
          name: name,
          consumed: consumed,
          target: target,
          gapPercentage: percentage,
        ),
      );
    }

    addGap(
      'Protein',
      proteinConsumed,
      proteinGoal,
    );

    addGap(
      'Carbohydrates',
      carbsConsumed,
      carbsGoal,
    );

    addGap(
      'Fats',
      fatConsumed,
      fatGoal,
    );

    gaps.sort(
      (a, b) =>
          b.gapPercentage.compareTo(
        a.gapPercentage,
      ),
    );

    return gaps;
  }

  List<SuggestedReportFood> _buildSuggestions(
    List<NutrientGap> gaps,
  ) {
    if (gaps.isEmpty) {
      return const [];
    }

    /*
     * These are only category-level suggestions.
     *
     * We should NOT pretend we know Vitamin D, iron, calcium etc.
     * because your current selected_meals documents only contain
     * calories/protein/carbs/fat.
     */
    return gaps.take(2).map((gap) {
      switch (gap.name) {
        case 'Protein':
          return const SuggestedReportFood(
            id: 'protein',
            name: 'Protein-rich foods',
            reason: 'Helps close today’s protein gap',
          );

        case 'Carbohydrates':
          return const SuggestedReportFood(
            id: 'carbohydrates',
            name: 'Healthy carbohydrate foods',
            reason: 'Helps reach today’s carbohydrate target',
          );

        case 'Fats':
          return const SuggestedReportFood(
            id: 'fats',
            name: 'Healthy fat sources',
            reason: 'Helps reach today’s fat target',
          );

        default:
          return SuggestedReportFood(
            id: gap.name.toLowerCase(),
            name: gap.name,
            reason: 'Helps close today’s nutrition gap',
          );
      }
    }).toList(growable: false);
  }

  int _calculateCalorieGoal({
    required double weightKg,
    required double heightCm,
    required DateTime? dateOfBirth,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    if (weightKg <= 0 || heightCm <= 0) {
      return 2000;
    }

    final age = _calculateAge(
      dateOfBirth,
    );

    final normalizedGender =
        gender.trim().toLowerCase();

    double bmr;

    /*
     * Mifflin-St Jeor equation.
     */
    if (normalizedGender == 'female') {
      bmr =
          (10 * weightKg) +
          (6.25 * heightCm) -
          (5 * age) -
          161;
    } else {
      bmr =
          (10 * weightKg) +
          (6.25 * heightCm) -
          (5 * age) +
          5;
    }

    final activity =
        activityLevel.trim().toLowerCase();

    double multiplier;

    if (activity.contains('low') ||
        activity.contains('sedentary')) {
      multiplier = 1.2;
    } else if (activity.contains('high')) {
      multiplier = 1.725;
    } else {
      multiplier = 1.55;
    }

    var target = bmr * multiplier;

    final normalizedGoal =
        goal.trim().toLowerCase();

    if (normalizedGoal.contains('loss')) {
      target -= 500;
    } else if (normalizedGoal.contains('gain')) {
      target += 400;
    }

    return target
        .round()
        .clamp(1200, 3500);
  }

  int _calculateAge(
    DateTime? birthDate,
  ) {
    if (birthDate == null) {
      return 25;
    }

    final today = DateTime.now();

    var age = today.year - birthDate.year;

    final birthdayNotPassed =
        today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day);

    if (birthdayNotPassed) {
      age--;
    }

    if (age <= 0 || age > 120) {
      return 25;
    }

    return age;
  }
}