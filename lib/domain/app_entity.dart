import 'package:instagram_clone/domain/entities/user/user_entity.dart';

import 'entities/posts/post_entity.dart';

class AppEntity {
  final UserEntity? currentUser;
  final PostEntity? postEntity;

  final String? uid;
  final String? postId;

  AppEntity({this.currentUser, this.postEntity, this.uid, this.postId});
}
