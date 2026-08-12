import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';
import 'package:restaurant_app/payment/paymob_service.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CartCubit cartCubit;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1️⃣ [جديد] متغير لتخزين طريقة الدفع المختارة (كاش كوضع افتراضي)
  String selectedPaymentMethod = 'cash';

  OrderCubit(this.cartCubit) : super(OrderInitial());

  // 2️⃣ [جديد] دالة لتغيير طريقة الدفع من واجهة المستخدم
  void changePaymentMethod(String method) {
    selectedPaymentMethod = method;
    emit(OrderPaymentMethodChanged()); // حالة جديدة عشان الـ UI يتحدث
  }

  // 3️⃣ إنشاء طلب جديد (تم دمج الدفع بالفيزا هنا)
  // 1. الدالة الأولى: توجيه الطلب
  Future<void> placeOrder({
    required String address,
    required String phone,
  }) async {
    emit(OrderLoading());
    try {
      if (cartCubit.items.isEmpty) return;
      final totalPrice = cartCubit.calculateTotalPrice();

      if (selectedPaymentMethod == 'visa') {
        await Future.delayed(
          const Duration(milliseconds: 300),
        ); // محاكاة انتظار
        // لو فيزا، نجيب الرابط ونرمي حالة عشان الـ UI يفتح الـ WebView
        final paymentUrl = await PaymobService.getPaymentUrl(
          amount: totalPrice.toDouble(),
        );
        emit(OrderPaymentUrlGenerated(paymentUrl));
      } else {
        // لو كاش، نحفظ في الفايربيز علطول
        await saveOrderToFirebase(address: address, phone: phone);
      }
    } catch (e) {
      emit(OrderFailure(errMessage: e.toString()));
    }
  }

  // 2. الدالة الثانية: الحفظ الفعلي في الفايربيز (تُستدعى بعد نجاح الدفع أو في حالة الكاش)
  Future<void> saveOrderToFirebase({
    required String address,
    required String phone,
  }) async {
    emit(OrderLoading()); // تحميل أثناء الرفع للفايربيز
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final orderData = OrderModel(
        userId: user.uid,
        items: List.from(cartCubit.items),
        totalPrice: cartCubit.calculateTotalPrice(),
        address: address,
        phone: phone,
        createdAt: DateTime.now(),
      ).toFirestore();

      orderData['paymentMethod'] = selectedPaymentMethod;
      orderData['status'] = 'pending';

      await _firestore.collection('orders').add(orderData);
      cartCubit.clearCart();
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure(errMessage: 'فشل حفظ الطلب: $e'));
    }
  }

  // 7️⃣ جلب طلبات المستخدم السابقة (زي ما هي بدون تغيير)
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

  // 8️⃣ [جديد] دالة مسح سجل الطلبات المكتملة فقط
  Future<void> clearDeliveredOrdersHistory() async {
    emit(OrderLoading()); // ممكن نستخدم نفس حالة التحميل
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // نجيب الطلبات اللي بتاعت اليوزر ده + حالتها "delivered"
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'delivered')
          .get();

      if (querySnapshot.docs.isEmpty) {
        emit(OrderFailure(errMessage: 'لا توجد طلبات مكتملة لمسحها.'));
        return;
      }

      // استخدام الـ Batch للمسح دفعة واحدة
      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // بعد ما مسحنا، نجيب الداتا من تاني عشان الشاشة تتحدث وتفضى
      await fetchMyOrders();

      // ملاحظة: مش بنعمل emit لـ Success هنا لأن الدالة بتاعة fetchMyOrders هتعمل emit لـ OrdersFetchSuccess
    } catch (e) {
      emit(OrderFailure(errMessage: 'حدث خطأ أثناء مسح السجل: $e'));
    }
  }
}
