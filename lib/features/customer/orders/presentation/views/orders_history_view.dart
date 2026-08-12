import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/services/service_locator.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_cubit.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_state.dart';
import '../../data/models/order_model.dart';

class OrdersHistoryView extends StatelessWidget {
  const OrdersHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderCubit>()..fetchMyOrders(),
      child: Scaffold(
        appBar: AppBar(title: const Text('طلباتي'), centerTitle: true),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrdersFetchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersFetchFailure) {
              return Center(child: Text(state.errMessage));
            } else if (state is OrdersFetchSuccess) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد طلبات سابقة حتى الآن',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildOrderCard(order);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final dateStr =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب بتاريخ: $dateStr',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const Divider(height: 20),
            Text('عدد الوجبات: ${order.items.length}'),
            const SizedBox(height: 4),
            Text('العنوان: ${order.address}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'قيد الانتظار';
        break;
      case 'preparing':
        color = Colors.blue;
        label = 'جاري التحضير';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'تم التوصيل';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }
}
