import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/utils/functions/custom_error_snack_bar.dart';
import 'package:restaurant_app/core/utils/widgets/custom_loading_indicator.dart';
import 'package:restaurant_app/features/admin/presentation/views/admin_dashboard_view.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/intro_section.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/login_section.dart';
import 'package:restaurant_app/features/cashier/presentation/views/cashier_orders_view.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/customer_menu_view.dart';
import 'package:restaurant_app/features/kitchen/presentation/views/kitchen_orders_view.dart';
import 'package:restaurant_app/features/auth/presentation/views/register_view.dart'; // 👈 استدعي شاشة التسجيل هنا لما تعملها

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const IntroSection(),
              const SizedBox(height: 32),
              LoginSection(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 24),

              // زرار تسجيل الدخول (مع BlocConsumer)
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessState) {
                    final role = state.user.role;

                    // توجيه المستخدم حسب Role
                    // 💡 نصيحة: يفضل استخدام pushReplacement بدل push عشان المستخدم ميرجعش لشاشة اللوجين لو داس Back
                    if (role == 'admin') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboardView(),
                        ),
                      );
                    } else if (role == 'cashier') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CashierOrdersView(),
                        ),
                      );
                    } else if (role == 'kitchen') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KitchenOrdersView(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerMenuView(),
                        ),
                      );
                    }
                  }

                  if (state is AuthFailureState) {
                    customErrorSnackBar(context, state.error);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const CustomLoadingIndicator();
                  }
                  return CustomElevatedButton(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  );
                },
              ),

              const SizedBox(height: 16),

              // 👈 1. خيار الانتقال لشاشة إنشاء حساب (Register)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟', style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      // 💡 لما تعمل شاشة RegisterView شيل التعليق عن السطر ده

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterView(),
                        ),
                      );
                    },
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo, // اختار اللون المناسب لتطبيقك
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 👈 2. زرار تخطي والمتابعة كزائر
              TextButton(
                onPressed: () async {
                  // 👈 خلينا الدالة async

                  // 1. مسح أي بيانات تسجيل دخول قديمة لضمان إنه زائر حقيقي 100%
                  await FirebaseAuth.instance.signOut();

                  // 2. الانتقال لشاشة المنيو
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerMenuView(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'تخطي والمتابعة كزائر',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
