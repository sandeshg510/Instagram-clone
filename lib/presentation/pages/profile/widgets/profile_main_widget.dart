import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_option_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

import '../../../cubit/post/post_cubit.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const ProfileMainWidget({
    super.key,
    required this.currentUser,
  });

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: Text(
          widget.currentUser.username!,
          style: const TextStyle(color: primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                _openBottomModelSheet(context);
              },
              child: const Icon(
                Icons.menu,
                color: primaryColor,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: profileWidget(
                          imageUrl: widget.currentUser.profileUrl),
                    ),
                  ),
                  sizedBoxHor(25),
                  Column(
                    children: [
                      Text(
                        '${widget.currentUser.totalPosts}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'posts',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHor(25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.followersPage,
                          arguments: widget.currentUser);
                    },
                    child: Column(
                      children: [
                        Text(
                          '${widget.currentUser.totalFollowers}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'followers',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHor(25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.followingPage,
                          arguments: widget.currentUser);
                    },
                    child: Column(
                      children: [
                        Text(
                          '${widget.currentUser.totalFollowing!}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'following',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sizedBoxVer(10),
              Text(
                '${widget.currentUser.name == '' ? widget.currentUser.username : widget.currentUser.name}',
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.currentUser.bio}',
                style: const TextStyle(color: primaryColor),
              ),
              sizedBoxVer(30),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.editProfilePage,
                          arguments: widget.currentUser);
                    },
                    child: const ProfileOptionButton(
                      title: 'Edit profile',
                    ),
                  ),
                  sizedBoxHor(5),
                  const ProfileOptionButton(
                    title: 'Share profile',
                  ),
                ],
              ),
              sizedBoxVer(30),
              BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
                  if (postState is PostLoaded) {
                    final posts = postState.posts
                        .where(
                            (post) => post.creatorUid == widget.currentUser.uid)
                        .toList();
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemCount: posts.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConst.postDetailPage,
                                arguments: posts[index].postId);
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: profileWidget(
                                imageUrl: posts[index].postImageUrl),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _openBottomModelSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: backGroundColor,
        context: context,
        builder: (context) {
          backGroundColor;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: backGroundColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: secondaryColor.shade600,
                  endIndent: 173,
                  indent: 173,
                  thickness: 3,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 20),
                  child: Text(
                    'More options',
                    style: TextStyle(color: secondaryColor, fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.editProfilePage,
                        arguments: widget.currentUser);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Edit profile',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 230, left: 30, bottom: 15, top: 10),
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<AuthCubit>(context).loggedOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, PageConst.loginPage, (route) => false);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: secondaryColor, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }
}
