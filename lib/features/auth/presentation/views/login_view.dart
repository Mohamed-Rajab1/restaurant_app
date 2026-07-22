import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/presentation/views/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const LoginViewBody());
  }
}
