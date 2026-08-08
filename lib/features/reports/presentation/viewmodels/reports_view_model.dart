import 'package:flutter/foundation.dart';

import '../../data/datasources/report_remote_data_source.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/entities/daily_report.dart';
import '../../domain/usecases/get_daily_report_usecase.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel({
    GetDailyReportUseCase? getDailyReportUseCase,
  }) : _getDailyReportUseCase =
            getDailyReportUseCase ??
                GetDailyReportUseCase(
                  ReportRepositoryImpl(
                    remoteDataSource:
                        const ReportRemoteDataSource(),
                  ),
                );

  final GetDailyReportUseCase
      _getDailyReportUseCase;

  DailyReport? _report;

  DailyReport? get report => _report;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  bool get hasData => _report != null;

  Future<void> loadReport({
    DateTime? date,
  }) async {
    if (_isLoading) {
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _report =
          await _getDailyReportUseCase(
        date: date ?? DateTime.now(),
      );
    } catch (e) {
      _error = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadReport(
      date: _report?.date ??
          DateTime.now(),
    );
  }

  // ---------------------------------------------------------------------------
  // UI-friendly getters
  // ---------------------------------------------------------------------------

  String get dateLabel =>
      _report?.dateLabel ?? '';

  String get calorieText =>
      _report?.calorieText ??
      '0 / 0 kcal';

  double get calorieProgress =>
      _report?.calorieProgress ?? 0;

  String get proteinText =>
      _report?.proteinText ??
      '0g / 0g';

  String get carbsText =>
      _report?.carbsText ??
      '0g / 0g';

  String get fatText =>
      _report?.fatText ??
      '0g / 0g';

  double get proteinProgress =>
      _report?.proteinProgress ?? 0;

  double get carbsProgress =>
      _report?.carbsProgress ?? 0;

  double get fatProgress =>
      _report?.fatProgress ?? 0;

  String get proteinPercentText =>
      '${_report?.proteinPercentage ?? 0}%';

  String get carbsPercentText =>
      '${_report?.carbsPercentage ?? 0}%';

  String get fatPercentText =>
      '${_report?.fatPercentage ?? 0}%';

  String get calorieAdherenceText =>
      '${_report?.caloriePercentage ?? 0}%';

  List<NutrientGap> get nutrientGaps =>
      _report?.nutrientGaps ??
      const [];

  List<SuggestedReportFood>
      get suggestedFoods =>
          _report?.suggestedFoods ??
          const [];

  String get statusTitle =>
      _report?.statusTitle ??
      'Daily Report';

  String get statusMessage =>
      _report?.statusMessage ??
      'No report data available.';
}