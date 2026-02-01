import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String message;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  const AppText({
    super.key,
    required this.message,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
