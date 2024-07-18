import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '';

class MessageEntity extends Equatable {
  final String? creatorUid;
  final String? chatId;
  final String? message;
  final String? imageUrl;
  final String? messageType;
  final Timestamp? createAt;
  final bool? isLike;

  const MessageEntity({
    this.creatorUid,
    this.chatId,
    this.message,
    this.imageUrl,
    this.messageType,
    this.createAt,
    this.isLike,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        creatorUid,
        chatId,
        message,
        imageUrl,
        messageType,
        createAt,
        isLike,
      ];
}
