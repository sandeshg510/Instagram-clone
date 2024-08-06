import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/on_generate_route.dart';
import 'package:instagram_clone/presentation/pages/chats/chat_box_page.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/chats/chats_cubit.dart';
import '../../cubit/user/user_cubit.dart';
import 'package:instagram_clone/injection_container.dart' as di;

import '../search/widgets/search_widget.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final TextEditingController _searchController = TextEditingController();

  String _currentUid = '';
  String chatRoomId = '';
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());
    di.sl<GetCurrentUidUseCase>().call().then((value) => _currentUid = value);

    _searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: primaryColor, //change your color here
          ),
          backgroundColor: backGroundColor,
          title: const Text(
            'Chats',
            style: TextStyle(color: primaryColor),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
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
                final filterAllUsers = userState.users
                    .where(
                      (user) =>
                          user.username!.startsWith(_searchController.text) ||
                          user.username!.toLowerCase().startsWith(
                              _searchController.text.toLowerCase()) ||
                          user.username!.contains(_searchController.text) ||
                          user.username!
                              .toLowerCase()
                              .contains(_searchController.text),
                    )
                    .toList();
                return Column(
                  children: [
                    SearchWidget(controller: _searchController),
                    sizedBoxVer(20),
                    _searchController.text.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: filterAllUsers.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          PageConst.singleUserProfilePage,
                                          arguments: filterAllUsers[index].uid);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: profileWidget(
                                                imageUrl: filterAllUsers[index]
                                                    .profileUrl),
                                          ),
                                        ),
                                        sizedBoxHor(10),
                                        Text(
                                          '${filterAllUsers[index].username}',
                                          style: const TextStyle(
                                              color: primaryColor),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: userState.users.length,
                                itemBuilder: (context, index) {
                                  final user = userState.users[index];

                                  return GestureDetector(
                                    onTap: () {
                                      if (_currentUid.hashCode >
                                          user.uid.hashCode) {
                                        chatRoomId = '$_currentUid-${user.uid}';
                                      } else {
                                        chatRoomId = '${user.uid}-$_currentUid';
                                      }
                                      Navigator.pushNamed(
                                          context, PageConst.chatBoxPage,
                                          arguments: ChatArguments(
                                              user: user, groupId: chatRoomId));
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: 56,
                                          height: 56,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            child: profileWidget(
                                                imageUrl: user.profileUrl),
                                          ),
                                        ),
                                        sizedBoxHor(20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name!,
                                              style: const TextStyle(
                                                  color: primaryColor),
                                            ),
                                            const Text(
                                              'message',
                                              style: TextStyle(
                                                  color: secondaryColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                  ],
                );
              }
              return const Center(
                  child: Text("There aren'\t any users, try again!"));
            })));
  }
}
