import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Make Splash Fullscreen (Hides Status Bar)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        // ✅ Ensures full-screen coverage
        child: Image.asset(
          'assets/images/splash_icon.png',
          fit: BoxFit.cover, // ✅ Covers the entire screen
        ),
      ),
    );
  }
}
