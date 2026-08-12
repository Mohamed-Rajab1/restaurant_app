import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_state.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 ضروري للنسخة المؤقتة

class AdminCubit extends Cubit<AdminState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminCubit() : super(AdminInitial());

  // 1. الدالة المحدثة لرفع الصورة باستخدام Dio
  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      const apiKey = 'bb64bf8f3f0b08f65e5508c754639880';

      // استخراج اسم الملف من المسار
      String fileName = imageFile.path.split('/').last;

      // تجهيز البيانات كـ FormData (الطريقة المثالية لرفع الملفات مع Dio)
      FormData formData = FormData.fromMap({
        'key': apiKey,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // إنشاء نسخة من Dio وإرسال الطلب
      final dio = Dio();
      final response = await dio.post(
        'https://api.imgbb.com/1/upload',
        data: formData,
      );

      // Dio بيحول الـ JSON لـ Map أوتوماتيك (مش محتاجين jsonDecode)
      if (response.statusCode == 200) {
        return response.data['data']['url']; // الرابط المباشر للصورة
      } else {
        emit(AdminFailure('فشل الرفع لموقع الصور: تأكد من مفتاح الـ API'));
        return null;
      }
    } on DioException catch (e) {
      // Dio بيوفر مسك أخطاء مفصل جداً
      emit(AdminFailure('خطأ في الاتصال (Dio): ${e.message}'));
      return null;
    } catch (e) {
      emit(AdminFailure('حدث خطأ غير متوقع: $e'));
      return null;
    }
  }

  Future<void> addStaffMember({
    required String name,
    required String email,
    required String password,
    required String role, // 'admin', 'cashier', 'kitchen'
  }) async {
    emit(AdminLoading());
    try {
      // 1. إنشاء نسخة مؤقتة من فايربيز عشان الأدمن الأساسي ميتعملوش Sign out
      FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'tempUserCreation',
        options: Firebase.app().options,
      );

      // 2. إنشاء حساب الموظف باستخدام النسخة المؤقتة
      UserCredential userCredential = await FirebaseAuth.instanceFor(
        app: tempApp,
      ).createUserWithEmailAndPassword(email: email, password: password);

      final String uid = userCredential.user!.uid;

      // 3. حذف النسخة المؤقتة فوراً بعد النجاح
      await tempApp.delete();

      // 4. حفظ بيانات الموظف وصلاحياته في الـ Firestore (بالنسخة الأساسية بتاعت التطبيق)
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': role, // هنا بيتحدد هو كاشير ولا مطبخ
        'createdAt': DateTime.now(),
      });

      emit(AdminSuccess('تمت إضافة الموظف بنجاح! 👨‍💼'));
    } catch (e) {
      emit(AdminFailure('فشل إضافة الموظف: $e'));
    }
  }

  // داخل AdminCubit
  Future<void> updateContactInfo({
    required String newPhone,
    required String newWhatsapp,
  }) async {
    emit(AdminLoading());
    try {
      // تحديث الدوكيومنت اللي اسمه contact_info في كوليكشن settings
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('contact_info')
          .set(
            {'phone': newPhone, 'whatsapp': newWhatsapp},
            SetOptions(merge: true),
          ); // بنستخدم merge عشان لو فيه إعدادات تانية ماتتمسحش

      emit(AdminSuccess('تم تحديث أرقام التواصل بنجاح! 📞'));
    } catch (e) {
      emit(AdminFailure('حدث خطأ أثناء تحديث الأرقام: $e'));
    }
  }

  // 2. دالة إضافة الوجبة (زي ما هي بالظبط مفيهاش تغيير)
  Future<void> addMeal({
    required String category,
    required String name,
    required double price,
    required String description,
    required File imageFile,
  }) async {
    emit(AdminLoading());
    try {
      final imageUrl = await uploadImageToImgBB(imageFile);

      if (imageUrl == null) {
        return;
      }

      await _firestore.collection('meals').add({
        'category': category,
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      });

      emit(AdminSuccess('تمت إضافة الوجبة بنجاح '));
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

  // دالة حذف مستخدم (موظف أو عميل)
  Future<void> deleteUser(String uid) async {
    emit(AdminLoading());
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      emit(AdminSuccess('تم حذف المستخدم بنجاح 🗑️'));
    } catch (e) {
      emit(AdminFailure('حدث خطأ أثناء الحذف: $e'));
    }
  }
}
