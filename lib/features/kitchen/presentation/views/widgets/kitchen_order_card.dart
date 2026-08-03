import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';
import '../../cubit/kitchen_orders_cubit.dart';

class KitchenOrderCard extends StatelessWidget {
  final OrderModel order;

  const KitchenOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    bool isPreparing = order.status == 'pending';

    return Container(
      width: double
          .infinity, // عرض مناسب عشان تترتب كروت جنب بعض (Grid / Horizontal List)
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPreparing ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPreparing ? Colors.orange : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: رقم الطلب والحالة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPreparing ? Colors.orange : Colors.grey.shade800,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب #${order.id?.substring(0, 5) ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  isPreparing ? '👨‍🍳 قيد التحضير' : '⏳ جديد',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // قائمة الاصناف المفهومة للشيف
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Row(
                  children: [
                    // دائرة الكمية
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.red.shade400,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // اسم الوجبة
                    Expanded(
                      child: Text(
                        item.meal.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // زرار الإنهاء والطلب جاهز
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                'جاهز للتسليم ✔️',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (order.id != null) {
                  context.read<KitchenOrdersCubit>().markOrderAsReady(
                    order.id!,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
