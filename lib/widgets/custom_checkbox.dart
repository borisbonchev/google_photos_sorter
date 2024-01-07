import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isSelected;

  const CustomCheckBox({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 13,
            )
          : null,
    );
  }
}