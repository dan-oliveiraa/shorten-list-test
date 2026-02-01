import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_button.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_input.dart';

class UrlSearch extends StatelessWidget {
  final TextEditingController urlController;
  final void Function()? shortenUrl;
  final ShortenUrlInput? input;

  UrlSearch({
    super.key,
    required this.urlController,
    required this.shortenUrl,
    this.input,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: UrlInput(
              urlController: urlController,
              input: input,
            ),
          ),
          const SizedBox(width: 12),
          UrlButton(
            shortenUrl: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                shortenUrl?.call();
              }
            },
          ),
        ],
      ),
    );
  }
}
