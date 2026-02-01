import 'dart:convert';

import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/client/rest_client/content/rest_body_content_json.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/dto/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/datasources/url_datasource_port.dart';

import '../mappers/shortened_link_mapper.dart';

class UrlDatasource implements UrlDatasourcePort {
  final IAppRestClient _client;
  UrlDatasource(this._client);

  @override
  Future<ShortenedLinkMapper> shortenUrl(ShortenUrlInputDTO input) async {
    final resp = await _client.sendPost(
      api: '/shorten',
      url: '',
      body: RestBodyContentJson.parse(input),
    );
    resp.ensureSuccess(message: 'Erro ao encurtar URL');

    final data = jsonDecode(resp.content);

    return ShortenedLinkMapper.fromMap(data);
  }
}
