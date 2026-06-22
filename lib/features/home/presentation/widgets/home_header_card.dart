import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class HomeHeaderCard extends StatelessWidget {
  const HomeHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello, John! 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tuesday, May 26',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none_outlined,
                  size: 26, color: AppColors.gray900),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.red500,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

