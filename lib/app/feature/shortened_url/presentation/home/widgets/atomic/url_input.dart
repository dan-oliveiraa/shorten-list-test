import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_input.dart';

import '../../../../domain/value_objects/shorten_url_input.dart';
import '../../../../domain/value_objects/url_value_object.dart';

class UrlInput extends StatelessWidget {
  final TextEditingController urlController;
  final ShortenUrlInput? input;

  const UrlInput({
    required this.urlController,
    required this.input,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      onChanged: (value) => input?.url = URL(value),
      onSaved: (value) {
        if (value != null) {
          input?.url = URL(value);
        }
      },
      validator: (value) => URL.validate(value ?? ''),
      inputController: urlController,
      hintText: 'Type URL here',
    );
  }
}
