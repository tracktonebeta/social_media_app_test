import 'dart:typed_data';

abstract class StorageRepo {
  /// Uploads an image file from mobile (using File API).
  /// [filePath] is the local path to the image on device storage.
  /// [destination] is the destination path or folder in storage (e.g. 'profile_images/user123.jpg').
  /// Returns the download URL of the uploaded image upon success.
  Future<String> uploadProfileImageMobile({
    required String filePath,
    required String destination,
  });

  /// Uploads an image file from web (using bytes).
  /// [bytes] is the image bytes.
  /// [destination] is the destination path or folder in storage (e.g. 'profile_images/user123.jpg').
  /// Returns the download URL of the uploaded image upon success.
  Future<String> uploadProfileImageWeb({
    required Uint8List fileBytes,
    required String destination,
  });
}