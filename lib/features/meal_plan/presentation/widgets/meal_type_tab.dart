import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

class MealTypeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const MealTypeTab({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.emerald500 : AppColors.gray100;
    final fg = selected ? AppColors.white : AppColors.gray900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

