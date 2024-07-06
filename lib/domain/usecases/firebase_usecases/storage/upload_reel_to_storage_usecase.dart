import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class UploadReelToStorageUseCase {
  final FirebaseRepository repository;

  UploadReelToStorageUseCase({required this.repository});

  Future<dynamic> call(
      {required String descriptionText,
      required String videoFilePath,
      context}) {
    return repository.uploadReelToStorage(
        descriptionText: descriptionText,
        videoFilePath: videoFilePath,
        context: context);
  }
}
