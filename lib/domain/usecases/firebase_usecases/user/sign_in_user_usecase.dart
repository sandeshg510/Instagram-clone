import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class SignInUserUseCase {
  final FirebaseRepository repository;

  SignInUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.signInUser(user);
  }
}
