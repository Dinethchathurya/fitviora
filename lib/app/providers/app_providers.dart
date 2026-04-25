import 'package:provider/provider.dart';

import '../../core/services/local_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/check_email_verified_usecase.dart';
import '../../features/auth/domain/usecases/create_account_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reauthenticate_user_usecase.dart';
import '../../features/auth/domain/usecases/reload_user_usecase.dart';
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/auth/domain/usecases/update_password_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/auth/presentation/viewmodels/email_verification_view_model.dart';
import '../../features/auth/presentation/viewmodels/password_view_model.dart';
import '../../features/auth/presentation/viewmodels/register_flow_view_model.dart';
import '../../features/onboarding/presentation/viewmodels/onboarding_view_model.dart';
import '../../features/profile/data/datasources/profile_remote_data_source_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentation/viewmodels/profile_view_model.dart';
import '../../features/splash/presentation/viewmodels/splash_view_model.dart';
import '../../main_shell/presentation/viewmodels/main_nav_view_model.dart';

class AppProviders {
  static final providers = [
    Provider<LocalStorageService>(
      create: (_) => LocalStorageService(),
    ),
    Provider<AuthRemoteDataSourceImpl>(
      create: (_) => AuthRemoteDataSourceImpl(),
    ),
    Provider<AuthRepositoryImpl>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
      ),
    ),
    Provider<ProfileRemoteDataSourceImpl>(
      create: (_) => ProfileRemoteDataSourceImpl(),
    ),
    Provider<ProfileRepositoryImpl>(
      create: (context) => ProfileRepositoryImpl(
        remoteDataSource: context.read<ProfileRemoteDataSourceImpl>(),
      ),
    ),
    Provider<LoginUseCase>(
      create: (context) => LoginUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<CreateAccountUseCase>(
      create: (context) => CreateAccountUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<LogoutUseCase>(
      create: (context) => LogoutUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<ReauthenticateUserUseCase>(
      create: (context) => ReauthenticateUserUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<UpdatePasswordUseCase>(
      create: (context) => UpdatePasswordUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<SendPasswordResetEmailUseCase>(
      create: (context) => SendPasswordResetEmailUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<SendEmailVerificationUseCase>(
      create: (context) => SendEmailVerificationUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<ReloadUserUseCase>(
      create: (context) => ReloadUserUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<CheckEmailVerifiedUseCase>(
      create: (context) => CheckEmailVerifiedUseCase(
        context.read<AuthRepositoryImpl>(),
      ),
    ),
    Provider<GetProfileUseCase>(
      create: (context) => GetProfileUseCase(
        context.read<ProfileRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => SplashViewModel(
        localStorageService: context.read<LocalStorageService>(),
        authRepository: context.read<AuthRepositoryImpl>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => OnboardingViewModel(
        localStorageService: context.read<LocalStorageService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(
        loginUseCase: context.read<LoginUseCase>(),
        createAccountUseCase: context.read<CreateAccountUseCase>(),
        logoutUseCase: context.read<LogoutUseCase>(),
        sendEmailVerificationUseCase: context.read<SendEmailVerificationUseCase>(),
        checkEmailVerifiedUseCase: context.read<CheckEmailVerifiedUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => PasswordViewModel(
        reauthenticateUserUseCase: context.read<ReauthenticateUserUseCase>(),
        updatePasswordUseCase: context.read<UpdatePasswordUseCase>(),
        sendPasswordResetEmailUseCase: context.read<SendPasswordResetEmailUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => EmailVerificationViewModel(
        sendEmailVerificationUseCase: context.read<SendEmailVerificationUseCase>(),
        reloadUserUseCase: context.read<ReloadUserUseCase>(),
        checkEmailVerifiedUseCase: context.read<CheckEmailVerifiedUseCase>(),
        logoutUseCase: context.read<LogoutUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => RegisterFlowViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => MainNavViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        getProfileUseCase: context.read<GetProfileUseCase>(),
        authRepository: context.read<AuthRepositoryImpl>(),
      ),
    ),
  ];
}
