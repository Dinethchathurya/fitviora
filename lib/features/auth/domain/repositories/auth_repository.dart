import '../../../../shared/entities/user_profile.dart';

abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<String?> createAccount({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  });

  Future<void> logout();

  String? get currentUserId;
}
