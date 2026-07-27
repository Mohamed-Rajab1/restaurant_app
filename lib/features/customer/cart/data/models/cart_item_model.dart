import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';

class CartItemModel {
  final MealEntity meal;
  int quantity;

  CartItemModel({required this.meal, this.quantity = 1});

  // حساب السعر الإجمالي للعنصر بناءً على الكمية
  double get totalPrice => meal.price * quantity;
}
