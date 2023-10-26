import 'package:ease_tour/models/message.dart';
import 'package:ease_tour/screens/chat_screen/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key});

  final messages = [
    Message(
      senderId: '2',
      receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      content: 'Hello',
      sentTime: DateTime.now(),
    ),
    Message(
      senderId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      receiverId: '2',
      content: 'How are you?',
      sentTime: DateTime.now(),
    ),
    Message(
      senderId: '2',
      receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      content: 'Fine',
      sentTime: DateTime.now(),
    ),
    Message(
      senderId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      receiverId: '2',
      content: 'What are you doing?',
      sentTime: DateTime.now(),
    ),
    Message(
      senderId: '2',
      receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      content: 'Nothing',
      sentTime: DateTime.now(),
    ),
    Message(
      senderId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      receiverId: '2',
      content: 'Can you help me?',
      sentTime: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(
          isMe: false,
          message: messages[index],
        );
      },
    );
  }
}
