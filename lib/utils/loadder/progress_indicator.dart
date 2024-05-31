import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ShowLoader extends StatelessWidget {
  const ShowLoader({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor,
        strokeWidth: 3.5,
      ),
    );
  }
}
