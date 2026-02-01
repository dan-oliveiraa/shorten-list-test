import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/datasources/url_datasource_port.dart';

import '../../domain/contracts/ports/repositories/url_repository_port.dart';
import '../../domain/entities/shortened_link_entity.dart';

class UrlRepository implements UrlRepositoryPort {
  final UrlDatasourcePort _datasource;
  UrlRepository(this._datasource);

  @override
  Future<ShortenedLinkEntity> shortenUrl(ShortenUrlInputDTO input) async {
    final response = await _datasource.shortenUrl(input);
    final entity = response.toEntity;
    return entity;
  }
}
