import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 1. استدعاء فايربيز هنا
import 'package:restaurant_app/features/auth/presentation/views/login_view.dart';
import 'package:restaurant_app/features/customer/cart/data/models/cart_item_model.dart';
import 'package:restaurant_app/features/customer/orders/presentation/views/checkout_view.dart';
// 👇 2. استدعي شاشة تسجيل الدخول بتاعتك هنا (تأكد من المسار الصحيح)
// import 'package:restaurant_app/features/auth/presentation/views/login_view.dart';

class CartSummarySection extends StatelessWidget {
  final double totalPrice;
  final List<CartItemModel> cartItems;

  const CartSummarySection({
    super.key,
    required this.totalPrice,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // تفاصيل الحساب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${totalPrice.toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  ':المجموع الإجمالي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // زرار إتمام الطلب (Checkout)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('السلة فارغة!')),
                    );
                    return;
                  }

                  // 👈 3. الكود الجديد للتحقق من حالة المستخدم
                  final currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser == null) {
                    // المستخدم زائر (غير مسجل دخول) -> إظهار نافذة التنبيه
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'تسجيل الدخول مطلوب 🔒',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'يرجى تسجيل الدخول أو إنشاء حساب لإتمام طلبك ومتابعته بنجاح.',
                          textAlign: TextAlign.right,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // قفل النافذة
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            onPressed: () {
                              Navigator.pop(context); // قفل النافذة أولاً

                              // التوجيه لشاشة تسجيل الدخول
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // افترضت اسم الشاشة LoginView، قم بتعديلها لتناسب مشروعك
                                  builder: (context) => const LoginView(),
                                ),
                              );
                            },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // المستخدم مسجل دخول -> التوجه لصفحة إتمام الطلب مباشرة
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutView(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'إتمام الطلب',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
