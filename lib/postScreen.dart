import 'package:flutter/material.dart';

import 'widgets/posts.dart';

class PostScreen extends StatelessWidget {
  final snapshot;
  PostScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(child: Posts(snapshot)),
      ),
    );
  }
}
