import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:freshbasket/widgets/login_card.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isVisible = false;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildBackground(), _buildOverlay(), _buildLoginForm()],
      ),
    );
  }

  /// ✅ Background Image
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// ✅ Dark Overlay
  Widget _buildOverlay() {
    return Container(color: Colors.black.withAlpha(120));
  }

  /// ✅ Login Form with Animation
  Widget _buildLoginForm() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _isVisible ? 1 : 0,
        child: LoginCard(authController: authController),
      ),
    );
  }
}
