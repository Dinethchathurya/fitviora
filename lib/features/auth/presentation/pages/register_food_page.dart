import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/register_flow_view_model.dart';
import '../widgets/register_progress_header.dart';
import '../widgets/selection_tile.dart';

class RegisterFoodPage extends StatelessWidget {
  const RegisterFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterFlowViewModel>();
    const items = [
      ('Vegetarian', '🥗'),
      ('Non-Vegetarian', '🍗'),
      ('Vegan', '🌱'),
      ('Pescatarian', '🐟'),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              children: [
                RegisterProgressHeader(
                  step: 2,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),
                AppCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Food Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Select your dietary preference',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SelectionTile(
                            title: item.$1,
                            leadingEmoji: item.$2,
                            selected: vm.foodPreference == item.$1,
                            onTap: () => vm.setFoodPreference(item.$1),
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
                  onPressed: vm.foodPreference.isEmpty
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            AppRoutes.registerHealth,
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
