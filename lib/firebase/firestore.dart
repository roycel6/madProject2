import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/userModel.dart';
import '../util/exception.dart';
import 'package:uuid/uuid.dart';

class FirestoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getUser({String? uid}) async {
    try {
      final user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final currentUser = user.data()!;
      return UserModel(
          currentUser['bio'], currentUser['email'], currentUser['username']);
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> createPost({
    required String postImage,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    UserModel user = await getUser();
    await _firestore.collection('posts').doc(uid).set({
      'postImage': postImage,
      'username': user.username,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postID': uid,
      'like': [],
      'time': data
    });
    return true;
  }

  Future<bool> Comment({required String comment, required String uidd}) async {
    var uid = Uuid().v4();
    UserModel user = await getUser();
    await _firestore
        .collection('posts')
        .doc(uidd)
        .collection('comments')
        .doc(uid)
        .set({
      'comment': comment,
      'username': user.username,
      'CommentUid': uid,
    });
    return true;
  }

  Future<String> like(
      {required List like, required String uid, required String postID}) async {
    String res = 'error';

    try {
      if (like.contains(uid)) {
        _firestore.collection('posts').doc(postID).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postID).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }
}
