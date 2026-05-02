import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_food_page.dart';
import '../../features/auth/presentation/pages/register_goals_page.dart';
import '../../features/auth/presentation/pages/register_health_page.dart';
import '../../features/auth/presentation/pages/register_personal_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../main_shell/presentation/pages/main_shell_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case AppRoutes.registerPersonal:
        return MaterialPageRoute(builder: (_) => const RegisterPersonalPage());
      case AppRoutes.registerFood:
        return MaterialPageRoute(builder: (_) => const RegisterFoodPage());
      case AppRoutes.registerHealth:
        return MaterialPageRoute(builder: (_) => const RegisterHealthPage());
      case AppRoutes.registerGoals:
        return MaterialPageRoute(builder: (_) => const RegisterGoalsPage());
      case AppRoutes.createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const MainShellPage());
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case AppRoutes.verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
