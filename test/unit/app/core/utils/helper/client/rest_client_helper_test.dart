import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_http_exception.dart';
import 'package:shorten_list_test/app/core/utils/helper/client/rest_client_helper.dart';

void main() {
  late RestClientHelper helper;

  setUp(() {
    helper = RestClientHelper();
  });

  test('clientResponseToRestResponse converts data and url', () {
    const response = ClientResponse<dynamic>(
      statusCode: 200,
      headers: {},
      url: 'http://example.com',
      data: {'ok': true},
    );

    final restResponse = helper.clientResponseToRestResponse(response);

    expect(restResponse.statusCode, 200);
    expect(restResponse.url, 'http://example.com');
    expect(restResponse.content, '{"ok":true}');
    expect(restResponse.contentBytes, isA<Uint8List>());
  });

  test('httpExceptionToRestResponse maps exception details', () {
    final exception = CustomHttpException(
      statusCode: 404,
      body: 'not-found',
      uri: Uri.parse('http://example.com'),
    );

    final restResponse = helper.httpExceptionToRestResponse(exception);

    expect(restResponse.statusCode, 404);
    expect(restResponse.content, 'not-found');
    expect(restResponse.contentBytes, Uint8List.fromList('not-found'.codeUnits));
    expect(restResponse.url, 'http://example.com');
  });
}
