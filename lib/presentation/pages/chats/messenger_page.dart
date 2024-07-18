import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/pages/chats/chat_box_page.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/chats/chats_cubit.dart';
import '../../cubit/user/user_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  String _currentUid = '';
  String chatRoomId = '';
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());
    di.sl<GetCurrentUidUseCase>().call().then((value) => _currentUid = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          leading: const Icon(
            CupertinoIcons.back,
            color: primaryColor,
          ),
          backgroundColor: backGroundColor,
          title: const Text(
            'Chats',
            style: TextStyle(color: primaryColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child:
              BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
            if (userState is UserFailure) {
              return const Center(
                child: Text("There aren'\t any users"),
              );
            }
            if (userState is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (userState is UserLoaded) {
              return ListView.builder(
                  itemCount: userState.users.length,
                  itemBuilder: (context, index) {
                    final user = userState.users[index];

                    return GestureDetector(
                      onTap: () {
                        if (_currentUid.hashCode > user.uid.hashCode) {
                          chatRoomId = '$_currentUid-${user.uid}';
                        } else {
                          chatRoomId = '${user.uid}-$_currentUid';
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatBoxPage(
                                      user: user,
                                      groupId: chatRoomId,
                                    )));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: 56,
                            height: 56,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: profileWidget(imageUrl: user.profileUrl),
                            ),
                          ),
                          sizedBoxHor(20),
                          Column(
                            children: [
                              Text(
                                user.username!,
                                style: const TextStyle(color: primaryColor),
                              ),
                              const Text(
                                'message',
                                style: TextStyle(color: secondaryColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            }
            return const Center(
                child: Text("There aren'\t any users, try again!"));
          }),
        ));
  }
}
