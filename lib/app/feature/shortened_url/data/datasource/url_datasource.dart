import 'dart:convert';

import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';

import '../contracts/url_datasource_port.dart';
import '../mappers/shortened_link_mapper.dart';

class UrlDatasource implements UrlDatasourcePort {
  final IAppRestClient _client;
  UrlDatasource(this._client);

  static const String _baseUrl = 'https://url-shortener-server.onrender.com/api/alias';

  @override
  Future<ShortenedLinkMapper> shortenUrl(ShortenUrlInput input) async {
    final body = {"url": input.url.value};

    final resp = await _client.sendPost(
      url: _baseUrl,
      body: body,
    );

    resp.ensureSuccess(message: 'Erro ao encurtar URL');

    final data = jsonDecode(resp.content);
    final mapper = ShortenedLinkMapper.fromMap(data);

    return mapper;
  }
}
