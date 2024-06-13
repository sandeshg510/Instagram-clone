import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository repository;

  DeleteReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.deleteReply(reply);
  }
}
