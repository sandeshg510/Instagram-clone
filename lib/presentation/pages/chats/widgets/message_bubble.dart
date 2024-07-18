import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.message, this.isMe, this.imageUrl});

  final String? message;
  final String? imageUrl;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Padding(
            padding: EdgeInsets.only(
                left: isMe == true ? 80.0 : 1,
                top: 1,
                bottom: 1,
                right: isMe == true ? 1 : 80),
            child: Column(
                crossAxisAlignment: isMe == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.3,
                            color: isMe == true
                                ? Colors.grey.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.7)),
                        color: isMe == true
                            ? Colors.grey.withOpacity(0.4)
                            : backGroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Text(
                        message!,
                        style:
                            const TextStyle(fontSize: 18, color: primaryColor),
                      ),
                    ),
                  )
                ]))
        : Padding(
            padding: isMe == true
                ? const EdgeInsets.only(left: 200.0)
                : const EdgeInsets.only(right: 200.0),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                      alignment: AlignmentDirectional.center,
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.fill)),
            ),
          );
  }
}
