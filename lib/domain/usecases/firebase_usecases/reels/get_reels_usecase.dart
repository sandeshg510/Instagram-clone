import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/repository/firebase_repository.dart';

class GetReelsUseCase {
  final FirebaseRepository repository;

  GetReelsUseCase({required this.repository});

  Stream<List<ReelEntity>> call(ReelEntity reel) {
    return repository.getReels(reel);
  }
}
