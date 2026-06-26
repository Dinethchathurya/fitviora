import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_variant.dart';
import '../../domain/entities/nutrition_info.dart';
import '../../domain/repositories/food_repository.dart';

import '../datasources/food_dataset.dart';
import '../models/food_item_model.dart';
import '../models/food_variant_model.dart';
import '../models/nutrition_info_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  const FoodRepositoryImpl();

  @override
  Future<List<FoodItem>> getAllFoods() async {
    return FoodDataset.foods.map(_toEntity).toList();
  }

  FoodItem _toEntity(FoodItemModel model) {
    return FoodItem(
      id: model.id,
      name: model.name,
      localNames: model.localNames,
      description: model.description,
      category: model.category,
      mealTypes: model.mealTypes,
      variants: model.variants.map(_variantToEntity).toList(),
    );
  }

  FoodVariant _variantToEntity(FoodVariantModel model) {
    return FoodVariant(
      variantId: model.variantId,
      variantName: model.variantName,
      isDefaultVariant: model.isDefaultVariant,
      containsMaldiveFish: model.containsMaldiveFish,
      preferenceTags: model.preferenceTags,
      healthFlags: model.healthFlags,
      allergenTags: model.allergenTags,
      diabetesFriendly: model.diabetesFriendly,
      hypertensionFriendly: model.hypertensionFriendly,
      goalFitTargets: model.goalFitTargets,
      servingLabel: model.servingLabel,
      servingGrams: model.servingGrams,
      nutrition: NutritionInfo(
        caloriesKcal: model.nutrition.caloriesKcal,
        proteinG: model.nutrition.proteinG,
        carbsG: model.nutrition.carbsG,
        fatG: model.nutrition.fatG,
      ),
      notes: model.notes,
    );
  }
}