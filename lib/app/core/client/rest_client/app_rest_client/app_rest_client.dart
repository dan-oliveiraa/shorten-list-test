import 'dart:convert';

import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_resolve_interface.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_body_content_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_authorization_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_interface.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';

import '../../../utils/helper/data_structure/map_helper.dart';

class AppRestClient implements IAppRestClient {
  final IRestClient _client;
  final IAppResolveUri _appResolve;
  final IRestClientHelper _helper;
  final IGlobalErrorService _errorService;

  AppRestClient(
    this._client,
    this._appResolve,
    this._helper,
    this._errorService,
  );

  @override
  Future<RestResponse> sendDelete({
    required String api,
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _client.sendDelete(
        url: api.isEmpty
            ? url
            : _appResolve.resolveUri(
                api: api,
                url: url,
              ),
      );

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendGet({
    required String api,
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
    Map<String, dynamic>? xFilter,
    List<String>? xFields,
  }) async {
    try {
      final response = await _client.sendGet(
        headers: MapHelper.mergeMaps(
          [
            headers,
            xFilter != null ? {'X-filter': Uri.encodeComponent(jsonEncode(xFilter))} : null,
            xFields != null ? {'X-fields': xFields.join(',')} : null,
          ],
        ),
        url: api.isEmpty
            ? url
            : _appResolve.resolveUri(
                api: api,
                url: url,
              ),
        authorization: authorization,
      );

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendPost({
    required String api,
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _client.sendPost(
        url: url,
        body: body,
        headers: headers,
        authorization: authorization,
      );

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendPut({
    required String api,
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _client.sendPut(
        url: url,
        body: body,
        headers: headers,
        authorization: authorization,
      );

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }
}
