import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class LikeReplyUseCase {
  final FirebaseRepository repository;

  LikeReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.likeReply(reply);
  }
}
