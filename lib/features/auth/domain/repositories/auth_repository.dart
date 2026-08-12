import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity?> getCurrentUser();

  // 👈 الدالة اللي ضفناها
  Future<UserEntity> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
}
