import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterCard extends StatelessWidget {
  final File? image;
  final VoidCallback onImagePick;
  final AuthController authController;

  const RegisterCard({
    super.key,
    required this.authController,
    required this.image,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? name, email, password, confirmPassword;

    void handleSignUp() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        authController.signUp(name!, email!, password!, image);
      }
    }

    return SingleChildScrollView(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        decoration: _boxDecoration(),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onImagePick,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white.withAlpha(50),
                  backgroundImage: image != null ? FileImage(image!) : null,
                  child:
                      image == null
                          ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white70,
                            size: 30,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 15),

              _title("create_account".tr),
              const SizedBox(height: 10),

              _inputField(
                hintText: "full_name".tr,
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter_your_full_name".tr;
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              const SizedBox(height: 15),

              _inputField(
                hintText: "email".tr,
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter_your_email".tr;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter a valid email".tr;
                  }
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
                  if (value.length < 6) {
                    return "password_must_be_6".tr;
                  }
                  return null;
                },
                onSaved: (value) => password = value,
              ),
              const SizedBox(height: 15),

              _inputField(
                hintText: "confirm_password".tr,
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (value != password) return "passwords_do_not_match".tr;
                  }
                  return null;
                },
                onSaved: (value) => confirmPassword = value,
              ),
              const SizedBox(height: 20),

              _button("sign_up".tr, handleSignUp),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "already_have_account".tr,
                  style: GoogleFonts.poppins(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

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
}
