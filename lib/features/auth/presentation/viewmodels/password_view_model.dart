import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/reauthenticate_user_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

class PasswordViewModel extends ChangeNotifier {
  final ReauthenticateUserUseCase reauthenticateUserUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  PasswordViewModel({
    required this.reauthenticateUserUseCase,
    required this.updatePasswordUseCase,
    required this.sendPasswordResetEmailUseCase,
  });

  // Loading states
  bool isLoadingChangePassword = false;
  bool isLoadingForgotPassword = false;

  // Error messages
  String? changePasswordErrorMessage;
  String? forgotPasswordErrorMessage;

  // Success messages
  String? changePasswordSuccessMessage;
  String? forgotPasswordSuccessMessage;

  // Visibility toggles
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible = !isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void clearChangePasswordState() {
    changePasswordErrorMessage = null;
    changePasswordSuccessMessage = null;
    notifyListeners();
  }

  void clearForgotPasswordState() {
    forgotPasswordErrorMessage = null;
    forgotPasswordSuccessMessage = null;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoadingChangePassword = true;
      changePasswordErrorMessage = null;
      changePasswordSuccessMessage = null;
      notifyListeners();

      // Step 1: Reauthenticate user with current password
      await reauthenticateUserUseCase(currentPassword: currentPassword);

      // Step 2: Update to new password
      await updatePasswordUseCase(newPassword: newPassword);

      changePasswordSuccessMessage = 'Password changed successfully';
      return true;
    } catch (e) {
      changePasswordErrorMessage = _friendlyPasswordError(e);
      return false;
    } finally {
      isLoadingChangePassword = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      isLoadingForgotPassword = true;
      forgotPasswordErrorMessage = null;
      forgotPasswordSuccessMessage = null;
      notifyListeners();

      await sendPasswordResetEmailUseCase(email: email);

      forgotPasswordSuccessMessage =
          'If an account exists, a reset link has been sent to your email';
      return true;
    } catch (e) {
      forgotPasswordErrorMessage = _friendlyPasswordError(e);
      return false;
    } finally {
      isLoadingForgotPassword = false;
      notifyListeners();
    }
  }

  String _friendlyPasswordError(Object error) {
    // Prefer FirebaseAuthException code for precise mapping
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'Current password is incorrect';
        case 'user-not-found':
          return 'No account found with this email';
        case 'invalid-email':
          return 'Enter a valid email address';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'network-request-failed':
          return 'Network error. Please check your connection';
        case 'requires-recent-login':
          return 'Please log in again before changing your password';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password';
        case 'invalid-continue-uri':
        case 'unauthorized-continue-uri':
          return 'Invalid request configuration. Contact support';
        case 'missing-android-pkg-name':
        case 'missing-ios-bundle-id':
          return 'App configuration error. Contact support';
        default:
          return 'Something went wrong (${error.code}). Please try again.';
      }
    }

    final message = error.toString().toLowerCase();

    if (message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Current password is incorrect';
    }
    if (message.contains('user-not-found')) {
      return 'No account found with this email';
    }
    if (message.contains('invalid-email')) {
      return 'Enter a valid email address';
    }
    if (message.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    }
    if (message.contains('requires-recent-login')) {
      return 'Please log in again before changing your password';
    }
    if (message.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password';
    }
    return 'Something went wrong. Please try again.';
  }
}

