import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/activity/activity_page.dart';
import 'package:instagram_clone/presentation/pages/home/home_page.dart';
import 'package:instagram_clone/presentation/pages/post/upload_post_page.dart';
import 'package:instagram_clone/presentation/pages/profile/profile_page.dart';
import 'package:instagram_clone/presentation/pages/search/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
    return Scaffold(
      backgroundColor: backGroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: backGroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
            'assets/hut.png',
            color: primaryColor,
            height: 20,
          )),
          const BottomNavigationBarItem(icon: Icon(Icons.search_sharp)),
          const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_sharp)),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_sharp)),
          const BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp)),
        ],
        onTap: navigationTapped,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomePage(),
          SearchPage(),
          UploadPostPage(),
          ActivityPage(),
          ProfilePage()
        ],
      ),
    );
  }
}
