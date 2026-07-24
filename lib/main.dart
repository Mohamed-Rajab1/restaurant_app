import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'core/services/service_locator.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'firebase_options.dart'; // ملف إعدادات الفايربيز بتاعك

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيز
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تشغيل الـ Service Locator لربط الاعتماديات
  setupServiceLocator();

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      home: MultiBlocProvider(
        // بديل السلسلة الطويلة: السطر السحري ده بس!
        providers: [
          BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        ],
        child: const LoginView(),
      ),
    );
  }
}
