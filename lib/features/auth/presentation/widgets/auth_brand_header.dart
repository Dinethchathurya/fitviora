import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/fitviora_logo.dart';

class AuthBrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showHeart;

  const AuthBrandHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showHeart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FitVioraLogo(
          size: 48,
          showHeart: showHeart,
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }
}
