import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();

  static Color primaryColor = const Color(0xFF2345b4);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color backgroundColor = const Color(0xFF2345b4).withOpacity(0.1);
  static Color listBGColor = const Color(0xFFEBEAEE);
  static Color textColor = const Color(0xFF252B5C);
  static Color dividerColor = const Color(0xFF57636C).withOpacity(0.3);
}
