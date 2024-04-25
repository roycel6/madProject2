import 'dart:io';

import 'package:flutter/material.dart';
import 'firebase/imgStorage.dart';
import 'firebase/firestore.dart';

class AddPostCaption extends StatefulWidget {
  File _file;
  AddPostCaption(this._file, {super.key});

  @override
  State<AddPostCaption> createState() => _AddPostCaptionState();
}

class _AddPostCaptionState extends State<AddPostCaption> {
  final caption = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add a Caption',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await FirestoreData().createPost(
                    postImage: post_url,
                    caption: caption.text,
                  );
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                image: FileImage(widget._file),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 280,
                            height: 60,
                            child: TextField(
                              controller: caption,
                              decoration: InputDecoration(
                                hintText:
                                    'Write a description about your post...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
