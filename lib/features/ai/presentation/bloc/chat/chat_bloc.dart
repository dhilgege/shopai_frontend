import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopai_fe/features/ai/domain/entities/chat_message.dart';
import 'package:shopai_fe/features/ai/domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final List<ChatMessage> _messages = [];
  String? _conversationId;

  ChatBloc({required this.sendMessage}) : super(const ChatInitialState()) {
    on<SendMessageChatEvent>(_onSendMessage);
    on<LoadConversationsChatEvent>(_onLoadConversations);
    on<DeleteConversationChatEvent>(_onDeleteConversation);
    on<ClearChatChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(SendMessageChatEvent event, Emitter<ChatState> emit) async {
    final userMessage = ChatMessage(text: event.message, isUser: true);
    _messages.add(userMessage);
    emit(ChatMessageSentState(List.from(_messages), conversationId: _conversationId));
    emit(const ChatLoadingState());
    final result = await sendMessage(event.message);
    result.fold(
      (failure) {
        if (_messages.isNotEmpty && _messages.last.isUser) _messages.removeLast();
        emit(ChatErrorState(failure.toString(), messages: List.from(_messages)));
        emit(ChatMessageSentState(List.from(_messages), conversationId: _conversationId));
      },
      (response) {
        _messages.add(ChatMessage(text: response, isUser: false));
        emit(ChatMessageSentState(List.from(_messages), conversationId: _conversationId));
      },
    );
  }

  Future<void> _onLoadConversations(LoadConversationsChatEvent event, Emitter<ChatState> emit) async {
    emit(const ConversationsLoadedState([]));
  }

  Future<void> _onDeleteConversation(DeleteConversationChatEvent event, Emitter<ChatState> emit) async {
    emit(const ConversationsLoadedState([]));
  }

  void _onClearChat(ClearChatChatEvent event, Emitter<ChatState> emit) {
    _messages.clear();
    _conversationId = null;
    emit(const ChatInitialState());
  }

  void clearChat() => add(const ClearChatChatEvent());
  List<ChatMessage> get currentMessages => List.from(_messages);
  String? get currentConversationId => _conversationId;
}
