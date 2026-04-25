import 'package:flutter/material.dart';

import '../../../../shared/entities/user_profile.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final AuthRepositoryImpl authRepository;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.authRepository,
  });

  UserProfile? profile;
  bool isLoading = false;

  Future<void> loadProfile() async {
    final uid = authRepository.currentUserId;
    if (uid == null) return;

    try {
      isLoading = true;
      notifyListeners();
      profile = await getProfileUseCase(uid);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
