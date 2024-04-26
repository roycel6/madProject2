import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String email;
  String username;
  String bio;
  String profilePic;

  UserModel(this.bio, this.email, this.username, this.profilePic);
}
