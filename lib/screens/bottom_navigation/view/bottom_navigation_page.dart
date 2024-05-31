import 'package:am_sys/screens/add_estate_screen/view/add_estate_page.dart';
import 'package:am_sys/screens/home_screen/view/home_screen.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/screens/map_page/view/cluster_map_screen.dart';
import 'package:am_sys/screens/profile_screen/view/profile_screen.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

BuildContext? globalContext;

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ClusterMapScreen(),
    const AddEstateScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.format_list_bulleted),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_pin_circle),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.domain_add),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _logout() async {
    await SessionManager.setIsUserLogin(false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(
              Icons.logout,
              color: AppColors.whiteColor,
            ),
          )
        ],
        title: Text(
          AppConstants.amSys,
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _navBarItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
