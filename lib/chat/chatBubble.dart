import 'package:flutter/material.dart';

import '../util/imageCached.dart';

class ChatBubble extends StatelessWidget {
  final String msg;
  final String profilePic;
  const ChatBubble({super.key, required this.msg, required this.profilePic});

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
