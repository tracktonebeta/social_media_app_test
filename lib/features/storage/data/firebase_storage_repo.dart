import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app_test/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo{

  final FirebaseStorage storage = FirebaseStorage.instance; 
  @override
  Future<String> uploadProfileImageMobile({required String filePath, required String destination}) {
    return _uploadFileMobile(filePath: filePath, destination: 'profile_images');
  }

  @override
  Future<String> uploadProfileImageWeb({required Uint8List fileBytes, required String destination}) {
    return _uploadFileWeb(fileBytes: fileBytes, destination: 'profile_images');
  }

  // Helper method to upload file to Firebase Storage for mobile
  Future<String> _uploadFileMobile({required String filePath, required String destination}) async {
    try {
      final ref = storage.ref(destination);
      final uploadTask = await ref.putFile(Uri.file(filePath).toFilePath() as dynamic);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to upload file to Firebase Storage for web
  Future<String> _uploadFileWeb({required Uint8List fileBytes, required String destination}) async {
    try {
      final ref = storage.ref(destination);
      final uploadTask = await ref.putData(fileBytes);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }
}