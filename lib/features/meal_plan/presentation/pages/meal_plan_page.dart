
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import '../../../../core/constants/app_colors.dart';
// import '../../data/repositories/food_component_repository.dart';
// import '../../data/repositories/user_meal_profile_repository.dart';
// import '../../data/services/gemini_meal_service.dart';
// import '../viewmodels/meal_plan_view_model.dart';
// import '../widgets/meal_card.dart';
// import '../widgets/meal_type_tab.dart';
// import '../widgets/smart_portions_info_card.dart';
// import '../../data/repositories/selected_meal_repository.dart';
// import 'cooking_guide_page.dart';


// import 'package:provider/provider.dart';

// import '../../../home/presentation/viewmodels/home_page_view_model.dart';
// import '../viewmodels/meal_plan_view_model.dart';


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
//       repository: const FoodComponentRepository(),
//       userProfileRepository: const UserMealProfileRepository(),
//       selectedMealRepository: const SelectedMealRepository(),
//       geminiMealService: GeminiMealService(
//         apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
//       ),
//     );

//     _viewModel.addListener(_onViewModelChanged);
//     _viewModel.loadMeals(mealType: selectedMealType);
//   }

//   void _onViewModelChanged() {
//     if (mounted) setState(() {});
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

//     _viewModel.changeMealType(mealType);
//   }



//   int _getTargetCalories(
//   HomePageViewModel homeViewModel,
//   String mealType,
// ) {
//   switch (mealType.toLowerCase()) {
//     case 'breakfast':
//       return homeViewModel.breakfastTargetCalories;

//     case 'lunch':
//       return homeViewModel.lunchTargetCalories;

//     case 'dinner':
//       return homeViewModel.dinnerTargetCalories;

//     default:
//       return homeViewModel.dailyCalorieGoal;
//   }
// }




//   @override
//   Widget build(BuildContext context) {

// final homeViewModel = context.read<HomePageViewModel>();
// final mealPlanViewModel = context.read<MealPlanViewModel>();

// final targetCalories = _getTargetCalories(
//   homeViewModel,
//   mealType,
// );

// await mealPlanViewModel.loadMeals(
//   mealType: mealType,
//   targetCalories: targetCalories,
// );



