import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminCubit() : super(AdminInitial());

  // 1️⃣ إضافة وجبة جديدة
  Future<void> addMeal({
    required String category,
    required String name,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    emit(AdminLoading());
    try {
      await _firestore.collection('meals').add({
        'category': category,
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      });
      emit(AdminSuccess('تمت إضافة الوجبة بنجاح!'));
    } catch (e) {
      emit(AdminFailure('فشل إضافة الوجبة: ${e.toString()}'));
    }
  }

  Future<void> updateMeal({
    required String mealId,
    required String category,
    required String name,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    emit(AdminLoading());
    try {
      await _firestore.collection('meals').doc(mealId).update({
        'category': category,
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      });
      emit(AdminSuccess('تمت تحديث الوجبة بنجاح!'));
    } catch (e) {
      emit(AdminFailure('فشل تحديث الوجبة: ${e.toString()}'));
    }
  }

  // 2️⃣ حذف وجبة
  Future<void> deleteMeal(String mealId) async {
    emit(AdminLoading());
    try {
      await _firestore.collection('meals').doc(mealId).delete();
      emit(AdminSuccess('تم حذف الوجبة بنجاح!'));
    } catch (e) {
      emit(AdminFailure('فشل حذف الوجبة: ${e.toString()}'));
    }
  }

  // 3️⃣ تغيير دور المستخدم (Role)
  Future<void> updateUserRole(String userId, String newRole) async {
    emit(AdminLoading());
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      emit(AdminSuccess('تم تعديل صلاحية المستخدم بنجاح!'));
    } catch (e) {
      emit(AdminFailure('فشل تعديل الصلاحية: ${e.toString()}'));
    }
  }
}
