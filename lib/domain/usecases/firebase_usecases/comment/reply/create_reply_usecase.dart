import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository repository;

  CreateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.createReply(reply);
  }
}
