import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   designSize: const Size(360, 690),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('ArtDisplay'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Color(0xffFAFAFA),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Posts();
            },
            childCount: 5,
          ))
        ],
      ),
    );
  }
}
