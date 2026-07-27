import 'package:flutter/material.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/card_body_section.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/image_section_body.dart';

class CustomCardBody extends StatelessWidget {
  const CustomCardBody({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSectionBody(meal: meal),
          CardBodySection(meal: meal),
        ],
      ),
    );
  }
}
