import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<UserEntity> call({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await _authRepository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }
}
