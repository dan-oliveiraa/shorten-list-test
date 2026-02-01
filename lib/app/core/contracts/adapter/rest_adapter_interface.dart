import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/client/response/client_response.dart';

abstract class IRestAdapter {
  Future<ClientResponse<T>> get<T>(
    String url, {
    required RestOptions options,
  });
  Future<ClientResponse<T>> delete<T>(
    String url, {
    required RestOptions options,
  });
  Future<ClientResponse<T>> post<T>(
    String url, {
    Object? body,
    required RestOptions options,
  });
  Future<ClientResponse<T>> put<T>(
    String url, {
    Object? body,
    required RestOptions options,
  });
}
