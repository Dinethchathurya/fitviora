import '../entities/daily_report.dart';
import '../repositories/report_repository.dart';

class GetDailyReportUseCase {
  const GetDailyReportUseCase(this.repository);

  final ReportRepository repository;

  Future<DailyReport> call({
    required DateTime date,
  }) {
    return repository.getDailyReport(
      date: date,
    );
  }
}