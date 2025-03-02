class Item {
  final String name;
  final String image;
  final double price;
  int quantity; // ✅ Add quantity field

  Item({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 0, // ✅ Default quantity
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json["name"] ?? "No Name",
      image: json["image"] ?? "❓",
      price: (json["price"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "image": image, "price": price, "quantity": quantity};
  }
}
