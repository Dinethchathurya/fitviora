enum SeasonalFoodCategory {
  fruit,
  vegetable,
  fish,
  protein,
  other,
}

class SeasonalFood {
  const SeasonalFood({
    required this.id,
    required this.name,
    required this.displayName,
    required this.category,
    required this.availableMonths,
    this.localName,
    this.emoji = '🍽️',
    this.imagePath,
    this.description = '',
    this.isPeakSeason = false,
    this.isStartingSeason = false,
    this.nutritionTags = const [],
    this.healthBenefits = const [],
  });

  /// Stable internal identifier.
  ///
  /// Example:
  /// mango, wood_apple, ceylon_olive
  final String id;

  /// Normalized English name.
  ///
  /// Example:
  /// Mango
  final String name;

  /// Name shown in the UI.
  ///
  /// This may contain an alternative or local name.
  ///
  /// Example:
  /// Veralu (Ceylon Olive)
  final String displayName;

  /// Fruit, vegetable, fish, protein, or another category.
  final SeasonalFoodCategory category;

  /// Month numbers in which this food is available.
  ///
  /// January = 1
  /// February = 2
  /// December = 12
  final List<int> availableMonths;

  /// Sinhala or commonly used Sri Lankan name.
  ///
  /// Example:
  /// Veralu, Divul, Kos
  final String? localName;

  /// Emoji used when an image is unavailable.
  final String emoji;

  /// Optional asset image path.
  ///
  /// Example:
  /// assets/images/seasonal_foods/mango.png
  final String? imagePath;

  /// Short description of the food.
  final String description;

  /// Indicates that the food is in its main or peak season.
  final bool isPeakSeason;

  /// Indicates that the season is beginning during this month.
  final bool isStartingSeason;

  /// General nutrition-related tags.
  ///
  /// Example:
  /// Vitamin C, High Fiber, Antioxidants
  final List<String> nutritionTags;

  /// General health benefits.
  final List<String> healthBenefits;

  bool isAvailableInMonth(int month) {
    return availableMonths.contains(month);
  }

  String get categoryName {
    switch (category) {
      case SeasonalFoodCategory.fruit:
        return 'Fruit';
      case SeasonalFoodCategory.vegetable:
        return 'Vegetable';
      case SeasonalFoodCategory.fish:
        return 'Fish';
      case SeasonalFoodCategory.protein:
        return 'Protein';
      case SeasonalFoodCategory.other:
        return 'Other';
    }
  }

  SeasonalFood copyWith({
    String? id,
    String? name,
    String? displayName,
    SeasonalFoodCategory? category,
    List<int>? availableMonths,
    String? localName,
    String? emoji,
    String? imagePath,
    String? description,
    bool? isPeakSeason,
    bool? isStartingSeason,
    List<String>? nutritionTags,
    List<String>? healthBenefits,
  }) {
    return SeasonalFood(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      category: category ?? this.category,
      availableMonths: availableMonths ?? this.availableMonths,
      localName: localName ?? this.localName,
      emoji: emoji ?? this.emoji,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isPeakSeason: isPeakSeason ?? this.isPeakSeason,
      isStartingSeason: isStartingSeason ?? this.isStartingSeason,
      nutritionTags: nutritionTags ?? this.nutritionTags,
      healthBenefits: healthBenefits ?? this.healthBenefits,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SeasonalFood &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SeasonalFood('
        'id: $id, '
        'name: $name, '
        'category: $categoryName, '
        'availableMonths: $availableMonths'
        ')';
  }
}