import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

void showContactSettingsDialog(BuildContext context) {
  final adminCubit = context.read<AdminCubit>();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'إعدادات التواصل 📞',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('settings')
              .doc('contact_info')
              .get(),
          builder: (context, snapshot) {
            // 1. حالة التحميل
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // 2. 👈 إضافة جديدة: لو حصل مشكلة في الاتصال بالفايربيز
            if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'حدث خطأ في الاتصال: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // 3. لو في بيانات قديمة والوثيقة موجودة فعلاً
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null) {
                phoneController.text = data['phone'] ?? '';
                whatsappController.text = data['whatsapp'] ?? '';
              }
            }

            // 4. عرض الفورمة في كل الحالات (حتى لو مفيش بيانات قديمة)
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف (للاتصال)',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val!.trim().isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: whatsappController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الواتساب (بالكود الدولي)',
                      hintText: 'مثال: 201012345678',
                      prefixIcon: Icon(Icons.wechat),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val!.trim().isEmpty ? 'يرجى إدخال رقم الواتساب' : null,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                adminCubit.updateContactInfo(
                  newPhone: phoneController.text.trim(),
                  newWhatsapp: whatsappController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'حفظ الإعدادات',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
