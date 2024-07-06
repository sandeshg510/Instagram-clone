import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';

class ReelModel extends ReelEntity {
  final String? reelId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? reelUrl;
  final String? thumbnailUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  ReelModel({
    this.reelId,
    this.creatorUid,
    this.username,
    this.description,
    this.reelUrl,
    this.thumbnailUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  }) : super(
          reelId: reelId,
          creatorUid: creatorUid,
          username: username,
          description: description,
          reelUrl: reelUrl,
          thumbnailUrl: thumbnailUrl,
          likes: likes,
          totalLikes: totalLikes,
          totalComments: totalComments,
          createAt: createAt,
          userProfileUrl: userProfileUrl,
        );

  factory ReelModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReelModel(
      reelId: snapshot['reelId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      reelUrl: snapshot['reelUrl'],
      thumbnailUrl: snapshot['thumbnailUrl'],
      likes: List.from(snap.get('likes')),
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reelId': reelId,
        'creatorUid': creatorUid,
        'username': username,
        'description': description,
        'reelUrl': reelUrl,
        'thumbnailUrl': thumbnailUrl,
        'likes': likes,
        'totalLikes': totalLikes,
        'totalComments': totalComments,
        'createAt': createAt,
        'userProfileUrl': userProfileUrl,
      };
}
