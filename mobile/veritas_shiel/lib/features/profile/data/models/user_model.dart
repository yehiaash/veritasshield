class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
    };
  }
}
