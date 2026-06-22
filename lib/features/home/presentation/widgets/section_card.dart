import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color? shadowColor;
  final double borderRadius;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = AppColors.white,
    this.shadowColor,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? Colors.black.withOpacity(0.06)),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

