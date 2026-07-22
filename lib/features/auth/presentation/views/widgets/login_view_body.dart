import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/utils/functions/custom_error_snack_bar.dart';
import 'package:restaurant_app/core/utils/functions/custom_snack_bar.dart';
import 'package:restaurant_app/core/utils/widgets/custom_loading_indicator.dart';
import 'package:restaurant_app/features/auth/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/intro_section.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/login_section.dart';

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
              IntroSection(),
              const SizedBox(height: 32),
              LoginSection(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 24),

              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessState) {
                    final role = state.user.role;
                    customSnackBar(
                      context,
                      role: role,
                      message: ' تم تسجيل الدخول بنجاح ، دورك هو',
                    );

                    // TODO: الانتقال للشاشة المناسبة بناءً على الـ Role
                    // مثلاً: if (role == 'cashier') { افتح شاشة الكاشير }
                  }

                  if (state is AuthFailureState) {
                    // لو فشل، أظهر رسالة الخطأ للمستخدم
                    customErrorSnackBar(context, state.error);
                  }
                },
                builder: (context, state) {
                  // هنا بنبني شكل الزرار بناءً على الحالة الحالية
                  if (state is AuthLoadingState) {
                    // لو بيحمل، بنخفي الزرار ونظهر دايرة التحميل
                    return const CustomLoadingIndicator();
                  }

                  // الحالة الطبيعية: زرار تسجيل الدخول
                  return CustomElevatedButton(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
