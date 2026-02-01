import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_button.dart';

class UrlButton extends StatelessWidget {
  final void Function()? shortenUrl;
  const UrlButton({
    super.key,
    required this.shortenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(onTap: shortenUrl);
  }
}
