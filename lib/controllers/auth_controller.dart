import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../controllers/cart_controller.dart';
import '../controllers/settings_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isAuthenticated = false.obs;

  RxBool isDarkMode = false.obs;
  RxString selectedLanguage = "en".obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _handleAuthStateChanged);
  }

  /// ✅ **Handle Authentication State Changes**
  void _handleAuthStateChanged(User? user) async {
    if (user == null) {
      _redirectToLogin();
      return;
    }

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection("users").doc(user.uid).get();

    if (userDoc.exists) {
      userModel.value = UserModel.fromJson(userDoc.data()!);
      isAuthenticated.value = true;

      // ✅ Load user settings
      Get.find<SettingsController>().loadSettingsFromFirestore();

      // ✅ Load cart data after authentication
      Get.find<CartController>().loadCartFromFirestore();

      _redirectToHome();
    } else {
      await logout();
    }
  }

  /// 🔄 **Redirect User to Home**
  void _redirectToHome() => Get.offAllNamed("/home");

  /// 🔄 **Redirect User to Login**
  void _redirectToLogin() => Get.offAllNamed("/login");

  /// 🔐 **Sign Up**
  Future<void> signUp(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl =
          image != null
              ? await uploadProfileImage(image, userCredential.user!.uid)
              : "";

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        profileImageUrl: imageUrl,
      );

      await firestore
          .collection("users")
          .doc(newUser.uid)
          .set(newUser.toJson());

      firebaseUser.value = userCredential.user; // ✅ Update user state
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    }
  }

  /// 🔐 **Login**
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebaseUser.value = userCredential.user; // ✅ Update user state
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }

  /// 🔐 **Logout**
  Future<void> logout() async {
    await auth.signOut();
    isAuthenticated.value = false;
    firebaseUser.value = null;
    _redirectToLogin();
  }

  /// 📷 **Upload Profile Image**
  Future<String> uploadProfileImage(File image, String uid) async {
    try {
      Reference ref = storage.ref().child("profile_images/$uid.jpg");
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Upload Failed", e.toString());
      return "";
    }
  }

  /// 🌙 **Toggle Dark Mode**
  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _updateSettingsInFirestore();
  }

  /// 🌎 **Change Language**
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    Get.updateLocale(Locale(lang));
    _updateSettingsInFirestore();
  }

  /// 🔥 **Update User Settings in Firestore**
  void _updateSettingsInFirestore() async {
    final user = firebaseUser.value;
    if (user == null) return;

    await firestore.collection("users").doc(user.uid).update({
      "isDarkMode": isDarkMode.value,
      "language": selectedLanguage.value,
    });
  }
}
