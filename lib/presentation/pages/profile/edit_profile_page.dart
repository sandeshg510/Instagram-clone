import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: secondaryColor,
            size: 32,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Icon(Icons.check, color: blueColor, size: 32),
          )
        ],
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                      color: secondaryColor, shape: BoxShape.circle),
                ),
              ),
              sizedBoxVer(15),
              const Center(
                child: Text(
                  'Change Profile Photo',
                  style: TextStyle(
                      color: blueColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              sizedBoxVer(30),
              ProfileFormWidget(title: 'Name', controller: controller),
              sizedBoxVer(10),
              ProfileFormWidget(title: 'user name', controller: controller),
              sizedBoxVer(10),
              ProfileFormWidget(title: 'Bio', controller: controller),
              sizedBoxVer(10),
              ProfileFormWidget(title: 'website', controller: controller),
              sizedBoxVer(10),
              ProfileFormWidget(title: 'pronouns', controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
