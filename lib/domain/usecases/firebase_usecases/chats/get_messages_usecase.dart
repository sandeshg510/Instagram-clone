import 'package:instagram_clone/domain/entities/chats/message_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class GetMessagesUseCase {
  final FirebaseRepository repository;

  GetMessagesUseCase({required this.repository});

  Stream<List<MessageEntity>> call(String groupId) {
    return repository.getMessages(groupId);
  }
}
