class UserModel {
  String uid;
  String name;
  String email;
  String profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  /// Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
