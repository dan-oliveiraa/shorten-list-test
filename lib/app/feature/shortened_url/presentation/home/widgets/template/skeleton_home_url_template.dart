import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_text.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/molecules/shortened_link_skeleton_tile.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/molecules/url_search.dart';

class SkeletonHomeUrlTemplate extends StatelessWidget {
  final TextEditingController urlController;
  const SkeletonHomeUrlTemplate({
    super.key,
    required this.urlController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        UrlSearch(
          urlController: urlController,
          shortenUrl: null,
        ),
        const SizedBox(height: 40),
        AppText(
          message: 'Recent Shortened URLs',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16),
            itemCount: 6,
            itemBuilder: (_, __) => const ShortenedLinkSkeletonItem(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      ],
    );
  }
}
