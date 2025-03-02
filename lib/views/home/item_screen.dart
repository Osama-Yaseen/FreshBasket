import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbasket/models/cart_item.dart';
import 'package:freshbasket/controllers/item_controller.dart';
import 'package:freshbasket/controllers/cart_controller.dart';
import 'package:freshbasket/controllers/favorite_controller.dart';

class ItemsScreen extends StatelessWidget {
  final String categoryId;
  ItemsScreen({super.key, required this.categoryId});

  final ItemController itemsController = Get.put(ItemController());
  final CartController cartController = Get.find<CartController>();
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    itemsController.fetchItemsForCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryId,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black26,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Get.toNamed("/cart"),
                ),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        "${cartController.totalItems}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (itemsController.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
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
              itemCount: itemsController.items.length,
              itemBuilder: (context, index) {
                final item = itemsController.items[index];

                return Obx(() {
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
                        /// ❤️ Favorite Button
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
                                key: ValueKey<bool>(
                                  favoriteController.isFavorite(item.name),
                                ),
                              ),
                            ),
                            onPressed: () {
                              favoriteController.toggleFavorite(
                                CartItem(
                                  name: item.name,
                                  image: item.image,
                                  price: item.price,
                                ),
                              );
                            },
                          ),
                        ),

                        /// 🍎 Item Image
                        Expanded(
                          child: Center(
                            child: Text(
                              item.image,
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),

                        /// 🏷️ Item Name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 5),

                        /// 💰 Price Tag
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
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

                        /// 🛒 Cart Controls
                        Obx(() {
                          int quantity =
                              cartController.cartItems[item.name]?.quantity ??
                              0;

                          return quantity == 0
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Add to Cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// ➖ Minus Button
                                      GestureDetector(
                                        onTap:
                                            () => cartController.removeFromCart(
                                              item.name,
                                            ),
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
                        }),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
