import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class UploadThumbnailToStorageUseCase {
  final FirebaseRepository repository;

  UploadThumbnailToStorageUseCase({required this.repository});

  Future<String> call(String videoFilePath) {
    return repository.uploadReelThumbnailToStorage(videoFilePath);
  }
}
