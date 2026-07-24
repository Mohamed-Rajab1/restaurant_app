import '../../../domain/entities/meal_entity.dart';

abstract class MenuState {}

class MenuInitialState extends MenuState {}

class MenuLoadingState extends MenuState {}

class MenuSuccessState extends MenuState {
  final List<MealEntity> meals;
  MenuSuccessState(this.meals);
}

class MenuFailureState extends MenuState {
  final String errorMessage;
  MenuFailureState(this.errorMessage);
}
