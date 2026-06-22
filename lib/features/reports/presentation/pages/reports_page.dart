import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/macro_breakdown_card.dart';
import '../widgets/nutrient_gap_card.dart';
import '../widgets/report_metric_card.dart';
import '../widgets/report_status_card.dart';
import '../widgets/suggested_foods_card.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // Header
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.gray200, width: 1),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Report',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tuesday, May 26',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Total Calories
              ReportMetricCard(
                label: 'Total Calories',
                value: '1856 / 2000 kcal',
                progress: 1856 / 2000,
              ),

              const SizedBox(height: 16),

              // Macronutrient Breakdown
              MacroBreakdownCard(
                proteinProgress: 125 / 150,
                carbsProgress: 198 / 225,
                fatsProgress: 52 / 67,
              ),

              const SizedBox(height: 16),

              // Nutrient Gap Analysis
              const NutrientGapCard(),

              const SizedBox(height: 16),

              // Suggested Foods
              const SuggestedFoodsCard(),

              const SizedBox(height: 16),

              // Daily Summary
              const DailySummaryCard(),

              const SizedBox(height: 16),

              // Final Status
              const ReportStatusCard(),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

