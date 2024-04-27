import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj2_real/firebase/firestore.dart';
import 'package:proj2_real/util/imageCached.dart';

import '../othersProfileScreen.dart';

class Comments extends StatefulWidget {
  String uid;
  Comments(this.uid, {super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final comment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
          color: Colors.white,
          height: 300,
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 140,
                child: Container(
                  width: 100,
                  height: 3,
                  color: Colors.black,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('posts')
                      .doc(widget.uid)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return commentItem(snapshot.data!.docs[index].data());
                        },
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data!.docs.length,
                      ),
                    );
                  }),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 260,
                        child: TextField(
                          controller: comment,
                          maxLines: 4,
                          decoration: const InputDecoration(
                              hintText: 'Enter a comment...',
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (comment.text.isNotEmpty) {
                              FirestoreData().Comment(
                                comment: comment.text,
                                uidd: widget.uid,
                              );
                            }
                            setState(() {
                              comment.clear();
                            });
                          },
                          child: Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget commentItem(final snapshot) {
    return ListTile(
        leading: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtherProfileScreen(
                  uidd: snapshot['uid'],
                  username: snapshot['username'],
                  profilePic: snapshot['profilePic'],
                  bio: snapshot['bio']),
            ),
          ),
          child: ClipOval(
            child: SizedBox(
              width: 35,
              height: 35,
              child: CachedImage(snapshot['profilePic']),
            ),
          ),
        ),
        title: Text(
          snapshot['username'],
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          snapshot['comment'],
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
        trailing: _auth.currentUser!.uid == snapshot['uid']
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(
                  snapshot['CommentUid'],
                ),
              )
            : null);
  }

  void _deleteItem(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This action will permanently delete this comment'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == null || !result) {
      return;
    }
    await _firestore
        .collection('posts')
        .doc(widget.uid)
        .collection('comments')
        .doc(id)
        .delete();
  }
}
