import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';

class ShortenedLinkEntity {
  final String alias;
  final LinkEntity link;
  bool get isEmpty => alias.isEmpty && link.isEmpty;

  ShortenedLinkEntity({
    required this.alias,
    required this.link,
  });
}
