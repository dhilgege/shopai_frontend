/**
 * AI Chat Page
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.skyBlue.withValues(alpha: 0.3), AppTheme.skyBlueLight.withValues(alpha: 0.2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.skyBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.skyBlue.withValues(alpha: 0.5), shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ShopAI Assistant', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: AppTheme.skyBlueDark, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Your smart shopping companion', style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: AppTheme.skyBlueDark.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: '**How can I help you today?**\n\n- **Find products** - Search for items by name, brand, or category\n- **Check availability** - Get real-time stock information\n- **Get recommendations** - AI-powered suggestions\n- **Create orders** - Place orders directly through chat\n- **Track orders** - Check order status and history\n\n*Just type your question or request!*',
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: AppTheme.skyBlueDark, fontSize: 14, height: 1.5),
              strong: TextStyle(color: AppTheme.skyBlueDark, fontWeight: FontWeight.bold),
              listBullet: TextStyle(color: AppTheme.skyBlueDark),
              code: TextStyle(color: AppTheme.primaryColor, backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1)),
              blockquote: TextStyle(color: AppTheme.skyBlueDark.withValues(alpha: 0.8), fontStyle: FontStyle.italic),
              a: TextStyle(color: AppTheme.secondaryColor, decoration: TextDecoration.underline),
              listBulletPadding: const EdgeInsets.only(left: 8),
              blockquotePadding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: ['Show me trending products', 'What is in stock?', 'Recommend something'].map((action) {
          return ActionChip(
            label: Text(action, style: const TextStyle(fontSize: 13)),
            backgroundColor: AppTheme.skyBlueLight.withValues(alpha: 0.3),
            side: BorderSide(color: AppTheme.skyBlue.withValues(alpha: 0.3)),
            onPressed: () => _handleSend(action),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.skyBlue.withValues(alpha: 0.2))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.skyBlueLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.skyBlue.withValues(alpha: 0.2)),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _handleSend,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.skyBlueDark]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: IconButton(icon: const Icon(Icons.send, size: 22), color: Colors.white, onPressed: () => _handleSend(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageSentState || state is ChatErrorState) _scrollToBottom();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                Text('Powered by Qwen2.5', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            actions: [
              if (state is ChatMessageSentState && state.messages.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  tooltip: 'Clear chat',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Chat'),
                        content: const Text('Are you sure you want to clear all messages?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<ChatBloc>().clearChat();
                            },
                            child: const Text('Clear', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(children: [
            Expanded(child: _buildMessagesView(state)),
            _buildInputArea(),
          ]),
        );
      },
    );
  }

  Widget _buildMessagesView(ChatState state) {
    if (state is ChatInitialState) {
      return CustomScrollView(
        controller: _scrollController,
        slivers: [SliverFillRemaining(hasScrollBody: false, child: Column(children: [const Spacer(), _buildWelcomeMessage(context), const SizedBox(height: 16), _buildQuickActions(), const Spacer()]))],
      );
    }

    if (state is ChatLoadingState) {
      return Stack(
        children: [
          _buildMessageList(),
          Positioned(
            bottom: 100, left: 16, right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))]),
              child: Row(
                children: [
                  Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color.fromARGB(51, 161, 194, 213), shape: BoxShape.circle), child: Icon(Icons.smart_toy, size: 18, color: Color(0xFF5A9BD4))),
                  SizedBox(width: 12),
                  Text('AI is thinking...'),
                  Spacer(),
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.skyBlue))),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (state is ChatErrorState) {
      return Stack(
        children: [
          _buildMessageList(),
          Positioned(
            bottom: 100, left: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red[200]!)),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 20, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Error: ${state.message}', style: TextStyle(color: Colors.red[700], fontSize: 13))),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      final lastMsg = state.messages.lastWhere((m) => m.isUser, orElse: () => ChatMessage(text: '', isUser: true));
                      if (lastMsg.text.isNotEmpty) context.read<ChatBloc>().add(SendMessageChatEvent(lastMsg.text));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (state is ChatMessageSentState) return _buildMessageList(messages: state.messages);
    return _buildMessageList();
  }

  Widget _buildMessageList({List<ChatMessage>? messages}) {
    final messageList = messages ?? context.read<ChatBloc>().currentMessages;
    if (messageList.isEmpty) {
      return CustomScrollView(
        controller: _scrollController,
        slivers: [SliverFillRemaining(hasScrollBody: false, child: Column(children: [const Spacer(), _buildWelcomeMessage(context), const SizedBox(height: 16), _buildQuickActions(), const Spacer()]))],
      );
    }
    return CustomScrollView(
      reverse: true,
      controller: _scrollController,
      slivers: [SliverPadding(padding: const EdgeInsets.only(top: 8), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => MessageBubble(message: messageList[messageList.length - 1 - index]), childCount: messageList.length)))],
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
