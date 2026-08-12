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
          // بنجيب الأرقام الحالية الأول عشان نعرضها للأدمن يعدل عليها
          future: FirebaseFirestore.instance
              .collection('settings')
              .doc('contact_info')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // لو في بيانات قديمة بنحطها في الـ Controllers
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              phoneController.text = data['phone'] ?? '';
              whatsappController.text = data['whatsapp'] ?? '';
            }

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
              if (formKey.currentState!.validate()) {
                // استدعاء دالة التحديث من الكيوبت
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
