import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/shortened_link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';

abstract class UrlDatasourcePort {
  Future<ShortenedLinkMapper> shortenUrl(ShortenUrlInput input);
}
