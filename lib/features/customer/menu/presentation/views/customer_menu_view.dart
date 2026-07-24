// features/customer/menu/presentation/views/customer_menu_view.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/services/service_locator.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_cubit.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/customer_menu_view_body.dart';

class CustomerMenuView extends StatelessWidget {
  const CustomerMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 🟢 بيتكريت لما نفتح الشاشة وبيتقفل أول ما نخرج منها
      create: (context) => getIt<MenuCubit>()..fetchMeals(),
      child: CustomerMenuViewBody(),
    );
  }
}
