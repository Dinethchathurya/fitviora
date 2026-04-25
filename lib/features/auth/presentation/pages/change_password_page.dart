import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/password_view_model.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(PasswordViewModel passwordViewModel) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await passwordViewModel.changePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordViewModel.changePasswordSuccessMessage!),
          backgroundColor: AppColors.emerald600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Clear fields and navigate back after short delay
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      passwordViewModel.clearChangePasswordState();

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordViewModel = context.watch<PasswordViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.gray700),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: AppCardContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update your password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For security, re-enter your current password before setting a new one.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppTextField(
                      label: 'Current Password',
                      controller: _currentPasswordController,
                      obscureText: !passwordViewModel.isCurrentPasswordVisible,
                      hintText: 'Enter current password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed:
                            passwordViewModel.toggleCurrentPasswordVisibility,
                        icon: Icon(
                          passwordViewModel.isCurrentPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                      validator: (value) => Validators.requiredField(
                        value,
                        'Current password',
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscureText: !passwordViewModel.isNewPasswordVisible,
                      hintText: 'Min 8 chars, upper, lower, number & special',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed:
                            passwordViewModel.toggleNewPasswordVisibility,
                        icon: Icon(
                          passwordViewModel.isNewPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                      validator: Validators.strongPassword,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      obscureText:
                          !passwordViewModel.isConfirmPasswordVisible,
                      hintText: 'Re-enter new password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed:
                            passwordViewModel.toggleConfirmPasswordVisibility,
                        icon: Icon(
                          passwordViewModel.isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.teal50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.teal100,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password requirements:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '• At least 8 characters\n• One uppercase letter\n• One lowercase letter\n• One number\n• One special character',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (passwordViewModel.changePasswordErrorMessage !=
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
                                passwordViewModel.changePasswordErrorMessage!,
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
                    const SizedBox(height: 20),
                    AppPrimaryButton(
                      label: passwordViewModel.isLoadingChangePassword
                          ? 'Updating...'
                          : 'Update Password',
                      onPressed: passwordViewModel.isLoadingChangePassword
                          ? null
                          : () => _submit(passwordViewModel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

