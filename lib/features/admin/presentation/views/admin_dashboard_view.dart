import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_state.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_analytics_tab.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_meals_tab.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_users_tab.dart';
import '../../../../core/services/service_locator.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AdminCubit>(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('لوحة الإدارة الشاملة ⚙️'),
            centerTitle: true,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            bottom: const TabBar(
              indicatorColor: Colors.amber,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.fastfood), text: 'الوجبات'),
                Tab(icon: Icon(Icons.people), text: 'المستخدمين'),
                Tab(icon: Icon(Icons.analytics), text: 'التقارير'),
              ],
            ),
          ),
          body: BlocListener<AdminCubit, AdminState>(
            listener: (context, state) {
              if (state is AdminSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is AdminFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: TabBarView(
              children: [
                const BuildMealsTab(),
                const BuildUsersTab(),
                const BuildAnalyticsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
