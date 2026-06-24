class UserProfile {
  final String uid;
  final String email;
  final String role;
  final String vendorStatus;
  final String name;
  final String photoUrl;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    required this.vendorStatus,
    required this.name,
    required this.photoUrl,
  });

  factory UserProfile.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'customer',
      vendorStatus:
          map['vendorStatus'] ?? 'none',
      name: map['name'] ?? '',
      photoUrl:
          map['photoUrl'] ?? '',
    );
  }
}