import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/cart_controller.dart';
import 'package:freshbasket/views/home/categories_tab.dart';
import 'package:freshbasket/views/home/favorites_tab.dart';
import 'package:freshbasket/views/home/profile_tab.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [CategoriesTab(), FavoritesTab(), ProfileTab()];
  final CartController cartController =
      Get.find<CartController>(); // ✅ Get cartController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fresh Basket"),
        centerTitle: true,
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Get.toNamed("/cart"),
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartController.totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _tabs[_selectedIndex],

      /// 🌟 Modern Floating Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15), // Creates floating effect
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 28,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Colors.green,
            color: Colors.black54,
            tabs: const [
              GButton(icon: Icons.storefront, text: "Home"),
              GButton(icon: Icons.favorite, text: "Favorites"),
              GButton(icon: Icons.person, text: "Profile"),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
