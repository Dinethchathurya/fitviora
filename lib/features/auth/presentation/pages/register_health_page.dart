import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/register_flow_view_model.dart';
import '../widgets/register_progress_header.dart';
import '../widgets/selection_tile.dart';

class RegisterHealthPage extends StatelessWidget {
  const RegisterHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterFlowViewModel>();
    const conditions = ['Diabetes', 'Hypertension'];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              children: [
                RegisterProgressHeader(
                  step: 3,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),
                AppCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Conditions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Select all that apply',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      ...conditions.map(
                        (condition) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SelectionTile(
                            title: condition,
                            selected: vm.healthConditions.contains(condition),
                            onTap: () => vm.toggleHealthCondition(condition),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Allergies (Optional)',
                        controller: vm.allergyController,
                        hintText: 'E.g., peanuts, shellfish...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppPrimaryButton(
                  label: 'Next',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.registerGoals,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
