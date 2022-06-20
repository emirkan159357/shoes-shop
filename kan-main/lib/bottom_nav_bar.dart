// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'main_page.dart';
import 'search_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController pageViewController = PageController(initialPage: 0);
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        pageSnapping: true,
        onPageChanged: (int page) => {
          setState(() {
            currentIndex = page;
          }),
        },
        children: [
          MainPage(user: user1),
          const SearchPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, color: Colors.black26),
            activeIcon: Icon(CupertinoIcons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search, color: Colors.black26),
            activeIcon: Icon(CupertinoIcons.search, color: Colors.black),
            label: '',
          ),

        ],
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            currentIndex = index;
          });
        },
      ),
    );
  }
}
