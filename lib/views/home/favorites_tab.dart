import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbasket/controllers/favorite_controller.dart';
import 'package:freshbasket/controllers/cart_controller.dart';
import 'package:freshbasket/models/cart_item.dart';

class FavoritesTab extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final CartController cartController = Get.find<CartController>();

  FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    favoriteController.loadFavoritesFromFirestore(); // ✅ Load from Firestore

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (favoriteController.favoriteItems.isEmpty) {
            return const Center(
              child: Text(
                "Your favorite items will appear here.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteController.favoriteItems.length,
              itemBuilder: (context, index) {
                final item =
                    favoriteController.favoriteItems.values.toList()[index];

                return _buildFavoriteItemCard(item);
              },
            ),
          );
        }),
      ),
    );
  }

  /// ✅ **Favorite Item Card**
  Widget _buildFavoriteItemCard(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// ❤️ **Favorite Button**
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  favoriteController.isFavorite(item.name)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      favoriteController.isFavorite(item.name)
                          ? Colors.red
                          : Colors.grey,
                  key: ValueKey<bool>(favoriteController.isFavorite(item.name)),
                ),
              ),
              onPressed: () {
                favoriteController.toggleFavorite(item);
              },
            ),
          ),

          /// 🍎 **Item Image**
          Expanded(
            child: Center(
              child: Text(item.image, style: const TextStyle(fontSize: 50)),
            ),
          ),

          /// 🏷️ **Item Name**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),

          /// 💰 **Price**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Text(
                "\$${item.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// 🛒 **Cart Controls**
          _buildCartControls(item),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// ✅ **Cart Controls**
  Widget _buildCartControls(CartItem item) {
    return Obx(() {
      int quantity = cartController.cartItems[item.name]?.quantity ?? 0;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child:
            quantity == 0
                ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    cartController.addToCart(
                      CartItem(
                        name: item.name,
                        image: item.image,
                        price: item.price,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ➖ Minus Button
                      GestureDetector(
                        onTap: () => cartController.removeFromCart(item.name),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade400,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),

                      /// 🔢 Quantity
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// ➕ Plus Button
                      GestureDetector(
                        onTap: () {
                          cartController.addToCart(
                            CartItem(
                              name: item.name,
                              image: item.image,
                              price: item.price,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.shade400,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      );
    });
  }
}
