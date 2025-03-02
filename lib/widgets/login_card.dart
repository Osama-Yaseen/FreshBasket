import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:freshbasket/views/auth/create_account_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginCard extends StatelessWidget {
  final AuthController authController;
  const LoginCard({required this.authController, super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? email, password;

    void handleLogin() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        authController.login(email!, password!);
      }
    }

    return Form(
      key: formKey,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        decoration: _boxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _title("welcome_back".tr),
            _subtitle("sign_in_continue".tr),
            const SizedBox(height: 20),

            _inputField(
              hintText: "email".tr,
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "enter_your_email".tr;
                }
                if (!value.contains("@")) return "invalid_email_format".tr;
                return null;
              },
              onSaved: (value) => email = value,
            ),
            const SizedBox(height: 15),

            _inputField(
              hintText: "password".tr,
              icon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "enter_your_password".tr;
                }
                if (value.length < 6) return "password_too_short".tr;
                return null;
              },
              onSaved: (value) => password = value,
            ),
            const SizedBox(height: 20),

            _button("sign_in".tr, handleLogin),
            const SizedBox(height: 10),

            _textButton("forgot_password".tr, () {}),

            _textButton("create_account".tr, () {
              Get.to(() => const CreateAccountScreen());
            }),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily:
          Get.locale?.languageCode == 'ar'
              ? 'Tajawal' // ✅ Use Arabic Font
              : GoogleFonts.poppins().fontFamily, // ✅ Use Poppins for English
    ),
  );

  Widget _subtitle(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white70,
      fontFamily:
          Get.locale?.languageCode == 'ar'
              ? 'Tajawal' // ✅ Arabic font
              : GoogleFonts.poppins().fontFamily, // ✅ English font
    ),
  );

  Widget _inputField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 72, 79, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _textButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white70)),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withAlpha(77)),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 10)],
    );
  }
}
