import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:freshbasket/controllers/cart_controller.dart';
import 'package:freshbasket/controllers/category_controller.dart';
import 'package:freshbasket/controllers/settings_controller.dart';
import 'package:freshbasket/firebase_options.dart';
import 'package:freshbasket/languages/translations.dart';
import 'package:freshbasket/themes.dart';
import 'package:freshbasket/views/auth/login_screen.dart';
import 'package:freshbasket/views/cart_screen.dart';
import 'package:get/get.dart';
import 'views/main_screen.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthController());
  Get.put(CategoryController());
  Get.put(CartController());
  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('ar', 'AR'),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const SplashScreen()),
        GetPage(name: "/home", page: () => const MainScreen()),
        GetPage(name: "/cart", page: () => CartScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
      ],
    );
  }
}
