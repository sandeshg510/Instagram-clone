import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../cubit/post/post_cubit.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;

  const SingleUserProfileMainWidget({
    super.key,
    required this.otherUserId,
  });

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfilePageSMainWidget();
}

class _SingleUserProfilePageSMainWidget
    extends State<SingleUserProfileMainWidget> {
  String _currentUid = '';

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());

    BlocProvider.of<GetSingleOtherUserCubit>(context)
        .getSingleOtherUser(otherUid: widget.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, userState) {
        if (userState is GetSingleOtherUserLoaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              backgroundColor: backGroundColor,
              title: Text(
                singleUser.username!,
                style: const TextStyle(color: primaryColor),
              ),
              iconTheme: const IconThemeData(
                color: primaryColor, //change your color here
              ),
              actions: [
                _currentUid == singleUser.uid
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: InkWell(
                          onTap: () {
                            _openBottomModelSheet(
                                context: context, currentUser: singleUser);
                          },
                          child: const Icon(
                            Icons.menu,
                            color: primaryColor,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
                            child:
                                profileWidget(imageUrl: singleUser.profileUrl),
                          ),
                        ),
                        sizedBoxHor(25),
                        Column(
                          children: [
                            Text(
                              '${singleUser.totalPosts}',
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
                            Navigator.pushNamed(
                                context, PageConst.followersPage,
                                arguments: singleUser);
                          },
                          child: Column(
                            children: [
                              Text(
                                '${singleUser.totalFollowers}',
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
                            Navigator.pushNamed(
                                context, PageConst.followingPage,
                                arguments: singleUser);
                          },
                          child: Column(
                            children: [
                              Text(
                                '${singleUser.totalFollowing!}',
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
                      '${singleUser.name == '' ? singleUser.username : singleUser.name}',
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${singleUser.bio}',
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizedBoxVer(20),
                    ButtonContainerWidget(
                      title: singleUser.followers!.contains(_currentUid)
                          ? 'Unfollow'
                          : 'follow',
                      color: singleUser.followers!.contains(_currentUid)
                          ? secondaryColor.withOpacity(.4)
                          : blueColor,
                      onTapListener: () {
                        BlocProvider.of<UserCubit>(context).followUnfollowUser(
                            user: UserEntity(
                          uid: _currentUid,
                          otherUid: widget.otherUserId,
                        ));
                      },
                    ),
                    sizedBoxVer(30),
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts
                              .where((post) =>
                                  post.creatorUid == widget.otherUserId)
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _openBottomModelSheet(
      {required BuildContext context, required UserEntity currentUser}) {
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
                        arguments: currentUser);
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
