import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

class BmiTrendCard extends StatelessWidget {
  const BmiTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    const weekRows = [
      {'week': 'Week 1', 'bmi': 24.5, 'weight': 75.0, 'latest': false},
      {'week': 'Week 2', 'bmi': 24.2, 'weight': 74.0, 'latest': false},
      {'week': 'Week 3', 'bmi': 23.7, 'weight': 72.5, 'latest': false},
      {'week': 'Week 4', 'bmi': 23.2, 'weight': 71.0, 'latest': false},
      {'week': 'Week 5', 'bmi': 22.9, 'weight': 70.0, 'latest': true},
    ];


    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
          const SizedBox(height: 4),
          ...weekRows.map((e) {
            final week = e['week'] as String;
            final bmi = e['bmi'] as double;
            final weight = e['weight'] as double;
            final isLatest = e['latest'] as bool;


            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      week,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isLatest ? AppColors.emerald500 : AppColors.gray600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: _clamp01((bmi - 22.0) / (25.0 - 22.0)),
                          minHeight: 8,
                          backgroundColor: AppColors.gray200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isLatest ? AppColors.emerald500 : AppColors.gray500,
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
                                color: isLatest ? AppColors.emerald600 : AppColors.gray500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${weight.toStringAsFixed(weight.truncateToDouble() == weight ? 0 : 1)} kg',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.gray900,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  double _clamp01(double v) => v.clamp(0.0, 1.0);
}

