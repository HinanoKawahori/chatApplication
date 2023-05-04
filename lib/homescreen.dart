import 'package:chatapplication/modifyprofile/screen/modifyprofile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'chat/chat_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = [ChatPage(), ModifyProfilePage()];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: const Icon(Icons.people),
                label: "チャットページ",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: "プロフィール編集ページ",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            }),
      ),
    );
  }
}
