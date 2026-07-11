import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeightRecord {
  const WeightRecord({
    required this.weightKg,
    required this.previousWeightKg,
    required this.recordedAt,
  });

  final double weightKg;
  final double previousWeightKg;
  final DateTime recordedAt;

  factory WeightRecord.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return WeightRecord(
      weightKg: ProgressViewModel.toDouble(data['weightKg']),
      previousWeightKg: ProgressViewModel.toDouble(data['previousWeightKg']),
      recordedAt: ProgressViewModel.toDateTime(data['recordedAt']),
    );
  }
}

enum BmiProgressState { unavailable, improving, stable, declining }

class ProgressViewModel extends ChangeNotifier {
  ProgressViewModel({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth,
      _firestore = firestore;

  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _weightRecordsSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdatingWeight = false;
  bool get isUpdatingWeight => _isUpdatingWeight;

  String? _error;
  String? get error => _error;

  double _heightCm = 0;
  double get heightCm => _heightCm;

  double _currentWeightKg = 0;
  double get currentWeightKg => _currentWeightKg;

  double _startingWeightKg = 0;
  double get startingWeightKg => _startingWeightKg;

  bool get hasData {
    return _currentWeightKg > 0 && _heightCm > 0 && _error == null;
  }

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;

  final List<WeightRecord> _weightRecords = [];
  List<WeightRecord> get weightRecords => List.unmodifiable(_weightRecords);

  /// Load the user profile and begin listening for weight changes.
  Future<void> loadProgressData() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      _error = 'User is not logged in.';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userSubscription?.cancel();
      await _weightRecordsSubscription?.cancel();

      _listenToUserProfile(user.uid);
      _listenToWeightRecords(user.uid);
    } catch (e) {
      _error = _friendlyError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToUserProfile(String userId) {
    _userSubscription = firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
          (snapshot) {
            final data = snapshot.data();

            if (!snapshot.exists || data == null) {
              _error = 'User profile was not found.';
              notifyListeners();
              return;
            }

            _heightCm = toDouble(data['heightCm']);
            _currentWeightKg = toDouble(data['weightKg']);
            _dateOfBirth = toNullableDateTime(data['dateOfBirth']);
            _goal = data['goal']?.toString().trim() ?? 'Maintenance';

            /*
         * Before the first weight record is loaded, use the profile's current
         * weight as the starting weight.
         */
            if (_weightRecords.isEmpty && _startingWeightKg <= 0) {
              _startingWeightKg = _currentWeightKg;
            }

            _error = null;
            notifyListeners();
          },
          onError: (Object error) {
            _error = _friendlyError(error);
            notifyListeners();
          },
        );
  }

  void _listenToWeightRecords(String userId) {
    _weightRecordsSubscription = firestore
        .collection('users')
        .doc(userId)
        .collection('weight_records')
        .orderBy('recordedAt', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            _weightRecords
              ..clear()
              ..addAll(snapshot.docs.map(WeightRecord.fromFirestore));

            _setStartingWeight();

            _error = null;
            notifyListeners();
          },
          onError: (Object error) {
            _error = _friendlyError(error);
            notifyListeners();
          },
        );
  }

  void _setStartingWeight() {
    if (_weightRecords.isEmpty) {
      _startingWeightKg = _currentWeightKg;
      return;
    }

    final firstRecord = _weightRecords.first;

    /*
     * The first historical record stores both the new weight and the weight
     * that existed before the update. Use previousWeightKg as the original
     * starting weight when available.
     */
    if (firstRecord.previousWeightKg > 0) {
      _startingWeightKg = firstRecord.previousWeightKg;
    } else {
      _startingWeightKg = firstRecord.weightKg;
    }
  }

