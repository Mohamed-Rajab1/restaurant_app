import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase) : super(AuthInitialState());

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState()); // خلّي الشاشة تلف دايرة تحميل
    try {
      // نداء الـ Use Case لجلب بيانات المستخدم والـ Role
      final userEntity = await _loginUseCase.call(email, password);
      emit(AuthSuccessState(userEntity)); // نجاح تسجيل الدخول
    } catch (e) {
      emit(AuthFailureState(e.toString())); // فشل، أظهر رسالة الخطأ
    }
  }
}
