import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository repository;

  CheckEmailVerifiedUseCase(this.repository);

  bool call() {
    return repository.isEmailVerified;
  }
}
