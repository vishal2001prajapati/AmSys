import 'dart:async';
import 'dart:developer';
import 'package:am_sys/screens/bottom_navigation/view/bottom_navigation_page.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/utils/app_image/app_image.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkUserIsLogIn();
  }

  checkUserIsLogIn() async {
    bool isLogin = await SessionManager.getIsUserLogin();

    if (isLogin == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: AppColors.whiteColor,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(
              AppImage.logo,
            ),
          ),
        ),
      ),
    );
  }
}
