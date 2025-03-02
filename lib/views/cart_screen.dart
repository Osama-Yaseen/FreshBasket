import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbasket/controllers/cart_controller.dart';
import 'package:lottie/lottie.dart';
import 'purchase_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _showClearCartDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems.values.toList()[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      leading: Text(
                        item.image,
                        style: const TextStyle(fontSize: 40),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "\$${item.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed:
                                () => cartController.removeFromCart(item.name),
                          ),
                          Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            onPressed: () => cartController.addToCart(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ✅ Checkout Button
            _buildCheckoutButton(),
          ],
        );
      }),
    );
  }

  /// ✅ Empty Cart UI with Lottie Animation
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            "assets/animations/empty_cart.json", // Make sure you have this animation
            height: 180,
          ),
          const SizedBox(height: 10),
          const Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// ✅ Modern Checkout Button
  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          /// ✅ Total Price Display
          Obx(
            () => Text(
              "Total: \$${cartController.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 15),

          /// ✅ Modern Checkout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.green,
              elevation: 5,
            ),
            onPressed: () => Get.to(() => PurchaseScreen()),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    Get.defaultDialog(
      titlePadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.all(16),
      title: "Clear Cart?",
      titleStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87, // ✅ Darker for better contrast
      ),
      middleText: "Are you sure you want to remove all items?",
      middleTextStyle: const TextStyle(fontSize: 16, color: Colors.black54),
      backgroundColor: Colors.white,
      radius: 20,

      /// 🔹 Lottie Animation for Better UI
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            child: Lottie.asset(
              "assets/animations/delete.json", // ✅ Make sure this file exists
            ),
          ),
        ],
      ),

      actions: [
        /// ❌ Cancel Button
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),

        /// ✅ Confirm Delete Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // ✅ More vibrant delete color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 3,
          ),
          onPressed: () {
            cartController.clearCart();
            Get.back();
          },
          child: const Text(
            "Yes, Clear",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
