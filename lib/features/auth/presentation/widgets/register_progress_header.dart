import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RegisterProgressHeader extends StatelessWidget {
  final int step;
  final VoidCallback onBack;

  const RegisterProgressHeader({
    super.key,
    required this.step,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.person_outline,
      Icons.restaurant_menu_outlined,
      Icons.monitor_heart_outlined,
      Icons.gps_fixed,
      Icons.lock_outline,
    ];

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),
            ),
            const Text(
              'Back',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final bool isActive = index < step;
            return Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.emerald500
                        : AppColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icons[index],
                    size: 16,
                    color: isActive
                        ? AppColors.white
                        : AppColors.gray500,
                  ),
                ),
                if (index != 4)
                  Container(
                    width: 18,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index < step - 1
                          ? AppColors.emerald500
                          : AppColors.gray200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $step of 5',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
