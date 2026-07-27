import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_state.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/widgets/cart_summary_section.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/widgets/empty_view_body.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/widgets/functions/show_clear_dialog.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/widgets/list_view_item.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        centerTitle: true,
        actions: [
          // زرار مسح السلة بالكامل
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              final cartCubit = context.read<CartCubit>();
              if (cartCubit.items.isNotEmpty) {
                showClearDialog(context);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cartItems = context.read<CartCubit>().items;

          // 🔴 1. حالة السلة الفاضية
          if (cartItems.isEmpty) {
            return EmptyViewBody();
          }

          // 🟢 2. حالة وجود عناصر في السلة
          return Column(
            children: [
              // قائمة العناصر (ListView)
              ListViewItem(cartItems: cartItems),

              // ملخص الفاتورة وزرار الدفع
              CartSummarySection(
                totalPrice: context.read<CartCubit>().calculateTotalPrice(),
              ),
            ],
          );
        },
      ),
    );
  }
}
