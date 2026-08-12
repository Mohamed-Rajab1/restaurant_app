import 'package:dio/dio.dart';

class PaymobService {
  // 1. الثوابت (المفاتيح اللي هنجيبها من حساب بيموب)
  static const String _apiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRJeE1UQXdOQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5MS0tOQUx4T25ZcTBsSFlkbXViaXR2MUtNQW04bTZRQWUxeDY4RUtqaTJHX0F4ME5GT0dfa1pKWGJRZC1aMmw3YzdScnNUeHhOTjMxTGpvZi1MajFDUQ==";
  static const String _integrationId = "5822606";
  static const String _iframeId = "1067129";

  // دالة واحدة بتنفذ الـ 3 خطوات ورا بعض
  static Future<String> getPaymentUrl({required double amount}) async {
    try {
      final dio = Dio();

      // ==========================================
      // الخطوة 1: التوثيق (Authentication)
      // ==========================================
      // بنبعت الـ API Key لبيموب عشان تدينا "توكن" (تصريح دخول مؤقت)
      final authResponse = await dio.post(
        'https://accept.paymob.com/api/auth/tokens',
        data: {"api_key": _apiKey},
      );
      final String authToken = authResponse.data['token'];

      // ==========================================
      // الخطوة 2: تسجيل الطلب (Order Registration)
      // ==========================================
      // بنقول لبيموب إن فيه أوردر جديد بالمبلغ الفلاني
      final orderResponse = await dio.post(
        'https://accept.paymob.com/api/ecommerce/orders',
        data: {
          "auth_token": authToken, // التصريح اللي لسه واخدينه
          "delivery_needed": "false", // هل بيموب هيوصل الطلب؟ لأ طبعاً
          "amount_cents": (amount * 100).toInt().toString(), // المبلغ بالقرش
          "currency": "EGP", // العملة جنيه مصري
          "items": [], // ممكن نسيبها فاضية
        },
      );
      final String orderId = orderResponse.data['id'].toString();

      // ==========================================
      // الخطوة 3: الحصول على مفتاح الدفع (Payment Key)
      // ==========================================
      // دي أهم خطوة، بناخد فيها المفتاح النهائي اللي هيفتح الشاشة
      final paymentKeyResponse = await dio.post(
        'https://accept.paymob.com/api/acceptance/payment_keys',
        data: {
          "auth_token": authToken,
          "amount_cents": (amount * 100).toInt().toString(),
          "expiration": 3600, // الشاشة دي تقفل بعد ساعة لو مدفعش
          "order_id": orderId,
          "billing_data": {
            // بيموب بتشترط بيانات الزبون، هنبعت بيانات افتراضية للتسهيل
            "first_name": "Customer",
            "last_name": "Name",
            "email": "customer@restaurant.com",
            "phone_number": "01000000000",
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "Cairo",
            "country": "EG",
            "state": "NA",
          },
          "currency": "EGP",
          "integration_id": _integrationId, // رقم تعريف الفيزا
        },
      );
      final String finalToken = paymentKeyResponse.data['token'];

      // ==========================================
      // الخطوة 4: فتح شاشة الدفع
      // ==========================================
      // نجهز اللينك اللي الزبون هيدفع عليه باستخدام التوكن النهائي
      final String paymentUrl =
          'https://accept.paymob.com/api/acceptance/iframes/$_iframeId?payment_token=$finalToken';

      // نفتح اللينك جوه التطبيق
      return paymentUrl; // نرجع اللينك عشان ممكن نستخدمه في WebView أو أي حاجة تانية
    } catch (e) {
      throw Exception("حدث خطأ أثناء محاولة فتح صفحة الدفع: $e");
    }
  }
}
