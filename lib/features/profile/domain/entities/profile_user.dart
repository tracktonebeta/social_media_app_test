import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser{
  final String bio;
  final String profileImageUrl;


ProfileUser ({
  required super.uid,
  required super.email,
  required super.name,
  required this.bio,
  required this.profileImageUrl,
});

  // Method to update ProfileUser
  ProfileUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? profileImageUrl,
  }) {
    return ProfileUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // convert profile user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  // convert json --> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

}