import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/cashier/presentation/manager/cashier_cubit/cashier_orders_cubit.dart';
import 'package:restaurant_app/features/cashier/presentation/manager/cashier_cubit/cashier_orders_state.dart';
import 'widgets/cashier_order_card.dart';
import '../../../../core/services/service_locator.dart';

class CashierOrdersView extends StatelessWidget {
  const CashierOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CashierOrdersCubit>()..listenToOrders(),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('لوحة تحكم الكاشير 👨‍🍳'),
            centerTitle: true,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'الكل'),
                Tab(text: 'جديدة (معلقة)'),
                Tab(text: 'قيد التحضير'),
                Tab(text: 'تم التسليم'),
              ],
            ),
          ),
          body: BlocBuilder<CashierOrdersCubit, CashierOrdersState>(
            builder: (context, state) {
              if (state is CashierOrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CashierOrdersFailure) {
                return Center(child: Text(state.errMessage));
              } else if (state is CashierOrdersSuccess) {
                if (state.orders.isEmpty) {
                  return const Center(child: Text('لا توجد طلبات حتى الآن'));
                }

                final allOrders = state.orders;
                final pendingOrders = allOrders
                    .where((o) => o.status == 'pending')
                    .toList();
                final preparingOrders = allOrders
                    .where(
                      (o) => o.status == 'preparing' || o.status == 'ready',
                    )
                    .toList();
                final deliveredOrders = allOrders
                    .where((o) => o.status == 'delivered')
                    .toList();

                return TabBarView(
                  children: [
                    _buildOrdersList(allOrders),
                    _buildOrdersList(pendingOrders),
                    _buildOrdersList(preparingOrders),
                    _buildOrdersList(deliveredOrders),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('لا توجد طلبات في تصنيف الصفحة الحالي'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return CashierOrderCard(order: orders[index]);
      },
    );
  }
}
