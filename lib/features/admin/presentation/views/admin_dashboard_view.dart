import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_state.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_analytics_tab.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_meals_tab.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/build_users_tab.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/show_contact_settings_dialog.dart';
import 'package:restaurant_app/features/auth/presentation/views/login_view.dart';
import '../../../../core/services/service_locator.dart';
// 👇 استدعي ملف النافذة هنا (تأكد من المسار الصحيح)
import 'package:restaurant_app/features/admin/presentation/views/widgets/add_staff_dialog.dart';

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
            actions: [
              Builder(
                builder: (cubitContext) {
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.settings),
                    tooltip: 'الإعدادات والخيارات',
                    onSelected: (value) async {
                      if (value == 'contact') {
                        // 1. فتح نافذة أرقام التواصل
                        showContactSettingsDialog(cubitContext);
                      } else if (value == 'add_staff') {
                        // 2. فتح نافذة إضافة موظف
                        showDialog(
                          context: cubitContext,
                          builder: (context) => BlocProvider.value(
                            value: cubitContext.read<AdminCubit>(),
                            child: const AddStaffDialog(),
                          ),
                        );
                      } else if (value == 'logout') {
                        // 3. تسجيل الخروج
                        await FirebaseAuth.instance.signOut();
                        if (cubitContext.mounted) {
                          Navigator.pushAndRemoveUntil(
                            cubitContext,
                            // تأكد إن ده اسم شاشة اللوجين عندك
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'contact',
                        child: Row(
                          children: [
                            Icon(
                              Icons.contact_phone,
                              color: Colors.indigo,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('أرقام الدعم الفني'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'add_staff',
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('إضافة موظف'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(), // خط فاصل
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
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
            child: const TabBarView(
              children: [BuildMealsTab(), BuildUsersTab(), BuildAnalyticsTab()],
            ),
          ),
        ),
      ),
    );
  }
}
