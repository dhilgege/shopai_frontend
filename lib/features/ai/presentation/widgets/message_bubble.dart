import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/features/ai/domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser ? AppTheme.primaryColor : AppTheme.skyBlueLight;
    final textColor = isUser ? Colors.white : AppTheme.textColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.skyBlue.withValues(alpha: 0.3), shape: BoxShape.circle),
              child: Icon(Icons.smart_toy, size: 20, color: AppTheme.skyBlueDark),
            ),
          if (!isUser) const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: isUser
                  ? Text(message.text, style: TextStyle(color: textColor, fontSize: 15, height: 1.4))
                  : MarkdownBody(data: message.text, styleSheet: _markdownStyle(textColor)),
            ),
          ),
          if (isUser) const SizedBox(width: 12),
          if (isUser)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.3), shape: BoxShape.circle),
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(Color textColor) {
    return MarkdownStyleSheet(
      p: TextStyle(color: textColor, fontSize: 15, height: 1.5),
      strong: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      code: TextStyle(color: AppTheme.skyBlueDark, backgroundColor: AppTheme.skyBlueLight.withValues(alpha: 0.5)),
      blockquote: TextStyle(color: textColor.withValues(alpha: 0.8), fontStyle: FontStyle.italic),
      a: TextStyle(color: AppTheme.secondaryColor, decoration: TextDecoration.underline),
      listBullet: TextStyle(color: textColor),
      tableColumnWidth: FlexColumnWidth(),
      tableBorder: TableBorder.all(color: textColor.withValues(alpha: 50)),
    );
  }
}
