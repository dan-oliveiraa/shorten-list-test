import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/enum/global_error_types.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_exception.dart';
import 'package:shorten_list_test/app/core/exceptions/unauthorized_exception.dart';

void main() {
  test('ensureSuccess returns when status is 200', () {
    final response = RestResponse(
      statusCode: 200,
      content: 'ok',
      contentBytes: Uint8List(0),
      url: 'http://example.com',
    );

    expect(() => response.ensureSuccess(message: 'error'), returnsNormally);
  });

  test('ensureSuccess throws CustomException on 400', () {
    final response = RestResponse(
      statusCode: 400,
      content: 'bad',
      contentBytes: Uint8List(0),
      url: 'http://example.com',
    );

    expect(
      () => response.ensureSuccess(message: 'error'),
      throwsA(
        isA<CustomException>()
            .having((e) => e.type, 'type', GlobalErrorTypes.request)
            .having((e) => e.message, 'message', 'Ocorreu um erro na requisição'),
      ),
    );
  });

  test('ensureSuccess throws UnauthorizedException on 401/403', () {
    final response = RestResponse(
      statusCode: 401,
      content: 'unauthorized',
      contentBytes: Uint8List(0),
      url: 'http://example.com',
    );

    expect(
      () => response.ensureSuccess(message: 'error'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('ensureSuccess throws CustomException with provided message on other errors', () {
    final response = RestResponse(
      statusCode: 500,
      content: 'error',
      contentBytes: Uint8List(0),
      url: 'http://example.com',
    );

    expect(
      () => response.ensureSuccess(message: 'custom'),
      throwsA(
        isA<CustomException>()
            .having((e) => e.type, 'type', GlobalErrorTypes.request)
            .having((e) => e.message, 'message', 'custom'),
      ),
    );
  });
}
