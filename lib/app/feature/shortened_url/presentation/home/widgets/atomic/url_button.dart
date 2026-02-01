import 'package:flutter/material.dart';

class UrlButton extends StatelessWidget {
  final void Function()? shortenUrl;
  const UrlButton({
    super.key,
    required this.shortenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: shortenUrl,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
