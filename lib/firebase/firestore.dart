import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/userModel.dart';
import '../util/exception.dart';
import 'package:uuid/uuid.dart';

class FirestoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({
    required String email,
    required String username,
    required String bio,
    required String profilePic,
  }) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'id': _auth.currentUser!.uid,
      'email': email,
      'username': username,
      'bio': bio,
      'profilePic': profilePic,
      'registrationTime': DateTime.now().toString(),
    });
    return true;
  }

  Future<UserModel> getUser({String? uid}) async {
    try {
      final user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final currentUser = user.data()!;
      return UserModel(currentUser['bio'], currentUser['email'],
          currentUser['username'], currentUser['profilePic']);
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
      'profilePic': user.profilePic,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postID': uid,
      'like': [],
      'time': data,
      'bio': user.bio,
    });
    return true;
  }

  Future<bool> Comment({required String comment, required String uidd}) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
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
      'profilePic': user.profilePic,
      'uid': _auth.currentUser!.uid,
      'bio': user.bio,
      'time': data,
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
