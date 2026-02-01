import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_button.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_input.dart';

class UrlSearch extends StatelessWidget {
  final TextEditingController urlController;
  final void Function()? shortenUrl;
  const UrlSearch({
    super.key,
    required this.urlController,
    required this.shortenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: UrlInput(urlController: urlController),
        ),
        const SizedBox(width: 12),
        UrlButton(shortenUrl: shortenUrl),
      ],
    );
  }
}
