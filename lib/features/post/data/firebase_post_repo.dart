import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app_test/features/post/domain/entities/post.dart';
import 'package:social_media_app_test/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Store posts in a collection called 'posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot = 
        await postsCollection.orderBy('timestamp', descending: true).get();

        final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

        return allPosts;

    } catch (e) {
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot = await postsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Post> userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Failed to fetch posts for user $userId: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePost(Post post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}