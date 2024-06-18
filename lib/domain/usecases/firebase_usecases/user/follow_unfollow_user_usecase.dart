import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class FollowUnfollowUserUseCase {
  final FirebaseRepository repository;

  FollowUnfollowUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.followUnfollowUser(user);
  }
}
