class UserModel {
  final String uid;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'phoneNumber': phoneNumber,
    'displayName': displayName,
    'photoURL': photoURL,
    'isEmailVerified': isEmailVerified,
    'createdAt': createdAt.toIso8601String(),
  };

  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String?,
    displayName: json['displayName'] as String?,
    photoURL: json['photoURL'] as String?,
    isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
  );

  // Copy with method for immutability
  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        displayName: displayName ?? this.displayName,
        photoURL: photoURL ?? this.photoURL,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        createdAt: createdAt ?? this.createdAt,
      );
}

