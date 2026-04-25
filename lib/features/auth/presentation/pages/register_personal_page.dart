import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/register_flow_view_model.dart';
import '../widgets/register_progress_header.dart';

class RegisterPersonalPage extends StatefulWidget {
  const RegisterPersonalPage({super.key});

  @override
  State<RegisterPersonalPage> createState() =>
      _RegisterPersonalPageState();
}

class _RegisterPersonalPageState extends State<RegisterPersonalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterFlowViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              children: [
                RegisterProgressHeader(
                  step: 1,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),
                AppCardContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Full Name',
                          controller: vm.fullNameController,
                          hintText: 'Enter your full name',
                          validator: (value) =>
                              Validators.requiredField(
                            value,
                            'Full name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Date of Birth',
                          controller: vm.dateOfBirthController,
                          hintText: 'yyyy-mm-dd',
                          validator: (value) =>
                              Validators.requiredField(
                            value,
                            'Date of birth',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: vm.gender.isEmpty ? null : vm.gender,
                          decoration: const InputDecoration(),
                          hint: const Text('Select gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) vm.setGender(value);
                          },
                          validator: (value) =>
                              value == null ? 'Gender is required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Height (cm)',
                                controller: vm.heightController,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    Validators.requiredField(
                                  value,
                                  'Height',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                label: 'Weight (kg)',
                                controller: vm.weightController,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    Validators.requiredField(
                                  value,
                                  'Weight',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Activity Level',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: vm.activityLevel.isEmpty
                              ? null
                              : vm.activityLevel,
                          decoration: const InputDecoration(),
                          hint: const Text('Select activity level'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Low',
                              child: Text('Low'),
                            ),
                            DropdownMenuItem(
                              value: 'Moderate',
                              child: Text('Moderate'),
                            ),
                            DropdownMenuItem(
                              value: 'High',
                              child: Text('High'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              vm.setActivityLevel(value);
                            }
                          },
                          validator: (value) => value == null
                              ? 'Activity level is required'
                              : null,
                        ),
                      ],
                    ),
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.registerFood,
                      );
                    }
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
