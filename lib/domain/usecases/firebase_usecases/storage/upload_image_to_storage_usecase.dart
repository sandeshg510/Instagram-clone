import 'dart:io';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(
      File file, bool isPost, bool isMessage, String childName) {
    return repository.uploadImageToStorage(file, isPost, isMessage, childName);
  }
}
