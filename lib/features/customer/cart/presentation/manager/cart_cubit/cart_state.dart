import 'package:restaurant_app/features/customer/cart/data/models/cart_item_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartUpdatedState extends CartState {
  final List<CartItemModel> items;
  final double totalPrice;

  CartUpdatedState({required this.items, required this.totalPrice});
}
