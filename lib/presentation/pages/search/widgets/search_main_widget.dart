import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/presentation/pages/search/widgets/search_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());

    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            final filterAllUsers = userState.users
                .where(
                  (user) =>
                      user.username!.startsWith(_searchController.text) ||
                      user.username!
                          .toLowerCase()
                          .startsWith(_searchController.text.toLowerCase()) ||
                      user.username!.contains(_searchController.text) ||
                      user.username!
                          .toLowerCase()
                          .contains(_searchController.text),
                )
                .toList();
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  children: [
                    SearchWidget(controller: _searchController),
                    sizedBoxVer(10),
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
                        : BlocBuilder<PostCubit, PostState>(
                            builder: (context, postState) {
                              if (postState is PostLoaded) {
                                final posts = postState.posts;
                                return Expanded(
                                  child: GridView.builder(
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
                                              imageUrl:
                                                  posts[index].postImageUrl),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          )
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
