import 'package:flutter/material.dart';
import 'package:freshbasket/controllers/category_controller.dart';
import 'package:freshbasket/views/home/item_screen.dart';
import 'package:get/get.dart';

class CategoriesTab extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (categoryController.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categoryController.categories.length,
          itemBuilder: (context, index) {
            var category = categoryController.categories[index];
            return GestureDetector(
              onTap: () async {
                await categoryController.storeItemsForCategory(category.id);
                Get.to(() => ItemsScreen(categoryId: category.id));
              },
              child: Card(
                color: Color(int.parse(category.color.replaceAll("#", "0xFF"))),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.icon, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
