import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/bmi_summary_card.dart';
import '../widgets/bmi_trend_card.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/progress_status_card.dart';
import '../viewmodels/progress_view_model.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late final ProgressViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProgressViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadProgressData();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _showUpdateWeightDialog() async {
    var enteredWeight = _viewModel.currentWeightKg > 0
        ? _viewModel.currentWeightKg.toStringAsFixed(1)
        : '';

    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Weight'),
          content: TextFormField(
            initialValue: enteredWeight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Weight',
              suffixText: 'kg',
              hintText: 'Enter your current weight',
            ),
            onChanged: (value) {
              enteredWeight = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(enteredWeight.trim());

                final validationMessage = weight == null
                    ? 'Enter a valid weight.'
                    : _viewModel.validateWeight(weight);

                if (validationMessage != null) {
                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(SnackBar(content: Text(validationMessage)));
                  return;
                }

                Navigator.of(dialogContext).pop(weight);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == null || !mounted) return;

    FocusScope.of(context).unfocus();

    final success = await _viewModel.updateWeight(result);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Weight updated successfully.'
              : _viewModel.error ?? 'Failed to update weight.',
        ),
      ),
    );
  }

  Future<void> _changeToMaintenancePlan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change to Maintenance Plan'),
          content: Text(
            'Your current goal is "${_viewModel.goal}". '
            'Do you want to change it to Maintenance?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final success = await _viewModel.changeToMaintenancePlan();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Your goal has been changed to Maintenance.'
              : _viewModel.error ?? 'Failed to update your goal.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error != null && !_viewModel.hasData) {
      return Center(child: Text(_viewModel.error!));
    }

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
                    colors: [Color(0xFF047857), Color(0xFF10B981)],
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
                        Text(
                          _viewModel.currentBmi.toStringAsFixed(1),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _viewModel.currentBmiCategory,
                            style: const TextStyle(
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
                          Text(
                            '${_viewModel.currentWeightKg.toStringAsFixed(1)} kg',
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
                onPressed: _viewModel.isUpdatingWeight
                    ? null
                    : _showUpdateWeightDialog,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(
                    color: AppColors.emerald500,
                    width: 1.5,
                  ),
                  foregroundColor: AppColors.emerald600,
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _viewModel.isUpdatingWeight
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
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

                      iconColor: AppColors.orange500,

                      title: 'Starting',

                      weight:
                          '${_viewModel.startingWeightKg.toStringAsFixed(1)} kg',

                      bmi: _viewModel.startingBmi.toStringAsFixed(1),

                      badgeColor: AppColors.orange500,

                      badgeTextColor: AppColors.white,

                      badgeText: _viewModel.startingBmiCategory,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BmiSummaryCard(
                      icon: Icons.favorite_border,

                      iconColor: AppColors.emerald600,

                      title: 'Current',

                      weight:
                          '${_viewModel.currentWeightKg.toStringAsFixed(1)} kg',

                      bmi: _viewModel.currentBmi.toStringAsFixed(1),

                      badgeColor: AppColors.emerald500,

                      badgeTextColor: AppColors.white,

                      badgeText: _viewModel.currentBmiCategory,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              BmiTrendCard(
                records: _viewModel.recentWeightRecords,
                heightCm: _viewModel.heightCm,
              ),

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
                      child: Icon(
                        _viewModel.showCongratulations
                            ? Icons.emoji_events_rounded
                            : _viewModel.isCurrentBmiNormal
                            ? Icons.check_circle_rounded
                            : Icons.trending_up_rounded,
                        color: AppColors.emerald600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _viewModel.showCongratulations
                                ? 'Congratulations! 🎉'
                                : _viewModel.progressTitle,

                            style: const TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.w900,

                              color: AppColors.gray900,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            _viewModel.showCongratulations
                                ? _viewModel.congratulationsMessage
                                : _viewModel.progressMessage,

                            style: const TextStyle(
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

              // Maintenance plan status/button
              if (_viewModel.canChangeToMaintenance)
                ElevatedButton(
                  onPressed: _viewModel.isUpdatingGoal
                      ? null
                      : _changeToMaintenancePlan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.emerald500,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.emerald500.withValues(
                      alpha: 0.6,
                    ),
                    disabledForegroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _viewModel.isUpdatingGoal
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text(
                          '🎉 Change to Maintenance Plan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emerald50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.emerald500, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.emerald600,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'You are in the Maintenance Plan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.emerald600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // Stats cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProgressStatCard(
                      icon: _viewModel.weightStatIcon,
                      iconColor: AppColors.blue500,
                      label: _viewModel.weightStatLabel,
                      value:
                          '${_viewModel.currentWeightKg.toStringAsFixed(1)} kg',
                      subtitle: _viewModel.weightStatSubtitle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProgressStatCard(
                      icon: _viewModel.bmiStatIcon,
                      iconColor: const Color(0xFF8B5CF6),
                      label: 'BMI Change',
                      value: '${_viewModel.bmiChange.toStringAsFixed(1)}',
                      subtitle: _viewModel.bmiStatSubtitle,
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
