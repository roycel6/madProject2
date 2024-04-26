import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj2_real/editProfile.dart';
import 'chat/chatPage.dart';
import 'postScreen.dart';
import 'widgets/posts.dart';
import 'firebase/firestore.dart';
import 'model/userModel.dart';
import 'util/imageCached.dart';

class OtherProfileScreen extends StatefulWidget {
  String uidd;
  String username;
  String profilePic;
  String bio;
  OtherProfileScreen(
      {Key? key,
      required this.uidd,
      required this.username,
      required this.profilePic,
      required this.bio})
      : super(key: key);

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int postLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        title: Text(widget.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: FirestoreData().getUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Head(snapshot.data!);
                },
              ),
            ),
            StreamBuilder(
              stream: _firestore
                  .collection('posts')
                  .where(
                    'uid',
                    isEqualTo: widget.uidd,
                  )
                  .snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                postLength = snapshot.data!.docs.length;
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var post = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostScreen(post.data()),
                          ),
                        );
                      },
                      child: CachedImage(
                        post['postImage'],
                      ),
                    );
                  }, childCount: postLength),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // number of columns
                    crossAxisSpacing: 2, // horizontal space between items
                    mainAxisSpacing: 2, // vertical space between items
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget Head(UserModel user) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CachedImage(widget.profilePic),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildStatColumn("Posts", postLength),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              widget.username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              widget.bio,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverUsername: widget.username,
                                      receiverUserID: widget.uidd,
                                      receiverProfilePic: widget.profilePic,
                                    ),
                                  ),
                                );
                              },
                              child: widget.uidd == _auth.currentUser!.uid
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade400,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                      ),
                                      child: Text(
                                        'Message',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
