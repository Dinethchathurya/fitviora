import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/local_storage_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final LocalStorageService localStorageService;

  OnboardingViewModel({
    required this.localStorageService,
  });

  final PageController controller = PageController();
  int currentIndex = 0;

  bool get isLast => currentIndex == 2;

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> next(BuildContext context) async {
    if (!isLast) {
      await controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      await complete(context);
    }
  }

  Future<void> skip(BuildContext context) async {
    await complete(context);
  }

  Future<void> complete(BuildContext context) async {
    await localStorageService.setOnboardingCompleted();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }
}
