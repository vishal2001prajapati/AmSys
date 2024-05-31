import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomLinearLoader extends StatelessWidget {
  const CustomLinearLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 29, horizontal: 10),
      decoration: BoxDecoration(
        //color: Colors.grey,
        border: Border.all(width: .5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          color: AppColors.primaryColor,
          minHeight: 5,
        ),
      ),
    );
  }
}
