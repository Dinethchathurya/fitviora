import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
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

  // ── Display getters ──

  String get displayName =>
      (profile?.fullName.isNotEmpty == true) ? profile!.fullName : 'FitViora User';

  String get displayEmail => profile?.email ?? 'user@fitviora.com';

  String get displayDob => _formatValue(profile?.dateOfBirth);

  String get displayGender => _capitalize(profile?.gender);

  String get displayHeight =>
      (profile != null && profile!.heightCm > 0)
          ? '${profile!.heightCm.toStringAsFixed(1)} cm'
          : 'Not provided';

  String get displayWeight =>
      (profile != null && profile!.weightKg > 0)
          ? '${profile!.weightKg.toStringAsFixed(1)} kg'
          : 'Not provided';

  String get displayActivityLevel => _capitalize(profile?.activityLevel);

  String get displayGoal => _capitalize(profile?.goal);

  String get displayFoodPreference => _capitalize(profile?.foodPreference);

  // ── Visual mapping getters ──
  String get foodPreferenceEmoji {
    final pref = profile?.foodPreference ?? '';
    final map = {
      'Vegetarian': '🥗',
      'Non-Vegetarian': '🍗',
      'Vegan': '🌱',
      'Pescatarian': '🐟',
    };
    return map[pref] ?? '🍽️';
  }

  String get goalEmoji {
    final goal = profile?.goal ?? '';
    final map = {
      'Weight Loss': '📉',
      'Weight Gain': '💪',
      'Maintenance': '⚖️',
    };
    return map[goal] ?? '🎯';
  }

  List<String> get healthConditionBadges {
    final conditions = profile?.healthConditions as List<String>? ?? [];
    final map = {
      'Diabetes': '🩸 Diabetes',
      'Hypertension': '❤️ Hypertension',
    };
    return conditions.map((c) => map[c] ?? c).where((b) => b.isNotEmpty).toList();
  }

  // ── BMI getters ──

  double get bmi {
    if (profile == null || profile!.heightCm <= 0 || profile!.weightKg <= 0) {
      return 0;
    }
    final heightM = profile!.heightCm / 100;
    return profile!.weightKg / (heightM * heightM);
  }

  String get bmiValue => bmi > 0 ? bmi.toStringAsFixed(1) : '--';

  String get bmiStatus {
    if (bmi <= 0) return 'Unknown';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get bmiColor {
    if (bmi <= 0) return AppColors.gray500;
    if (bmi < 18.5) return AppColors.blue500;
    if (bmi < 25) return AppColors.emerald500;
    if (bmi < 30) return AppColors.orange500;
    return AppColors.destructive;
  }

  // ── Helpers ──

  String _capitalize(String? value) {
    if (value == null || value.isEmpty) return 'Not provided';
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  String _formatValue(String? value) {
    if (value == null || value.trim().isEmpty) return 'Not provided';
    return value;
  }
}

