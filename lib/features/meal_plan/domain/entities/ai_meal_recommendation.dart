class AiMealRecommendation {
  const AiMealRecommendation({
    required this.title,
    required this.description,
    required this.tags,
    required this.portionSize,
    required this.totalCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.componentIds,
  });

  final String title;
  final String description;
  final List<String> tags;
  final String portionSize;
  final int totalCalories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<String> componentIds;

  factory AiMealRecommendation.fromJson(Map<String, dynamic> json) {
    return AiMealRecommendation(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      tags: _stringList(json['tags']),
      portionSize: json['portionSize']?.toString() ?? '',
      totalCalories: _toDouble(json['totalCalories']).round(),
      proteinG: _toDouble(json['proteinG']),
      carbsG: _toDouble(json['carbsG']),
      fatG: _toDouble(json['fatG']),
      componentIds: _stringList(json['componentIds']),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}