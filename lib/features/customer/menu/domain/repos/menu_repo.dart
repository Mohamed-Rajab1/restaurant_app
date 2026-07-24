// features/customer/menu/domain/repos/menu_repo.dart
import 'package:dartz/dartz.dart';
import '../entities/meal_entity.dart';

abstract class MenuRepo {
  // بنستخدم Either لتمرير إما الخطأ (Failure) أو قائمة الوجبات (List<MealEntity>)
  Future<Either<String, List<MealEntity>>> getMeals({String? category});
}
