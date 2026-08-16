class NutrientGap {
  const NutrientGap({
    required this.name,
    required this.consumed,
    required this.target,
    required this.gapPercentage,
  });

  final String name;
  final double consumed;
  final double target;
  final double gapPercentage;

  bool get hasGap => consumed < target;
}

class SuggestedReportFood {
  const SuggestedReportFood({
    required this.id,
    required this.name,
    required this.reason,
  });

  final String id;
  final String name;
  final String reason;
}

class DailyReport {
  const DailyReport({
    required this.date,
    required this.calorieConsumed,
    required this.calorieGoal,
    required this.proteinConsumed,
    required this.proteinGoal,
    required this.carbsConsumed,
    required this.carbsGoal,
    required this.fatConsumed,
    required this.fatGoal,
    required this.mealsSelected,
    required this.nutrientGaps,
    required this.suggestedFoods,
  });

  final DateTime date;

  final int calorieConsumed;
  final int calorieGoal;

  final double proteinConsumed;
  final double proteinGoal;

  final double carbsConsumed;
  final double carbsGoal;

  final double fatConsumed;
  final double fatGoal;

  final int mealsSelected;

  final List<NutrientGap> nutrientGaps;
  final List<SuggestedReportFood> suggestedFoods;

  // ---------------------------------------------------------------------------
  // Progress
  // ---------------------------------------------------------------------------

  double get calorieProgress =>
      _progress(calorieConsumed.toDouble(), calorieGoal.toDouble());

  double get proteinProgress =>
      _progress(proteinConsumed, proteinGoal);

  double get carbsProgress =>
      _progress(carbsConsumed, carbsGoal);

  double get fatProgress =>
      _progress(fatConsumed, fatGoal);

  // ---------------------------------------------------------------------------
  // Percentages
  // ---------------------------------------------------------------------------

  int get caloriePercentage =>
      (calorieProgress * 100).round();

  int get proteinPercentage =>
      (proteinProgress * 100).round();

  int get carbsPercentage =>
      (carbsProgress * 100).round();

  int get fatPercentage =>
      (fatProgress * 100).round();

  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  String get calorieText =>
      '$calorieConsumed / $calorieGoal kcal';

  String get proteinText =>
      '${proteinConsumed.round()}g / ${proteinGoal.round()}g';

  String get carbsText =>
      '${carbsConsumed.round()}g / ${carbsGoal.round()}g';

  String get fatText =>
      '${fatConsumed.round()}g / ${fatGoal.round()}g';

  String get dateLabel {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

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

    return '${weekdays[date.weekday - 1]}, '
        '${months[date.month - 1]} ${date.day}';
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  double get overallAdherence {
    return (
      calorieProgress +
      proteinProgress +
      carbsProgress +
      fatProgress
    ) / 4;
  }

  String get statusTitle {
    final adherence = overallAdherence;

    if (mealsSelected == 0) {
      return 'No meals recorded yet';
    }

    if (adherence >= 0.9) {
      return 'Excellent Progress! 🎉';
    }

    if (adherence >= 0.75) {
      return 'Good Progress!';
    }

    if (adherence >= 0.5) {
      return 'Keep Going!';
    }

    return 'Needs Attention';
  }

  String get statusMessage {
    if (mealsSelected == 0) {
      return 'Select your meals to start building today’s nutrition report.';
    }

    if (nutrientGaps.isEmpty) {
      return 'You are meeting your main calorie and macronutrient targets today.';
    }

    final biggestGap = nutrientGaps.reduce(
      (current, next) =>
          current.gapPercentage >= next.gapPercentage
              ? current
              : next,
    );

    return 'Your largest remaining nutrition gap is '
        '${biggestGap.name.toLowerCase()}. '
        'Continue following your meal plan to move closer to your daily target.';
  }

  static double _progress(
    double consumed,
    double goal,
  ) {
    if (goal <= 0) return 0;

    return (consumed / goal).clamp(0.0, 1.0);
  }
}