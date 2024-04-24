import 'package:flutter/material.dart';

class MessageBoards extends StatefulWidget {
  const MessageBoards({super.key});

  @override
  State<MessageBoards> createState() => _MessageBoardsState();
}

class _MessageBoardsState extends State<MessageBoards> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('messages'),
    );
  }
}
