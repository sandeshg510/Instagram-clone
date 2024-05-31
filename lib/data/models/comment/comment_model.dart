import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplies;
  final String? creatorUid;

  CommentModel({
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplies,
    this.creatorUid,
  }) : super(
          commentId: commentId,
          postId: postId,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalReplies: totalReplies,
          creatorUid: creatorUid,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: List.from(snap.get('likes')),
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      totalReplies: snapshot['totalReplies'],
    );
  }

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'postId': postId,
        'description': description,
        'username': username,
        'userProfileUrl': userProfileUrl,
        'createAt': createAt,
        'likes': likes,
        'totalReplies': totalReplies,
        'creatorUid': creatorUid,
      };
}
