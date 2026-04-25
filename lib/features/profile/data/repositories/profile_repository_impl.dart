import '../../../../shared/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source_impl.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSourceImpl remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<UserProfile?> getProfile(String uid) {
    return remoteDataSource.getProfile(uid);
  }
}
