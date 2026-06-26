class NutritionInfoModel {
  const NutritionInfoModel({
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double caloriesKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  factory NutritionInfoModel.fromJson(Map<String, dynamic> json) {
    return NutritionInfoModel(
      caloriesKcal: (json['caloriesKcal'] as num).toDouble(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caloriesKcal': caloriesKcal,
      'proteinG': proteinG,
      'carbsG': carbsG,
      'fatG': fatG,
    };
  }

  NutritionInfoModel copyWith({
    double? caloriesKcal,
    double? proteinG,
    double? carbsG,
    double? fatG,
  }) {
    return NutritionInfoModel(
      caloriesKcal: caloriesKcal ?? this.caloriesKcal,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
    );
  }
}


