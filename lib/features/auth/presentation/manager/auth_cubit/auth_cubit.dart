import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:restaurant_app/features/auth/domain/usecases/register_use_case.dart'; // 👈 استدعاء الـ UseCase الجديد

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase; // 👈 إضافة الـ UseCase الخاص بالتسجيل

  // 👈 تحديث الـ Constructor لاستقبال الاتنين
  AuthCubit(this._loginUseCase, this._registerUseCase)
    : super(AuthInitialState());

  // ----------------- دالة تسجيل الدخول -----------------
  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final userEntity = await _loginUseCase.call(email, password);
      emit(AuthSuccessState(userEntity));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  // ----------------- دالة إنشاء الحساب -----------------
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState()); // تشغيل دائرة التحميل
    try {
      // نداء الـ Use Case لإنشاء الحساب في Firebase Authentication و Firestore
      final userEntity = await _registerUseCase.call(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      // بمجرد النجاح، بنذيع حالة النجاح وبنبعت معاها الـ userEntity
      // عشان الشاشة تعرف إن نوعه customer وتوديه لصفحة المنيو
      emit(AuthSuccessState(userEntity));
    } catch (e) {
      emit(AuthFailureState(e.toString())); // إرسال رسالة الخطأ للـ SnackBar
    }
  }
}
