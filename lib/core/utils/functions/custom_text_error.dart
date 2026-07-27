import 'package:flutter/material.dart';

class CustomTextError extends StatelessWidget {
  const CustomTextError({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
