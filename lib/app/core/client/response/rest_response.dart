import 'dart:typed_data';

import 'package:shorten_list_test/app/core/contracts/response/rest_response_interface.dart';
import 'package:shorten_list_test/app/core/enum/global_error_types.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_exception.dart';
import 'package:shorten_list_test/app/core/exceptions/unauthorized_exception.dart';

import '../../utils/helper/data_structure/list_helper.dart';

class RestResponse implements IRestResponse {
  final int _statusCode;
  final String _content;
  final Uint8List _contentBytes;
  final String _url;
  bool get _unauthorized => ListHelper.contains(statusCode, [401, 403]);

  RestResponse({
    required int statusCode,
    required String content,
    required Uint8List contentBytes,
    required String url,
  })  : _statusCode = statusCode,
        _content = content,
        _contentBytes = contentBytes,
        _url = url;

  @override
  String get content => _content;

  @override
  Uint8List get contentBytes => _contentBytes;

  @override
  int get statusCode => _statusCode;

  @override
  bool get unauthorized => _unauthorized;

  @override
  String get url => _url;
}

extension RestResponseExtension on RestResponse {
  void ensureSuccess({
    required String message,
  }) {
    if (statusCode == 200) return;

    if (statusCode == 400) {
      throw CustomException(
        message: "Ocorreu um erro na requisição",
        type: GlobalErrorTypes.request,
      );
    }

    if (unauthorized) {
      throw UnauthorizedException("Sem permissão. $url");
    }

    throw CustomException(
      message: message.isEmpty ? "Ocorreu um erro na requisição" : message,
      type: GlobalErrorTypes.request,
    );
  }
}
