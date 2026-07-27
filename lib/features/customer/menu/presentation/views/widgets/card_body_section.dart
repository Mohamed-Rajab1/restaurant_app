import 'package:flutter/material.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';
import 'package:restaurant_app/features/customer/menu/presentation/views/widgets/last_section_body_of_card.dart';

class CardBodySection extends StatelessWidget {
  const CardBodySection({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            meal.description,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          LastSectionBodyOfCard(meal: meal),
        ],
      ),
    );
  }
}
