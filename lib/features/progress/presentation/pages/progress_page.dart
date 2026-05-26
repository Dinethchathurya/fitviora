import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/bmi_summary_card.dart';
import '../widgets/bmi_trend_card.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/progress_status_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),

              // Header
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.gray200, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Track your health journey',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Current BMI hero card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF047857),
                      Color(0xFF10B981),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Current BMI',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '22.9',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,

                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'kg/m²',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Normal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.emerald100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Current Weight',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '70 kg',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Update weight button
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.emerald500, width: 1.5),
                  foregroundColor: AppColors.emerald600,
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Update Weight',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Starting vs Current
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BmiSummaryCard(
                      icon: Icons.flag_outlined,
                      title: 'Starting',
                      weight: '75 kg',
                      bmi: '24.5',
                      badgeColor: AppColors.orange500.withOpacity(0.95),
                      badgeTextColor: AppColors.orange500,
                      badgeText: 'Overweight',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BmiSummaryCard(
                      icon: Icons.favorite_border,
                      title: 'Current',
                      weight: '70 kg',
                      bmi: '22.9',
                      badgeColor: AppColors.emerald500.withOpacity(0.95),
                      badgeTextColor: AppColors.emerald100,
                      badgeText: 'Normal',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              BmiTrendCard(),

              const SizedBox(height: 16),

              // Status message cards
              ProgressStatusCard(
                title: 'Great progress!',
                text:
                    'Your BMI is moving toward a healthier range. Keep following your current plan.',
              ),

              const SizedBox(height: 12),

              Container(
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
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.emerald500.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.emerald600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Congratulations! 🎉',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gray900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "You've maintained normal BMI for 2 consecutive weeks",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Maintenance plan button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.emerald500,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '🎉 Change to Maintenance Plan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Stats cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProgressStatCard(
                      icon: Icons.trending_down_rounded,
                      iconColor: AppColors.blue500,
                      label: 'Weight Lost',
                      value: '5.0 kg',
                      subtitle: '↘ Last 5 weeks',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProgressStatCard(
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      label: 'BMI Change',
                      value: '-1.7',
                      subtitle: '↘ Improving',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

