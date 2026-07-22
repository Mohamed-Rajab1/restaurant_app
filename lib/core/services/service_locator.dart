import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:restaurant_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:restaurant_app/features/auth/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. External Services (Firebase)
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // 2. Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );

  // 3. Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  // 4. Cubit / ViewModel
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<LoginUseCase>()));
}
