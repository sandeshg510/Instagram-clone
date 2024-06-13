import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class ReadRepliesUseCase {
  final FirebaseRepository repository;

  ReadRepliesUseCase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repository.readReplies(reply);
  }
}
