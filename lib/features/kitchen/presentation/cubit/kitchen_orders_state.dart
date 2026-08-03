import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';

abstract class KitchenOrdersState {}

class KitchenOrdersInitial extends KitchenOrdersState {}

class KitchenOrdersLoading extends KitchenOrdersState {}

class KitchenOrdersSuccess extends KitchenOrdersState {
  final List<OrderModel> orders;
  KitchenOrdersSuccess({required this.orders});
}

class KitchenOrdersFailure extends KitchenOrdersState {
  final String errMessage;
  KitchenOrdersFailure({required this.errMessage});
}