//     final meals = _viewModel.meals;
//     final isSelectedMeal = _viewModel.selectedMeal != null;

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

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: MealTypeTab(
//                         label: 'Breakfast',
//                         icon: Icons.wb_sunny_outlined,
//                         selected: selectedMealType == 'Breakfast',
//                         onTap: () => _changeMealType('Breakfast'),
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
//                         onTap: () => _changeMealType('Lunch'),
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
//                         onTap: () => _changeMealType('Dinner'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               if (_viewModel.loading)
//                 const Center(child: CircularProgressIndicator())
//               else if (_viewModel.error != null)
//                 Text(_viewModel.error!)
//               else if (meals.isEmpty)
//                 const Text('No suitable meals found.')
//               else
//                 ...meals.map(
//                   (meal) => MealCard(
//                     title: meal.title,
//                     categories: meal.tags,
//                     calories: meal.totalCalories,
//                     protein: '${meal.proteinG.round()}g',
//                     carbs: '${meal.carbsG.round()}g',
//                     fat: '${meal.fatG.round()}g',
//                     portionSize: meal.portionSize,
//                     buttonText: _viewModel.selectedMeal != null
//                         ? 'Make This Meal'
//                         : 'Select This Meal',
//                     onSelect: () async {
//                       if (isSelectedMeal) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => CookingGuidePage(
//                                 meal: meal,
//                                 mealType: selectedMealType,
//                               ),
//                             ),
//                           );
//                           return;
//                         }
//                       final success = await _viewModel.selectMeal(
//                         meal: meal,
//                         mealType: selectedMealType,
//                       );

//                       if (!context.mounted) return;

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             success
//                                 ? 'Meal saved successfully.'
//                                 : _viewModel.error ?? 'Failed to save meal.',
//                           ),
//                         ),
//                       );
//                     },
//                   ),
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








// -----------------------------------------------





// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';

// import '../../../../core/constants/app_colors.dart';
// import '../../../home/presentation/viewmodels/home_page_view_model.dart';
// import '../../data/repositories/food_component_repository.dart';
// import '../../data/repositories/selected_meal_repository.dart';
// import '../../data/repositories/user_meal_profile_repository.dart';
// import '../../data/services/gemini_meal_service.dart';
// import '../viewmodels/meal_plan_view_model.dart';
// import '../widgets/meal_card.dart';
// import '../widgets/meal_type_tab.dart';
// import '../widgets/smart_portions_info_card.dart';
// import 'cooking_guide_page.dart';

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
//       repository: const FoodComponentRepository(),
//       userProfileRepository: const UserMealProfileRepository(),
//       selectedMealRepository: const SelectedMealRepository(),
//       geminiMealService: GeminiMealService(
//         apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
//       ),
//     );

//     _viewModel.addListener(_onViewModelChanged);

//     // Provider cannot safely be read directly during initState.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       _loadSelectedMealType();
//     });
//   }

//   void _onViewModelChanged() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _loadSelectedMealType() async {
//     final homeViewModel = context.read<HomePageViewModel>();

//     /*
//      * Ensure the calorie values have been calculated.
//      * This is useful when the user opens Meal Plan before opening Home.
//      */
//     if (homeViewModel.dailyCalorieGoal <= 0 ||
//         homeViewModel.isLoading) {
//       await homeViewModel.loadHomeData();
//     }

//     if (!mounted) return;

//     final targetCalories = _getTargetCalories(
//       homeViewModel,
//       selectedMealType,
//     );

//     await _viewModel.loadMeals(
//       mealType: selectedMealType,
//     );
//   }

//   Future<void> _changeMealType(String mealType) async {
//     if (mealType == selectedMealType) return;

//     setState(() {
//       selectedMealType = mealType;
//     });

//     final homeViewModel = context.read<HomePageViewModel>();

//     final targetCalories = _getTargetCalories(
//       homeViewModel,
//       mealType,
//     );

//     await _viewModel.changeMealType(
//       mealType: mealType,
//       targetCalories: targetCalories,
//     );
//   }

//   int _getTargetCalories(
//     HomePageViewModel homeViewModel,
//     String mealType,
//   ) {
//     switch (mealType.trim().toLowerCase()) {
//       case 'breakfast':
//         return homeViewModel.breakfastTargetCalories;

//       case 'lunch':
//         return homeViewModel.lunchTargetCalories;

//       case 'dinner':
//         return homeViewModel.dinnerTargetCalories;

//       default:
//         return homeViewModel.dailyCalorieGoal;
//     }
//   }

//   @override
//   void dispose() {
//     _viewModel.removeListener(_onViewModelChanged);
//     _viewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final meals = _viewModel.meals;
//     final hasSelectedMeal = _viewModel.selectedMeal != null;

//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 8,
//                   bottom: 12,
//                 ),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Color(0xFFE5E7EB),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Meal Recommendations',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: AppColors.gray900,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       'AI-powered suggestions based on your profile',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
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
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 40),
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               else if (_viewModel.error != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Text(
//                     _viewModel.error!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: AppColors.destructive,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 )
//               else if (meals.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: Text(
//                     'No suitable meals found.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.gray600,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 )
//               else
//                 ...meals.map(
//                   (meal) {
//                     return MealCard(
//                       title: meal.title,
//                       categories: meal.tags,
//                       calories: meal.totalCalories,
//                       protein: '${meal.proteinG.round()}g',
//                       carbs: '${meal.carbsG.round()}g',
//                       fat: '${meal.fatG.round()}g',
//                       portionSize: meal.portionSize,
//                       buttonText: hasSelectedMeal
//                           ? 'Make This Meal'
//                           : 'Select This Meal',
//                       onSelect: () async {
//                         if (hasSelectedMeal) {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute<void>(
//                               builder: (_) => CookingGuidePage(
//                                 meal: meal,
//                                 mealType: selectedMealType,
//                               ),
//                             ),
//                           );

//                           return;
//                         }

//                         final success = await _viewModel.selectMeal(
//                           meal: meal,
//                           mealType: selectedMealType,
//                         );

//                         if (!mounted) return;

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               success
//                                   ? 'Meal saved successfully.'
//                                   : _viewModel.error ??
//                                       'Failed to save meal.',
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
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
import '../../data/repositories/selected_meal_repository.dart';
import '../../data/repositories/user_meal_profile_repository.dart';
import '../../data/services/gemini_meal_service.dart';
import '../viewmodels/meal_plan_view_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_type_tab.dart';
import '../widgets/smart_portions_info_card.dart';
import 'cooking_guide_page.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() =>
      _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String selectedMealType = 'Breakfast';

  late final MealPlanViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MealPlanViewModel(
      repository: const FoodComponentRepository(),
      userProfileRepository:
          const UserMealProfileRepository(),
      selectedMealRepository:
          const SelectedMealRepository(),
      geminiMealService: GeminiMealService(
        apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      ),
    );

    _viewModel.addListener(_onViewModelChanged);

    _viewModel.loadMeals(
      mealType: selectedMealType,
    );
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _changeMealType(
    String mealType,
  ) async {
    if (mealType == selectedMealType) {
      return;
    }

    setState(() {
      selectedMealType = mealType;
    });

    await _viewModel.changeMealType(
      mealType:mealType,
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(
      _onViewModelChanged,
    );

    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = _viewModel.meals;

    final hasSelectedMeal =
        _viewModel.selectedMeal != null;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Recommendations',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w900,
                        color: AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'AI-powered suggestions based on your profile',
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: MealTypeTab(
                      label: 'Breakfast',
                      icon:
                          Icons.wb_sunny_outlined,
                      selected:
                          selectedMealType ==
                              'Breakfast',
                      onTap: () =>
                          _changeMealType(
                        'Breakfast',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MealTypeTab(
                      label: 'Lunch',
                      icon:
                          Icons.restaurant_outlined,
                      selected:
                          selectedMealType ==
                              'Lunch',
                      onTap: () =>
                          _changeMealType(
                        'Lunch',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MealTypeTab(
                      label: 'Dinner',
                      icon: Icons
                          .nightlight_round_outlined,
                      selected:
                          selectedMealType ==
                              'Dinner',
                      onTap: () =>
                          _changeMealType(
                        'Dinner',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (_viewModel.loading)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                )
              else if (_viewModel.error != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Text(
                    _viewModel.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color:
                          AppColors.destructive,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                )
              else if (meals.isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Text(
                    'No suitable meals found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.gray600,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                )
              else
                ...meals.map(
                  (meal) {
                    return MealCard(
                      title: meal.title,
                      categories: meal.tags,
                      calories:
                          meal.totalCalories,
                      protein:
                          '${meal.proteinG.round()}g',
                      carbs:
                          '${meal.carbsG.round()}g',
                      fat:
                          '${meal.fatG.round()}g',
                      portionSize:
                          meal.portionSize,
                      baseFoodId: meal.baseFoodId,

                      buttonText:
                          hasSelectedMeal
                              ? 'Make This Meal'
                              : 'Select This Meal',
                      onSelect: () async {
                        if (hasSelectedMeal) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  CookingGuidePage(
                                meal: meal,
                                mealType:
                                    selectedMealType,
                              ),
                            ),
                          );

                          return;
                        }

                        final success =
                            await _viewModel
                                .selectMeal(
                          meal: meal,
                          mealType:
                              selectedMealType,
                        );

                        if (!mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Meal saved successfully.'
                                  : _viewModel
                                          .error ??
                                      'Failed to save meal.',
                            ),
                          ),
                        );
                      },
                    );
                  },
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
