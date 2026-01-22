import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart';
import 'package:social_media_app_test/features/profile/domain/entities/profile_user.dart' show ProfileUser;
import 'package:social_media_app_test/features/profile/domain/repos/profile_repos.dart';

class FirebaseProfileRepo implements ProfileRepo{
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
  try {
    // Replace with the code to get the user document from Firestore.
    // (In actual implementation, you'd do something like:)
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data();

      if (userData != null) {
        return ProfileUser(
          uid: uid,
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          bio: userData['bio'] ?? '',
          profileImageUrl: userData['profileImageUrl'].toString(),
        );
      }
    }

    return null;
  } catch (e) {
    // Handle or log the exception as needed
    return null;
  }
  }

  @override
  Future<void> updateProfile(ProfileUser profileUser) async {
  try {
    final userRef = FirebaseFirestore.instance.collection('users').doc(profileUser.uid);
    await userRef.update({
      'bio': profileUser.bio,
      'profileImageUrl': profileUser.profileImageUrl,
    });
  } catch (e, stack) {
    // Handle or log the exception as needed
    debugPrint('❌ Unknown error: $e');
    debugPrintStack(stackTrace: stack);
  }
  }
}