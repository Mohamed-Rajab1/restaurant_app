import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/services/service_locator.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_cubit.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_state.dart';
import 'orders_history_view.dart';

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
          listener: (context, state) {
            if (state is OrderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلبك بنجاح! 🎉'),
                  backgroundColor: Colors.green,
                ),
              );

              // الانتقال لشاشة سجل الطلبات ومسح شاشات التمهيد
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersHistoryView(),
                ),
              );
            } else if (state is OrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
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

                    // طريقة الدفع (Default: Cash)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.money, color: Colors.green),
                        title: const Text('طريقة الدفع'),
                        subtitle: const Text(
                          'الدفع كاش عند الاستلام (Cash on Delivery)',
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
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
                                  context.read<OrderCubit>().placeOrder(
                                    address: _addressController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                  );
                                }
                              },
                        child: state is OrderLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'تأكيد الطلب الآن',
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
          },
        ),
      ),
    );
  }
}
