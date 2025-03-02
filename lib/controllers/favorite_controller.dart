import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:freshbasket/controllers/auth_controller.dart';
import 'package:freshbasket/models/cart_item.dart';

class FavoriteController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxMap<String, CartItem> favoriteItems = <String, CartItem>{}.obs;

  /// ✅ Check if item is favorite
  bool isFavorite(String itemName) {
    return favoriteItems.containsKey(itemName);
  }

  /// ✅ Toggle Favorite Status
  void toggleFavorite(CartItem item) async {
    if (favoriteItems.containsKey(item.name)) {
      favoriteItems.remove(item.name);
    } else {
      favoriteItems[item.name] = item;
    }
    update();
    await updateFavoritesInFirestore();
  }

  /// 🔥 Store Favorite Items in Firestore
  Future<void> updateFavoritesInFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    final userFavoritesRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites");

    final batch = firestore.batch();
    favoriteItems.forEach((key, item) {
      batch.set(userFavoritesRef.doc(item.name), item.toJson());
    });

    await batch.commit();
  }

  /// 🔥 Load Favorite Items from Firestore
  void loadFavoritesFromFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    final userFavoritesRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites");

    QuerySnapshot favoriteSnapshot = await userFavoritesRef.get();
    if (favoriteSnapshot.docs.isNotEmpty) {
      favoriteItems.assignAll({
        for (var doc in favoriteSnapshot.docs)
          doc.id: CartItem.fromJson(doc.data() as Map<String, dynamic>),
      });
      update();
    }
  }
}
