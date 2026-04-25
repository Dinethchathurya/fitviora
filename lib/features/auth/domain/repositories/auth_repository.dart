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

  Future<void> reauthenticateUser({required String currentPassword});

  Future<void> updatePassword({required String newPassword});

  Future<void> sendPasswordResetEmail({required String email});

  String? get currentUserId;
}

