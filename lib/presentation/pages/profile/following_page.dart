import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../widgets/profile_widget.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key, required this.user});

  final UserEntity user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text(
          'Following',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: backGroundColor,
      ),
      body: user.following!.isEmpty
          ? _noFollowersWidget()
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: user.following!.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<List<UserEntity>>(
                                stream: di
                                    .sl<GetSingleUserUseCase>()
                                    .call(user.following![index]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.data!.isEmpty) {
                                    return Container();
                                  }
                                  final singleUserData = snapshot.data!.first;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          PageConst.singleUserProfilePage,
                                          arguments: singleUserData.uid);
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
                                                imageUrl:
                                                    singleUserData.profileUrl),
                                          ),
                                        ),
                                        sizedBoxHor(15),
                                        Text(
                                          '${singleUserData.username}',
                                          style: const TextStyle(
                                              color: primaryColor),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }))
                ],
              ),
            ),
    );
  }

  _noFollowersWidget() {
    return const Center(
      child: Text(
        'You are not following anyone',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }
}
