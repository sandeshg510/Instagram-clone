import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../domain/entities/comment/reply/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  final String? commentId;
  final String? postId;
  final String? replyId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;

  ReplyModel(
      {this.commentId,
      this.postId,
      this.replyId,
      this.creatorUid,
      this.description,
      this.username,
      this.userProfileUrl,
      this.createAt,
      this.likes})
      : super(
          commentId: commentId,
          postId: postId,
          replyId: replyId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
        );

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: List.from(snap.get('likes')),
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      replyId: snapshot['replyId'],
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
        'replyId': replyId,
        'creatorUid': creatorUid,
      };
}
