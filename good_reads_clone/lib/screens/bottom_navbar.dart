import 'package:flutter/material.dart';
import 'package:good_reads_clone/screens/home_page.dart';
import 'package:good_reads_clone/screens/user_chat_screens.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentindex = 0;

  final screens = [
    HomePage(),
    UsersList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentindex],
    
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[700],
        items: [
          navItem(Icons.book, 'search'),
          navItem(Icons.chat, 'chat'),
        ],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.lightBlue,
        onTap: (index){
          setState(() {
            _currentindex = index;
          });
        },
        currentIndex: _currentindex,
      ),
    );
  }
}

BottomNavigationBarItem navItem(IconData icon, String title) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    title: Text(title),
  );
}
