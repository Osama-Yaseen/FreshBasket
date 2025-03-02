import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxMap<String, CartItem> cartItems = <String, CartItem>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromFirestore(); // 🔥 Load cart when controller is initialized
  }

  /// ✅ Get total price
  double get totalPrice => cartItems.values.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  /// ✅ Get total item count (Reactive)
  int get totalItems =>
      cartItems.values.fold(0, (sum, item) => sum + item.quantity);

  /// ✅ Add item to cart & update Firestore
  void addToCart(CartItem item) async {
    if (cartItems.containsKey(item.name)) {
      cartItems[item.name]!.quantity++;
    } else {
      cartItems[item.name] = item;
    }
    cartItems.refresh(); // 🔥 Force UI update
    updateCartInFirestore();
  }

  /// ✅ Remove item from cart & update Firestore
  void removeFromCart(String itemName) async {
    if (cartItems.containsKey(itemName)) {
      if (cartItems[itemName]!.quantity > 1) {
        cartItems[itemName]!.quantity--;
      } else {
        cartItems.remove(itemName);
      }
    }
    cartItems.refresh(); // 🔥 Ensure UI updates instantly
    updateCartInFirestore();
  }

  /// ✅ Clear Cart & update Firestore
  void clearCart() async {
    cartItems.clear();
    cartItems.refresh();
    updateCartInFirestore();
  }

  /// 🔥 Store Cart in Firestore (Persistent Cart)
  Future<void> updateCartInFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    final userCartRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("cart");

    // ✅ Firestore batch write to update cart items efficiently
    final batch = firestore.batch();
    cartItems.forEach((key, item) {
      batch.set(userCartRef.doc(item.name), item.toJson());
    });

    await batch.commit();
  }

  /// 🔥 Load Cart from Firestore when user logs in
  void loadCartFromFirestore() async {
    final user = AuthController.instance.firebaseUser.value;
    if (user == null) return;

    final userCartRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("cart");

    QuerySnapshot cartSnapshot = await userCartRef.get();
    if (cartSnapshot.docs.isNotEmpty) {
      cartItems.assignAll({
        for (var doc in cartSnapshot.docs)
          doc.id: CartItem.fromJson(doc.data() as Map<String, dynamic>),
      });
      cartItems.refresh(); // 🔥 Ensure UI updates instantly
    }
  }
}
