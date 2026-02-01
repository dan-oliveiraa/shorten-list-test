import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/contracts/adapter/rest_adapter_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_body_content_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_authorization_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_interface.dart';

import '../../../utils/helper/data_structure/map_helper.dart';
import '../../dto/rest_object.dart';

class RestClient implements IRestClient {
  final IRestAdapter _client;

  RestClient(this._client);

  final int _secondsTimeout = 20;

  @override
  Future<ClientResponse> sendDelete({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    final resp = await _client.delete(
      url,
      options: RestOptions(
        sendTimeout: Duration(seconds: _secondsTimeout),
        receiveTimeout: Duration(seconds: _secondsTimeout),
        headers: MapHelper.mergeMaps(
          [
            (authorization != null ? {"Authorization": authorization.getValue()} : null),
            headers,
          ],
        ),
      ),
    );

    return resp;
  }

  @override
  Future<ClientResponse> sendGet({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    final resp = await _client.get(
      url,
      options: RestOptions(
        sendTimeout: Duration(seconds: _secondsTimeout),
        receiveTimeout: Duration(seconds: _secondsTimeout),
        headers: MapHelper.mergeMaps(
          [
            (authorization != null ? {"Authorization": authorization.getValue()} : null),
            headers,
          ],
        ),
      ),
    );

    return resp;
  }

  @override
  Future<ClientResponse> sendPost({
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    final resp = await _client.post(
      url,
      body: body.render(),
      options: RestOptions(
        sendTimeout: Duration(seconds: _secondsTimeout),
        receiveTimeout: Duration(seconds: _secondsTimeout),
        headers: MapHelper.mergeMaps(
          [
            (authorization != null ? {"Authorization": authorization.getValue()} : null),
            headers,
          ],
        ),
      ),
    );

    return resp;
  }

  @override
  Future<ClientResponse> sendPut({
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    final resp = await _client.put(
      url,
      body: body.render(),
      options: RestOptions(
        sendTimeout: Duration(seconds: _secondsTimeout),
        receiveTimeout: Duration(seconds: _secondsTimeout),
        headers: MapHelper.mergeMaps(
          [
            (authorization != null ? {"Authorization": authorization.getValue()} : null),
            headers,
          ],
        ),
      ),
    );

    return resp;
  }
}
