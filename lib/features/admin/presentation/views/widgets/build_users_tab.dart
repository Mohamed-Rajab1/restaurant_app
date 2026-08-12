import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/data/models/admin_user_model.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';

class BuildUsersTab extends StatelessWidget {
  const BuildUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لا يوجد مستخدمون حالياً'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final userDoc = docs[index];
            final user = AdminUserModel.fromFirestore(
              userDoc.data() as Map<String, dynamic>,
              userDoc.id,
            );

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  user.name.isEmpty ? 'بدون اسم' : user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user.email),

                // 👈 التعديل هنا: وضعنا الصلاحيات وزرار الحذف داخل Row
                trailing: Row(
                  mainAxisSize:
                      MainAxisSize.min, // مهم جداً عشان ميبوظش الـ ListTile
                  children: [
                    // قائمة تغيير الصلاحية
                    DropdownButton<String>(
                      value:
                          [
                            'customer',
                            'cashier',
                            'kitchen',
                            'admin',
                          ].contains(user.role)
                          ? user.role
                          : 'customer',
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(
                          value: 'customer',
                          child: Text('زبون'),
                        ),
                        DropdownMenuItem(
                          value: 'cashier',
                          child: Text('كاشير'),
                        ),
                        DropdownMenuItem(value: 'kitchen', child: Text('مطبخ')),
                        DropdownMenuItem(value: 'admin', child: Text('أدمن')),
                      ],
                      onChanged: (newRole) {
                        if (newRole != null && newRole != user.role) {
                          context.read<AdminCubit>().updateUserRole(
                            user.uid,
                            newRole,
                          );
                        }
                      },
                    ),

                    const SizedBox(
                      width: 8,
                    ), // مسافة صغيرة بين القائمة وزرار الحذف
                    // زرار الحذف
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'حذف المستخدم',
                      onPressed: () {
                        // إظهار نافذة التأكيد قبل الحذف
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('تأكيد الحذف ⚠️'),
                            content: Text(
                              'هل أنت متأكد أنك تريد حذف المستخدم "${user.name}"؟',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text(
                                  'إلغاء',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  // استدعاء دالة الحذف (تأكد إنك ضفتها في AdminCubit)
                                  context.read<AdminCubit>().deleteUser(
                                    user.uid,
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: const Text(
                                  'نعم، احذف',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
