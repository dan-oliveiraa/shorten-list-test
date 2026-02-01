import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/client/rest_client/app_rest_client/app_rest_client.dart';
import 'package:shorten_list_test/app/core/contracts/adapter/rest_adapter_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';

class MockRestAdapter extends Mock implements IRestAdapter {}

class MockRestClientHelper extends Mock implements IRestClientHelper {}

class MockGlobalErrorService extends Mock implements IGlobalErrorService {}

void main() {
  late MockRestAdapter adapter;
  late MockRestClientHelper helper;
  late MockGlobalErrorService errorService;
  late AppRestClient client;

  final restOptions = RestOptions(
    headers: {'k': 'v'},
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  );

  setUpAll(() {
    registerFallbackValue(restOptions);
  });

  setUp(() {
    adapter = MockRestAdapter();
    helper = MockRestClientHelper();
    errorService = MockGlobalErrorService();
    client = AppRestClient(adapter, helper, errorService);
  });

  test('sendPost returns RestResponse', () async {
    const clientResponse = ClientResponse<dynamic>(
      statusCode: 201,
      headers: {},
      url: 'http://example.com',
      data: {'ok': true},
    );

    when(() => adapter.post(
          any(),
          body: any(named: 'body'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => clientResponse);

    when(() => helper.clientResponseToRestResponse(clientResponse)).thenReturn(
      RestResponse(
        statusCode: 201,
        content: 'ok',
        contentBytes: Uint8List(0),
        url: 'http://example.com',
      ),
    );

    final response = await client.sendPost(
      url: 'http://example.com',
      body: {'a': 1},
    );

    expect(response.statusCode, 201);
  });

  test('sendPost handles network failure', () async {
    final exception = Exception('Connection refused');
    final fallback = RestResponse(
      statusCode: 0,
      content: 'error',
      contentBytes: Uint8List(0),
      url: '',
    );

    when(() => adapter.post(
          any(),
          body: any(named: 'body'),
          options: any(named: 'options'),
        )).thenThrow(exception);
    when(() => errorService.restExceptionHandling(exception)).thenReturn(fallback);

    final response = await client.sendPost(
      url: 'http://example.com',
      body: {'x': 1},
    );

    expect(response, fallback);
  });
}
