import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/common/widgets/app_text.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/empty_url.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/shortened_url_tile.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/molecules/url_search.dart';

class HomeUrlTemplate extends StatelessWidget {
  final TextEditingController urlController;
  final void Function() shortenUrl;
  final List<ShortenedLinkEntity> recentUrls;
  const HomeUrlTemplate({
    super.key,
    required this.urlController,
    required this.shortenUrl,
    required this.recentUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        UrlSearch(
          urlController: urlController,
          shortenUrl: shortenUrl,
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
          child: recentUrls.isEmpty
              ? const EmptyUrl()
              : ListView.separated(
                  itemCount: recentUrls.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return ShortenedUrlTile(url: recentUrls[index].link.shortenedUrl);
                  },
                ),
        ),
      ],
    );
  }
}
