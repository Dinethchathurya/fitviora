// import '../../domain/entities/food_component.dart';

// abstract class FoodComponentRepository {
//   Future<List<FoodComponent>> getAllComponents();
// }


import '../../domain/entities/food_component.dart';
import '../datasources/food_component_dataset.dart';
import '../models/food_component_model.dart';

class FoodComponentRepository {
  const FoodComponentRepository();

  Future<List<FoodComponent>> getAllFoodComponents() async {
    return FoodComponentDataset.foodComponents
        .map((json) => FoodComponentModel.fromJson(json))
        .toList();
  }
}