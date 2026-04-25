import '../repositories/auth_repository.dart';

class ReauthenticateUserUseCase {
  final AuthRepository repository;

  ReauthenticateUserUseCase(this.repository);

  Future<void> call({required String currentPassword}) {
    return repository.reauthenticateUser(
      currentPassword: currentPassword,
    );
  }
}

