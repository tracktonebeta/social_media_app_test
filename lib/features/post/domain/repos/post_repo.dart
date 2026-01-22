import '../entities/post.dart';

abstract class PostRepo {
  Future<void> createPost(Post post);
  Future<List<Post>> fetchAllPosts();
  Future<void> updatePost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostByUserId(String userid);
}