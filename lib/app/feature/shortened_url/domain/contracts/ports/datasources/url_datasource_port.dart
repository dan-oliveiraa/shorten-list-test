import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';

import '../../../../data/mappers/shortened_link_mapper.dart';

abstract class UrlDatasourcePort {
  Future<ShortenedLinkMapper> shortenUrl(ShortenUrlInputDTO input);
}
