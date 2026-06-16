import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ReportMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const ReportMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.emerald500,
            AppColors.teal600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald600.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: safeProgress,
                minHeight: 12,
                backgroundColor: Colors.white.withOpacity(0.18),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

