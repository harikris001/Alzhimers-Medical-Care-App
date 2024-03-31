import 'package:alzhcare/screens/chat_screen.dart';
import 'package:alzhcare/screens/location_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;
  List<Widget> screens = [
    const ChatScreen(),
    const LocationScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble,
                ),
                label: 'AlzhBot'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.location_searching,
              ),
              label: 'Location',
            )
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}