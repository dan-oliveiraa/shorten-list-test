import 'dart:io';

import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/contracts/adapter/rest_adapter_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/adapter_helper_interface.dart';

class HttpRestAdapter implements IRestAdapter {
  final HttpClient _client;
  final IAdapterHelper _helper;

  HttpRestAdapter(this._client, this._helper);

  @override
  Future<ClientResponse<T>> get<T>(
    String url, {
    required RestOptions options,
  }) async {
    final uri = Uri.parse(url);
    var request = await _client.getUrl(uri);

    request = _helper.applyOptions(request, options);

    final response = await request.close();
    final data = await _helper.readResponse(response);

    return _helper.buildClientResponse<T>(data, response, options, url);
  }

  @override
  Future<ClientResponse<T>> delete<T>(
    String url, {
    required RestOptions options,
  }) async {
    final uri = Uri.parse(url);
    var request = await _client.deleteUrl(uri);

    request = _helper.applyOptions(request, options);

    final response = await request.close();
    final data = await _helper.readResponse(response);

    return _helper.buildClientResponse<T>(data, response, options, url);
  }

  @override
  Future<ClientResponse<T>> post<T>(
    String url, {
    Object? body,
    required RestOptions options,
  }) async {
    final uri = Uri.parse(url);
    var request = await _client.postUrl(uri);

    request = _helper.applyOptions(request, options);
    request = _helper.writeBody(request, body);

    final response = await request.close();
    final data = await _helper.readResponse(response);

    return _helper.buildClientResponse<T>(data, response, options, url);
  }

  @override
  Future<ClientResponse<T>> put<T>(
    String url, {
    Object? body,
    required RestOptions options,
  }) async {
    final uri = Uri.parse(url);
    var request = await _client.putUrl(uri);

    request = _helper.applyOptions(request, options);
    request = _helper.writeBody(request, body);

    final response = await request.close();
    final data = await _helper.readResponse(response);

    return _helper.buildClientResponse<T>(data, response, options, url);
  }
}
