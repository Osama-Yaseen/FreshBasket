import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_controller.dart';

class SettingsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isDarkMode = false.obs;
  RxString selectedLanguage = "en".obs;

  /// ✅ **Toggle Dark Mode**
  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _updateSettingsInFirestore();
  }

  /// ✅ **Change Language**
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    Get.updateLocale(Locale(lang));
    _updateSettingsInFirestore();
  }

  /// 🔥 **Store User Settings in Firestore**
  void _updateSettingsInFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    await firestore.collection("users").doc(user.uid).set({
      "isDarkMode": isDarkMode.value,
      "language": selectedLanguage.value,
    }, SetOptions(merge: true));
  }

  /// 🔥 **Load Settings from Firestore When User Logs In**
  void loadSettingsFromFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    DocumentSnapshot doc =
        await firestore.collection("users").doc(user.uid).get();
    if (doc.exists) {
      isDarkMode.value = doc["isDarkMode"] ?? false;
      selectedLanguage.value = doc["language"] ?? "en";

      /// ✅ **Apply Theme & Language**
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      Get.updateLocale(Locale(selectedLanguage.value));
    }
  }
}
