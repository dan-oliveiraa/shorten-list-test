import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/repositories/url_repository_port.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';

import '../contracts/url_datasource_port.dart';

class UrlRepository implements UrlRepositoryPort {
  final UrlDatasourcePort _datasource;
  UrlRepository(this._datasource);

  @override
  Future<ShortenedLinkEntity> shortenUrl(ShortenUrlInput input) async {
    final resp = await _datasource.shortenUrl(input);
    return resp.toEntity;
  }
}
