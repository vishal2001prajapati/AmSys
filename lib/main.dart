import 'package:am_sys/screens/bottom_navigation/view/bottom_navigation_page.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'screens/splash_screen/view/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Raleway',
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
        ),
        scaffoldBackgroundColor: AppColors.whiteColor,
        useMaterial3: true,
      ),
    );
  }
}
