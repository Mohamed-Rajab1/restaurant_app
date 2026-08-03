import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';
import 'cashier_orders_state.dart';

class CashierOrdersCubit extends Cubit<CashierOrdersState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _ordersSubscription;

  CashierOrdersCubit() : super(CashierOrdersInitial());

  // 1. استماع لحظي للطلبات (Real-time stream) مرتبة من الأحدث للأقدم
  void listenToOrders() {
    emit(CashierOrdersLoading());
    _ordersSubscription?.cancel();
    _ordersSubscription = _firestore
        .collection('orders')
        .snapshots()
        .listen(
          (snapshot) {
            final orders = snapshot.docs
                .map((doc) => OrderModel.fromFirestore(doc))
                .toList();

            // ترتيب الطلبات من الأحدث للأقدم محلياً
            orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            emit(CashierOrdersSuccess(orders: orders));
          },
          onError: (error) {
            emit(
              CashierOrdersFailure(
                errMessage: 'حدث خطأ أثناء جلب الطلبات: ${error.toString()}',
              ),
            );
          },
        );
  }

  // 2. تحديث حالة الطلب (pending -> preparing -> ready -> delivered -> cancelled)
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      emit(
        CashierOrdersFailure(
          errMessage: 'فشل في تحديث حالة الطلب: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
