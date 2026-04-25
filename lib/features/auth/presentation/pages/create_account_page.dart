import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/register_flow_view_model.dart';
import '../widgets/register_progress_header.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(
    AuthViewModel authViewModel,
    RegisterFlowViewModel registerFlowViewModel,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authViewModel.createAccount(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      profileData: registerFlowViewModel.toFirestoreMap(),
    );

    if (!mounted) return;

if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.verifyEmail,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final registerFlowViewModel =
        context.watch<RegisterFlowViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              children: [
                RegisterProgressHeader(
                  step: 5,
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
                          'Create Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Set up your login details.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Email Address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'your.email@example.com',
                          validator: Validators.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          hintText: 'Min 8 chars, uppercase, lowercase, number & special char',
                          validator: Validators.strongPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.emerald50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.emerald100,
                            ),
                          ),
                          child: const Text(
                            'Your credentials are encrypted and will be used to log in to FitViora.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                        if (authViewModel.errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            authViewModel.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.destructive,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppPrimaryButton(
                  label: authViewModel.isLoading
                      ? 'Completing Setup...'
                      : 'Complete Setup',
                  onPressed: authViewModel.isLoading
                      ? null
                      : () => _submit(
                            authViewModel,
                            registerFlowViewModel,
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
