import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SeasonalTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const SeasonalTag({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.gray900.withOpacity(0.92),
        ),
      ),
    );
  }
}

