import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<String?> createAccount({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  }) {
    return remoteDataSource.createAccount(
      email: email,
      password: password,
      profileData: profileData,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> reauthenticateUser({required String currentPassword}) {
    return remoteDataSource.reauthenticateUser(
      currentPassword: currentPassword,
    );
  }

  @override
  Future<void> updatePassword({required String newPassword}) {
    return remoteDataSource.updatePassword(
      newPassword: newPassword,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return remoteDataSource.sendPasswordResetEmail(
      email: email,
    );
  }

  @override
  String? get currentUserId => remoteDataSource.currentUserId;
}

