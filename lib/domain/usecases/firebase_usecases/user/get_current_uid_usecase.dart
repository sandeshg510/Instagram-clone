import '../../../entities/user/user_entity.dart';
import '../../../repository/firebase_repository.dart';

class GetCurrentUidUseCase {
  final FirebaseRepository repository;

  GetCurrentUidUseCase({required this.repository});

  Future<void> call() {
    return repository.getCurrentUid();
  }
}
