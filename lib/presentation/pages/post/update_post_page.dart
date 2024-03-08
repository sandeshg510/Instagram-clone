import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';

import '../profile/edit_profile_page.dart';

class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Edit Post',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.done,
              color: blueColor,
              size: 32,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryColor,
                ),
              ),
              sizedBoxVer(10),
              const Text(
                'Username',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizedBoxVer(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: secondaryColor,
                ),
              ),
              sizedBoxVer(10),
              ProfileFormWidget(title: 'Description', controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}
