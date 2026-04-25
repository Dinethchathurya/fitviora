import '../../../../shared/entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfile?> call(String uid) {
    return repository.getProfile(uid);
  }
}
