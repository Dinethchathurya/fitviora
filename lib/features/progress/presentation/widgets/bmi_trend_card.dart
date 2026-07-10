import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../viewmodels/progress_view_model.dart';

class BmiTrendCard extends StatelessWidget {
  const BmiTrendCard({
    super.key,
    required this.records,
    required this.heightCm,
  });

  final List<WeightRecord> records;
  final double heightCm;

  @override
  Widget build(BuildContext context) {
    final displayRecords = records.length <= 5
        ? records
        : records.sublist(records.length - 5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'BMI Trend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.gray900,
              ),
            ),
          ),

          if (displayRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No weight history available yet.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray600,
                ),
              ),
            )
          else
            ...List.generate(displayRecords.length, (index) {
              final record = displayRecords[index];

              final bmi = ProgressViewModel.calculateBmi(
                weightKg: record.weightKg,
                heightCm: heightCm,
              );

              final isLatest = index == displayRecords.length - 1;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 58,
                      child: Text(
                        'Record ${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isLatest
                              ? AppColors.emerald500
                              : AppColors.gray600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: _bmiProgress(bmi),
                            minHeight: 8,
                            backgroundColor: AppColors.gray200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isLatest
                                  ? AppColors.emerald500
                                  : AppColors.gray500,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                bmi.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isLatest
                                      ? AppColors.emerald600
                                      : AppColors.gray500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_formatWeight(record.weightKg)} kg',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.gray900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  double _bmiProgress(double bmi) {
    if (bmi <= 0) return 0;

    return (bmi / 40).clamp(0.0, 1.0);
  }

  String _formatWeight(double weight) {
    if (weight == weight.roundToDouble()) {
      return weight.toStringAsFixed(0);
    }

    return weight.toStringAsFixed(1);
  }
}