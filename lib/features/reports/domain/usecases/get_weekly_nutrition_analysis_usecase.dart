import '../entities/weekly_nutrition_analysis.dart';
import '../repositories/weekly_nutrition_repository.dart';

class GetWeeklyNutritionAnalysisUseCase {
  const GetWeeklyNutritionAnalysisUseCase(
    this.repository,
  );

  final WeeklyNutritionRepository repository;

  Future<WeeklyNutritionAnalysis> call({
    DateTime? endDate,
  }) {
    return repository.getWeeklyAnalysis(
      endDate: endDate ?? DateTime.now(),
    );
  }
}