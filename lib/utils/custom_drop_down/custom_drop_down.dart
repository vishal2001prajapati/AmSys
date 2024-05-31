import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String hint;
  final List<String> items;
  final Function(Object?) onChanged;

  const CustomDropdownButtonFormField({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      isExpanded: true,
      validator: (value) {
        return value == null ? "Field required" : null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.listBGColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 0.5),
        ),
      ),
      onChanged: (value) => onChanged(value),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
