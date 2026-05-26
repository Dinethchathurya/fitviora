import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_type_tab.dart';

import '../widgets/smart_portions_info_card.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Static UI only (no real tab/meal selection logic).
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

              // Meal type tabs (static styling)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Breakfast',
                        icon: Icons.wb_sunny_outlined,
                        selected: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Lunch',
                        icon: Icons.restaurant_outlined,
                        selected: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Center(
                      child: MealTypeTab(
                        label: 'Dinner',
                        icon: Icons.nightlight_round_outlined,
                        selected: false,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Meal cards
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

