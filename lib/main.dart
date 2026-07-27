import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:restaurant_app/features/customer/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'core/services/service_locator.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'firebase_options.dart'; // ملف إعدادات الفايربيز بتاعك

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupServiceLocator();

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthCubit>()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        home: const LoginView(),
      ),
    );
  }
}
