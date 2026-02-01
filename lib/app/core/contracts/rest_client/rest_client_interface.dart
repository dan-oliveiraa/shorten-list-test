import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_body_content_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_authorization_interface.dart';

abstract class IRestClient {
  Future<ClientResponse> sendGet({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
  Future<ClientResponse> sendPost({
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
  Future<ClientResponse> sendPut({
    required String url,
    required IRestBodyContent body,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
  Future<ClientResponse> sendDelete({
    required String url,
    Map<String, String>? headers,
    IRestClientAuthorization? authorization,
  });
}
