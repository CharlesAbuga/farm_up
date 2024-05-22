import 'package:farm_up/screens/home.dart';
import 'package:farm_up/screens/my_animals.dart';
import 'package:farm_up/screens/profile_screen.dart';
import 'package:farm_up/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    MyAnimalsScreen(),
    ProfileScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.green,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.cow,
              size: 19,
            ),
            label: 'My Animals',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
