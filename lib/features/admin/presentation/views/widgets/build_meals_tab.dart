import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/admin/presentation/manager/cubit/admin_cubit.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/add_meal_dialog.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/delete_dialog.dart';
import 'package:restaurant_app/features/admin/presentation/views/widgets/show_edit_meal_dialog.dart';

class BuildMealsTab extends StatelessWidget {
  const BuildMealsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة وجبة', style: TextStyle(color: Colors.white)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<AdminCubit>(),
              child: const AddMealDialog(),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('meals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد وجبات حالياً'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final meal = docs[index].data() as Map<String, dynamic>;
              final mealId = docs[index].id;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      meal['imageUrl'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, _) =>
                          const Icon(Icons.fastfood, size: 40),
                    ),
                  ),
                  title: Text(
                    meal['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${meal['price'] ?? 0} ج.م'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // مهمة عشان الأيقونات ماتاخدش عرض الشاشة كله
                    children: [
                      // 👈 زرار التعديل اللي ضفناه
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showEditMealDialog(context, meal, mealId);
                        },
                      ),
                      // 👈 زرار الحذف بتاعك زي ما هو
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          confirmDelete(context, mealId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
