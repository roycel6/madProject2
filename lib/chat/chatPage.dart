import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatService.dart';
import 'package:intl/intl.dart';

import 'chatBubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserID;
  const ChatPage(
      {super.key,
      required this.receiverUsername,
      required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Text(widget.receiverUsername,
              style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMsgList(),
            ),
            _buildMsgInput(),
          ],
        ));
  }

  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMsg(widget.receiverUserID, _msgController.text);
      _msgController.clear();
    }
  }

  Widget _buildMsgList() {
    return StreamBuilder(
        stream:
            _chatService.getMsg(widget.receiverUserID, _auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) => _buildMsgItem(doc)).toList(),
          );
        });
  }

  Widget _buildMsgItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String fullName = data['senderUsername'];
    var alignment = (data['senderID'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: (data['senderID'] == _auth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: (data['senderID'] == _auth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(fullName),
                ChatBubble(msg: data['msg']),
                Text(DateFormat()
                    .add_yMMMEd()
                    .add_jm()
                    .format(data['timestamp'].toDate())),
              ],
            )));
  }

  Widget _buildMsgInput() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: new InputDecoration(hintText: 'Enter a message...'),
            ),
          ),
          IconButton(
            onPressed: sendMsg,
            icon: const Icon(Icons.send, size: 40),
          )
        ],
      ),
    );
  }
}
