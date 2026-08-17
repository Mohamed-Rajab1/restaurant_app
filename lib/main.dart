import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/views/admin_dashboard_view.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/cashier/presentation/views/cashier_orders_view.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/customer_menu_view.dart';
import 'package:restaurant_app/features/kitchen/presentation/views/kitchen_orders_view.dart';
import 'core/services/service_locator.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'firebase_options.dart'; // ملف إعدادات الفايربيز بتاعك

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupServiceLocator();

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthCubit>()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. التطبيق لسه بيقرأ حالة المستخدم
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. فيه مستخدم مسجل دخوله فعلاً
        if (snapshot.hasData && snapshot.data != null) {
          // نجيب بياناته من فايرستور عشان نعرف هو أدمن ولا زبون
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                // قراءة الدور
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final String role = userData['role'] ?? 'customer';

                // التوجيه بناءً على الدور
                if (role == 'admin') {
                  return const AdminDashboardView();
                } else if (role == 'cashier') {
                  return const CashierOrdersView();
                } else if (role == 'kitchen') {
                  return const KitchenOrdersView();
                }

                return const CustomerMenuView();
              }

              // لو حصلت أي مشكلة في قراءة البيانات، افتح اللوجن
              return const LoginView();
            },
          );
        }

        // 3. مفيش مستخدم، افتح شاشة تسجيل الدخول
        return const LoginView();
      },
    );
  }
}
