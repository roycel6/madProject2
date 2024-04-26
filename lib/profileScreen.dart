import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'postScreen.dart';
import 'widgets/posts.dart';
import 'firebase/firestore.dart';
import 'model/userModel.dart';
import 'util/imageCached.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int postLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
              _logout();
              // Navigate to settings page or perform other actions
            },
          ),
        ],
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
                    isEqualTo: _auth.currentUser!.uid,
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
                        width: 90,
                        height: 90,
                        child: Icon(Icons.person_2_outlined, size: 90),
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage: NetworkImage(
                    //       'https://via.placeholder.com/150'), // Example profile image
                    // ),
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
                              user.username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              user.bio,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Text('Edit Bio'),
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

  void _logout() async {
    //logout
    await _auth.signOut();
  }
}
