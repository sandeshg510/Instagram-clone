import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class DeleteCommentUseCase {
  final FirebaseRepository repository;

  DeleteCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.deleteComment(comment);
  }
}
