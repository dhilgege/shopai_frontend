import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
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
    on<ClearChatChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessageChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final userMessage = ChatMessage(text: event.message, isUser: true);

    _messages.add(userMessage);
    emit(ChatMessageSentState(List.from(_messages)));

    emit(ChatLoadingState(List.from(_messages)));

    final result = await sendMessage(event.message);

    result.fold(
      (failure) {
        emit(ChatErrorState(
          failure.toString(),
          messages: List.from(_messages),
        ));
      },
      (response) {
        _messages.add(ChatMessage(text: response, isUser: false));
        emit(ChatMessageSentState(List.from(_messages)));
      },
    );
  }

  void _onClearChat(ClearChatChatEvent event, Emitter<ChatState> emit) {
    _messages.clear();
    emit(const ChatInitialState());
  }
}