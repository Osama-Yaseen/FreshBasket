import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshbasket/models/item_model.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Item> items = <Item>[].obs; // ✅ Use Item model

  Future<void> fetchItemsForCategory(String categoryId) async {
    try {
      QuerySnapshot query =
          await firestore
              .collection("categories")
              .doc(categoryId)
              .collection("items")
              .get();

      items.assignAll(
        query.docs
            .map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch items: $e");
    }
  }
}
