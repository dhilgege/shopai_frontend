import 'package:flutter/material.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/core/usecases/usecase.dart';
import 'package:shopai_fe/features/ai/domain/usecases/send_message.dart';
import 'package:get_it/get_it.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  late final SendMessage _sendMessageUseCase;

  @override
  void initState() {
    super.initState();
    _sendMessageUseCase = GetIt.instance<SendMessage>();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });

    final result = await _sendMessageUseCase.call(text);
    
    result.fold(
      (failure) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Error: $failure",
              isUser: false,
            ),
          );
        });
      },
      (ai) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: ai.isEmpty ? "No response" : ai,
              isUser: false,
            ),
          );
        });
      }
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),

          if (_isLoading)
            const LinearProgressIndicator(),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on String {
  void fold(Null Function(Failure) param0, Null Function(ai) param1) {}
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}