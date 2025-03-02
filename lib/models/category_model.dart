class Category {
  final String id;
  final String name;
  final String icon;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
      id: id,
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "icon": icon, "color": color};
  }
}
