import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/cashier/presentation/manager/cashier_cubit/cashier_orders_cubit.dart';
import 'package:restaurant_app/features/customer/orders/data/models/order_model.dart';

class CashierOrderCard extends StatelessWidget {
  final OrderModel order;

  const CashierOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الكارت: رقم الطلب والحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب رقم: #${order.id?.substring(0, 6) ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const Divider(),

            // بيانات التوصيل
            Text(
              '📱 الهاتف: ${order.phone}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              '📍 العنوان: ${order.address}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),

            // أصناف الطلب
            const Text(
              'الوجبات المطلوبة:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: order.items
                    .map(
                      (item) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.meal.name}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            '${item.totalPrice.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),

            // الإجمالي ودوال التحكم بالحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي: ${order.totalPrice.toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                _buildActionButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // أزرار التحكم بالحالة بناءً على الحالة الحالية للطلب
  Widget _buildActionButtons(BuildContext context) {
    final cubit = context.read<CashierOrdersCubit>();
    if (order.id == null) return const SizedBox.shrink();

    switch (order.status) {
      case 'pending':
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          icon: const Icon(Icons.restaurant, color: Colors.white, size: 18),
          label: const Text(
            'بدء التحضير',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => cubit.updateOrderStatus(
            orderId: order.id!,
            newStatus: 'preparing',
          ),
        );
      case 'preparing':
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade800,
          ),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 18,
          ),
          label: const Text(
            'جاهز للتسليم',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () =>
              cubit.updateOrderStatus(orderId: order.id!, newStatus: 'ready'),
        );
      case 'ready':
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          icon: const Icon(Icons.done_all, color: Colors.white, size: 18),
          label: const Text(
            'تم التسليم',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => cubit.updateOrderStatus(
            orderId: order.id!,
            newStatus: 'delivered',
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'معلق';
        break;
      case 'preparing':
        color = Colors.blue;
        label = 'قيد التحضير';
        break;
      case 'ready':
        color = Colors.amber.shade800;
        label = 'جاهز';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'تم التسليم';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'ملغى';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
