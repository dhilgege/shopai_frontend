import 'package:equatable/equatable.dart';
import 'package:shopai_fe/features/ai/domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

class ChatMessageSentState extends ChatState {
  final List<ChatMessage> messages;
  final String? conversationId;
  const ChatMessageSentState(this.messages, {this.conversationId});
  @override
  List<Object> get props => [messages, conversationId ?? ''];
}

class ChatErrorState extends ChatState {
  final String message;
  final List<ChatMessage> messages;
  const ChatErrorState(this.message, {required this.messages});
  @override
  List<Object> get props => [message, messages];
}

class ConversationsLoadedState extends ChatState {
  final List<ConversationInfo> conversations;
  const ConversationsLoadedState(this.conversations);
  @override
  List<Object> get props => [conversations];
}

class ConversationInfo {
  final String id;
  final DateTime updatedAt;
  final String lastMessage;
  const ConversationInfo({required this.id, required this.updatedAt, required this.lastMessage});
}
