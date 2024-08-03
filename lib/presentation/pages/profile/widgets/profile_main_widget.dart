import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_option_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import '../../../cubit/post/post_cubit.dart';
import '../../../cubit/theme/theme_cubit.dart';

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
    BlocProvider.of<ThemeCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.currentUser.username!,
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'posts',
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
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'followers',
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
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'following',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sizedBoxVer(10),
              Text(
                '${widget.currentUser.name == '' ? widget.currentUser.username : widget.currentUser.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.currentUser.bio}',
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
                          child: SizedBox(
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context) {
          Theme.of(context).colorScheme.tertiary;
          return SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 300,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 30, left: 30, bottom: 15, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<ThemeCubit>(context)
                          .toggleTheme(isDarkMode);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDarkMode ? 'Light mode' : 'Dark mode',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18),
                        ),
                        Icon(isDarkMode
                            ? CupertinoIcons.moon_circle
                            : CupertinoIcons.moon_circle_fill),
                        sizedBoxHor(4),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.editProfilePage,
                        arguments: widget.currentUser);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 230, left: 30, bottom: 15, top: 10),
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
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
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }
}
