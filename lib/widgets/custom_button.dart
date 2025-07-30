// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
