import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/domain/entities/chats/message_entity.dart';

class MessageModel extends MessageEntity {
  final String? creatorUid;
  final String? chatId;
  final String? message;
  final String? imageUrl;
  final String? messageType;
  final Timestamp? createAt;
  final bool? isLike;

  const MessageModel({
    this.chatId,
    this.message,
    this.imageUrl,
    this.messageType,
    this.isLike,
    this.createAt,
    this.creatorUid,
  }) : super(
          chatId: chatId,
          message: message,
          imageUrl: imageUrl,
          messageType: messageType,
          isLike: isLike,
          createAt: createAt,
          creatorUid: creatorUid,
        );

  factory MessageModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
      creatorUid: snapshot['creatorUid'],
      createAt: snapshot['createAt'],
      chatId: snapshot['commentId'],
      message: snapshot['message'],
      imageUrl: snapshot['imageUrl'],
      messageType: snapshot['messageType'],
      isLike: snapshot['isLike'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'createAt': createAt,
        'creatorUid': creatorUid,
        'message': message,
        'imageUrl': imageUrl,
        'messageType': messageType,
        'isLike': isLike,
      };
}
