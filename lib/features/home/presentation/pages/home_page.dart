import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../main_shell/presentation/viewmodels/main_nav_view_model.dart';

import '../widgets/home_header_card.dart';
import '../widgets/premium_gradient_card.dart';
import '../widgets/section_card.dart';
import '../widgets/section_title.dart';
import '../widgets/nutrient_row.dart';

import '../widgets/quick_action_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const HomeHeaderCard(),
              const SizedBox(height: 16),

              // Daily Calorie Target
              PremiumGradientCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_fire_department,
                                size: 18, color: AppColors.white),
                            SizedBox(width: 10),
                            Text(
                              'Daily Calorie Target',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        // spacer
                        const SizedBox(width: 1),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '544',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'kcal left',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: 0.728,
                        minHeight: 12,
                        backgroundColor: Colors.white.withOpacity(0.18),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Consumed: 1456 kcal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Goal: 2000 kcal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Meal Distribution
              SectionCard(
                color: AppColors.white,
                padding: const EdgeInsets.all(18),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle(
                      title: 'Meal Distribution',
                      icon: Icons.restaurant_menu,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const _MealDistributionRow(
                      label: 'Breakfast',
                      percentage: '30%',
                      valueKcal: '600 kcal',
                      progressColor: AppColors.orange500,
                      progress: 0.3,
                    ),
                    const SizedBox(height: 16),
                    const _MealDistributionRow(
                      label: 'Lunch',
                      percentage: '40%',
                      valueKcal: '800 kcal',
                      progressColor: AppColors.emerald500,
                      progress: 0.4,
                    ),
                    const SizedBox(height: 16),
                    const _MealDistributionRow(
                      label: 'Dinner',
                      percentage: '30%',
                      valueKcal: '600 kcal',
                      progressColor: AppColors.blue500,
                      progress: 0.3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Nutrient Progress
              SectionCard(
                color: AppColors.white,
                padding: const EdgeInsets.all(18),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle(
                      title: 'Nutrient Progress',
                      icon: Icons.science_outlined,
                    ),
                    const SizedBox(height: 14),
                    const NutrientRow(
                      label: 'Protein',
                      value: '98g / 150g',
                      progress: 0.653,
                      progressColor: AppColors.blue500,
                    ),
                    const SizedBox(height: 16),
                    const NutrientRow(
                      label: 'Carbs',
                      value: '120g / 200g',
                      progress: 0.6,
                      progressColor: AppColors.orange500,
                    ),
                    const SizedBox(height: 16),
                    const NutrientRow(
                      label: 'Fats',
                      value: '55g / 90g',
                      progress: 0.611,
                      progressColor: AppColors.pink500,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Seasonal Foods
              Container(
                decoration: BoxDecoration(
                  color: AppColors.emerald100.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald600.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seasonal Foods - February',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.gray900,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Fresh and nutritious foods available this month in Sri Lanka',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _SeasonalCategory(
                      titleEmoji: 'FRUITS 🍎',
                      pillBackground: const Color(0xFFFFE0CC),
                      pillBorder: const Color(0xFFFFC7A3),
                      pills: const [
                        'Mango (Amba)',
                        'Papaya (Papol)',
                        'Pineapple (Annasi)',
                        'Banana (Kesel)',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SeasonalCategory(
                      titleEmoji: 'VEGETABLES 🥬',
                      pillBackground: const Color(0xFFD9FAD9),
                      pillBorder: const Color(0xFFB8F5B8),
                      pills: const [
                        'Pumpkin (Wattakka)',
                        'Snake Gourd (Pathola)',
                        'Bitter Gourd (Karawila)',
                        'Okra (Bandakka)',
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SeasonalCategory(
                      titleEmoji: 'FISH & PROTEIN 🐟',
                      pillBackground: const Color(0xFFDCEBFF),
                      pillBorder: const Color(0xFFBFD7FF),
                      pills: const [
                        'Tuna (Kelawalla)',
                        'Mackerel (Kumbalawa)',
                        'Prawns (Isso)',
                      ],
                    ),

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6D6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFFE3A3)),
                      ),
                      child: const Text(
                        '💡 Tip:\nSeasonal foods are fresher, more affordable, and packed with nutrients!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gray900,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Health Status
              SectionCard(
                color: AppColors.emerald50,
                padding: const EdgeInsets.all(18),
                borderRadius: 24,
                shadowColor: Colors.black.withOpacity(0.03),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.emerald100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: const Icon(Icons.health_and_safety,
                          color: AppColors.emerald600, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Health Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gray900,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Your health progress is improving. Keep following your plan and you'll reach your goals! 💪",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray600,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.edit_note_outlined,
                      title: 'Log Meal',
                      subtitle: 'Track your food',
                      onTap: () {
                        // MainShellPage uses MainNavViewModel + IndexedStack.
                        // Switching tabs is done by updating vm.currentIndex.
                        context.read<MainNavViewModel>().changeIndex(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.trending_up_outlined,
                      title: 'View Progress',
                      subtitle: 'Check your stats',
                      onTap: () {
                        context.read<MainNavViewModel>().changeIndex(2);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealDistributionRow extends StatelessWidget {
  final String label;
  final String percentage;
  final String valueKcal;
  final double progress;
  final Color progressColor;

  const _MealDistributionRow({
    required this.label,
    required this.percentage,
    required this.valueKcal,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          valueKcal,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }
}

class _SeasonalCategory extends StatelessWidget {
  final String titleEmoji;
  final Color pillBackground;
  final Color pillBorder;
  final List<String> pills;

  const _SeasonalCategory({
    required this.titleEmoji,
    required this.pillBackground,
    required this.pillBorder,
    required this.pills,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleEmoji,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: pills
              .map(
                (p) => Container(
                  decoration: BoxDecoration(
                    color: pillBackground,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: pillBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gray900.withOpacity(0.92),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

