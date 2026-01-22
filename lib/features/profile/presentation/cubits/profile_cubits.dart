import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/profile/domain/entities/profile_user.dart'
    show ProfileUser;
import 'package:social_media_app_test/features/profile/domain/repos/profile_repos.dart'
    show ProfileRepo;
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app_test/features/storage/domain/storage_repo.dart';

class ProfileCubits extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubits({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to fetch profile: ${e.toString()}'));
    }
  }

  Future<void> updateProfile(
    String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  ) async {
    emit(ProfileLoading());
    try {
      // Fetch current profile first
      final oldProfile = await profileRepo.fetchUserProfile(uid);
      if (oldProfile == null) {
        emit(ProfileError('User not found'));
        return;
      }

      String? profileImageUrl = oldProfile.profileImageUrl;

      // Handle image upload if there's new image data
      if (imageWebBytes != null) {
        // Upload for web
        try {
          profileImageUrl = await storageRepo.uploadProfileImageWeb(
            fileBytes: imageWebBytes,
            destination: 'profile_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
        } catch (e) {
          emit(ProfileError('Failed to upload image: ${e.toString()}'));
          return;
        }
      } else if (imageMobilePath != null) {
        // Upload for mobile
        try {
          profileImageUrl = await storageRepo.uploadProfileImageMobile(
            filePath: imageMobilePath,
            destination: 'profile_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
        } catch (e, stack) {
          // Print error and stack trace to console for debugging
          print('Failed to upload image: $e');
          print('Stack trace: $stack');
          final errorMessage = 'Failed to upload image: ${e.toString()}';
          emit(ProfileError(errorMessage));
          return;
        }
      }

      // Build the updated profile
      final updatedProfile = oldProfile.copyWith(
        bio: newBio ?? oldProfile.bio,
        profileImageUrl: profileImageUrl,
      );

      // Update in repo
      await profileRepo.updateProfile(updatedProfile);

      // Re-fetch the updated profile
      final refreshedProfile = await profileRepo.fetchUserProfile(uid);

      if (refreshedProfile != null) {
        emit(ProfileLoaded(refreshedProfile));
      } else {
        emit(ProfileError('Unable to fetch updated profile'));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }
}