import 'package:flutter/material.dart';
import 'package:restaurant_app/features/customer/menu/domain/entities/meal_entity.dart';

class ImageSectionBody extends StatelessWidget {
  const ImageSectionBody({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey[200],
        child: Image.network(
          meal.imageUrl,
          fit: BoxFit.fill,
          headers: const {
            // 🟢 يحل مشكلة الحظر في بعض السيرفرات الخارجية
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
          // 🟢 في حالة التحميل
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          // 🔴 في حالة فشل الرابط أو حظره (يمسك الخطأ ويمنع الكراش)
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.fastfood, size: 40, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
