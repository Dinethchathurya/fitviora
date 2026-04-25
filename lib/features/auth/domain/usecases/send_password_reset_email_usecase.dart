import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.sendPasswordResetEmail(
      email: email,
    );
  }
}

