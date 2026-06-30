// import 'package:flutter/material.dart';

// import '../../../../core/constants/app_colors.dart';
// import '../widgets/meal_card.dart';
// import '../widgets/meal_type_tab.dart';
// import '../widgets/smart_portions_info_card.dart';
// import '../../data/repositories/food_component_repository.dart';
// import '../../domain/entities/food_component.dart';
// import '../viewmodels/meal_plan_view_model.dart';

// class MealPlanPage extends StatefulWidget {
//   const MealPlanPage({super.key});

//   @override
//   State<MealPlanPage> createState() => _MealPlanPageState();
// }

// class _MealPlanPageState extends State<MealPlanPage> {
//   String selectedMealType = 'Breakfast';

//   @override
//   void initState() {
//     super.initState();
//     _viewModel = MealPlanViewModel(
//       repository: FoodComponentRepository(),
//     );  

//     _viewModel.loadFoodDataset();

//   }


//   late final MealPlanViewModel _viewModel;
  

//   @override
//   Widget build(BuildContext context) {
//     final foods = _viewModel.availableFoods;
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.only(top: 8, bottom: 12),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Meal Recommendations',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: AppColors.gray900,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       'AI-powered suggestions based on your profile',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.gray600,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 14),

//               // Meal type tabs
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: MealTypeTab(
//                         label: 'Breakfast',
//                         icon: Icons.wb_sunny_outlined,
//                         selected: selectedMealType == 'Breakfast',
//                         onTap: () {
//                           setState(() {
//                             selectedMealType = 'Breakfast';
//                           });
//                           _loadMeals();
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Center(
//                       child: MealTypeTab(
//                         label: 'Lunch',
//                         icon: Icons.restaurant_outlined,
//                         selected: selectedMealType == 'Lunch',
//                         onTap: () {
//                           setState(() {
//                             selectedMealType = 'Lunch';
//                           });
//                           _loadMeals();
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Center(
//                       child: MealTypeTab(
//                         label: 'Dinner',
//                         icon: Icons.nightlight_round_outlined,
//                         selected: selectedMealType == 'Dinner',
//                         onTap: () {
//                           setState(() {
//                             selectedMealType = 'Dinner';
//                           });
//                           _loadMeals();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               ...mealCards,

//               const SizedBox(height: 8),

//               // Bottom info card
//               const SmartPortionsInfoCard(),

//               // Extra bottom padding to avoid overlap with MainShellPage bottom nav
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';

// import '../../../../core/constants/app_colors.dart';
// import '../../domain/entities/food_component.dart';
// import '../viewmodels/meal_plan_view_model.dart';
// import '../widgets/meal_type_tab.dart';
// import '../widgets/smart_portions_info_card.dart';
// import '../../data/repositories/food_component_repository.dart';
// import '../../data/repositories/user_meal_profile_repository.dart';

// class MealPlanPage extends StatefulWidget {
//   const MealPlanPage({super.key});

//   @override
//   State<MealPlanPage> createState() => _MealPlanPageState();
// }

// class _MealPlanPageState extends State<MealPlanPage> {
//   String selectedMealType = 'Breakfast';

//   late final MealPlanViewModel _viewModel;

//   @override
//   void initState() {
//     super.initState();

//     _viewModel = MealPlanViewModel(
//       repository: FoodComponentRepository(),
//       userProfileRepository: const UserMealProfileRepository(),
//     );

//     _viewModel.addListener(_onViewModelChanged);
//     _viewModel.loadFoodDataset(mealType: selectedMealType);
//   }

//   void _onViewModelChanged() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     _viewModel.removeListener(_onViewModelChanged);
//     super.dispose();
//   }

//   void _changeMealType(String mealType) {
//     setState(() {
//       selectedMealType = mealType;
//     });

//     _viewModel.filterByMealType(mealType);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredFoods = _viewModel.availableFoods;

//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(top: 8, bottom: 12),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
//                   ),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Meal Recommendations',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: AppColors.gray900,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       'AI-powered suggestions based on your profile',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.gray600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 14),

//               Row(
//                 children: [
//                   Expanded(
//                     child: MealTypeTab(
//                       label: 'Breakfast',
//                       icon: Icons.wb_sunny_outlined,
//                       selected: selectedMealType == 'Breakfast',
//                       onTap: () => _changeMealType('Breakfast'),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: MealTypeTab(
//                       label: 'Lunch',
//                       icon: Icons.restaurant_outlined,
//                       selected: selectedMealType == 'Lunch',
//                       onTap: () => _changeMealType('Lunch'),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: MealTypeTab(
//                       label: 'Dinner',
//                       icon: Icons.nightlight_round_outlined,
//                       selected: selectedMealType == 'Dinner',
//                       onTap: () => _changeMealType('Dinner'),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               if (_viewModel.loading)
//                 const Center(child: CircularProgressIndicator())
//               else if (filteredFoods.isEmpty)
//                 const Text('No suitable food components found.')
//               else
//                 ...filteredFoods.map(
//                   (food) => Text(food.name),
//                 ),

//               const SizedBox(height: 8),
//               const SmartPortionsInfoCard(),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/food_component_repository.dart';
import '../../data/repositories/user_meal_profile_repository.dart';
import '../../data/services/gemini_meal_service.dart';
import '../viewmodels/meal_plan_view_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_type_tab.dart';
import '../widgets/smart_portions_info_card.dart';
import '../../data/repositories/selected_meal_repository.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String selectedMealType = 'Breakfast';

  late final MealPlanViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MealPlanViewModel(
      repository: const FoodComponentRepository(),
      userProfileRepository: const UserMealProfileRepository(),
      selectedMealRepository: const SelectedMealRepository(),
      geminiMealService: GeminiMealService(
        apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      ),
    );

    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadMeals(mealType: selectedMealType);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _changeMealType(String mealType) {
    setState(() {
      selectedMealType = mealType;
    });

    _viewModel.changeMealType(mealType);
  }

  @override
  Widget build(BuildContext context) {
    final meals = _viewModel.meals;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Breakfast',
                        icon: Icons.wb_sunny_outlined,
                        selected: selectedMealType == 'Breakfast',
                        onTap: () => _changeMealType('Breakfast'),
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
                        onTap: () => _changeMealType('Lunch'),
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
                        onTap: () => _changeMealType('Dinner'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (_viewModel.loading)
                const Center(child: CircularProgressIndicator())
              else if (_viewModel.error != null)
                Text(_viewModel.error!)
              else if (meals.isEmpty)
                const Text('No suitable meals found.')
              else
                ...meals.map(
                  (meal) => MealCard(
                    title: meal.title,
                    categories: meal.tags,
                    calories: meal.totalCalories,
                    protein: '${meal.proteinG.round()}g',
                    carbs: '${meal.carbsG.round()}g',
                    fat: '${meal.fatG.round()}g',
                    portionSize: meal.portionSize,
                    onSelect: () async {
                      final success = await _viewModel.selectMeal(
                        meal: meal,
                        mealType: selectedMealType,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Meal saved successfully.'
                                : _viewModel.error ?? 'Failed to save meal.',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              const SmartPortionsInfoCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}