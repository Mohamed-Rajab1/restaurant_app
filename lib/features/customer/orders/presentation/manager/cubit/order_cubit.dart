import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CartCubit cartCubit;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrderCubit(this.cartCubit) : super(OrderInitial());

  // 1. إنشاء طلب جديد وتخزينه في Firestore
  Future<void> placeOrder({
    required String address,
    required String phone,
  }) async {
    emit(OrderLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(
          OrderFailure(
            errMessage: 'يرجى تسجيل الدخول أولاً للتمكن من إتمام الطلب',
          ),
        );
        return;
      }

      if (cartCubit.items.isEmpty) {
        emit(OrderFailure(errMessage: 'السلة فارغة، أضف بعض الوجبات أولاً'));
        return;
      }

      final order = OrderModel(
        userId: user.uid,
        items: List.from(cartCubit.items), // نسخة من العناصر
        totalPrice: cartCubit.calculateTotalPrice(),
        address: address,
        phone: phone,
        createdAt: DateTime.now(),
      );

      // حفظ في كولكشن orders
      await _firestore.collection('orders').add(order.toFirestore());

      // تفريغ السلة فور نجاح الحفظ
      cartCubit.clearCart();

      emit(OrderSuccess());
    } catch (e) {
      emit(
        OrderFailure(errMessage: 'حدث خطأ أثناء إرسال الطلب: ${e.toString()}'),
      );
    }
  }

  // 2. جلب طلبات المستخدم السابقة
  Future<void> fetchMyOrders() async {
    emit(OrdersFetchLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(OrdersFetchFailure(errMessage: 'المستخدم غير مسجل'));
        return;
      }

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      emit(OrdersFetchSuccess(orders: orders));
    } catch (e) {
      emit(
        OrdersFetchFailure(
          errMessage: 'فشل في جلب قائمة الطلبات: ${e.toString()}',
        ),
      );
    }
  }
}
