import '../../domain/entities/seasonal_food.dart';
import '../datasources/seasonal_food_dataset.dart';

class SeasonalFoodRepository {
  const SeasonalFoodRepository();

  List<SeasonalFood> getAllFoods() {
    return List<SeasonalFood>.unmodifiable(
      SeasonalFoodDataset.foods,
    );
  }

  List<SeasonalFood> getFoodsForMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(
        month,
        'month',
        'Month must be between 1 and 12.',
      );
    }

    return SeasonalFoodDataset.foods
        .where((food) => food.isAvailableInMonth(month))
        .toList(growable: false);
  }

  List<SeasonalFood> getFoodsByCategory({
    required int month,
    required SeasonalFoodCategory category,
  }) {
    return getFoodsForMonth(month)
        .where((food) => food.category == category)
        .toList(growable: false);
  }

  SeasonalFood? getFoodById(String id) {
    final normalizedId = id.trim().toLowerCase();

    for (final food in SeasonalFoodDataset.foods) {
      if (food.id.toLowerCase() == normalizedId) {
        return food;
      }
    }

    return null;
  }

  List<SeasonalFood> searchFoods(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return getAllFoods();
    }

    return SeasonalFoodDataset.foods.where((food) {
      return food.name.toLowerCase().contains(normalizedQuery) ||
          food.displayName.toLowerCase().contains(normalizedQuery) ||
          (food.localName?.toLowerCase().contains(normalizedQuery) ?? false);
    }).toList(growable: false);
  }
}