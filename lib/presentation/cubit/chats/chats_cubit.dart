import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/chats/message_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/chats/get_messages_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/chats/send_message_usecase.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatsInitial());

  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;

  Future<void> sendMessages(
      {required MessageEntity message, required String groupId}) async {
    emit(ChatsLoading());
    try {
      await sendMessageUseCase.call(message, groupId);
    } on SocketException catch (_) {
      emit(ChatsFailure());
    } catch (e) {
      emit(ChatsFailure());
    }
  }

  Future<void> getMessages({required String groupId}) async {
    emit(ChatsLoading());
    try {
      final streamResponse = getMessagesUseCase.call(groupId);
      streamResponse.listen((messages) {
        if (!isClosed) emit(ChatsLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      if (isClosed) emit(ChatsFailure());
    } catch (_) {
      if (isClosed) emit(ChatsFailure());
    }
  }
}
