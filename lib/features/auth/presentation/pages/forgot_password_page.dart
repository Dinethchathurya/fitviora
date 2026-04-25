import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/password_view_model.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(PasswordViewModel passwordViewModel) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await passwordViewModel.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordViewModel.forgotPasswordSuccessMessage!),
          backgroundColor: AppColors.emerald600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordViewModel = context.watch<PasswordViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppCardContainer(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Enter your email address and we will send you a link to reset your password.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'Email Address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'your.email@example.com',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              size: 20,
                            ),
                            validator: Validators.email,
                          ),
                          if (passwordViewModel.forgotPasswordErrorMessage !=
                              null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                          color: AppColors.red500.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.destructive,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      passwordViewModel
                                          .forgotPasswordErrorMessage!,
                                      style: const TextStyle(
                                        color: AppColors.destructive,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (passwordViewModel.forgotPasswordSuccessMessage !=
                              null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.emerald50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.emerald100,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.emerald600,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      passwordViewModel
                                          .forgotPasswordSuccessMessage!,
                                      style: const TextStyle(
                                        color: AppColors.emerald600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          AppPrimaryButton(
                            label: passwordViewModel.isLoadingForgotPassword
                                ? 'Sending...'
                                : 'Send Reset Link',
                            onPressed:
                                passwordViewModel.isLoadingForgotPassword
                                    ? null
                                    : () => _submit(passwordViewModel),
                          ),
                          if (passwordViewModel
                                  .forgotPasswordSuccessMessage !=
                              null) ...[
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed:
                                    passwordViewModel.isLoadingForgotPassword
                                        ? null
                                        : () => _submit(passwordViewModel),
                                style: OutlinedButton.styleFrom(
                                  minimumSize:
                                      const Size.fromHeight(52),
                                  side: const BorderSide(
                                    color: AppColors.emerald500,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Resend Email',
                                  style: TextStyle(
                                    color: AppColors.emerald600,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      passwordViewModel.clearForgotPasswordState();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        color: AppColors.emerald600,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

