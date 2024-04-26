import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMsg(receiverID, String msg) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    Query<Map<String, dynamic>> userdata =
        _firestore.collection('users').where('id', isEqualTo: currentUserID);
    var snapshotData = await userdata.get();
    List docsList = snapshotData.docs;
    var firstDoc = docsList[0];
    final String currentUsername = firstDoc.get('username');
    final Timestamp timestamp = Timestamp.now();
    Msg newMsg = Msg(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      senderUsername: currentUsername,
      receiverID: receiverID,
      timestamp: timestamp,
      msg: msg,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMsg.toMap());
  }

  Stream<QuerySnapshot> getMsg(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
        .collection('chatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
