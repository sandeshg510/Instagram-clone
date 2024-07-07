import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class GetSingleReelUseCase {
  final FirebaseRepository repository;

  GetSingleReelUseCase({required this.repository});

  Stream<List<ReelEntity>> call(String reelId) {
    return repository.getSingleReel(reelId);
  }
}
