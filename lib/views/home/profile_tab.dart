import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:lottie/lottie.dart';

class ProfileTab extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authController.userModel.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              /// 👤 **Profile Card**
              _buildProfileCard(user),

              const SizedBox(height: 20),

              /// ⚙️ **Settings Section**
              _buildSettings(),

              const Spacer(),

              /// 🚪 **Logout Button**
              _buildLogoutButton(),
            ],
          ),
        ),
      );
    });
  }

  /// 🆔 **Profile Card**
  Widget _buildProfileCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🖼️ **Profile Picture**
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                user.profileImageUrl.isNotEmpty
                    ? NetworkImage(user.profileImageUrl)
                    : const AssetImage("assets/images/default_avatar.png")
                        as ImageProvider,
          ),

          const SizedBox(height: 12),

          /// 🏷️ **User Name**
          Text(
            user.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),

          /// ✉️ **User Email**
          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// ⚙️ **Settings Section**
  Widget _buildSettings() {
    return Column(
      children: [
        /// 🌙 **Dark Mode Toggle**
        _buildSettingTile(
          icon: Icons.dark_mode,
          title: "Dark Mode",
          trailing: Obx(
            () => Switch(
              value: authController.isDarkMode.value,
              onChanged: (value) {
                authController.toggleDarkMode();
              },
            ),
          ),
        ),

        /// 🌎 **Language Selection with Radio Buttons**
        _buildLanguageSelection(),
      ],
    );
  }

  /// 🎨 **Reusable Setting Tile**
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing: trailing,
    );
  }

  /// 🌎 **Language Selection with Radio Buttons**
  Widget _buildLanguageSelection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Language",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<String>(
            title: const Text("English"),
            value: "en",
            groupValue: authController.selectedLanguage.value,
            onChanged: (value) {
              authController.changeLanguage(value!);
            },
          ),
          RadioListTile<String>(
            title: const Text("العربية"),
            value: "ar",
            groupValue: authController.selectedLanguage.value,
            onChanged: (value) {
              authController.changeLanguage(value!);
            },
          ),
        ],
      );
    });
  }

  /// 🚪 **Logout Button**
  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _showLogoutDialog(),
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  /// ✅ **Beautiful Logout Confirmation Dialog**
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(
              "Logout?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              "assets/animations/logout.json",
              height: 100,
              repeat: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              authController.logout();
              Get.back();
            },
            child: const Text(
              "Yes, Logout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
