import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/chats/message_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_voice_note_to_storage_usecaes.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/presentation/cubit/chats/chats_cubit.dart';
import 'package:instagram_clone/presentation/pages/chats/widgets/message_bubble.dart';
import 'package:instagram_clone/presentation/pages/chats/widgets/voice_animating_widget.dart';
import 'package:instagram_clone/presentation/pages/chats/widgets/voice_message_bubble.dart';
import 'package:instagram_clone/presentation/widgets/profile_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/entities/user/user_entity.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';

class ChatBoxMainWidget extends StatefulWidget {
  final UserEntity user;
  final String groupId;

  const ChatBoxMainWidget({
    super.key,
    required this.user,
    required this.groupId,
  });

  @override
  State<ChatBoxMainWidget> createState() => _ChatBoxMainWidgetState();
}

class _ChatBoxMainWidgetState extends State<ChatBoxMainWidget> {
  TextEditingController? _messageController;
  String? currentUserUid;
  bool _isUpdating = false;
  File? _image;
  AudioRecorder? record;

  bool _isPlayer = false;
  String path = '';
  String url = '';

  @override
  void initState() {
    di
        .sl<GetCurrentUidUseCase>()
        .call()
        .then((value) => currentUserUid = value);
    _messageController = TextEditingController();
    record = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _messageController!.dispose();
    super.dispose();
  }

  Future selectImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _pickedImageAndSending();
        } else {
          Fluttertoast.showToast(msg: 'no image has been selected');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'some error occur $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: primaryColor, //change your color here
        ),
        backgroundColor: backGroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: profileWidget(imageUrl: "${widget.user.profileUrl}"),
                ),
              ),
              sizedBoxHor(16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.user.name}",
                    style: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${widget.user.username}",
                    style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          BlocProvider(
            create: (context) =>
                di.sl<ChatsCubit>()..getMessages(groupId: widget.groupId),
            child: BlocBuilder<ChatsCubit, ChatsState>(
              builder: (context, messageState) {
                if (messageState is ChatsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (messageState is ChatsFailure) {
                  return const Center(
                    child: Text('Something went wrong! Please try again'),
                  );
                }
                if (messageState is ChatsLoaded) {
                  return Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: messageState.messages.length,
                        itemBuilder: (context, index) {
                          final message = messageState.messages[index];
                          switch (message.messageType) {
                            case MessageConst.textMessage:
                              {
                                return MessageBubble(
                                  message: message.message,
                                  imageUrl: message.imageUrl,
                                  isMe: currentUserUid == message.creatorUid,
                                );
                              }
                            case MessageConst.image:
                              {
                                return MessageBubble(
                                  message: message.message,
                                  imageUrl: message.imageUrl,
                                  isMe: currentUserUid == message.creatorUid,
                                );
                              }
                            case MessageConst.voiceNote:
                              {
                                return VoiceMessageBubble(
                                  url: message.voiceNoteUrl!,
                                  isMe: currentUserUid == message.creatorUid,
                                );
                              }
                          }
                        }),
                  );
                }

                return messageWidget;
              },
            ),
          ),
          _isUpdating ? loadingWidget() : const SizedBox(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget messageWidget = Container();

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 15),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(25)),
        child: _isPlayer
            ? VoiceAnimatingWidget(
                sendCallback: _sendRecord,
                stopCallback: _stopRecord,
                deleteCallback: _deleteRecord,
              )
            : Row(
                children: [
                  sizedBoxHor(4),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: blueColor),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            selectImage(ImageSource.camera);
                          },
                          icon: const Icon(
                            Icons.photo_camera_rounded,
                            size: 26,
                            color: primaryColor,
                          )),
                    ),
                  ),
                  sizedBoxHor(5),
                  Flexible(
                      flex: 2,
                      child: TextField(
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Message...',
                          hintStyle: TextStyle(color: secondaryColor),
                        ),
                        cursorColor: Colors.white,
                        controller: _messageController,
                        style: const TextStyle(color: primaryColor),
                      )),
                  Row(children: [
                    _messageController!.text.isNotEmpty
                        ? sizedBoxHor(0)
                        : IconButton(
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                            },
                            icon: const Icon(
                              Icons.image_rounded,
                              size: 24,
                              color: primaryColor,
                            )),
                    _messageController!.text.isNotEmpty
                        ? sizedBoxHor(0)
                        : GestureDetector(
                            onTap: () async {
                              _startRecord();
                            },
                            child: const Icon(
                              Icons.mic_none,
                              size: 24,
                              color: primaryColor,
                            )),
                    _messageController!.text.isNotEmpty
                        ? TextButton(
                            onPressed: () {
                              _sendMessages();
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                  color: blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ))
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_circle_outline_sharp,
                              size: 24,
                              color: primaryColor,
                            )),
                    sizedBoxHor(10)
                  ]),
                ],
              ),
      ),
    );
  }

  _startRecord() async {
    print('record started');

    setState(() {
      _isPlayer = true;
    });
    final String name = const Uuid().v1();
    final location = await getApplicationDocumentsDirectory();
    final status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      await record!
          .start(const RecordConfig(), path: '${location.path}$name.m4a');
    } else {
      Fluttertoast.showToast(msg: 'Please Allow Permissions');
    }
  }

  _stopRecord() async {
    print('record stopped');
    String? finalPath = await record!.stop();
    setState(() {
      path = finalPath!;
    });
    // di
    //     .sl<UploadVoiceNoteToStorage>()
    //     .call(path)
    //     .then((voiceNoteUrl) => _sendVoiceNote(voiceNoteUrl))
    //     .then((value) => _clear());
  }

  _sendRecord() {
    di
        .sl<UploadVoiceNoteToStorage>()
        .call(path)
        .then((voiceNoteUrl) => _sendVoiceNote(voiceNoteUrl))
        .then((value) => _clear());
    print('record sending');

    setState(() {
      _isPlayer = false;
    });
  }

  _deleteRecord() async {
    String? finalPath = await record!.stop();

    setState(() {
      finalPath = null;
      _isPlayer = false;
    });
  }

  _sendMessages() {
    if (_messageController!.text.isEmpty) {
      return;
    }

    BlocProvider.of<ChatsCubit>(context)
        .sendMessages(
            message: MessageEntity(
                message: _messageController!.text,
                messageType: MessageConst.textMessage,
                chatId: widget.groupId,
                isLike: false,
                creatorUid: currentUserUid),
            groupId: widget.groupId)
        .then((value) => _clear());
  }

  _pickedImageAndSending() {
    if (_image == null) {
      return;
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, true, 'images')
          .then(
            (profileUrl) => _sendImages(profileUrl),
          );
    }
  }

  _sendImages(String imageUrl) {
    setState(() {
      _isUpdating = true;
    });

    BlocProvider.of<ChatsCubit>(context)
        .sendMessages(
            message: MessageEntity(
                message: _messageController!.text,
                imageUrl: imageUrl,
                messageType: MessageConst.image,
                chatId: widget.groupId,
                isLike: false,
                creatorUid: currentUserUid),
            groupId: widget.groupId)
        .then((value) => _clear());
  }

  _sendVoiceNote(String voiceNoteUrl) {
    setState(() {
      _isUpdating = true;
    });

    BlocProvider.of<ChatsCubit>(context)
        .sendMessages(
            message: MessageEntity(
                voiceNoteUrl: voiceNoteUrl,
                messageType: MessageConst.voiceNote,
                chatId: widget.groupId,
                isLike: false,
                creatorUid: currentUserUid),
            groupId: widget.groupId)
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _messageController!.clear();
      // record!.dispose();
    });
  }
}
