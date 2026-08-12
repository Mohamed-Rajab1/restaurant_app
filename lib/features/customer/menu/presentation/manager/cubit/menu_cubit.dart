import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';
import '../../../domain/repos/menu_repo.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo menuRepo;
  List<MealEntity> _allMeals = [];
  MenuCubit(this.menuRepo) : super(MenuInitialState());

  Future<void> fetchMeals({String? category}) async {
    emit(MenuLoadingState());
    try {
      final result = await menuRepo.getMeals(category: category);

      // 👈 السطر السحري الأول: التأكد إن الكيوبت لسه عايش بعد ما الفايربيز رد
      if (isClosed) return;

      _allMeals = result.fold((failure) => [], (meals) => meals);
      result.fold(
        (failure) => emit(MenuFailureState(failure)),
        (meals) => emit(MenuSuccessState(meals)),
      );
    } on Exception catch (e) {
      // 👈 السطر السحري الثاني: التأكد برضه قبل إرسال حالة الخطأ
      if (isClosed) return;

      emit(MenuFailureState('حدث خطأ أثناء جلب الوجبات: ${e.toString()}'));
    }
  }

  Future<void> searchMeals(String query) async {
    emit(MenuLoadingState());

    try {
      if (query.isEmpty) {
        // إذا كان الاستعلام فارغًا، نعيد جميع الوجبات
        emit(MenuSuccessState(_allMeals));
        return;
      } else {
        // إذا كان هناك استعلام، نقوم بالبحث في قائمة الوجبات المخزنة
        final filteredMeals = _allMeals
            .where(
              (meal) => meal.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        emit(MenuSuccessState(filteredMeals));
      }
    } on Exception catch (e) {
      emit(MenuFailureState('حدث خطأ أثناء البحث عن الوجبات: ${e.toString()}'));
    }
  }
}
