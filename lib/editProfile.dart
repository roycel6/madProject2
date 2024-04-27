import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _bioController = TextEditingController();
  String currentUserBio = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text('Edit Your Bio', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'About Me'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateInfo(_bioController.text);
              },
              child: Text('Save', style: TextStyle()),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentUserInfo() async {
    final String currentUserID = _auth.currentUser!.uid;
    Query<Map<String, dynamic>> userdata =
        _firestore.collection('users').where('id', isEqualTo: currentUserID);
    var snapshotData = await userdata.get();
    List docsList = snapshotData.docs;
    var firstDoc = docsList[0];
    setState(() {
      currentUserBio = firstDoc.get('bio');
      _bioController.text = currentUserBio;
    });
  }

  void _updateInfo(String bioText) async {
    final String currentUserID = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .where('id', isEqualTo: currentUserID)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        _firestore.collection('users').doc(element.id).update({'bio': bioText});
      });
    });
    const snackBar = SnackBar(
      content: Text('Updated Info', style: TextStyle(color: Colors.white)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
