import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/custom_text_form_field.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({
    super.key,
    required this._emailController,
    required this._passwordController,
  });

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          emailController: _emailController,
          labelText: 'البريد الإلكتروني',
          prefixIcon: Icons.email,
        ),

        const SizedBox(height: 16),

        CustomTextFormField(
          emailController: _passwordController,
          labelText: 'كلمة المرور',
          prefixIcon: Icons.lock,
          isObscure: true, // نخفي النص للباسورد
        ),
      ],
    );
  }
}
