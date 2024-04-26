import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proj2_real/firebase/firestore.dart';
import 'package:proj2_real/util/imageCached.dart';
import '../widgets/likeAnimation.dart';
import '../widgets/comments.dart';

class Posts extends StatefulWidget {
  final snapshot;
  Posts(this.snapshot, {super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 54,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(Icons.person_2_outlined),
                ),
              ),
              title: Text(
                widget.snapshot['username'],
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            FirestoreData().like(
                like: widget.snapshot['like'],
                uid: user,
                postID: widget.snapshot['postID']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 375,
                height: 375,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.red,
                  ),
                  isAnimating: isAnimating,
                  duration: Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(width: 3.5),
                  LikeAnimation(
                    child: IconButton(
                      onPressed: () {
                        FirestoreData().like(
                            like: widget.snapshot['like'],
                            uid: user,
                            postID: widget.snapshot['postID']);
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Colors.black,
                        size: 25,
                      ),
                    ),
                    isAnimating: widget.snapshot['like'].contains(user),
                  ),
                  SizedBox(width: 17),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                maxChildSize: 0.5,
                                initialChildSize: 0.5,
                                minChildSize: 0.2,
                                builder: ((context, scrollController) {
                                  return Comments(widget.snapshot['postID']);
                                }),
                              ),
                            );
                          });
                    },
                    child: Icon(Icons.chat_bubble_outline, size: 28),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.5, top: 0.5, bottom: 5),
                child: Text(widget.snapshot['like'].length.toString(),
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['username'] + '  ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.snapshot['caption'],
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 20, bottom: 8),
                child: Text(
                  formatDate(
                    widget.snapshot['time'].toDate(),
                    [yyyy, '-', mm, '-', dd],
                  ),
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
