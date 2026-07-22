import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  // بنمرر المستودع هنا عن طريق الـ Constructor (Dependency Injection)
  LoginUseCase(this.repository);

  // دالة call بتخلينا ننادي الكلاس ده كأنه دالة مباشرة في الكود
  Future<UserEntity> call(String email, String password) async {
    // هنا بنفذ أمر تسجيل الدخول من خلال المستودع
    return await repository.loginWithEmail(email, password);
  }
}
