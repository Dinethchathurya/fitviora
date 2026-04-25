import '../repositories/auth_repository.dart';

class CreateAccountUseCase {
  final AuthRepository repository;

  CreateAccountUseCase(this.repository);

  Future<String?> call({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  }) {
    return repository.createAccount(
      email: email,
      password: password,
      profileData: profileData,
    );
  }
}