  /// Updates users/{uid}.weightKg and creates a history record atomically.
  Future<bool> updateWeight(double newWeightKg) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      _error = 'User is not logged in.';
      notifyListeners();
      return false;
    }

    final validationMessage = validateWeight(newWeightKg);

    if (validationMessage != null) {
      _error = validationMessage;
      notifyListeners();
      return false;
    }

    if (_isUpdatingWeight) {
      return false;
    }

    final previousWeightKg = _currentWeightKg;

    try {
      _isUpdatingWeight = true;
      _error = null;
      notifyListeners();

      final userReference = firestore.collection('users').doc(user.uid);

      final weightRecordReference = userReference
          .collection('weight_records')
          .doc();

      final now = DateTime.now();
      final recordedDate = _dateOnlyString(now);

      final batch = firestore.batch();

      batch.update(userReference, {
        'weightKg': newWeightKg,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.set(weightRecordReference, {
        'userId': user.uid,
        'weightKg': newWeightKg,
        'previousWeightKg': previousWeightKg,
        'recordedDate': recordedDate,
        'recordedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      /*
       * The Firestore profile stream will also update this value. Assigning it
       * here makes the interface respond immediately after the write succeeds.
       */
      _currentWeightKg = newWeightKg;

      if (_startingWeightKg <= 0) {
        _startingWeightKg = previousWeightKg > 0
            ? previousWeightKg
            : newWeightKg;
      }

      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      _error = e.message ?? 'Failed to update weight.';
      notifyListeners();
      return false;
    } catch (e) {
      _error = _friendlyError(e);
      notifyListeners();
      return false;
    } finally {
      _isUpdatingWeight = false;
      notifyListeners();
    }
  }

  String? validateWeight(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Enter a valid weight.';
    }

    if (value <= 0) {
      return 'Weight must be greater than 0 kg.';
    }

    if (value < 20) {
      return 'Weight must be at least 20 kg.';
    }

    if (value > 400) {
      return 'Weight cannot exceed 400 kg.';
    }

    if (_currentWeightKg > 0 && (value - _currentWeightKg).abs() > 50) {
      return 'The weight change is too large. Check the entered value.';
    }

    return null;
  }

  void clearError() {
    if (_error == null) return;

    _error = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // BMI calculations
  // ---------------------------------------------------------------------------

  double get currentBmi =>
      calculateBmi(weightKg: _currentWeightKg, heightCm: _heightCm);

  double get startingBmi =>
      calculateBmi(weightKg: _startingWeightKg, heightCm: _heightCm);

  String get currentBmiText => currentBmi.toStringAsFixed(1);

  String get startingBmiText => startingBmi.toStringAsFixed(1);

  String get currentWeightText => '${_formatWeight(_currentWeightKg)} kg';

  String get startingWeightText => '${_formatWeight(_startingWeightKg)} kg';

  String get currentBmiCategory => bmiCategory(currentBmi);

  String get startingBmiCategory => bmiCategory(startingBmi);

  static double calculateBmi({
    required double weightKg,
    required double heightCm,
  }) {
    if (weightKg <= 0 || heightCm <= 0) {
      return 0;
    }

    final heightMetres = heightCm / 100;

    return weightKg / (heightMetres * heightMetres);
  }

  static String bmiCategory(double bmi) {
    if (bmi <= 0) return 'Unknown';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  // ---------------------------------------------------------------------------
  // Progress calculations
  // ---------------------------------------------------------------------------

  double get weightChangeKg => _currentWeightKg - _startingWeightKg;

  double get weightLostKg {
    final difference = _startingWeightKg - _currentWeightKg;
    return difference > 0 ? difference : 0;
  }

  double get weightGainedKg {
    final difference = _currentWeightKg - _startingWeightKg;
    return difference > 0 ? difference : 0;
  }

  double get bmiChange => currentBmi - startingBmi;

  String get weightChangeText {
    if (_startingWeightKg <= 0 || _currentWeightKg <= 0) {
      return '0.0 kg';
    }

    if (weightChangeKg < 0) {
      return '${weightLostKg.toStringAsFixed(1)} kg';
    }

    if (weightChangeKg > 0) {
      return '+${weightGainedKg.toStringAsFixed(1)} kg';
    }

    return '0.0 kg';
  }

  String get bmiChangeText {
    final change = bmiChange;

    if (change > 0) {
      return '+${change.toStringAsFixed(1)}';
    }

    return change.toStringAsFixed(1);
  }

  bool get isWeightReduced => weightChangeKg < 0;

  bool get isWeightIncreased => weightChangeKg > 0;

  bool get isCurrentBmiNormal => currentBmi >= 18.5 && currentBmi < 25;

  int get totalRecordedWeights => _weightRecords.length;

  String get progressPeriodText {
    if (_weightRecords.isEmpty) {
      return 'No previous records';
    }

    final firstDate = _weightRecords.first.recordedAt;
    final difference = DateTime.now().difference(firstDate);

    final weeks = (difference.inDays / 7).ceil();

    if (weeks <= 1) {
      return 'Last week';
    }

    return 'Last $weeks weeks';
  }

String get progressTitle {
  switch (bmiProgressState) {
    case BmiProgressState.improving:
      return 'Great progress!';

    case BmiProgressState.stable:
      return 'You are maintaining your current state';

    case BmiProgressState.declining:
      return 'Your BMI needs attention';

    case BmiProgressState.unavailable:
      return 'Progress unavailable';
  }
}


String get progressMessage {
  switch (bmiProgressState) {
    case BmiProgressState.improving:
      return 'Your BMI is moving toward a healthier range. '
          'Keep following your current plan.';

    case BmiProgressState.stable:
      return 'You are maintaining your current state. '
          'Keep going and stay focused.';

    case BmiProgressState.declining:
      return 'Your BMI is moving away from the healthy range. '
          'Please follow your plan more consistently.';

    case BmiProgressState.unavailable:
      return 'Add a valid height and weight to calculate your BMI progress.';
  }
}

  int get consecutiveNormalRecords {
    if (_weightRecords.isEmpty || _heightCm <= 0) {
      return isCurrentBmiNormal ? 1 : 0;
    }

    var count = 0;

    for (final record in _weightRecords.reversed) {
      final bmi = calculateBmi(weightKg: record.weightKg, heightCm: _heightCm);

      if (bmi >= 18.5 && bmi < 25) {
        count++;
      } else {
        break;
      }
    }

    return count;
  }
bool get showCongratulations {
  return startedOutsideNormalRange &&
      reachedNormalRange &&
      hasStableNormalBmi;
}

String get congratulationsMessage {
  if (!reachedNormalRange) {
    return progressMessage;
  }

  if (!startedOutsideNormalRange) {
    return 'Your BMI is currently within the normal range.';
  }

  if (!hasStableNormalBmi) {
    return 'You have reached the normal BMI range. '
        'Maintain it for two consecutive weeks to complete normalization.';
  }

  return 'Congratulations! You have reached a healthy BMI range '
      'and maintained it for two consecutive weeks.';
}
  static double distanceFromNormalRange(double bmi) {
    if (bmi <= 0) {
      return double.infinity;
    }

    if (bmi < 18.5) {
      return 18.5 - bmi;
    }

    if (bmi >= 25.0) {
      return bmi - 24.9;
    }

    return 0;
  }

  // ---------------------------------------------------------------------------
  // Trend data for BmiTrendCard
  // ---------------------------------------------------------------------------

  List<WeightRecord> get recentWeightRecords {
    if (_weightRecords.length <= 5) {
      return List.unmodifiable(_weightRecords);
    }

    return List.unmodifiable(_weightRecords.sublist(_weightRecords.length - 5));
  }

  List<double> get recentWeights {
    final records = recentWeightRecords;

    if (records.isEmpty && _currentWeightKg > 0) {
      return [_currentWeightKg];
    }

    return records.map((record) => record.weightKg).toList();
  }

  List<double> get recentBmis {
    return recentWeights
        .map((weight) => calculateBmi(weightKg: weight, heightCm: _heightCm))
        .toList();
  }

  double get maximumTrendWeight {
    if (recentWeights.isEmpty) return 1;

    return recentWeights.reduce(
      (current, next) => current > next ? current : next,
    );
  }

  double trendProgress(double weightKg) {
    final maximum = maximumTrendWeight;

    if (maximum <= 0) return 0;

    return (weightKg / maximum).clamp(0.0, 1.0);
  }

  String trendLabel(int index) => 'Record ${index + 1}';

  // ---------------------------------------------------------------------------
  // Parsing and formatting
  // ---------------------------------------------------------------------------

  static double toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  static DateTime toDateTime(dynamic value) {
    return toNullableDateTime(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? toNullableDateTime(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  static String _formatWeight(double value) {
    if (value <= 0) return '0';

    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  static String _dateOnlyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static String _friendlyError(Object error) {
    if (error is FirebaseException) {
      return error.message ?? 'A Firebase operation failed.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _weightRecordsSubscription?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Change the plan

  String _goal = 'Maintenance';
  String get goal => _goal;

  bool _isUpdatingGoal = false;
  bool get isUpdatingGoal => _isUpdatingGoal;

  bool get isMaintenancePlan {
    final normalizedGoal = _goal.trim().toLowerCase();

    return normalizedGoal == 'maintenance' ||
        normalizedGoal == 'maintain' ||
        normalizedGoal == 'maintenance plan';
  }

bool get canChangeToMaintenance {
  return !isMaintenancePlan &&
      startedOutsideNormalRange &&
      reachedNormalRange &&
      hasStableNormalBmi;
}

 Future<bool> changeToMaintenancePlan() async {
  final user = firebaseAuth.currentUser;

  if (user == null) {
    _error = 'User is not logged in.';
    notifyListeners();
    return false;
  }

  if (isMaintenancePlan) {
    return true;
  }

  if (!canChangeToMaintenance) {
    _error = maintenanceStatusText;
    notifyListeners();
    return false;
  }

  if (_isUpdatingGoal) {
    return false;
  }

  try {
    _isUpdatingGoal = true;
    _error = null;
    notifyListeners();

    final userReference = firestore.collection('users').doc(user.uid);

    final planHistoryReference = userReference
        .collection('plan_history')
        .doc();

    final batch = firestore.batch();

    batch.set(planHistoryReference, {
      'previousGoal': _goal,
      'newGoal': 'Maintenance',
      'weightKg': _currentWeightKg,
      'bmi': currentBmi,
      'changedAt': FieldValue.serverTimestamp(),
    });

    batch.update(userReference, {
      'goal': 'Maintenance',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    _goal = 'Maintenance';

    notifyListeners();
    return true;
  } on FirebaseException catch (e) {
    _error = e.message ?? 'Failed to update your goal.';
    notifyListeners();
    return false;
  } catch (e) {
    _error = _friendlyError(e);
    notifyListeners();
    return false;
  } finally {
    _isUpdatingGoal = false;
    notifyListeners();
  }
}


  String get weightStatLabel {
    if (_startingWeightKg <= 0 || _currentWeightKg <= 0) {
      return 'Weight Change';
    }

    if (isWeightReduced) {
      return 'Weight Lost';
    }

    if (isWeightIncreased) {
      return 'Weight Gained';
    }

    return 'Weight Change';
  }

  String get weightStatValue {
    if (_startingWeightKg <= 0 || _currentWeightKg <= 0) {
      return '0.0 kg';
    }

    if (isWeightReduced) {
      return '${weightLostKg.toStringAsFixed(1)} kg';
    }

    if (isWeightIncreased) {
      return '+${weightGainedKg.toStringAsFixed(1)} kg';
    }

    return '0.0 kg';
  }

  String get weightStatSubtitle {
    if (_weightRecords.isEmpty) {
      return 'No previous records';
    }

    final recordCount = _weightRecords.length;

    if (recordCount == 1) {
      return 'Based on 1 update';
    }

    return 'Based on $recordCount updates';
  }

  String get bmiStatSubtitle {
    if (startingBmi <= 0 || currentBmi <= 0) {
      return 'BMI data unavailable';
    }

    if (bmiChange < 0) {
      if (currentBmi >= 18.5 && currentBmi < 25) {
        return '↘ Now in normal range';
      }

      return '↘ BMI decreased';
    }

    if (bmiChange > 0) {
      if (currentBmi < 18.5) {
        return '↗ Moving toward normal';
      }

      return '↗ BMI increased';
    }

    return 'No BMI change';
  }

  IconData get weightStatIcon {
    if (isWeightReduced) {
      return Icons.trending_down_rounded;
    }

    if (isWeightIncreased) {
      return Icons.trending_up_rounded;
    }

    return Icons.remove_rounded;
  }

  IconData get bmiStatIcon {
    if (bmiChange < 0) {
      return Icons.trending_down_rounded;
    }

    if (bmiChange > 0) {
      return Icons.trending_up_rounded;
    }

    return Icons.remove_rounded;
  }


BmiProgressState get bmiProgressState {
  if (startingBmi <= 0 || currentBmi <= 0) {
    return BmiProgressState.unavailable;
  }

  final startingDistance = distanceFromNormalRange(startingBmi);
  final currentDistance = distanceFromNormalRange(currentBmi);

  final bmiDifference = (currentBmi - startingBmi).abs();

  // Small changes should be treated as stable.
  const stabilityBuffer = 0.2;

  if (bmiDifference <= stabilityBuffer) {
    return BmiProgressState.stable;
  }

  if (currentDistance < startingDistance) {
    return BmiProgressState.improving;
  }

  if (currentDistance > startingDistance) {
    return BmiProgressState.declining;
  }

  return BmiProgressState.stable;
}



int get consecutiveNormalWeeks {
  if (_heightCm <= 0 || _weightRecords.isEmpty) {
    return 0;
  }

  final weeklyLatestRecords = <String, WeightRecord>{};

  for (final record in _weightRecords) {
    if (record.recordedAt.millisecondsSinceEpoch <= 0) {
      continue;
    }

    final weekKey = _weekKey(record.recordedAt);

    final existingRecord = weeklyLatestRecords[weekKey];

    if (existingRecord == null ||
        record.recordedAt.isAfter(existingRecord.recordedAt)) {
      weeklyLatestRecords[weekKey] = record;
    }
  }

  final records = weeklyLatestRecords.values.toList()
    ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

  var count = 0;

  for (final record in records) {
    final bmi = calculateBmi(
      weightKg: record.weightKg,
      heightCm: _heightCm,
    );

    if (bmi >= 18.5 && bmi < 25.0) {
      count++;
    } else {
      break;
    }
  }

  return count;
}

static String _weekKey(DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);

  final monday = normalizedDate.subtract(
    Duration(days: normalizedDate.weekday - DateTime.monday),
  );

  final year = monday.year.toString().padLeft(4, '0');
  final month = monday.month.toString().padLeft(2, '0');
  final day = monday.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}

bool get startedOutsideNormalRange {
  return startingBmi > 0 &&
      (startingBmi < 18.5 || startingBmi >= 25.0);
}

bool get reachedNormalRange {
  return currentBmi >= 18.5 && currentBmi < 25.0;
}

bool get hasStableNormalBmi {
  return consecutiveNormalWeeks >= 2;
}



String get maintenanceStatusText {
  if (isMaintenancePlan) {
    return 'You are in the Maintenance Plan.';
  }

  if (!reachedNormalRange) {
    return 'Reach the normal BMI range to become eligible for Maintenance.';
  }

  if (!startedOutsideNormalRange) {
    return 'Your BMI started within the normal range.';
  }

  if (!hasStableNormalBmi) {
    final remainingWeeks = 2 - consecutiveNormalWeeks;

    return remainingWeeks == 1
        ? 'Maintain a normal BMI for 1 more week.'
        : 'Maintain a normal BMI for 2 consecutive weeks.';
  }

  return 'You are eligible to change to the Maintenance Plan.';
}

}
