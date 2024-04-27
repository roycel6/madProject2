import 'package:flutter/material.dart';
import '../chat/messageBoards.dart';
import '../homePage.dart';

import '../profileScreen.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({super.key});

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

int _currentIndex = 0;

class _Navigation_BarState extends State<Navigation_Bar> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _currentIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: navigationTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: '',
              ),
            ],
          ),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            HomePage(),
            ProfileScreen(),
            MessageBoards(),
          ],
        ));
  }
}
