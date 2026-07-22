import 'package:flutter/material.dart';

void customErrorSnackBar(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}
