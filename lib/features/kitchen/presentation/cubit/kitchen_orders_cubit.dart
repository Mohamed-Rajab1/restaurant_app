import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';
import 'kitchen_orders_state.dart';

class KitchenOrdersCubit extends Cubit<KitchenOrdersState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  KitchenOrdersCubit() : super(KitchenOrdersInitial());

  // الاستماع فقط للطلبات النشطة في المطبخ (pending & preparing)
  void listenToKitchenOrders() {
    emit(KitchenOrdersLoading());
    _subscription?.cancel();

    _subscription = _firestore
        .collection('orders')
        .where(
          'status',
          whereIn: ['pending', 'preparing'],
        ) // فلترة حتمية للمطبخ
        .snapshots()
        .listen(
          (snapshot) {
            final orders = snapshot.docs
                .map((doc) => OrderModel.fromFirestore(doc))
                .toList();

            // ترتيب الطلبات أفقياً حسب الوقت (الأقدم أولاً لأن الأقدم لازم يتعمل الأول!)
            orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));

            emit(KitchenOrdersSuccess(orders: orders));
          },
          onError: (error) {
            emit(
              KitchenOrdersFailure(
                errMessage: 'خطأ في استقبال طلبات المطبخ: ${error.toString()}',
              ),
            );
          },
        );
  }

  // تحديث حالة الطلب من المطبخ (مثلاً: تغيير من preparing إلى ready)
  Future<void> markOrderAsReady(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'ready',
      });
    } catch (e) {
      emit(
        KitchenOrdersFailure(
          errMessage: 'فشل تغيير حالة الطلب: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
