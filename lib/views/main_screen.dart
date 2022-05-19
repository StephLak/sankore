import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sankore_task/shared/bottom_navbar.dart';
import 'package:sankore_task/views/tabs/contacts.dart';
import 'package:sankore_task/views/tabs/home.dart';
import 'package:sankore_task/views/tabs/sms.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    const HomeTab(),
    const ContactsTab(),
    const SmsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNav(_currentIndex, onTabTapped),
      body: _children[_currentIndex],
    );
  }
}
