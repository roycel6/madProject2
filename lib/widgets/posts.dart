import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
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
                'username',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
        Container(
          width: 375,
          height: 375,
          child: Image.asset(
            'images/example.jpg',
            fit: BoxFit.cover,
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
                  SizedBox(width: 14),
                  Icon(
                    Icons.favorite_outline,
                    size: 25,
                  ),
                  SizedBox(width: 17),
                  Icon(Icons.chat_bubble_outline, size: 28),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.5, top: 0.5, bottom: 5),
                child: Text('0',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'username ' + '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'caption',
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
                  'dateformat',
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
