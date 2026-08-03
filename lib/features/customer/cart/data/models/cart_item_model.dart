import 'package:restaurant_app/features/customer/menu/data/models/meal_model.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';

class CartItemModel {
  final MealEntity meal;
  int quantity;

  CartItemModel({required this.meal, this.quantity = 1});

  // حساب السعر الإجمالي للعنصر بناءً على الكمية
  double get totalPrice => meal.price * quantity;

  Map<String, dynamic> toFirestore() {
    // يحول الـ meal إلى MealModel لو كانت مجرد MealEntity
    final mealModel = (meal is MealModel)
        ? (meal as MealModel)
        : MealModel(
            id: meal.id,
            name: meal.name,
            description: meal.description,
            price: meal.price,
            imageUrl: meal.imageUrl,
            category: meal.category,
          );

    return {
      'meal': mealModel.toFirestore(),
      'mealId': meal.id, // فائدة إضافية: حفظ الـ id بشكل منفصل للسهولة
      'quantity': quantity,
    };
  }

  // 2. قراءة الـ CartItem من Firestore
  factory CartItemModel.fromFirestore(Map<String, dynamic> json) {
    final mealData = json['meal'] as Map<String, dynamic>;
    final mealId = json['mealId'] ?? '';

    return CartItemModel(
      meal: MealModel.fromFirestore(mealData, mealId),
      quantity: json['quantity'] ?? 1,
    );
  }
}
