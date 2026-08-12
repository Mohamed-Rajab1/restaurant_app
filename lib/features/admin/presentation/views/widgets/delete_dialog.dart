import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

void confirmDelete(BuildContext context, String mealId) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('حذف وجبة'),
      content: const Text('هل أنت متأكد من حذف هذه الوجبة نهائياً؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            context.read<AdminCubit>().deleteMeal(
              mealId,
            ); // افترضنا إن عندك دالة حذف
            Navigator.pop(ctx);
          },
          child: const Text('حذف', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
