import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/usecases/check_email_verified_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reload_user_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final ReloadUserUseCase reloadUserUseCase;
  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;
  final LogoutUseCase logoutUseCase;

  EmailVerificationViewModel({
    required this.sendEmailVerificationUseCase,
    required this.reloadUserUseCase,
    required this.checkEmailVerifiedUseCase,
    required this.logoutUseCase,
  });

  bool isLoading = false;
  bool isChecking = false;
  String? errorMessage;
  bool isEmailVerified = false;

  // Resend cooldown
  int resendCooldownSeconds = 0;
  Timer? _resendTimer;

  void startResendCooldown() {
    resendCooldownSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCooldownSeconds--;
      notifyListeners();
      if (resendCooldownSeconds <= 0) {
        timer.cancel();
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<bool> sendEmailVerification() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await sendEmailVerificationUseCase();
      startResendCooldown();
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      isChecking = true;
      errorMessage = null;
      notifyListeners();

      await reloadUserUseCase();
      isEmailVerified = checkEmailVerifiedUseCase();

      return isEmailVerified;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isChecking = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    _resendTimer?.cancel();
    await logoutUseCase();
  }

  String _friendlyError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('too-many-requests')) {
      return 'Too many requests. Please try again later';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    }
    return 'Something went wrong. Please try again.';
  }
}
