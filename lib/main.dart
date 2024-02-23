import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/pages/home_page.dart';
import 'package:instagram_clone/presentation/pages/sign_up_page.dart';

import 'presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
