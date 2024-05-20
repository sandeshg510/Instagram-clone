import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class CreateUserWithImageUseCase {
  final FirebaseRepository repository;

  CreateUserWithImageUseCase({required this.repository});

  Future<void> call(UserEntity user, String profileUrl) {
    return repository.createUserWithImage(user, profileUrl);
  }
}
