import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj2_real/util/imageCached.dart';

import 'chatPage.dart';

class MessageBoards extends StatefulWidget {
  const MessageBoards({super.key});

  @override
  State<MessageBoards> createState() => _MessageBoardsState();
}

class _MessageBoardsState extends State<MessageBoards> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        title: Text('Direct Messages', style: TextStyle(color: Colors.black)),
      ),
      body: Scaffold(body: _buildUserList()),
    );
  }

  void _logout() async {
    //logout
    await _auth.signOut();
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('loading');
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
          title: Text(data['username']),
          leading: ClipOval(
            child: SizedBox(
              width: 35,
              height: 35,
              child: CachedImage(data['profilePic']),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUsername: data['username'],
                    receiverUserID: data['id'],
                    receiverProfilePic: data['profilePic'],
                  ),
                ));
          });
    } else {
      return Container();
    }
  }
}
