import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/food_variant.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_type_tab.dart';
import '../widgets/smart_portions_info_card.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/services/meal_suggestion_service.dart';
import '../viewmodels/meal_plan_view_model.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String selectedMealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _viewModel = MealPlanViewModel(
      repository: const FoodRepositoryImpl(),
      suggestionService: const MealSuggestionService(),
    );  

    _loadMeals();

  }


  late final MealPlanViewModel _viewModel;
  
  Future<void> _loadMeals() async {
  await _viewModel.loadMeals(
    mealType: selectedMealType,
    dietaryPreference: "Any",
    goal: "Maintenance",
    allergies: [],
  );

  setState(() {});
}




  FoodVariant? _getDefaultVariant(FoodItem food) {
    if (food.variants.isEmpty) return null;
    return food.variants.firstWhere(
      (variant) => variant.isDefaultVariant,
      orElse: () => food.variants.first,
    );
  }

  List<MealCard> _buildMealCards(List<FoodItem> suggestions) {
    if (suggestions.isEmpty) {
      return [
        MealCard(
          title: 'No suitable meals found.',
          categories: const [],
          calories: 0,
          protein: '0g',
          carbs: '0g',
          fat: '0g',
          portionSize: '',
          onSelect: () {},
        ),
      ];
    }

    return suggestions.map((food) {
      final variant = _getDefaultVariant(food);
      if (variant == null) {
        return MealCard(
          title: food.name,
          categories: const [],
          calories: 0,
          protein: '0g',
          carbs: '0g',
          fat: '0g',
          portionSize: '',
          onSelect: () {},
        );
      }

      return MealCard(
        title: food.name,
        categories: variant.healthFlags,
        calories: variant.nutrition.caloriesKcal.round(),
        protein: '${variant.nutrition.proteinG.round()}g',
        carbs: '${variant.nutrition.carbsG.round()}g',
        fat: '${variant.nutrition.fatG.round()}g',
        portionSize: variant.servingLabel,
        onSelect: () {},
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mealCards = _buildMealCards(_viewModel.meals);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Meal Recommendations',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'AI-powered suggestions based on your profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Meal type tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Breakfast',
                        icon: Icons.wb_sunny_outlined,
                        selected: selectedMealType == 'Breakfast',
                        onTap: () {
                          setState(() {
                            selectedMealType = 'Breakfast';
                          });
                          _loadMeals();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Lunch',
                        icon: Icons.restaurant_outlined,
                        selected: selectedMealType == 'Lunch',
                        onTap: () {
                          setState(() {
                            selectedMealType = 'Lunch';
                          });
                          _loadMeals();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Dinner',
                        icon: Icons.nightlight_round_outlined,
                        selected: selectedMealType == 'Dinner',
                        onTap: () {
                          setState(() {
                            selectedMealType = 'Dinner';
                          });
                          _loadMeals();
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ...mealCards,

              const SizedBox(height: 8),

              // Bottom info card
              const SmartPortionsInfoCard(),

              // Extra bottom padding to avoid overlap with MainShellPage bottom nav
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
