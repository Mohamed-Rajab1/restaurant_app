import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:restaurant_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/customer/menu/data/data_sources/menu_remote_data_source.dart';
import 'package:restaurant_app/features/customer/menu/data/repos/menu_repo_impl.dart';
import 'package:restaurant_app/features/customer/menu/domain/repos/menu_repo.dart';
import 'package:restaurant_app/features/customer/menu/presentation/manager/cubit/menu_cubit.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. External Services (Firebase)
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<LoginUseCase>()));

  getIt.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<MenuRepo>(
    () => MenuRepoImpl(remoteDataSource: getIt<MenuRemoteDataSource>()),
  );
  getIt.registerFactory<MenuCubit>(() => MenuCubit(getIt<MenuRepo>()));
}
