import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

import '../../domain/entities/link_entity.dart';

class ShortenedLinkMapper {
  final String alias;
  final LinkMapper link;
  bool get isEmpty => alias.isEmpty && link.isEmpty;

  ShortenedLinkMapper({
    required this.alias,
    required this.link,
  });

  factory ShortenedLinkMapper.fromMap(Map<String, dynamic> map) {
    return ShortenedLinkMapper(
      alias: map['alias'] ?? '',
      link: map['_links'] != null
          ? LinkMapper.fromMap(map['_links'] as Map<String, dynamic>)
          : LinkMapper(
              originalUrl: '',
              shortenedUrl: '',
            ),
    );
  }

  ShortenedLinkEntity get toEntity {
    return ShortenedLinkEntity(
      alias: alias,
      link: LinkEntity(
        originalUrl: link.originalUrl,
        shortenedUrl: link.shortenedUrl,
      ),
    );
  }
}
