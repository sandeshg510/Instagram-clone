import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class UpdateReplyUseCase {
  final FirebaseRepository repository;

  UpdateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.updateReply(reply);
  }
}
