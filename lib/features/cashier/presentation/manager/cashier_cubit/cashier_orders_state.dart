import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';

abstract class CashierOrdersState {}

class CashierOrdersInitial extends CashierOrdersState {}

class CashierOrdersLoading extends CashierOrdersState {}

class CashierOrdersSuccess extends CashierOrdersState {
  final List<OrderModel> orders;
  CashierOrdersSuccess({required this.orders});
}

class CashierOrdersFailure extends CashierOrdersState {
  final String errMessage;
  CashierOrdersFailure({required this.errMessage});
}
