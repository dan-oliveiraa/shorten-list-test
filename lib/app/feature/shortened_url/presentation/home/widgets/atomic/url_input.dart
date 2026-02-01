import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_input.dart';

class UrlInput extends StatelessWidget {
  final TextEditingController urlController;
  const UrlInput({
    required this.urlController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      inputController: urlController,
      hintText: 'https://vkco.ma',
    );
  }
}
