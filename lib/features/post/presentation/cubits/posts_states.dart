import '../../domain/entities/post.dart';

abstract class PostsStates {}

// Initial state
class PostsInitial extends PostsStates {}

// Loading state (e.g., fetching posts)
class PostsLoading extends PostsStates {}

// Loaded State
class PostsLoaded extends PostsStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}

// Uploading state (when a new post is being uploaded)
class PostsUploading extends PostsStates {}

// Error state
class PostsError extends PostsStates {
  final String message;

  PostsError(this.message);
}