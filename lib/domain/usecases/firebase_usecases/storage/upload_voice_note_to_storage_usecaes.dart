import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class UploadVoiceNoteToStorage {
  final FirebaseRepository repository;

  UploadVoiceNoteToStorage({required this.repository});

  Future<String> call(String voiceNotePath) {
    return repository.uploadVoiceNoteToStorage(voiceNotePath);
  }
}
