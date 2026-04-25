import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

class SplashViewModel extends ChangeNotifier {
  final LocalStorageService localStorageService;
  final AuthRepositoryImpl authRepository;

  SplashViewModel({
    required this.localStorageService,
    required this.authRepository,
  });

  Future<String> resolveInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    final onboarded =
        await localStorageService.isOnboardingCompleted();
    final loggedIn = authRepository.currentUserId != null;

    if (!onboarded) return AppRoutes.onboarding;
    if (!loggedIn) return AppRoutes.welcome;

    // Check if email is verified
    final isVerified = authRepository.isEmailVerified;
    if (!isVerified) return AppRoutes.verifyEmail;

    return AppRoutes.mainShell;
  }
}
