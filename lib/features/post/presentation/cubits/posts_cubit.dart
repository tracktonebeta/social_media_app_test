import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/post/domain/entities/post.dart' show Post;
import 'package:social_media_app_test/features/post/domain/repos/post_repo.dart';
import 'package:social_media_app_test/features/post/presentation/cubits/posts_states.dart';
import 'package:social_media_app_test/features/storage/domain/storage_repo.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostsCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  // create a new post
  Future<void> createPost(Post post, 
    {String? imagePath, Uint8List? imageBytes}) async {

    String? imageUrl;

    try {
      // handle image upload from mobile using file path
    if (imagePath != null) {
      emit(PostsUploading());
      imageUrl = await storageRepo.uploadProfileImageMobile(filePath: imagePath, destination: post.id);
    }
    // handle image upload from web platform using file bytes
    else if (imageBytes != null) {
      emit(PostsUploading());
      imageUrl = await storageRepo.uploadProfileImageWeb(fileBytes: imageBytes, destination: post.id);
    }

    // give image url to post
    final newPost = post.copyWith(imageUrl: imageUrl);

    // create post in backend
    postRepo.createPost(newPost);

    } catch (e) {
      throw Exception("Failed to post: $e");
    }

  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    emit(PostsLoading());
    try {
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    emit(PostsLoading());
    try {
      await postRepo.deletePost(postId);
      // Refresh posts after deletion
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }
  
  
}
