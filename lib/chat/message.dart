import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String senderID;
  final String senderUsername;
  final String senderEmail;
  final String receiverID;
  final String msg;
  final String profilePic;
  final Timestamp timestamp;

  Msg(
      {required this.senderID,
      required this.senderUsername,
      required this.senderEmail,
      required this.receiverID,
      required this.msg,
      required this.profilePic,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'senderUsername': senderUsername,
      'receiverID': receiverID,
      'msg': msg,
      'profilePic': profilePic,
      'timestamp': timestamp
    };
  }
}
