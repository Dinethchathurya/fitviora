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
import '../widgets/auth_brand_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: 'your.email@example.com');
  final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthViewModel authViewModel) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authViewModel.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.mainShell,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AppCardContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthBrandHeader(
                        title: 'Welcome Back',
                        subtitle: 'Log in to continue your health journey',
                      ),
                      const SizedBox(height: 28),
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
                      const SizedBox(height: 18),
                      AppTextField(
                        label: 'Password',
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: !authViewModel.isPasswordVisible,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: authViewModel.togglePasswordVisibility,
                          icon: Icon(
                            authViewModel.isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                          ),
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.forgotPassword,
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.emerald600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (authViewModel.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          authViewModel.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.destructive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      AppPrimaryButton(
                        label: authViewModel.isLoading
                            ? 'Logging in...'
                            : 'Log In',
                        onPressed: authViewModel.isLoading
                            ? null
                            : () => _submit(authViewModel),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.registerPersonal,
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray600,
                            ),
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.emerald600,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
