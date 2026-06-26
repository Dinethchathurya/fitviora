import 'nutrition_info_model.dart';

class FoodVariantModel {
  const FoodVariantModel({
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

  final NutritionInfoModel nutrition;

  final String? notes;

  factory FoodVariantModel.fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>;

    return FoodVariantModel(
      variantId: json['variantId'] as String,
      variantName: json['variantName'] as String,
      isDefaultVariant: json['isDefaultVariant'] as bool,
      containsMaldiveFish: json['containsMaldiveFish'] as bool,
      preferenceTags: (json['preferenceTags'] as List<dynamic>).cast<String>(),
      healthFlags: (json['healthFlags'] as List<dynamic>).cast<String>(),
      allergenTags: (json['allergenTags'] as List<dynamic>).cast<String>(),
      diabetesFriendly: json['diabetesFriendly'] as bool?,
      hypertensionFriendly: json['hypertensionFriendly'] as bool?,
      goalFitTargets: (json['goalFitTargets'] as List<dynamic>).cast<String>(),
      servingLabel: json['servingLabel'] as String,
      servingGrams: (json['servingGrams'] as num).toDouble(),       nutrition: NutritionInfoModel.fromJson(nutrition),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'variantName': variantName,
      'isDefaultVariant': isDefaultVariant,
      'containsMaldiveFish': containsMaldiveFish,
      'preferenceTags': preferenceTags,
      'healthFlags': healthFlags,
      'allergenTags': allergenTags,
      'diabetesFriendly': diabetesFriendly,
      'hypertensionFriendly': hypertensionFriendly,
      'goalFitTargets': goalFitTargets,
      'servingLabel': servingLabel,
      'servingGrams': servingGrams,
      'nutrition': nutrition.toJson(),
      'notes': notes,
    };
  }

  FoodVariantModel copyWith({
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
    NutritionInfoModel? nutrition,
    String? notes,
  }) {
    return FoodVariantModel(
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

