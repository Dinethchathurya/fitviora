import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_type_tab.dart';

import '../widgets/smart_portions_info_card.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String selectedMealType = 'Breakfast';

  final Map<String, List<MealCard>> mealSuggestions = {
    'Breakfast': [
      MealCard(
        title: 'Kiribath with Lunu Miris',
        categories: const ['Traditional', 'Vegetarian'],
        calories: 320,
        protein: '8g',
        carbs: '55g',
        fat: '7g',
        portionSize: '1 plate',
        onSelect: () {},
      ),
      MealCard(
        title: 'String Hoppers with Dhal Curry',
        categories: const ['Vegetarian', 'High Protein'],
        calories: 280,
        protein: '12g',
        carbs: '48g',
        fat: '5g',
        portionSize: '4 hoppers',
        onSelect: () {},
      ),
      MealCard(
        title: 'Coconut Roti with Seeni Sambol',
        categories: const ['Traditional'],
        calories: 350,
        protein: '7g',
        carbs: '42g',
        fat: '16g',
        portionSize: '2 rotis',
        onSelect: () {},
      ),
    ],
    'Lunch': [
      MealCard(
        title: 'Rice and Chicken Curry',
        categories: const ['High Protein', 'Balanced'],
        calories: 620,
        protein: '38g',
        carbs: '65g',
        fat: '22g',
        portionSize: '1 bowl',
        onSelect: () {},
      ),
      MealCard(
        title: 'Rice with Dhal and Mallung',
        categories: const ['Balanced', 'Vegetarian'],
        calories: 520,
        protein: '22g',
        carbs: '78g',
        fat: '10g',
        portionSize: '1 bowl',
        onSelect: () {},
      ),
      MealCard(
        title: 'Fish Curry with Red Rice',
        categories: const ['High Protein', 'Balanced'],
        calories: 590,
        protein: '30g',
        carbs: '62g',
        fat: '20g',
        portionSize: '1 plate',
        onSelect: () {},
      ),
    ],
    'Dinner': [
      MealCard(
        title: 'Vegetable Soup with Toast',
        categories: const ['Vegetarian', 'Balanced'],
        calories: 390,
        protein: '16g',
        carbs: '50g',
        fat: '12g',
        portionSize: '1 bowl',
        onSelect: () {},
      ),
      MealCard(
        title: 'Egg Hoppers',
        categories: const ['High Protein', 'Traditional'],
        calories: 460,
        protein: '24g',
        carbs: '55g',
        fat: '18g',
        portionSize: '2 hoppers',
        onSelect: () {},
      ),
      MealCard(
        title: 'Grilled Fish with Salad',
        categories: const ['High Protein', 'Balanced'],
        calories: 540,
        protein: '35g',
        carbs: '30g',
        fat: '26g',
        portionSize: '1 plate',
        onSelect: () {},
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final mealCards = mealSuggestions[selectedMealType] ?? const [];

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


