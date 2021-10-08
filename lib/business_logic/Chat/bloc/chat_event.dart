part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitialChatEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {}

class GetAllMessagesEvent extends ChatEvent {
  final int page;
  final int pageSize;
  GetAllMessagesEvent({
    required this.page,
    required this.pageSize,
  });
}
