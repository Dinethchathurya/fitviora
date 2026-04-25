import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/onboarding_view_model.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: 'Fit',
                            style: TextStyle(
                              color: AppColors.gray900,
                            ),
                          ),
                          TextSpan(
                            text: 'Viora',
                            style: TextStyle(
                              color: AppColors.emerald600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => vm.skip(context),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: vm.controller,
                    onPageChanged: vm.onPageChanged,
                    children: const [
                      _OnboardingItem(
                        iconData: Icons.eco_outlined,
                        iconGradient: [
                          AppColors.emerald500,
                          AppColors.teal600,
                        ],
                        title: 'Personalized Meal\nPlanning',
                        subtitle:
                            'AI-powered meal recommendations based\non your health and food preferences.',
                      ),
                      _OnboardingItem(
                        iconData: Icons.calendar_month_outlined,
                        iconGradient: [
                          AppColors.orange500,
                          Color(0xFFFF6B00),
                        ],
                        title: 'Eat Seasonal, Stay\nHealthy',
                        subtitle:
                            'We recommend locally available Sri Lankan\nseasonal foods automatically.',
                      ),
                      _OnboardingItem(
                        iconData: Icons.trending_up,
                        iconGradient: [
                          AppColors.blue500,
                          Color(0xFF4F46E5),
                        ],
                        title: 'Track Your Health\nJourney',
                        subtitle:
                            'Monitor BMI, calories, and nutrient\nprogress weekly.',
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      width: vm.currentIndex == index ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: vm.currentIndex == index
                            ? AppColors.emerald500
                            : AppColors.gray200,
                        borderRadius:
                            BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppPrimaryButton(
                  label:
                      vm.isLast ? 'Get Started' : 'Next',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onPressed: () => vm.next(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final IconData iconData;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;

  const _OnboardingItem({
    required this.iconData,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: iconGradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                iconData,
                size: 42,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 34),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
