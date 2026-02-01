import 'dart:convert';
import 'dart:io';

import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/contracts/helper/adapter_helper_interface.dart';

import '../../../client/dto/rest_object.dart';
import '../../../exceptions/custom_http_exception.dart';

class AdapterHelper implements IAdapterHelper {
  AdapterHelper();

  @override
  HttpClientRequest applyOptions(
    HttpClientRequest request,
    RestOptions options,
  ) {
    options.headers?.forEach((key, value) {
      request.headers.set(key, value.toString());
    });
    request.headers.contentType ??= ContentType.json;

    return request;
  }

  @override
  HttpClientRequest writeBody(HttpClientRequest request, Object? body) {
    if (body != null) {
      final jsonString = json.encode(body);
      request.write(jsonString);
    }
    return request;
  }

  @override
  Future<dynamic> readResponse(HttpClientResponse response) async {
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return body.isNotEmpty ? json.decode(body) : null;
      } catch (_) {
        return body;
      }
    } else {
      throw CustomHttpException(
        statusCode: response.statusCode,
        body: body,
        uri: response.redirects.isNotEmpty ? response.redirects.first.location : null,
      );
    }
  }

  @override
  ClientResponse<T> buildClientResponse<T>(
    dynamic data,
    HttpClientResponse response,
    RestOptions options,
    String url,
  ) {
    final headers = <String, String>{};
    response.headers.forEach((name, values) {
      headers[name] = values.join(',');
    });

    return ClientResponse<T>(
      data: parse<T>(data, options),
      statusCode: response.statusCode,
      headers: headers,
      url: url,
    );
  }

  @override
  T parse<T>(dynamic data, RestOptions options) {
    if (options.parser != null) {
      return options.parser!(data);
    }
    return data as T;
  }
}
