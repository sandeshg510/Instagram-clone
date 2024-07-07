import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class LikeReelUseCase {
  final FirebaseRepository repository;

  LikeReelUseCase({required this.repository});

  Future<void> call(ReelEntity reel) {
    return repository.likeReel(reel);
  }
}
