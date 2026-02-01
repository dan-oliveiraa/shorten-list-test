import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';

abstract class UrlRepositoryPort {
  Future<ShortenedLinkEntity> shortenUrl(ShortenUrlInput input);
}
