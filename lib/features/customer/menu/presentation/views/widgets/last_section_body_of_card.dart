import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';

class LastSectionBodyOfCard extends StatelessWidget {
  const LastSectionBodyOfCard({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${meal.price} ج.م',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.add_circle, color: Colors.orange),
          onPressed: () {
            context.read<CartCubit>().addToCart(meal);

            // إشعار سريع للمستخدم
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إضافة ${meal.name} إلى السلة'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }
}
