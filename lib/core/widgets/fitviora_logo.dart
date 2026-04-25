import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FitVioraLogo extends StatelessWidget {
  final double size;
  final bool showHeart;

  const FitVioraLogo({
    super.key,
    this.size = 96,
    this.showHeart = true,
  });

  @override
  Widget build(BuildContext context) {
    final double heartSize = size * 0.34;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.emerald500,
                AppColors.teal600,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.eco_outlined,
            size: size * 0.44,
            color: AppColors.white,
          ),
        ),
        if (showHeart)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: heartSize,
              height: heartSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.red400,
                    AppColors.pink500,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                size: heartSize * 0.52,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}
