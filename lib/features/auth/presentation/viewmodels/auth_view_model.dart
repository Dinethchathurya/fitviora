import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final CreateAccountUseCase createAccountUseCase;
  final LogoutUseCase logoutUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.createAccountUseCase,
    required this.logoutUseCase,
  });

  bool isLoading = false;
  bool isPasswordVisible = false;
  String? errorMessage;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      await loginUseCase(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAccount({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      final uid = await createAccountUseCase(
        email: email,
        password: password,
        profileData: profileData,
      );
      return uid != null;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await logoutUseCase();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.welcome,
      (route) => false,
    );
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('user-not-found')) {
      return 'No account found with this email';
    }
    if (message.contains('wrong-password') || message.contains('invalid-credential')) {
      return 'Incorrect email or password';
    }
    if (message.contains('email-already-in-use')) {
      return 'This email is already in use';
    }
    return 'Something went wrong. Please try again.';
  }
}
