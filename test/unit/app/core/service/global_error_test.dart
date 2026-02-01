import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/enum/global_error_types.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_exception.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_http_exception.dart';
import 'package:shorten_list_test/app/core/service/global_error.dart';

class MockRestClientHelper extends Mock implements IRestClientHelper {}

void main() {
  late MockRestClientHelper helper;
  late GlobalErrorService service;

  setUp(() {
    helper = MockRestClientHelper();
    service = GlobalErrorService(helper);
  });

  test('exceptionHandling maps CustomException', () {
    final exception = CustomException(
      message: 'custom',
      type: GlobalErrorTypes.request,
    );

    final dto = service.exceptionHandling(
      'context',
      exception: exception,
    );

    expect(dto.type, GlobalErrorTypes.request);
    expect(dto.message, 'custom');
  });

  test('restExceptionHandling maps CustomHttpException using helper', () {
    final exception = CustomHttpException(
      statusCode: 400,
      body: 'bad',
      uri: Uri.parse('http://example.com'),
    );
    final expected = RestResponse(
      statusCode: 400,
      content: 'bad',
      contentBytes: Uint8List(0),
      url: 'http://example.com',
    );

    when(() => helper.httpExceptionToRestResponse(exception)).thenReturn(expected);

    final response = service.restExceptionHandling(exception);
    expect(response, expected);
  });

  test('restExceptionHandling builds fallback RestResponse', () {
    final response = service.restExceptionHandling(Exception('fail'));

    expect(response.statusCode, 0);
    expect(response.content, contains('fail'));
    expect(response.contentBytes.length, 8);
    expect(response.url, '');
  });
}
