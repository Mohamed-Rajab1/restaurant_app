import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

// حالات إرسال طلب جديد
class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderFailure extends OrderState {
  final String errMessage;
  OrderFailure({required this.errMessage});
}

// حالات جلب سجل الطلبات
class OrdersFetchLoading extends OrderState {}

class OrdersFetchSuccess extends OrderState {
  final List<OrderModel> orders;
  OrdersFetchSuccess({required this.orders});
}

class OrdersFetchFailure extends OrderState {
  final String errMessage;
  OrdersFetchFailure({required this.errMessage});
}

class OrderPaymentMethodChanged extends OrderState {}

class OrderPaymentUrlGenerated extends OrderState {
  final String paymentUrl;
  OrderPaymentUrlGenerated(this.paymentUrl);
}
