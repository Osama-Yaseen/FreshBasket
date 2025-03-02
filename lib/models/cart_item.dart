class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  /// 🔄 Convert CartItem to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {"name": name, "image": image, "price": price, "quantity": quantity};
  }

  /// 🔄 Convert JSON to CartItem (for Firestore)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json["name"],
      image: json["image"],
      price: json["price"],
      quantity: json["quantity"],
    );
  }
}
