import '../entities/daily_report.dart';

abstract class ReportRepository {
  Future<DailyReport> getDailyReport({
    required DateTime date,
  });
}