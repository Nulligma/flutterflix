import 'package:flutter/material.dart';
import 'package:flutterflix/screens/profileScreen.dart';
import 'package:flutterflix/screens/screens.dart';
import 'package:flutterflix/screens/searchScreen.dart';
import 'package:flutterflix/widgets/responsive.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    HomeScreen(type: HomeScreenType.none),
    SearchScreen(),
    ProfileScreen(),
  ];

  final Map<String, IconData> _icons = const {
    'Home': Icons.home,
    'Search': Icons.search,
    'More': Icons.menu,
  };

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Responsive.isMobile(context)
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                items: _icons
                    .map((title, icon) => MapEntry(
                        title,
                        BottomNavigationBarItem(
                          icon: Icon(icon, size: 30.0),
                          label: title,
                        )))
                    .values
                    .toList(),
                currentIndex: _currentIndex,
                selectedItemColor: Colors.white,
                selectedFontSize: 11.0,
                unselectedItemColor: Colors.grey,
                unselectedFontSize: 11.0,
                onTap: (index) => setState(() => _currentIndex = index),
              )
            : null);
  }
}
