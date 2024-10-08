import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/presentation/pages/chats/messenger_page.dart';
import 'package:instagram_clone/presentation/pages/home/home_page.dart';
import 'package:instagram_clone/presentation/pages/post/upload_page.dart';
import 'package:instagram_clone/presentation/pages/profile/profile_page.dart';
import 'package:instagram_clone/presentation/pages/search/search_page.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

import '../reels/reels_page.dart';

class MainPage extends StatefulWidget {
  final String uid;

  const MainPage({super.key, required this.uid});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                  'assets/hut.png',
                  color: Theme.of(context).colorScheme.primary,
                  height: 20,
                )),
                BottomNavigationBarItem(
                    icon: Icon(
                  Icons.search_sharp,
                  color: Theme.of(context).colorScheme.primary,
                )),
                BottomNavigationBarItem(
                    icon: Icon(
                  Icons.add_circle_outline_sharp,
                  color: Theme.of(context).colorScheme.primary,
                )),
                BottomNavigationBarItem(
                    icon: Image.asset(
                  'assets/reels_logo.png',
                  color: Theme.of(context).colorScheme.primary,
                  height: 20,
                )),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    width: 28,
                    height: 28,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: profileWidget(imageUrl: currentUser.profileUrl),
                    ),
                  ),
                )
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                const HomePage(),
                const SearchPage(),
                UploadPage(currentUser: currentUser),
                const ReelsPage(),
                ProfilePage(currentUser: currentUser),
                const MessengerPage()
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
