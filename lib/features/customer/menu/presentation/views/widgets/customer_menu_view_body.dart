import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_cubit.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/categories_list_view.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/custom_app_bar.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/custom_text_field.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/grid_view_body.dart';

class CustomerMenuViewBody extends StatefulWidget {
  const CustomerMenuViewBody({super.key});

  @override
  State<CustomerMenuViewBody> createState() => _CustomerMenuViewBodyState();
}

class _CustomerMenuViewBodyState extends State<CustomerMenuViewBody> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    'الكل',
    'برجر 🍔',
    'بيتزا 🍕',
    'مشروبات 🥤',
    'حلويات 🍩',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الطعام 🍽️'),
        actions: [CartBadgeIcon(), const SizedBox(width: 8)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(),
            const SizedBox(height: 16),

            SizedBox(
              height: 40,
              child: CategoriesListView(
                categories: categories,
                selectedCategoryIndex: selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() {
                    selectedCategoryIndex = index;
                    context.read<MenuCubit>().fetchMeals(
                      category: categories[index],
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            GridViewBody(),
          ],
        ),
      ),
    );
  }
}
