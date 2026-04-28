import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class SendMessageChatEvent extends ChatEvent {
  final String message;
  const SendMessageChatEvent(this.message);
  @override
  List<Object> get props => [message];
}

class LoadConversationsChatEvent extends ChatEvent {}

class DeleteConversationChatEvent extends ChatEvent {
  final String conversationId;
  const DeleteConversationChatEvent(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}

class ClearChatChatEvent extends ChatEvent {
  const ClearChatChatEvent();
  @override
  List<Object> get props => [];
}
