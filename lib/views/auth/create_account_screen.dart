import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:freshbasket/widgets/register_card.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isVisible = false;
  File? _image;
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_buildBackground(), _buildOverlay(), _buildRegisterForm()],
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

  /// ✅ Register Form with Animation
  Widget _buildRegisterForm() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _isVisible ? 1 : 0,
        child: RegisterCard(
          authController: authController,
          image: _image,
          onImagePick: _pickImage,
        ),
      ),
    );
  }
}
