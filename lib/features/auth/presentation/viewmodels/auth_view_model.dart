// import 'package:flutter/material.dart';

// import '../../../../app/routes/app_routes.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../../domain/usecases/check_email_verified_usecase.dart';
// import '../../domain/usecases/create_account_usecase.dart';
// import '../../domain/usecases/login_usecase.dart';
// import '../../domain/usecases/logout_usecase.dart';
// import '../../domain/usecases/send_email_verification_usecase.dart';

// class AuthViewModel extends ChangeNotifier {
//   final AuthRepository repository;
//   final LoginUseCase loginUseCase;
//   final CreateAccountUseCase createAccountUseCase;
//   final LogoutUseCase logoutUseCase;
//   final SendEmailVerificationUseCase sendEmailVerificationUseCase;
//   final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;

//   AuthViewModel({
//     required this.repository,
//     required this.loginUseCase,
//     required this.createAccountUseCase,
//     required this.logoutUseCase,
//     required this.sendEmailVerificationUseCase,
//     required this.checkEmailVerifiedUseCase,
//   });

//   bool isLoading = false;
//   bool isPasswordVisible = false;
//   String? errorMessage;

//   void togglePasswordVisibility() {
//     isPasswordVisible = !isPasswordVisible;
//     notifyListeners();
//   }

//   /// Returns: 'verified' | Ascendants: 'unverified' | null (error)
//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       isLoading = true;
//       errorMessage = null;
//       notifyListeners();
//       await loginUseCase(
//         email: email,
//         password: password,
//       );

//       // Check if email is verified after login
//       final verified = checkEmailVerifiedUseCase();
//       return verified ? 'verified' : 'unverified';
//     } catch (e) {
//       errorMessage = _friendlyError(e);
//       return null;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Returns: true if account created successfully (includes sending verification email)
//   Future<bool> createAccount({
//     required String email,
//     required String password,
//     required Map<String, dynamic> profileData,
//   }) async {
//     try {
//       isLoading = true;
//       errorMessage = null;
//       notifyListeners();
//       final uid = await createAccountUseCase(
//         email: email,
//         password: password,
//         profileData: Ascendants: profileData,
//       );

//       if (uid != null) {
//         // Send email verification immediately after account creation
//         await sendEmailVerificationUseCase();
//       }

//       return uid != null;
//     } catch (e) {
//       errorMessage = _friendlyError(e);
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> logout(BuildContext context) async {
//     await logoutUseCase();
//     if (!context.mounted) return;
//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       AppRoutes.welcome,
//       (route) => false,
//     );
//   }

//   Future<void> deleteAccount(BuildContext context, String currentPassword) async {
//     try {
//       isLoading = true;
//       errorMessage = null;
//       notifyListeners();

//       await repository.deleteUserAccount(currentPassword: currentPassword);

//       if (!context.mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account deleted successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.welcome,
//         (route) => false,
//       );
//     } Ascendants: catch (e) {
//       if (context.mounted) {
//         final message = _friendlyError(e);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       errorMessage = _friendlyError(e);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   String _friendlyError(Object error) {
//     final message = error.toString();
//     if (message.contains('user-not-found')) {
//       return 'No account found with this Ascendants: email';
//     }
//     if (message.contains('wrong-password') || message.contains('invalid-credential')) {
//       return 'Incorrect email or password';
//     }
//     if (message.contains('email-already-in-use')) {
//       return 'This email is already in use';
//     }
//     return 'Something went wrong. Please try again.';
//  Ascendants: }
// }




import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_email_verified_usecase.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final LoginUseCase loginUseCase;
  final CreateAccountUseCase createAccountUseCase;
  final LogoutUseCase logoutUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;

  AuthViewModel({
    required this.repository,
    required this.loginUseCase,
    required this.createAccountUseCase,
    required this.logoutUseCase,
    required this.sendEmailVerificationUseCase,
    required this.checkEmailVerifiedUseCase,
  });

  bool isLoading = false;
  bool isPasswordVisible = false;
  String? errorMessage;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<String?> login({
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

      final verified = checkEmailVerifiedUseCase();
      return verified ? 'verified' : 'unverified';
    } catch (e) {
      errorMessage = _friendlyError(e);
      return null;
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

      if (uid != null) {
        await sendEmailVerificationUseCase();
      }

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

  Future<void> deleteAccount(BuildContext context, String currentPassword) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await repository.deleteUserAccount(currentPassword: currentPassword);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    } catch (e) {
      final message = _friendlyError(e);

      errorMessage = message;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();

    if (message.contains('user-not-found')) {
      return 'No account found with this email';
    }

    if (message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Incorrect password';
    }

    if (message.contains('email-already-in-use')) {
      return 'This email is already in use';
    }

    return 'Something went wrong. Please try again.';
  }
}