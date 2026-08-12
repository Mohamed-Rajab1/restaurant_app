import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

// دالة إظهار نافذة التعديل
void showEditMealDialog(BuildContext context, dynamic meal,String mealId) {
  final adminCubit = context.read<AdminCubit>();

  // 1. تجهيز الـ Controllers وتعبئتها بالبيانات الحالية للوجبة
  final categoryController = TextEditingController(text: meal['category']);
  final nameController = TextEditingController(text: meal['name']);
  final priceController = TextEditingController(text: meal['price'].toString());
  final descController = TextEditingController(text: meal['description']);
  final imageUrlController = TextEditingController(text: meal['imageUrl']);

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'تعديل الوجبة ✏️',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            // عشان الشاشة ماتضربش لو الكيبورد فتح
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // التصنيف
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'التصنيف',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'يرجى إدخال التصنيف' : null,
                ),
                const SizedBox(height: 12),

                // اسم الوجبة
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الوجبة',
                    prefixIcon: Icon(Icons.fastfood),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'يرجى إدخال اسم الوجبة' : null,
                ),
                const SizedBox(height: 12),

                // السعر
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'السعر (ج.م)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'يرجى إدخال السعر' : null,
                ),
                const SizedBox(height: 12),

                // الوصف
                TextFormField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'يرجى إدخال الوصف' : null,
                ),
                const SizedBox(height: 12),

                // رابط الصورة
                TextFormField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'رابط الصورة (URL)',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'يرجى إدخال رابط الصورة' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // 2. استدعاء دالتك المطابقة تماماً للمتغيرات المطلوبة
                adminCubit.updateMeal(
                  mealId: mealId,
                 // تأكد إنك بتجيب الـ ID بتاع الـ Document صح حسب الموديل
                  category: categoryController.text.trim(),
                  name: nameController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                  description: descController.text.trim(),
                  imageUrl: imageUrlController.text.trim(),
                );

                // 3. قفل النافذة بعد الإرسال
                Navigator.pop(context);
              }
            },
            child: const Text(
              'حفظ التعديلات',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}
