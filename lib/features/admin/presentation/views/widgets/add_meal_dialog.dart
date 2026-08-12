import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

class AddMealDialog extends StatefulWidget {
  const AddMealDialog({super.key});

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final categoryController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? _selectedImage; // المتغير اللي هيشيل الصورة المحددة

  // دالة فتح الاستوديو واختيار الصورة
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminCubit>();

    return AlertDialog(
      title: const Text(
        'إضافة وجبة جديدة 🍔',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 👈 منطقة اختيار وعرض الصورة
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'اضغط لاختيار صورة الوجبة',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // باقي الحقول
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الوجبة',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'السعر',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.trim().isEmpty ? 'مطلوب' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (_selectedImage == null) {
                // إظهار تنبيه لو الأدمن نسي يختار صورة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى اختيار صورة للوجبة أولاً!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              adminCubit.addMeal(
                category: categoryController.text.trim(),
                name: nameController.text.trim(),
                price: double.parse(priceController.text.trim()),
                description: descController.text.trim(),
                imageFile: _selectedImage!, // بنبعت ملف الصورة للكيوبت
              );
              Navigator.pop(context);
            }
          },
          child: const Text('إضافة', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
