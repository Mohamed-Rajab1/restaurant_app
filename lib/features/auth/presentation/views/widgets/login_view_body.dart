import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/utils/functions/custom_error_snack_bar.dart';
import 'package:restaurant_app/core/utils/widgets/custom_loading_indicator.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/intro_section.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/login_section.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/customer_menu_view.dart';

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

                    // توجيه المستخدم حسب Role
                    if (role == 'admin') {
                      // Navigator.pushReplacementNamed(context, '/admin_home');
                      print('توجيه لصفحة الـ Admin');
                    } else if (role == 'cashier') {
                      print('توجيه لصفحة الـ Cashier');
                    } else if (role == 'kitchen') {
                      // Navigator.pushReplacementNamed(context, '/kitchen_home');
                      print('توجيه لصفحة المطبخ Kitchen');
                    } else {
                      // Navigator.pushReplacementNamed(context, '/customer_home');
                      print('توجيه لصفحة الزبون Customer');
                      Navigator.push(
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
            ],
          ),
        ),
      ),
    );
  }
}
