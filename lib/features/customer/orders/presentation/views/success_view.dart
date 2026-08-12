import 'package:flutter/material.dart';
import 'orders_history_view.dart'; // تأكد إن مسار الملف ده صح عندك

class SuccessView extends StatefulWidget {
  const SuccessView({super.key});

  @override
  State<SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // إعداد متحكم الأنيميشن (هياخد نص ثانية عشان يكتمل)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // استخدام تأثير "الاستيك" (ElasticOut) عشان علامة الصح تظهر بشكل ناعم وجميل
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // تشغيل الأنيميشن أول ما الشاشة تفتح
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // علامة الصح المتحركة
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 140,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'تم تأكيد طلبك بنجاح! 🎉',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'شكراً لثقتك فينا.\nجاري تحضير طلبك وسيتم توصيله في أقرب وقت.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 50),

              // زرار الانتقال لسجل الطلبات
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
                    // تفريغ الشاشات السابقة والانتقال لسجل الطلبات
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersHistoryView(),
                      ),
                    );
                  },
                  child: const Text(
                    'متابعة حالة الطلب',
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
      ),
    );
  }
}
