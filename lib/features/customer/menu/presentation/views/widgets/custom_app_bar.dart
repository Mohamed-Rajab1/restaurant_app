import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_state.dart';
import 'package:restaurant_app/features/customer/cart/presentation/views/cart_view.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartItems = context.read<CartCubit>().items;
        final totalCount = cartItems.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CartView();
                    },
                  ),
                );
              },
            ),
            // بنظهر الـ Badge بس لو فيه عناصر في السلة أكبر من 0
            if (totalCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
