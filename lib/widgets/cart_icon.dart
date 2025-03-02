import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbasket/controllers/cart_controller.dart';

class CartIcon extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed("/cart");
            },
          ),
          if (cartController.totalItems > 0)
            Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  "${cartController.totalItems}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
