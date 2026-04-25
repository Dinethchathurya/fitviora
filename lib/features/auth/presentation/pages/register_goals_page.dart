import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/register_flow_view_model.dart';
import '../widgets/register_progress_header.dart';
import '../widgets/selection_tile.dart';

class RegisterGoalsPage extends StatelessWidget {
  const RegisterGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterFlowViewModel>();
    const goals = [
      ('Weight Loss', '📉'),
      ('Weight Gain', '💪'),
      ('Maintenance', '⚖️'),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              children: [
                RegisterProgressHeader(
                  step: 4,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),
                AppCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Goals',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "What's your primary goal?",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ...goals.map(
                        (goal) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SelectionTile(
                            title: goal.$1,
                            leadingEmoji: goal.$2,
                            selected: vm.goal == goal.$1,
                            onTap: () => vm.setGoal(goal.$1),
                            showRadio: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppPrimaryButton(
                  label: 'Next',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onPressed: vm.goal.isEmpty
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            AppRoutes.createAccount,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
