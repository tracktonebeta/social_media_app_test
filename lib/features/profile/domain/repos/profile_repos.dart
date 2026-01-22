import 'package:social_media_app_test/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  /// Fetches the profile information for the given [uid].
  Future<ProfileUser?> fetchUserProfile(String uid);

  /// Updates the profile information for the user with [uid]
  Future<void> updateProfile(ProfileUser profileUser);

}