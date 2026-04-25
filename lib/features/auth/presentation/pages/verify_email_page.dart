import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card_container.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../viewmodels/email_verification_view_model.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<EmailVerificationViewModel>();
      vm.sendEmailVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmailVerificationViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.emerald100,
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 36,
                            color: AppColors.emerald600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Verify Your Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'We have sent a verification email to your inbox. Please check your email and tap the verification link.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.emerald50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.emerald100,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.emerald600,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Didn\'t receive the email? Check your spam folder or tap Resend below.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (vm.errorMessage != null) ...[
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
                                    vm.errorMessage!,
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
                        const SizedBox(height: 24),
                        AppPrimaryButton(
                          label: vm.isChecking
                              ? 'Checking...'
                              : 'I Have Verified',
                          onPressed: vm.isChecking
                              ? null
                              : () => _handleCheckVerified(vm),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: vm.isLoading ||
                                    vm.resendCooldownSeconds > 0
                                ? null
                                : () => _handleResend(vm),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              side: const BorderSide(
                                color: AppColors.emerald500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              vm.isLoading
                                  ? 'Sending...'
                                  : vm.resendCooldownSeconds > 0
                                      ? 'Resend in ${vm.resendCooldownSeconds}s'
                                      : 'Resend Email',
                              style: const TextStyle(
                                color: AppColors.emerald600,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => _handleLogout(vm),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(
                              color: AppColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _handleCheckVerified(
    EmailVerificationViewModel vm,
  ) async {
    final verified = await vm.checkEmailVerified();

    if (!mounted) return;

    if (verified) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.mainShell,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your inbox.'),
          backgroundColor: AppColors.orange500,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleResend(EmailVerificationViewModel vm) async {
    await vm.sendEmailVerification();

    if (!mounted) return;

    if (vm.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email resent successfully'),
          backgroundColor: AppColors.emerald600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleLogout(EmailVerificationViewModel vm) async {
    await vm.logout(context);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.welcome,
      (route) => false,
    );
  }
}
