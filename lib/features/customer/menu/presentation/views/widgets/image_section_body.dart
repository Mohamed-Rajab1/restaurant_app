import 'package:cached_network_image/cached_network_image.dart'; // 👈 ضفنا الاستدعاء ده
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
        // 👈 استبدلنا Image.network بـ CachedNetworkImage
        child: CachedNetworkImage(
          imageUrl: meal.imageUrl,
          fit: BoxFit.fill,
          // 🟢 نفس الـ headers بتاعتك عشان نحل مشكلة السيرفرات
          httpHeaders: const {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
          // 🟢 في حالة التحميل (بديل loadingBuilder)
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          // 🔴 في حالة فشل الرابط أو حظره (بديل errorBuilder)
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.fastfood, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
