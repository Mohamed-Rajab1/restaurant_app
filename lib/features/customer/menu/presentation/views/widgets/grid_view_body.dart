import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_cubit.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_state.dart';
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
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meal.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
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
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    // TODO: Add to Cart
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is MenuFailureState) {
            print('=== FIREBASE MENU ERROR: ${state.errorMessage} ===');
            // 3. عرض رسالة الخطأ لو حصل مشكلة في السيرفر
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Center(
            child: Text(
              'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
