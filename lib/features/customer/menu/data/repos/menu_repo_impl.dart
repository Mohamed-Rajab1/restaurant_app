import 'package:dartz/dartz.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repos/menu_repo.dart';
import '../data_sources/menu_remote_data_source.dart';

class MenuRepoImpl implements MenuRepo {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<MealEntity>>> getMeals({String? category}) async {
    try {
      final meals = await remoteDataSource.getMeals(category: category);
      return Right(meals);
    } catch (e) {
      return Left('حدث خطأ أثناء جلب الوجبات: ${e.toString()}');
    }
  }
}
