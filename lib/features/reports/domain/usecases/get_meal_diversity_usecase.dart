import '../entities/meal_diversity_analysis.dart';
import '../repositories/meal_diversity_repository.dart';

class GetMealDiversityUseCase {
  const GetMealDiversityUseCase(
    this.repository,
  );

  final MealDiversityRepository repository;

  Future<MealDiversityAnalysis> call({
    DateTime? date,
  }) {
    return repository.getMealDiversity(
      endDate: date ?? DateTime.now(),
      numberOfDays: 7,
    );
  }
}