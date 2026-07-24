import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repos/menu_repo.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo menuRepo;

  MenuCubit(this.menuRepo) : super(MenuInitialState());

  Future<void> fetchMeals({String? category}) async {
    emit(MenuLoadingState());
    try {
      final result = await menuRepo.getMeals(category: category);

      result.fold(
        (failure) => emit(MenuFailureState(failure)),
        (meals) => emit(MenuSuccessState(meals)),
      );
    } on Exception catch (e) {
      emit(MenuFailureState('حدث خطأ أثناء جلب الوجبات: ${e.toString()}'));
    }
  }
}
