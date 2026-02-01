import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_authorization_interface.dart';

abstract class IAppRestClient {
  Future<RestResponse> sendGet({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
    Map<String, dynamic>? xFilter,
    List<String>? xFields,
  });
  Future<RestResponse> sendDelete({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
  Future<RestResponse> sendPost({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
  Future<RestResponse> sendPut({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
}
