import 'package:instagram_clone/domain/entities/chats/message_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class SendMessageUseCase {
  final FirebaseRepository repository;

  SendMessageUseCase({required this.repository});

  Future<void> call(MessageEntity message, String groupId) {
    return repository.sendMessage(message, groupId);
  }
}
