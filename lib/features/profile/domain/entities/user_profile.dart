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

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'customer',
      vendorStatus: map['vendorStatus'] ?? 'none',
    );
  }
}