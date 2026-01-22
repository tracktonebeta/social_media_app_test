import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app_test/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) async {
    try {

      // attempt to sign in with email and password
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // return the user
      AppUser user = AppUser(
        uid: userCredential.user?.uid ?? '', 
        email: email, name: userCredential.user?.displayName ?? '');
      return user;

    } catch (e) {
      throw Exception('Failed to login with email and password');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {

      // attempt to register with email and password
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // return the user
      AppUser user = AppUser(uid: userCredential.user?.uid ?? '', email: email, name: name);

      // save user data in firestore for users collection in json format
      // To do this, we need to import cloud_firestore. (Make sure to add the dependency in pubspec.yaml!)
      //
      // This requires: import 'package:cloud_firestore/cloud_firestore.dart';
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.name,
      });
      return user;

    } catch (e) {
      throw Exception('Failed to register with email and password');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // attempt to get current user
      final user = firebaseAuth.currentUser;

      // return the user
      return AppUser(uid: user?.uid ?? '', email: user?.email ?? '', name: user?.displayName ?? '');
    } catch (e) {
      throw Exception('Failed to get current user');
    }
  }

  @override

  Future<void> logout() async {
    try {

      // attempt to logout
      await firebaseAuth.signOut();

    } catch (e) {
      throw Exception('Failed to logout');
    }
  }
}