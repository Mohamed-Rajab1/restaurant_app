import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/kitchen_orders_cubit.dart';
import '../cubit/kitchen_orders_state.dart';
import 'widgets/kitchen_order_card.dart';
import '../../../../core/services/service_locator.dart';

class KitchenOrdersView extends StatelessWidget {
  const KitchenOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<KitchenOrdersCubit>()..listenToKitchenOrders(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('شاشة شيف المطبخ 👨‍🍳🔥'),
          centerTitle: true,
          backgroundColor: Colors.orange.shade800,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<KitchenOrdersCubit, KitchenOrdersState>(
          builder: (context, state) {
            if (state is KitchenOrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KitchenOrdersFailure) {
              return Center(child: Text(state.errMessage));
            } else if (state is KitchenOrdersSuccess) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد طلبات جارية في المطبخ حالياً ☕',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: double.infinity,
                  mainAxisExtent: 400, // ارتفاع ثابت للكارت
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return KitchenOrderCard(order: state.orders[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
