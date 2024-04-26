import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'addPost.dart';

import 'widgets/posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text('ArtDisplay'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add_a_photo),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddPost()),
                );
              },
            ),
          ),
        ],
        backgroundColor: Color(0xffFAFAFA),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: _firestore
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Posts(snapshot.data!.docs[index].data());
                  },
                  childCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
