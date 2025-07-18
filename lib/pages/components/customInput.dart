import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Color borderColor;

  const CustomInput({
    super.key,
    required this.hint,
    required this.controller,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.6), // use passed color
              spreadRadius: 4,
              blurRadius: 0,
              offset: const Offset(-2, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Swansea',
              letterSpacing: 1.0,
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
