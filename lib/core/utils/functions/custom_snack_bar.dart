import 'package:flutter/material.dart';

void customSnackBar(
  BuildContext context, {
  required String role,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('[$role $message  ]'),
      backgroundColor: Colors.green,
    ),
  );
}
