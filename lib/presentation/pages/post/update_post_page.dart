import 'package:flutter/material.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';

import '../profile/edit_profile_page.dart';

class UpdatePostPage extends StatefulWidget {
  final PostEntity post;
  const UpdatePostPage({super.key, required this.post});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizedBoxVer(10),
              Text(
                '${widget.post.username}',
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizedBoxVer(10),
              Container(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  child: profileWidget(imageUrl: widget.post.postImageUrl),
                ),
              ),
              sizedBoxVer(10),
              ProfileFormWidget(
                  title: 'Description', controller: _descriptionController!)
            ],
          ),
        ),
      ),
    );
  }
}
