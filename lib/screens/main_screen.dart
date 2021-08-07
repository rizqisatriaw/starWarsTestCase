import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starwarsapp/assets/colors.dart' as color;
import 'package:starwarsapp/screens/beranda_screen.dart';
import 'package:starwarsapp/screens/favorit_screen.dart';
import 'package:starwarsapp/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isDark = false;
  color.Colors newColor = new color.Colors();

  final List<Widget> _children = [
    BerandaScreen(),
    FavoritScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    // if (index == 1) {
    setState(() {
      _currentIndex = index;
      _isDark = false;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: _children[_currentIndex],
          backgroundColor: newColor.blackBackground,
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.width / 5.5,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: newColor.primaryColor,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/home1.png",
                      width: 30,
                      height: 30,
                    ),
                    activeIcon: Image.asset(
                      "assets/images/home.png",
                      width: 30,
                      height: 30,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/like1.png",
                      width: 30,
                      height: 30,
                    ),
                    activeIcon: Image.asset(
                      "assets/images/like.png",
                      width: 30,
                      height: 30,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/user2.png",
                      width: 30,
                      height: 30,
                    ),
                    label: "",
                    activeIcon: Image.asset(
                      "assets/images/user.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => true);
  }
}
