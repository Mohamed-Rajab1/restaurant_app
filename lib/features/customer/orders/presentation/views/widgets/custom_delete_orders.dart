import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/orders/presentation/manager/cubit/order_cubit.dart';

class CustomDeleteOrders extends StatelessWidget {
  const CustomDeleteOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          context.read<OrderCubit>().clearMyDeliveredOrdersHistory(),
      icon: const Icon(Icons.delete, color: Colors.red),
    );
  }
}
