import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/login_page.dart';
import 'package:instagram_clone/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/presentation/widgets/form_container_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            Center(
              child: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
              ),
            ),
            sizedBoxVer(18),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(35)),
                    child: Image.asset('assets/profile_default.png'),
                  ),
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: IconButton(
                      color: blueColor,
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo_rounded),
                    ),
                  ),
                ],
              ),
            ),
            sizedBoxVer(35),
            const FormContainerWidget(
              hintText: 'Enter your Username',
            ),
            sizedBoxVer(15),
            const FormContainerWidget(
              hintText: 'Enter your Email',
            ),
            sizedBoxVer(15),
            const FormContainerWidget(
              hintText: 'Enter your Password',
              isPasswordField: true,
            ),
            sizedBoxVer(15),
            const FormContainerWidget(
              hintText: 'Enter your Bio',
            ),
            sizedBoxVer(15),
            const ButtonContainerWidget(
              color: blueColor,
              title: 'Sign Up',
            ),
            Flexible(flex: 2, child: Container()),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
