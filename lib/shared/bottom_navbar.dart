import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabTapped;

  const BottomNav(this.currentIndex, this.onTabTapped, {Key? key})
      : super(key: key);

  BottomNavigationBarItem navItem(IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Colors.grey,
      ),
      label: '',
      activeIcon: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTabTapped,
      type: BottomNavigationBarType.shifting,
      items: [
        navItem(Icons.home),
        navItem(Icons.phone),
        navItem(Icons.sms),
      ],
    );
  }
}
