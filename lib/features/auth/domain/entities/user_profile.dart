class UserProfile {
  final String uid;
  final String email;
  final String role;
  final String vendorStatus;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    required this.vendorStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'vendorStatus': vendorStatus,
    };
  }
}