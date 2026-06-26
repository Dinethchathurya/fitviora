import 'nutrition_info.dart';

class FoodVariant {
  const FoodVariant({
    required this.variantId,
    required this.variantName,
    required this.isDefaultVariant,
    required this.containsMaldiveFish,
    required this.preferenceTags,
    required this.healthFlags,
    required this.allergenTags,
    required this.diabetesFriendly,
    required this.hypertensionFriendly,
    required this.goalFitTargets,
    required this.servingLabel,
    required this.servingGrams,
    required this.nutrition,
    this.notes,
  });

  final String variantId;
  final String variantName;
  final bool isDefaultVariant;
  final bool containsMaldiveFish;

  final List<String> preferenceTags;
  final List<String> healthFlags;
  final List<String> allergenTags;

  final bool? diabetesFriendly;
  final bool? hypertensionFriendly;

  final List<String> goalFitTargets;

  final String servingLabel;
  final double servingGrams;

  final NutritionInfo nutrition;

  final String? notes;

  FoodVariant copyWith({
    String? variantId,
    String? variantName,
    bool? isDefaultVariant,
    bool? containsMaldiveFish,
    List<String>? preferenceTags,
    List<String>? healthFlags,
    List<String>? allergenTags,
    bool? diabetesFriendly,
    bool? hypertensionFriendly,
    List<String>? goalFitTargets,
    String? servingLabel,
    double? servingGrams,
    NutritionInfo? nutrition,
    String? notes,
  }) {
    return FoodVariant(
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      isDefaultVariant: isDefaultVariant ?? this.isDefaultVariant,
      containsMaldiveFish: containsMaldiveFish ?? this.containsMaldiveFish,
      preferenceTags: preferenceTags ?? this.preferenceTags,
      healthFlags: healthFlags ?? this.healthFlags,
      allergenTags: allergenTags ?? this.allergenTags,
      diabetesFriendly: diabetesFriendly ?? this.diabetesFriendly,
      hypertensionFriendly: hypertensionFriendly ?? this.hypertensionFriendly,
      goalFitTargets: goalFitTargets ?? this.goalFitTargets,
      servingLabel: servingLabel ?? this.servingLabel,
      servingGrams: servingGrams ?? this.servingGrams,
      nutrition: nutrition ?? this.nutrition,
      notes: notes ?? this.notes,
    );
  }
}