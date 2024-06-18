import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/domain/entities/comment/reply/reply_entity.dart';
import '../../../../../consts.dart';
import '../../../../cubit/comment/reply/reply_cubit.dart';
import '../../../../widgets/button_container_widget.dart';
import '../../../profile/widgets/profile_form_widget.dart';

class EditReplyMainWidget extends StatefulWidget {
  const EditReplyMainWidget({super.key, required this.reply});
  final ReplyEntity reply;
  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {
  TextEditingController? _descriptionController;
  bool _isReplyUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Edit your reply',
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
              onTapListener: _editReply,
            ),
            sizedBoxVer(10),
            _isReplyUpdating == true
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

  _editReply() {
    {
      setState(() {
        _isReplyUpdating = true;
      });
      BlocProvider.of<ReplyCubit>(context)
          .updateReply(
              reply: ReplyEntity(
        commentId: widget.reply.commentId,
        postId: widget.reply.postId,
        replyId: widget.reply.replyId,
        description: _descriptionController!.text,
      ))
          .then((value) {
        setState(() {
          _isReplyUpdating = false;
          _descriptionController!.clear();
        });
        Navigator.pop(context);
      });
    }
  }
}
