import 'dart:convert';

import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/adapter/rest_adapter_interface.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_authorization_interface.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';

import '../../../utils/helper/data_structure/map_helper.dart';

class AppRestClient implements IAppRestClient {
  final IRestAdapter _adapter;
  final IRestClientHelper _helper;
  final IGlobalErrorService _errorService;

  static const int _secondsTimeout = 20;

  AppRestClient(
    this._adapter,
    this._helper,
    this._errorService,
  );

  @override
  Future<RestResponse> sendDelete({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _adapter.delete(
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

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendGet({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
    Map<String, dynamic>? xFilter,
    List<String>? xFields,
  }) async {
    try {
      final response = await _adapter.get(
        url,
        options: RestOptions(
          sendTimeout: Duration(seconds: _secondsTimeout),
          receiveTimeout: Duration(seconds: _secondsTimeout),
          headers: MapHelper.mergeMaps(
            [
              headers,
              (authorization != null ? {"Authorization": authorization.getValue()} : null),
              xFilter != null ? {'X-filter': Uri.encodeComponent(jsonEncode(xFilter))} : null,
              xFields != null ? {'X-fields': xFields.join(',')} : null,
            ],
          ),
        ),
      );

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendPost({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _adapter.post(
        url,
        body: body,
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

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }

  @override
  Future<RestResponse> sendPut({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  }) async {
    try {
      final response = await _adapter.put(
        url,
        body: body,
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

      return _helper.clientResponseToRestResponse(response);
    } catch (e) {
      return _errorService.restExceptionHandling(e);
    }
  }
}
