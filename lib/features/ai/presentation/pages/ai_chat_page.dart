import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/features/ai/domain/entities/chat_message.dart';
import 'package:shopai_fe/features/ai/presentation/bloc/chat/chat_bloc.dart';
import 'package:shopai_fe/features/ai/presentation/bloc/chat/chat_event.dart';
import 'package:shopai_fe/features/ai/presentation/bloc/chat/chat_state.dart';
import 'package:shopai_fe/features/ai/presentation/widgets/message_bubble.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    context.read<ChatBloc>().add(SendMessageChatEvent(text.trim()));
  }

  Widget _buildWelcomeMessage(BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ShopAI Assistant"),
          const SizedBox(height: 10),
          const Text("Your smart shopping companion"),
          const SizedBox(height: 10),
          const MarkdownBody(
            data: '''
**How can I help you today?**
- Find products
- Get recommendations
''',
          ),
          const SizedBox(height: 20),
          const Text("Quick questions:"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionBubble("Apa saja produk yang tersedia?"),
              _buildSuggestionBubble("Bagaimana cara membeli produk?"),
              _buildSuggestionBubble("Produk apa yang direkomendasikan?"),
              _buildSuggestionBubble("Berapa harga produk?"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionBubble(String text) {
    return ElevatedButton(
      onPressed: () => _handleSend(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              onSubmitted: _handleSend,
              decoration: const InputDecoration(
                hintText: 'Type message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSend(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatState state) {
    final messages = (state is ChatMessageSentState)
        ? state.messages
        : (state is ChatLoadingState)
            ? state.messages
            : (state is ChatErrorState)
                ? state.messages
                : <ChatMessage>[];

    if (messages.isEmpty) {
      return SingleChildScrollView(
        child: _buildWelcomeMessage(context),
      );
    }

    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];
        return MessageBubble(message: msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageSentState || state is ChatErrorState) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Assistant'),
            actions: [
              IconButton(
                icon: const Icon(Icons.inventory_2),
                onPressed: () => context.go('/products'),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(child: _buildMessageList(state)),
              if (state is ChatLoadingState)
                const LinearProgressIndicator(),
              _buildInputArea(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}