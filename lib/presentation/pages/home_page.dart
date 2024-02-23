import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: backGroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(icon: Icon(Icons.search_sharp)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_sharp)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline_sharp)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp)),
        ],
      ),
    );
  }
}
