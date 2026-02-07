import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_text.dart';

class ErrorView extends StatelessWidget {
  final void Function()? onPressed;
  final String message;
  const ErrorView({
    required this.onPressed,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AppText(message: message),
          const SizedBox(
            height: 12.0,
          ),
          TextButton(
            onPressed: onPressed,
            child: AppText(message: "Try Again"),
          )
        ],
      ),
    );
  }
}
