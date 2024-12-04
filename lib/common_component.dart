import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Icon? icon;
  final Color? iconColor;
  final Color? buttonColor;
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key,
    this.icon,
    this.iconColor,
    this.buttonColor = Colors.blue,
    required this.onPressed,
    required this.text,
    this.textColor = Colors.black,
    this.width = 90,
    this.height = 25,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Container(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon!.icon,
                color: iconColor,
                size: fontSize + 8, // Icon size relative to font size
              ),
            if (icon != null)
              const SizedBox(width: 4), // Space between icon and text
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
