import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String msg;
  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.blue.shade500),
      child: Text(
        msg,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
