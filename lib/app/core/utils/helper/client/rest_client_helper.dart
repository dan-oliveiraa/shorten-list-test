import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';

import '../../../client/response/client_response.dart';
import '../../../client/response/rest_response.dart';
import '../../../exceptions/custom_http_exception.dart';

class RestClientHelper implements IRestClientHelper {
  @override
  RestResponse clientResponseToRestResponse(ClientResponse resp) {
    final contentString = _stringify(resp.data);
    final contentBytes = Uint8List.fromList(utf8.encode(contentString));

    return RestResponse(
      statusCode: resp.statusCode,
      content: contentString,
      contentBytes: contentBytes,
      url: resp.url,
    );
  }

  @override
  RestResponse dioExceptionToRestResponse(DioException exception) {
    return RestResponse(
      statusCode: exception.response?.statusCode ?? 0,
      content: const JsonCodec().encode(exception.response?.data ?? ""),
      contentBytes: Uint8List(0),
      url: exception.response?.realUri.toString() ?? "",
    );
  }

  @override
  RestResponse httpExceptionToRestResponse(CustomHttpException exception) {
    return RestResponse(
      statusCode: exception.statusCode,
      content: exception.body,
      contentBytes: Uint8List.fromList(utf8.encode(exception.body)),
      url: exception.uri?.toString() ?? '',
    );
  }

  String _stringify(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    try {
      return json.encode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
