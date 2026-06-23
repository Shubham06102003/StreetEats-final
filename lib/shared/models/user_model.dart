class UserModel {
  final String uid;
  final String email;
  final String role;
  final String name;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}