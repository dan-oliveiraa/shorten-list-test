import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String message;
  const EmptyData({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
    );
  }
}
