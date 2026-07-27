import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';

void showClearDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('مسح السلة'),
      content: const Text('هل أنت متأكد من مسح جميع الوجبات من السلة؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            context.read<CartCubit>().clearCart();
            Navigator.pop(dialogContext);
          },
          child: const Text('مسح', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
