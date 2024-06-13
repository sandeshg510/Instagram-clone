import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/presentation/widgets/button_container_widget.dart';

class EditCommentMainPage extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentMainPage({super.key, required this.comment});

  @override
  State<EditCommentMainPage> createState() => _EditCommentMainPageState();
}

class _EditCommentMainPageState extends State<EditCommentMainPage> {
  TextEditingController? _descriptionController;
  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit comment',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
                title: 'description', controller: _descriptionController!),
            sizedBoxVer(10),
            ButtonContainerWidget(
              title: 'save changes',
              color: blueColor,
              onTapListener: _editComment,
            ),
            sizedBoxVer(10),
            _isCommentUpdating == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'updating...',
                        style: TextStyle(color: primaryColor),
                      ),
                      sizedBoxHor(10),
                      const CircularProgressIndicator()
                    ],
                  )
                : sizedBoxVer(0)
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComments(
            comment: CommentEntity(
      postId: widget.comment.postId,
      commentId: widget.comment.commentId,
      description: _descriptionController!.text,
    ))
        .then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}
