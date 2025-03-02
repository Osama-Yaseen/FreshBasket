import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot query = await firestore.collection("categories").get();

      if (query.docs.isEmpty) {
        categories.assignAll(await storeCategories());
      } else {
        categories.assignAll(
          query.docs
              .map(
                (doc) => Category.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
    }
  }

  Future<List<Category>> storeCategories() async {
    List<Category> categoryList = [
      Category(
        id: "Citrus Fruits",
        name: "Citrus Fruits",
        icon: "🍊",
        color: "#FFA726",
      ),
      Category(id: "Berries", name: "Berries", icon: "🍓", color: "#D32F2F"),
      Category(
        id: "Tropical Fruits",
        name: "Tropical Fruits",
        icon: "🥭",
        color: "#F57C00",
      ),
      Category(
        id: "Stone Fruits",
        name: "Stone Fruits",
        icon: "🍑",
        color: "#FF7043",
      ),
      Category(id: "Melons", name: "Melons", icon: "🍉", color: "#4CAF50"),
      Category(id: "Pomes", name: "Pomes", icon: "🍏", color: "#8BC34A"),
      Category(
        id: "Tropical & Exotic",
        name: "Tropical & Exotic",
        icon: "🥥",
        color: "#6D4C41",
      ),
      Category(
        id: "Grapes & Vine Fruits",
        name: "Grapes & Vine Fruits",
        icon: "🍇",
        color: "#673AB7",
      ),
      Category(
        id: "Dried Fruits",
        name: "Dried Fruits",
        icon: "🌰",
        color: "#795548",
      ),
      Category(
        id: "Root & Starchy Fruits",
        name: "Root & Starchy Fruits",
        icon: "🍠",
        color: "#9E9E9E",
      ),
    ];

    for (var category in categoryList) {
      await firestore
          .collection("categories")
          .doc(category.id)
          .set(category.toJson());
    }

    return categoryList;
  }

  /// ✅ Store Items ONLY if they don’t exist
  Future<void> storeItemsForCategory(String categoryId) async {
    QuerySnapshot query =
        await firestore
            .collection("categories")
            .doc(categoryId)
            .collection("items")
            .get();

    if (query.docs.isNotEmpty) return; // ✅ Skip if already exists

    Map<String, List<Map<String, dynamic>>> categoryItems = {
      "Citrus Fruits": [
        {"name": "Orange", "image": "🍊", "price": 3.99},
        {"name": "Lemon", "image": "🍋", "price": 2.99},
        {"name": "Grapefruit", "image": "🍊", "price": 4.49},
        {"name": "Lime", "image": "🍈", "price": 3.59},
        {"name": "Tangerine", "image": "🍊", "price": 3.79},
      ],
      "Berries": [
        {"name": "Strawberry", "image": "🍓", "price": 5.99},
        {"name": "Blueberry", "image": "🫐", "price": 6.99},
        {"name": "Raspberry", "image": "🍇", "price": 7.49},
        {"name": "Blackberry", "image": "🍇", "price": 6.29},
        {"name": "Cranberry", "image": "🫐", "price": 4.99},
      ],
      "Tropical Fruits": [
        {"name": "Mango", "image": "🥭", "price": 5.49},
        {"name": "Pineapple", "image": "🍍", "price": 4.99},
        {"name": "Banana", "image": "🍌", "price": 2.49},
        {"name": "Papaya", "image": "🥭", "price": 6.29},
        {"name": "Coconut", "image": "🥥", "price": 3.99},
      ],
      "Stone Fruits": [
        {"name": "Peach", "image": "🍑", "price": 4.29},
        {"name": "Cherry", "image": "🍒", "price": 7.99},
        {"name": "Plum", "image": "🍑", "price": 4.99},
        {"name": "Apricot", "image": "🍑", "price": 5.29},
        {"name": "Nectarine", "image": "🍑", "price": 4.79},
      ],
      "Melons": [
        {"name": "Watermelon", "image": "🍉", "price": 6.99},
        {"name": "Cantaloupe", "image": "🍈", "price": 5.49},
        {"name": "Honeydew", "image": "🍈", "price": 5.79},
        {"name": "Galia Melon", "image": "🍈", "price": 6.19},
      ],
      "Pomes": [
        {"name": "Apple", "image": "🍏", "price": 3.49},
        {"name": "Pear", "image": "🍐", "price": 4.29},
        {"name": "Quince", "image": "🍏", "price": 5.99},
      ],
      "Tropical & Exotic": [
        {"name": "Passion Fruit", "image": "🥭", "price": 4.99},
        {"name": "Dragon Fruit", "image": "🐉", "price": 6.49},
        {"name": "Starfruit", "image": "⭐", "price": 5.99},
        {"name": "Jackfruit", "image": "🍈", "price": 7.99},
      ],
      "Grapes & Vine Fruits": [
        {"name": "Red Grapes", "image": "🍇", "price": 5.99},
        {"name": "Green Grapes", "image": "🍏", "price": 6.29},
        {"name": "Black Grapes", "image": "🍇", "price": 6.49},
      ],
      "Dried Fruits": [
        {"name": "Dates", "image": "🌰", "price": 8.99},
        {"name": "Figs", "image": "🌰", "price": 7.49},
        {"name": "Raisins", "image": "🍇", "price": 5.99},
        {"name": "Prunes", "image": "🍑", "price": 6.29},
      ],
      "Root & Starchy Fruits": [
        {"name": "Sweet Potato", "image": "🍠", "price": 4.99},
        {"name": "Plantain", "image": "🍌", "price": 3.79},
        {"name": "Cassava", "image": "🌱", "price": 4.59},
      ],
    };

    if (categoryItems.containsKey(categoryId)) {
      for (var item in categoryItems[categoryId]!) {
        await firestore
            .collection("categories")
            .doc(categoryId)
            .collection("items")
            .add(item);
      }
    }
  }
}
