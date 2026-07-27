import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/data/models/cart_item_model.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());

  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get items => _cartItems;

  // 1. إضافة وجبة للسلة
  void addToCart(MealEntity meal) {
    // البحث لو كانت الوجبة موجودة بالفعل
    final index = _cartItems.indexWhere((item) => item.meal.id == meal.id);

    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItemModel(meal: meal));
    }
    _emitCartState();
  }

  // 2. تزويد الكمية
  void incrementQuantity(CartItemModel item) {
    item.quantity++;
    _emitCartState();
  }

  // 3. تقليل الكمية أو الحذف عند الوصول لـ 0
  void decrementQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }
    _emitCartState();
  }

  // 4. حذف عنصر بالكامل
  void removeFromCart(CartItemModel item) {
    _cartItems.remove(item);
    _emitCartState();
  }

  // 5. تفريغ السلة بعد الطلب
  void clearCart() {
    _cartItems.clear();
    _emitCartState();
  }

  // حساب السعر الكلي للطلبات
  double calculateTotalPrice() {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void _emitCartState() {
    emit(
      CartUpdatedState(
        items: List.from(_cartItems),
        totalPrice: calculateTotalPrice(),
      ),
    );
  }
}
