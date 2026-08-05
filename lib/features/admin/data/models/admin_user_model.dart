class AdminUserModel {
  final String uid;
  final String name;
  final String email;
  final String role;

  AdminUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminUserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return AdminUserModel(
      uid: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
    );
  }
}
