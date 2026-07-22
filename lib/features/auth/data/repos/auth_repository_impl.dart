import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/features/auth/data/models/user_model.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // بنمرر الفايربيز هنا علشان نسهل عملية الـ Testing بعدين (Dependency Injection)
  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    try {
      // 1. تسجيل الدخول باستخدام Firebase Authentication
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final String? uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('فشل في الحصول على معرف المستخدم');
      }

      // 2. جلب الـ Role وباقي البيانات من Cloud Firestore باستخدام الـ uid
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        throw Exception(
          'المستخدم موجود في Auth ولكن ليس له بيانات في قاعدة البيانات!',
        );
      }

      // 3. تحويل البيانات القادمة من الفايربيز إلى الـ Entity النقية بتاعة الـ Domain
      final data = userDoc.data() as Map<String, dynamic>;
      return UserModel.fromJson(data, uid);
    } on FirebaseAuthException catch (e) {
      // التعامل مع أخطاء الفايربيز الشهيرة بشكل نظيف
      if (e.code == 'user-not-found') {
        throw 'هذا الحساب غير مسجل لدينا.';
      } else if (e.code == 'wrong-password') {
        throw 'كلمة المرور غير صحيحة.';
      } else if (e.code == 'network-request-failed') {
        throw 'تأكد من اتصالك بالإنترنت.';
      }
      throw e.message ?? 'حدث خطأ ما أثناء تسجيل الدخول';
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // دالة إضافية لمعرفة هل المستخدم مسجل دخول أصلاً لما يفتح الأبلكيشن ولا لأ
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return UserEntity(
          uid: currentUser.uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          role: data['role'] ?? 'customer',
        );
      }
    }
    return null;
  }
}
