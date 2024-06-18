import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

import 'chat_bubble.dart';

class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({
    super.key,
  });

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final TextEditingController _messageController = TextEditingController();
  // final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // void sendMessage() async {
  //   // only send message if it is not empty
  //   if (_messageController.text.isNotEmpty) {
  //     await _chatService.sendMessages(
  //         widget.receiverUserId, _messageController.text);
  //
  //     // clear the controller once the message is sent
  //     _messageController.clear();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.receiversName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatBubble(
              message: 'dhjsk',
              color: blueColor,
            ),
          ),
          _buildMessageInput(),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  // build message list
  // Widget _buildMessageList() {
  //   return StreamBuilder(
  //       stream: _chatService.getMessages(
  //           widget.receiverUserId, _firebaseAuth.currentUser!.uid),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Text('Error ${snapshot.error.toString()}');
  //         }
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Text('Loading..');
  //         }
  //         return ListView(
  //           children: snapshot.data!.docs
  //               .map((document) => _buildMessageItem(document))
  //               .toList(),
  //         );
  //       });
  // }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the left if the sender is the current user, otherwise to the left

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text('   ${data['senderEmail']}   '),
          const SizedBox(
            height: 4,
          ),
          ChatBubble(
            message: data['message'],
            color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? Colors.lightGreen.shade300
                : Colors.lightBlue.shade300,
          ),
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter message',
              ),
              obscureText: false,
              controller: _messageController,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Center(
              child: IconButton(
                color: Colors.teal,
                // onPressed: sendMessage,
                icon: const Icon(
                  Icons.send_rounded,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
