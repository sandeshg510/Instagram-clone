part of 'chats_cubit.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();
}

class ChatsInitial extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsLoading extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsLoaded extends ChatsState {
  final List<MessageEntity> messages;

  const ChatsLoaded({required this.messages});
  @override
  List<Object> get props => [messages];
}

class ChatsFailure extends ChatsState {
  @override
  List<Object> get props => [];
}
