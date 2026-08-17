import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/services/service_locator.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_cubit.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_state.dart';
import 'package:restaurant_app/features/customer/orders/presentation/views/success_view.dart';
import 'package:restaurant_app/payment/paymob_webview.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('إتمام الطلب'), centerTitle: true),
        body: BlocConsumer<OrderCubit, OrderState>(
          // 👈 جعلنا الـ listener يعمل بشكل غير متزامن (async) عشان يقدر ينتظر نتيجة الـ WebView
          listener: (context, state) async {
            if (state is OrderSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SuccessView()),
              );
            } else if (state is OrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // 👈 التعديل الجديد: اصطياد حالة جاهزية رابط الدفع
            else if (state is OrderPaymentUrlGenerated) {
              // فتح شاشة الـ WebView وانتظار النتيجة (true أو false)
              final isSuccess = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymobWebView(paymentUrl: state.paymentUrl),
                ),
              );

              // التحقق من النتيجة بعد قفل شاشة الدفع
              if (isSuccess == true) {
                if(!context.mounted) return;
                // الدفع تم بنجاح، نأمر الـ Cubit بحفظ الأوردر في الفايربيز
                context.read<OrderCubit>().saveOrderToFirebase(
                  address: _addressController.text.trim(),
                  phone: _phoneController.text.trim(),
                );
              } else {
                if(!context.mounted) return;
                // المستخدم ألغى العملية أو الدفع فشل
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إلغاء عملية الدفع أو فشلت'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            // سحبنا الكيوبت هنا عشان نقدر نقرأ منه طريقة الدفع الحالية
            final cubit = context.read<OrderCubit>();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عنوان التوصيل وبيانات التواصل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // input العنوان
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'العنوان بالتفصيل (المنطقة، الشارع، المبنى)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'يرجى إدخال العنوان'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // input الهاتف
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف للتواصل',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'يرجى إدخال رقم الهاتف'
                          : null,
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      'طريقة الدفع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // استخدام RadioGroup حسب أحدث إصدار لفلاتر
                    RadioGroup<String>(
                      groupValue: cubit.selectedPaymentMethod,
                      onChanged: (String? val) {
                        if (val != null) {
                          cubit.changePaymentMethod(val);
                        }
                      },
                      child: Column(
                        children: [
                          _buildPaymentOption(
                            context: context,
                            cubit: cubit,
                            title: 'الدفع كاش عند الاستلام',
                            value: 'cash',
                            icon: Icons.money,
                            iconColor: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentOption(
                            context: context,
                            cubit: cubit,
                            title: 'الدفع بالبطاقة (فيزا / ماستركارد)',
                            value: 'visa',
                            icon: Icons.credit_card,
                            iconColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // زرار الإرسال
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
                        onPressed: state is OrderLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // استدعاء دالة تأكيد الطلب، والكيوبت هيتصرف حسب طريقة الدفع
                                  cubit.placeOrder(
                                    address: _addressController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                  );
                                }
                              },
                        child: state is OrderLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                // لو مختار فيزا نغير النص عشان الزبون يبقى عارف إنه هيدفع أونلاين
                                cubit.selectedPaymentMethod == 'visa'
                                    ? 'المتابعة للدفع أونلاين'
                                    : 'تأكيد الطلب الآن',
                                style: const TextStyle(
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
          },
        ),
      ),
    );
  }

  // دالة مساعدة (Helper Method) لرسم مربع خيار الدفع بشكل احترافي
  Widget _buildPaymentOption({
    required BuildContext context,
    required OrderCubit cubit,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    // التحقق هل هذا الخيار هو المحدد حالياً أم لا
    final isSelected = cubit.selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        // عند الضغط، نرسل القيمة الجديدة للكيوبت
        cubit.changePaymentMethod(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // الكود النظيف بعد تحديث فلاتر الأخير
            Radio<String>(
              value: value,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
