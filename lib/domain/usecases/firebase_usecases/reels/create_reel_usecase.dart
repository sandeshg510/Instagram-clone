import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class CreateReelUseCase {
  final FirebaseRepository repository;

  CreateReelUseCase({required this.repository});

  Future<void> call(ReelEntity reel) {
    return repository.createReel(reel);
  }
}
