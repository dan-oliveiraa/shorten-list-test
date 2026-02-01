import 'dart:io';

import '../../client/dto/rest_object.dart';
import '../../client/response/client_response.dart';

abstract class IAdapterHelper {
  HttpClientRequest applyOptions(
    HttpClientRequest request,
    RestOptions options,
  );
  HttpClientRequest writeBody(HttpClientRequest request, Object? body);
  Future<dynamic> readResponse(HttpClientResponse response);
  ClientResponse<T> buildClientResponse<T>(
    dynamic data,
    HttpClientResponse response,
    RestOptions options,
    String url,
  );
  T parse<T>(dynamic data, RestOptions options);
}
