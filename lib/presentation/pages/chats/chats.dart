import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/chats/chat_box.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Chats',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBoxPage()));
                },
                child: Expanded(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 56,
                        height: 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: profileWidget(),
                        ),
                      ),
                      sizedBoxHor(20),
                      const Column(
                        children: [
                          Text(
                            'username',
                            style: TextStyle(color: primaryColor),
                          ),
                          Text(
                            'message',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
