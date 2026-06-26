import 'food_variant.dart';

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.localNames,
    this.description,
    required this.category,
    required this.mealTypes,
    required this.variants,
  });

  final String id;
  final String name;
  final List<String> localNames;
  final String? description;
  final String category;
  final List<String> mealTypes;
  final List<FoodVariant> variants;
}