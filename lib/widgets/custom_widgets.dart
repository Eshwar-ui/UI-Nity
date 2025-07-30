// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight
                .w700, // Using w700 since RobotoCondensed-Bold.ttf is weight 700
            fontStyle: FontStyle.normal,
          ),
          elevation: 30,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ), // Theme.of(context).colorScheme.primary
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.isEnabled,
    required this.minlines,
    required String? Function(dynamic value) validator,
  });
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  final bool isEnabled;
  final int minlines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: TextField(
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
        maxLines: 50,
        minLines: minlines,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: false,
        enabled: isEnabled,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
    required this.isEnabled,
    required this.suffixIcon,
    required String? Function(dynamic value) validator,
  });
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isEnabled;
  final IconButton suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: TextField(
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
        maxLines: 1,
        minLines: 1,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: isEnabled,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class CustomCTA extends StatelessWidget {
  const CustomCTA({
    super.key,
    required this.text,
    required this.onPressed, // Theme.of(context).colorScheme.primary
    required this.borderRadius,
    this.borderColor = Colors.black, // Theme.of(context).colorScheme.primary
    this.shadowColor = Colors.black,
    this.textColor = Colors.black,
    this.color = Colors.transparent,
    this.width = double.infinity,
    required bool isLoading,
  });
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
  final double borderRadius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width, 50),
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          elevation: 20,
          shadowColor: shadowColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class CustomCardComponent extends StatelessWidget {
  const CustomCardComponent({
    super.key,
    required this.title,
    required this.component,
    required this.category,
  });
  final String title;
  final Widget component;
  final String category;

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'button':
        return const Color(0xFFE3F2FD); // Light Blue
      case 'cards':
        return const Color(0xFFE8F5E9); // Light Green
      case 'input':
        return const Color.fromARGB(255, 253, 239, 239); // Light Yellow
      case 'navigation':
        return const Color(0xFFFFF3E0); // Light Orange
      case 'modals':
        return const Color(0xFFF3E5F5); // Light Purple
      case 'badge':
        return const Color(0xFFFFEBEE); // Light Red
      case 'dialog':
        return const Color(0xFFE1F5FE); // Lighter Blue
      case 'list':
        return const Color(0xFFFFFDE7); // Lightest Yellow
      default:
        return const Color(0xFFF5F5F5); // Default Light Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 170,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _getCategoryColor(category),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 70,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: component),
          Text(
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0), // Theme.of(context).colorScheme.primary
      child: Divider(
        color: Colors.black,
        thickness: 2,
      ), // Theme.of(context).colorScheme.primary
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final bool isFirstTabSelected;
  final String firstTabText;
  final String secondTabText;
  final Function(bool) onTabChanged;

  const CustomTabBar({
    super.key,
    required this.isFirstTabSelected,
    required this.firstTabText,
    required this.secondTabText,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Animated Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: isFirstTabSelected ? 0 : tabWidth,
                child: Container(
                  width: tabWidth,
                  height: 60,
                  decoration: BoxDecoration(
                    // Theme.of(context).colorScheme.primary
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              // Tab Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(true),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.w700,
                          color: isFirstTabSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(firstTabText),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(false),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.w700,
                          color: !isFirstTabSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(secondTabText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
