import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this._emailController,
    this.isObscure = false,
    required this.labelText,
    required this.prefixIcon,
  });

  final TextEditingController _emailController;
  final bool isObscure; // Default value for password field
  final String labelText; // Default label text
  final IconData? prefixIcon; // Default icon for email field
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      obscureText: isObscure, // Use the isObscure value for password field
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'من فضلك أدخل $labelText';
        }
        return null;
      },
    );
  }
}
