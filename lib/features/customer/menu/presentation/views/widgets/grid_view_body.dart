import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/utils/functions/custom_text_error.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_cubit.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_state.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/custom_card_body.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/meal_shimmer_loading.dart';

class GridViewBody extends StatelessWidget {
  const GridViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoadingState || state is MenuInitialState) {
            // 1. عرض الـ Shimmer عند جلب البيانات
            return const MealShimmerLoading();
          } else if (state is MenuSuccessState) {
            // لو مفيش وجبات مضافة أصلاً في الفايربيز
            if (state.meals.isEmpty) {
              return const Center(child: Text('لا توجد وجبات مضافة حالياً 🍔'));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return CustomCardBody(meal: meal);
              },
            );
          } else if (state is MenuFailureState) {
            // 3. عرض رسالة الخطأ لو حصل مشكلة في السيرفر
            return CustomTextError(errorMessage: state.errorMessage);
          }
          return CustomTextError(
            errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
          );
        },
      ),
    );
  }
}
